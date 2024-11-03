::ModEncounterManager.Hooks.hook("scripts/entity/world/settlement", function(q) {
    /** New field for events that should happens on settlement enter */
    q.m.SettlementTriggers <- [];
    /** New field for settlements encounters */
    q.m.SettlementEncountersCooldownUntil <- 0.0;
    q.m.SettlementEncounters <- [];

    /**
     * Updates encounters in the town.
     */
    q.updateEncounters <- function() {
        if (this.m.SettlementEncountersCooldownUntil > this.Time.getVirtualTimeF()) {
            local notValid = [];
            foreach (e in this.m.SettlementEncounters) {
                if (!e.isValid(this))
                    notValid.push(e);
            }
            foreach (e in notValid) {
                ::logInfo("encounter became non valid " + e.getType());
                ::MSU.Array.removeByValue(this.m.SettlementEncounters, e);
            }
            ::logInfo("cooldown still on, skipping the creation");
            return;
        }

        local list = [];
        foreach (e in this.World.Encounters.m.SettlementEncounters) {
            if (e.isValid(this)) {
                list.push(e);
            }
        }

        local count = this.Math.rand(3, 5);
        while(list.len() > count) {
            local r = this.Math.rand(0, list.len() - 1);
            list.remove(r);
        }
        this.m.SettlementEncounters.clear();
        foreach (e in list) {
            this.m.SettlementEncounters.push(e);
        }
        this.m.SettlementEncountersCooldownUntil = this.Time.getVirtualTimeF() + (5 * this.World.getTime().SecondsPerDay);
    }

    /**
     * Adds a check on settlement enter, to check if it should show event.
     */
    q.onEnter = @(__original) function () {
        local ret = __original();
        this.updateEncounters();
        if(::World.Encounters.onSettlementEntered(this)) {
            ::World.State.m.LastEnteredTown = null;
            return false;
        }
        return ret;
    }

    /**
     * Callback function for UI, called on encounter icon click
     */
    q.onEncounterClicked <- function(_i, _townScreen){
        this.World.Encounters.fireEncounter(this.m.SettlementEncounters[_i]);
        this.m.SettlementEncounters.remove(_i);
    }

    /**
     * Injects settlement encounters into data for the ui
     */
    q.getUIInformation = @(__original) function() {
        local result = __original();
        result.Encounters <- [];
        foreach(encounter in this.m.SettlementEncounters) {
            if (encounter != null) {
                result.Encounters.push({
                    Icon = encounter.m.Icon,
                    Type = encounter.getType(),
                });
            }
        }
        return result;
    }

    q.onSerialize = @(__original) function (_out) {
        __original(_out);
        _out.writeF32(this.m.SettlementEncountersCooldownUntil);
        _out.writeU32(this.m.SettlementEncounters.len());
        foreach(e in this.m.SettlementEncounters) {
            _out.writeString(e.getType());
        }
    }

    q.onDeserialize = @(__original) function (_in) {
        __original(_in);
        if (::ModEncounterManager.Mod.Serialization.isSavedVersionAtLeast("0.1.1", _in.getMetaData())) {
            this.m.SettlementEncountersCooldownUntil = _in.readF32();
            local size = _in.readU32();
            for(local i = 0; i < size; i++) {
                local e = this.World.Encounters.getEncounter(_in.readString());
                if(e != null) {
                    this.m.SettlementEncounters.push(e);
                }
            }
        }
    }
});
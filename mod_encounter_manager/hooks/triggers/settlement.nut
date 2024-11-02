::ModEncounterManager.Hooks.hook("scripts/entity/world/settlement", function(q) {
    /** New field for events that should happens on settlement enter */
    q.m.SettlementTriggers <- []
    /** New field for settlements encounters */
    q.m.SettlementEncounters <- []

    /**
     * Updates encounters in the town.
     */
    q.updateEncounters <- function() {
        // todo, this needs some time based check too, idk how to do it
        local list = [];
        foreach (e in this.World.EncounterManager.m.SettlementEncounters) {
            if (e.isValid(this)) {
                ::logInfo("encounter valid " + e.getType());
                list.push(e);
            } else {
                ::logInfo("encounter not valid " + e.getType());
            }
        }

        local count = this.Math.rand(3, 5);
        while(list.len() > count) {
            local r = this.Math.rand(0, list.len() - 1);
            ::logInfo("discarding encounter " + list[r].getType());
            list.remove(r);
        }
        this.m.SettlementEncounters.clear();
        foreach (e in list) {
            ::logInfo("adding encounter " + e.getType());
            this.m.SettlementEncounters.push(e);
        }
    }

    /**
     * Adds a check on settlement enter, to check if it should show event.
     */
    q.onEnter = @(__original) function () {
        local ret = __original();
        this.updateEncounters();
        if(::World.EncounterManager.onSettlementEntered(this)) {
            ::World.State.m.LastEnteredTown = null;
            return false;
        }
        return ret;
    }

    /**
     * Callback function for UI, called on encounter icon click
     */
    q.onEncounterClicked <- function(_i, _townScreen){
        this.World.EncounterManager.fireEncounter(this.m.SettlementEncounters[_i]);
        this.m.SettlementEncounters.remove(_i);
    }

    /**
     * Injects settlement encounters data for the ui
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
});
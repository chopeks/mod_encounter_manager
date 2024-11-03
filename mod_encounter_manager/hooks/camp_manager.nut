::ModEncounterManager.Hooks.hook("scripts/states/world/camp_manager", function(q) {
    /** New field for camp encounters */
    q.m.CampEncountersCooldownUntil <- 0.0;
    q.m.CampEncounters <- [];

    /**
     * Updates encounters in the camp.
     */
    q.updateEncounters <- function() {
        ::logInfo("camp_manager.updateEncounters called");
        if (this.m.CampEncountersCooldownUntil > this.Time.getVirtualTimeF()) {
            local notValid = [];
            foreach (e in this.m.CampEncounters) {
                if (!e.isValid(this))
                    notValid.push(e);
            }
            foreach (e in notValid) {
                ::logInfo("encounter became non valid " + e.getType());
                ::MSU.Array.removeByValue(this.m.CampEncounters, e);
            }
            ::logInfo("cooldown still on, skipping the creation");
            return;
        }

        local list = [];
        foreach (e in this.World.Encounters.m.CampEncounters) {
            if (e.isValid(this)) {
                list.push(e);
            }
        }

        local count = this.Math.rand(3, 5);
        while(list.len() > count) {
            local r = this.Math.rand(0, list.len() - 1);
            list.remove(r);
        }
        this.m.CampEncounters.clear();
        foreach (e in list) {
            this.m.CampEncounters.push(e);
        }
        this.m.CampEncountersCooldownUntil = this.Time.getVirtualTimeF() + (5 * this.World.getTime().SecondsPerDay);
        ::logInfo("camp encounters in array = " + this.m.CampEncounters.len());
    }

    /**
     * Adds a check on settlement enter, to check if it should show event.
     */
    q.onEnter <- function () {
        ::logInfo("camp_manager.onEnter called");
        this.updateEncounters();
        return true;
    }

    /**
     * Callback function for UI, called on encounter icon click
     */
    q.onEncounterClicked <- function(_i, _townScreen){
        ::logInfo("camp_manager.onEncounterClicked called");
        this.World.Encounters.fireCampEncounter(this.m.CampEncounters[_i]);
        this.m.CampEncounters.remove(_i);
    }

    /**
     * This stuff should be implemented in camp class, not UI class as of current state
     */
    q.getUITerrain <- function() {
        ::logInfo("camp_manager.getUITerrain called");
        local tile = this.World.State.getPlayer().getTile();
        local terrain = [];
        terrain.resize(this.Const.World.TerrainType.COUNT, 0);

        for(local i = 0; i < 6; i++)
        {
            if (tile.hasNextTile(i))
            {
                ++terrain[tile.getNextTile(i).Type];
            }
        }

        terrain[this.Const.World.TerrainType.Plains] = this.Math.max(0, terrain[this.Const.World.TerrainType.Plains] - 1);

        if (terrain[this.Const.World.TerrainType.Steppe] != 0 && this.Math.abs(terrain[this.Const.World.TerrainType.Steppe] - terrain[this.Const.World.TerrainType.Hills]) <= 2)
        {
            terrain[this.Const.World.TerrainType.Steppe] += 2;
        }

        if (terrain[this.Const.World.TerrainType.Snow] != 0 && this.Math.abs(terrain[this.Const.World.TerrainType.Snow] - terrain[this.Const.World.TerrainType.Hills]) <= 2)
        {
            terrain[this.Const.World.TerrainType.Snow] += 2;
        }

        local highest = 0;

        for(local i = 0; i < this.Const.World.TerrainType.COUNT; i++)
        {
            if (i == this.Const.World.TerrainType.Ocean || i == this.Const.World.TerrainType.Shore)
            {
            }
            else if (terrain[i] >= terrain[highest])
            {
                highest = i;
            }
        }

        return highest;
    }

    /**
     * Injects settlement encounters into data for the ui
     * This stuff should be implemented in camp class, not UI class as of current state
     */
    q.getUIInformation <- function() {
        ::logInfo("camp_manager.getUIInformation called");
        local night = !this.World.getTime().IsDaytime;
        local highest = this.getUITerrain();
        local foreground = this.Const.World.TerrainCampImages[highest].Foreground;
        local result = {
            Title = this.World.Assets.getName() + " Camp",
            SubTitle = "No camp tasks have been scheduled...",
            HeaderImagePath = null,
            Background = this.Const.World.TerrainCampImages[highest].Background + (night ? "_night" : "") + ".jpg",
            Mood = this.Const.World.TerrainCampImages[highest].Mood + ".png",
            Foreground = foreground != null ? foreground + (night ? "_night" : "") + ".png" : null,
                Slots = [],
                Situations = []
        };
        foreach (building in this.getBuildings())
        {
            if (building == null || building.isHidden())
            {
                result.Slots.push(null);
                continue;
            }

            local image = null;

            // how about consts here? magic numbers are bad practice
            if (highest == 4 || highest == 8 || highest == 9) {
                image = building.getUIImage(highest);
            } else {
                image = building.getUIImage(0);
            }

            local b = {
                Image = image,
                Tooltip = building.getTooltipID(),
                Slot = building.getSlot(),
                CanEnter = building.canEnter()
            };
            result.Slots.push(b);
        }

        // original function end, add mod stuff
        result.Encounters <- [];
        foreach(encounter in this.m.CampEncounters) {
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
        _out.writeF32(this.m.CampEncountersCooldownUntil);
        _out.writeU32(this.m.CampEncounters.len());
        foreach(e in this.m.CampEncounters) {
            _out.writeString(e.getType());
        }
    }

    q.onDeserialize = @(__original) function (_in) {
        __original(_in);
        if (::ModEncounterManager.Mod.Serialization.isSavedVersionAtLeast("0.1.2", _in.getMetaData())) {
            this.m.CampEncountersCooldownUntil = _in.readF32();
            local size = _in.readU32();
            for( local i = 0; i < size; i = ++i ) {
                local e = this.World.Encounters.getEncounter(_in.readString());
                if (e != null) {
                    this.m.CampEncounters.push(e);
                }
            }
        }
    }

});
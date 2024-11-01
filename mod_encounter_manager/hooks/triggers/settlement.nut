::ModEncounterManager.Hooks.hook("scripts/entity/world/settlement", function(q) {
    /** New field for events that should happens on settlement enter */
    q.m.SettlementTriggers <- [this.new("scripts/triggers/quest/test_quest")]
    /** New field for settlements encounters */
    q.m.SettlementEncounters <- [
        this.new("scripts/encounters/generic/fav_enemy_swordmaster_encounter"),
//        this.new("scripts/encounters/generic/test_encounter"),
//        this.new("scripts/encounters/generic/test_encounter"),
//        this.new("scripts/encounters/generic/test_encounter"),
//        this.new("scripts/encounters/generic/test_encounter")
    ]

    /**
     * Adds a check on settlement enter, to check if it should show event.
     */
    q.onEnter = @(__original) function () {
        local ret = __original();
        if(::World.EncounterManager.onSettlementEntered(this)) {
            ::World.State.m.LastEnteredTown = null;
            return false;
        }
        return ret;
    }

    /**
     * Callback function for UI, called on encounter click
     */
    q.onEncounterClicked <- function(_i, _townScreen){
        this.World.EncounterManager.fireEncounter(this.m.SettlementEncounters[_i]);
    }

    /**
     * Injects settlement encounters datgit branch -M maina for the ui
     */
    q.getUIInformation = @(__original) function() {
        local result = __original();
        result.Encounters <- [];
        foreach(encounter in this.m.SettlementEncounters) {
            result.Encounters.push({
                Icon = encounter.m.Icon,
                EncounterId = encounter.m.ID,
            });
        }
        return result;
    }
});
::ModEncounterManager.Hooks.hook("scripts/states/world_state", function(q) {
    q.m.Encounters <- null;

    q.onInit = @(__original) function () {
        this.m.Encounters = this.new("scripts/states/world/encounter_manager");
        this.World.Encounters <- this.WeakTableRef(this.m.Encounters);
        this.m.Encounters.onInit();
        __original();
    }

    q.onFinish = @(__original) function() {
        __original();
        this.m.Encounters.clear();
        this.m.Encounters = null;
        this.World.Encounters = null;
    }

    /**
     * Adds convenience method to world state to mimic original
     * Shows encouter dialog while in settlement
     */
    q.showEncounterScreenFromTown <- function (_encounter, _playSound = true) {
        if (!this.m.EventScreen.isVisible() && !this.m.EventScreen.isAnimating())
        {
            if (_playSound && this.Const.Events.GlobalSound != "")
            {
                this.Sound.play(this.Const.Events.GlobalSound, 1.0);
            }

            this.m.WorldTownScreen.hideAllDialogs();
            this.m.EventScreen.setIsEncounter(true);
            this.m.EventScreen.show(_encounter);
            this.m.MenuStack.push(function ()
            {
                this.m.EventScreen.hide();
                this.m.WorldTownScreen.showLastActiveDialog();
                this.m.EventScreen.setIsEncounter(false);
                this.m.WorldTownScreen.refresh();
            }, function ()
            {
                return false;
            });
        }
    }

    /**
     * Adds convenience method to world state to mimic original
     * Shows encouter dialog while in camp
     */
    q.showEncounterScreenFromCamp <- function (_encounter, _playSound = true) {
        if (!this.m.EventScreen.isVisible() && !this.m.EventScreen.isAnimating())
        {
            if (_playSound && this.Const.Events.GlobalSound != "")
            {
                this.Sound.play(this.Const.Events.GlobalSound, 1.0);
            }

            this.m.CampScreen.hide();
            this.m.EventScreen.setIsEncounter(true);
            this.m.EventScreen.show(_encounter);
            this.m.MenuStack.push(function ()
            {
                this.m.EventScreen.hide();
                this.m.CampScreen.show();
                this.m.EventScreen.setIsEncounter(false);
                this.m.WorldTownScreen.refresh();
            }, function ()
            {
                return false;
            });
        }
    }

    q.onSerialize = @(__original) function (_out) {
        this.m.Encounters.onSerialize(_out);
        __original(_out);
    }

    q.onDeserialize = @(__original) function (_in) {
        if (::ModEncounterManager.Mod.Serialization.isSavedVersionAtLeast("0.1.0", _in.getMetaData())) {
            this.m.Encounters.onDeserialize(_in);
        }
        __original(_in);
    }
});
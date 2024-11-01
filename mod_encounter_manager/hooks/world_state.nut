::ModEncounterManager.Hooks.hook("scripts/states/world_state", function(q) {
    q.m.EncounterManager <- null;

    q.onInit = @(__original) function () {
        this.m.EncounterManager = this.new("scripts/states/world/encounter_manager");
        this.World.EncounterManager <- this.WeakTableRef(this.m.EncounterManager);
        this.m.EncounterManager.onInit();
        __original();
    }

    q.onFinish = @(__original) function() {
        __original();
        this.m.EncounterManager.clear();
        this.m.EncounterManager = null;
        this.World.EncounterManager = null;
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
            }, function ()
            {
                return false;
            });
        }
    }

    q.onSerialize = @(__original) function (_out) {
        this.m.EncounterManager.onSerialize(_out);
        __original(_out);
    }

    q.onDeserialize = @(__original) function (_in) {
        if (::ModEncounterManager.Mod.Serialization.isSavedVersionAtLeast("0.1.0", _in.getMetaData())) {
            this.m.EncounterManager.onDeserialize(_in);
        }
        __original(_in);
    }
});
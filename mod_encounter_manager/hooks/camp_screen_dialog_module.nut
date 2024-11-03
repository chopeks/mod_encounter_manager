::ModEncounterManager.Hooks.hook("scripts/ui/screens/world/modules/camp_screen/camp_main_dialog_module", function(q) {
    /**
     * Screen handler method, passes clicks to parent screen
     */
    q.onEncounterClicked <- function(_data) {
        this.m.Parent.onEncounterClicked(_data);
    }
});
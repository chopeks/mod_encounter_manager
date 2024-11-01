::ModEncounterManager.Hooks.hook("scripts/ui/screens/world/world_town_screen", function(q) {
    /**
     * Screen handler method, passes clicks to settlement callback
     */
    q.onEncounterClicked <- function(_data){
        if (this.isAnimating()) {
            return;
        }
        if (this.m.Town != null) {
            this.m.Town.onEncounterClicked(_data, this);
        }
    }
});
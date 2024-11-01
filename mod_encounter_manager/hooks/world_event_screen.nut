::ModEncounterManager.Hooks.hook("scripts/ui/screens/world/world_event_screen", function(q) {
    /** Adds variable to the event screen controller, that indicates encounter*/
    q.m.IsEncounter <- false;

    /** Setter */
    q.setIsEncounter <- function ( _c ) {
        this.m.IsEncounter = _c;
    }

    /**
     * Reroutes input handler for encounter to proper manager
     */
    q.onButtonPressed = @(__original) function (_buttonID) {
        if (this.m.IsEncounter) {
            this.World.EncounterManager.processInput(_buttonID);
        } else {
            __original(_buttonID);
        }
    }

});
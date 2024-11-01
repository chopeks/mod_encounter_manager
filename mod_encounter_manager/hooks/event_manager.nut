::ModEncounterManager.Hooks.hook("scripts/events/event_manager", function(q) {
    /**
     * Adds new method that fires event from event instance instead of ID, to be used for events that should happens on settlement enter
     */
    q.fireEvent <- function (_event) {
        if (_event != null && this.m.ActiveEvent != null && this.m.ActiveEvent.getID() != _event.getID()) {
            this.logInfo("Failed to fire event - another event with id \'" + this.m.ActiveEvent.getID() + "\' is already queued.");
            return false;
        }
        if (event != null) {
            this.m.ActiveEvent = _event;
            this.m.ActiveEvent.fire();

            if (this.World.State.showEventScreen(this.m.ActiveEvent)) {
                return true;
            } else {
                this.m.ActiveEvent.clear();
                this.m.ActiveEvent = null;
                return false;
            }
        } else {
            this.logInfo("Failed to fire event - with id \'" + _event.getID() + "\' not found.");
            return false;
        }
    }
});


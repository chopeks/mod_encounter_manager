this.encounter_manager <- {
    m = {
        ActiveEvent = null,
        SettlementEvents = [],
        SettlementEncounters = []
    },

    function onInit() {
        foreach(i, scriptFile in this.IO.enumerateFiles("scripts/triggers/settlement/")) {
            this.m.SettlementEvents.push(this.new(scriptFile));
        }
        ::logInfo("initialized SettlementEvents, len=" +  this.m.SettlementEvents.len());
        foreach(i, scriptFile in this.IO.enumerateFiles("scripts/encounters/generic")) {
            this.m.SettlementEncounters.push(this.new(scriptFile));
        }
//        foreach(i, scriptFile in this.IO.enumerateFiles("scripts/encounters/situation")) {
//            this.m.SettlementEncounters.push(this.new(scriptFile));
//        }
        ::logInfo("initialized SettlementEncounters, len=" +  this.m.SettlementEncounters.len());
    }

    function clear() {
        this.m.ActiveEvent = null;
        this.m.SettlementEvents = [];
    }

    /**
     * Decides if event on settlement enter should be shown or not
     */
    function onSettlementEntered(_settlement) {
        ::logInfo("onSettlementEntered");
        local validEvents = [];
        foreach(event in this.m.SettlementEvents) {
            if (event.isTriggerValid(_settlement)) {
                validEvents.push(event);
            }
        }
        ::logInfo("onSettlementEntered validEvents.len() = " + validEvents.len());
        if (validEvents.len() == 0)
            return false;

        ::logInfo("can fire event " + this.canFireEvent())
        if (this.canFireEvent()) {
            ::logInfo("scheduling an event now")
            return this.World.Events.fireEvent(validEvents[0]);
        } else {
            ::logWarning("couldn't fire an event")
        }
        return false;
    }

    /**
     * Encounter click handler
     */
    function processInput(_buttonID) {
        if (this.m.ActiveEvent == null) {
            return false;
        }
        if (this.m.ActiveEvent.processInput(_buttonID)) {
            this.World.State.getEventScreen().show(this.m.ActiveEvent)
            return false;
        } else {
            this.m.ActiveEvent.clear();
            this.m.ActiveEvent = null;
            this.World.State.getMenuStack().pop(true);
            return true;
        }
    }

    function canFireEvent() {
        if (
            this.World.State.getMenuStack().hasBacksteps() ||
            this.LoadingScreen != null && (this.LoadingScreen.isAnimating() || this.LoadingScreen.isVisible()) ||
            this.World.State.m.EventScreen.isVisible() ||
            this.World.State.m.EventScreen.isAnimating()
        ) {
            return false;
        }

        if (("State" in this.Tactical) && this.Tactical.State != null) {
            return false;
        }

        if (this.m.ActiveEvent != null) {
            return false;
        }

        local parties = this.World.getAllEntitiesAtPos(this.World.State.getPlayer().getPos(), 400.0);

        foreach(party in parties) {
            if (!party.isAlliedWithPlayer()) {
                return false;
            }
        }
        return true;
    }

    function fire( _id, _update = true )
    {
        if (this.m.ActiveEvent != null && this.m.ActiveEvent.getID() != _id)
        {
            this.logInfo("Failed to fire event - another event with id \'" + this.m.ActiveEvent.getID() + "\' is already queued.");
            return false;
        }

        local event = this.getEvent(_id);

        if (event != null)
        {
            if (_update)
            {
                event.update();
            }

            this.m.ActiveEvent = event;
            this.m.ActiveEvent.fire();

            if (this.World.State.showEventScreen(this.m.ActiveEvent))
            {
                return true;
            }
            else
            {
                this.m.ActiveEvent.clear();
                this.m.ActiveEvent = null;
                return false;
            }
        } else {
            this.logInfo("Failed to fire event - with id \'" + _id + "\' not found.");
            return false;
        }
    }

    function fireEncounter(_encounter, _update = true) {
        if (_encounter != null && this.m.ActiveEvent != null && this.m.ActiveEvent.getID() != _encounter.getID()) {
            this.logInfo("Failed to fire event - another event with id \'" + this.m.ActiveEvent.getID() + "\' is already queued.");
            return false;
        }

//        if (_update) {
//            _encounter.update();
//        }

        this.m.ActiveEvent = _encounter;
        this.m.ActiveEvent.fire();

        this.World.State.showEncounterScreenFromTown(_encounter);
    }


    function onSerialize( _out )
    {
        ::logInfo("encounter_manager.onSerialize");
    }

    function onDeserialize( _in )
    {
        ::logInfo("encounter_manager.onDeserialize");
    }
};
this.recruitment_vala_encounter <- this.inherit("scripts/encounters/encounter", {
    m = {

    },
    function create() {
        this.createScreens();
        this.m.Type = "encounter.recruitment_vala_encounter";
        this.m.Name = "Recruitment effort";
    }

    function createScreens() {
        this.m.Screens.extend([{
            ID = "Start",
            Title = "Recruitment",
            Text = "[img]gfx/ui/events/event_134.png[/img]{Recruit Vala.}",
            Image = "",
            List = [],
            Options = [
            {
                Text = "Check her out",
                function getResult() {
                    this.World.State.getMenuStack().popAll(true);
                    this.Time.scheduleEvent(this.TimeUnit.Virtual, 1, function ( _tag ) {
                        this.World.Events.fire("event.legend_vala_recruitment");
                    }, null);
                    this.Time.scheduleEvent(this.TimeUnit.Real, 500, function ( _tag ) {
                        this.World.State.setPause(false);
                    }, null);
                    return 0;
                }
            },
            {
                Text = "Not now.",
                function getResult() {
                    return 0;
                }
            }
            ],
            function start() {

            }
        }]);
    }

    function isValid(_settlement) {
        local event = this.World.Events.getEvent("event.legend_vala_recruitment");
        if (event == null) {
            return false;
        }
        event.onUpdateScore();
        return event.m.isValidForEncounter;
    }
})
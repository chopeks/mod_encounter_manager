this.fav_enemy_swordmaster_camp_encounter <- this.inherit("scripts/encounters/encounter", {
    m = {

    },
    function create() {
        this.createScreens();
        this.m.Type = "encounter.fav_enemy_swordmaster_camp_encounter";
        this.m.Name = "fav_enemy_swordmaster_camp_encounter";
    }

    function createScreens() {
        this.m.Screens.extend([{
            ID = "Start",
            Title = "Looking for a fight",
            Text = "[img]gfx/ui/events/event_134.png[/img]{You hear some ruckus near the camp entrance.}",
            Image = "",
            List = [],
            Options = [
            {
                Text = "Check it out",
                function getResult() {
                    this.World.State.getMenuStack().popAll(true);
                    this.Time.scheduleEvent(this.TimeUnit.Virtual, 1, function ( _tag ) {
                        this.World.Events.fire("event.legend_swordmaster_fav_enemy");
                    }, null);
                    this.Time.scheduleEvent(this.TimeUnit.Real, 500, function ( _tag ) {
                        this.World.State.setPause(false);
                    }, null);
                    return 0;
                }
            }
            ],
            function start() {

            }
        }]);
    }

    function isValid(_camp) {
        local event = this.World.Events.getEvent("event.legend_swordmaster_fav_enemy");
        if (event == null) {
            return false;
        }
        event.onUpdateScore();
        return event.m.isValidForEncounter;
    }
})
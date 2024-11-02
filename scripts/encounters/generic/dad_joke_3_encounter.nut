this.dad_joke_3_encounter <- this.inherit("scripts/encounters/encounter", {
    m = {

    },
    function create() {
        this.createScreens();
        this.m.Type = "encounter.dad_joke_3_encounter";
        this.m.Name = "Dad joke 3";
//        this.m.Icon = "ui/encounters/encounter.png"
    }

    function createScreens() {
        this.m.Screens.extend([{
            ID = "Task",
            Title = "Dad joke of the day",
            Text = "[img]gfx/ui/boggers.png[/img]{I used to hate facial hair, but then it grew on me.}",
            Image = "",
            List = [],
            Options = [
            {
                Text = "Give me a break",
                function getResult() {
                    return 0;
                }
            }
            ],
            function start() {}
        }]);
    }

    function isValid(_settlement) {
        return !isOnCooldown();
    }
})
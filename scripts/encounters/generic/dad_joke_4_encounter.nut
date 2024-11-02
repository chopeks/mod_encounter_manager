this.dad_joke_4_encounter <- this.inherit("scripts/encounters/encounter", {
    m = {

    },
    function create() {
        this.createScreens();
        this.m.Type = "encounter.dad_joke_4_encounter";
        this.m.Name = "Dad joke 4";
//        this.m.Icon = "ui/encounters/encounter.png"
    }

    function createScreens() {
        this.m.Screens.extend([{
            ID = "Task",
            Title = "Dad joke of the day",
            Text = "[img]gfx/ui/boggers.png[/img]{I was in a job interview the other day and they asked if I could perform under pressure. I said no, but I could perform Bohemian Rhapsody.}",
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
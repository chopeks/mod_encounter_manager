this.dad_joke_5_encounter <- this.inherit("scripts/encounters/encounter", {
    m = {

    },
    function create() {
        this.createScreens();
        this.m.Type = "encounter.dad_joke_5_encounter";
        this.m.Name = "Dad joke 5";
//        this.m.Icon = "ui/encounters/encounter.png"
    }

    function createScreens() {
        this.m.Screens.extend([{
            ID = "Task",
            Title = "Dad joke of the day",
            Text = "[img]gfx/ui/boggers.png[/img]{An apple a day keeps the doctor away. At least it does if you throw it hard enough.}",
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
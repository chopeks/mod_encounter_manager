this.dad_joke_6_encounter <- this.inherit("scripts/encounters/encounter", {
    m = {

    },
    function create() {
        this.createScreens();
        this.m.Type = "encounter.dad_joke_6_encounter";
        this.m.Name = "Dad joke 6";
//        this.m.Icon = "ui/encounters/encounter.png"
    }

    function createScreens() {
        this.m.Screens.extend([{
            ID = "Task",
            Title = "Dad joke of the day",
            Text = "[img]gfx/ui/boggers.png[/img]{My landlord told me we need to talk about the heating bill. \"Sure,\" I said. \"My door is always open.\"}",
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
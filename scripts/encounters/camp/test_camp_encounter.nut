this.test_camp_encounter <- this.inherit("scripts/encounters/encounter", {
    m = {
    },
    function create() {
        this.createScreens();
        this.m.Type = "encounter.test_camp_encounter";
        this.m.Name = "Scout report from camp";
//        this.m.Icon = "ui/encounters/encounter.png"
    }

    function createScreens() {
        this.m.Screens.extend([{
            ID = "Task",
            Title = "Aye mate, here we go",
            Text = "Put some jokes here or something, idk.",
            Image = "",
            List = [],
            Options = [
            {
                Text = "Click me for free puppies!",
                function getResult() {
                    return "screen2";
                }
            },
            {
                Text = "Not now",
                function getResult() {
                    return 0;
                }
            }
            ],
            function start() {}
        }, {
            ID = "screen2",
            Title = "Aye mate, that's 2nd screen!",
            Text = "No puppies, but 2nd screen! Woohoo, now push that button",
            Image = "",
            List = [],
            Options = [
            {
                Text = "Bummer, let's go!",
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
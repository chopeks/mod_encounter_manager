this.test_encounter <- this.inherit("scripts/encounters/encounter", {
    m = {

    },
    function create() {
        this.createScreens();
        this.m.Type = "encounter.test_encounter";
        this.m.Name = "Scout report";
//        this.m.Icon = "ui/encounters/encounter.png"
    }

    function createScreens() {
        this.m.Screens.extend([{
            ID = "Task",
            Title = "Aye mate, here we go",
            Text = "Somehow it even showed",
            Image = "",
            List = [],
            Options = [
            {
                Text = "Enter",
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
            Title = "Aye mate, that's 2nd screen",
            Text = "Now push that button",
            Image = "",
            List = [],
            Options = [
            {
                Text = "Let's go!",
                function getResult() {
                    return 0;
                }

            }
            ],
            function start() {}
        }]);
    }
})
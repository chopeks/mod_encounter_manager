this._tips_encounter <- this.inherit("scripts/encounters/encounter", {
    m = {

    },
    function create() {
        this.createScreens();
        this.m.Type = "encounter._tips_encounter";
        this.m.Name = "Tips";
//        this.m.Icon = "ui/encounters/encounter.png"
    }

    function createScreens() {
        // todo lists don't work?
//        local list = [];
//        foreach(i, tip in ::Const.TipOfTheDay)
//            list.push({ id = i, icon = "ui/boggers", text = tip })
        local text = "Here are some tips for you:";
        foreach(i, tip in ::Const.TipOfTheDay) {
            text = text + "\n- " + tip;
        }
        this.m.Screens.extend([{
            ID = "Task",
            Title = "Tips",
            Text = text,
            Image = "",
            List = [],
            Options = [
            {
                Text = "Nice",
                function getResult() {
                    return 0;
                }
            }
            ],
            function start() {}
        }]);
    }

    function isValid(_camp) {
        return false;
    }
})
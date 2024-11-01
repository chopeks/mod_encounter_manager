this.test_quest <- {
    ID = "Task",
    Title = "Title hell yeah",
    Text = "You approach.",
    Icon = "ui/items/legendary_map.png",
    Image = "ui/items/legendary_map.png",
    List = [],
    ShowEmployer = true,
    Options = [
        {
            Text = "Enter",
            function getResult() {
                return "Overview_Building";
            }
        },
        {
            Text = "Not now",
            function getResult() {
                return 0;
            }

        }
    ],
    function start() {

    }

    function getID() {
        return this.ID;
    }

    function getUITitle() {
        return this.ID;
    }
}
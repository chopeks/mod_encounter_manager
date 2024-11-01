this.fav_enemy_swordmaster_encounter <- this.inherit("scripts/encounters/encounter", {
    m = {

    },
    function create() {
        this.createScreens();
        this.m.Type = "encounter.fav_enemy_swordmaster_encounter";
        this.m.Name = "Swordmaster";
    }

    function createScreens() {
        this.m.Screens.extend([{
            ID = "Start",
            Title = "Looking for a fight",
            Text = "[img]gfx/ui/events/event_134.png[/img]{You hear that there's some cocky bastard looking for a fight.}",
            Image = "",
            List = [],
            Options = [
            {
                Text = "Check him out",
                function getResult() {
                    this.World.State.getMenuStack().popAll(true);
                    this.Time.scheduleEvent(this.TimeUnit.Virtual, 1, function ( _tag ) {
                        local event = this.World.Events.getEvent("event.legend_swordmaster_fav_enemy");
                        event.onUpdateScore();
                        this.World.Events.fire("event.legend_swordmaster_fav_enemy");
                    }, null);
                    this.Time.scheduleEvent(this.TimeUnit.Real, 500, function ( _tag ) {
                        this.World.State.setPause(false);
                    }, null);
                    return 0;
                }
            },
            {
                Text = "It's not worth it",
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
        local candidates = [];
        foreach( bro in this.World.getPlayerRoster().getAll()) {
            if (!bro.getSkills().hasSkill("perk.legend_favoured_enemy_swordmaster")) {
                continue;
            }

            if (bro.getLevel() < 11) {
                continue;
            }

            local stats = this.Const.LegendMod.GetFavoriteEnemyStats(bro, this.Const.LegendMod.FavoriteSwordmaster);

            while (stats.Strength < this.m.MinStrength)	{
                this.logInfo("BRO " + bro.getName() + " Min strength < m.MinStrength : " + stats.Strength);
            }

            this.m.Stats = this.Math.floor(stats.Strength);
            candidates.push(bro);
        }

        if (candidates.len() == 0) {
            return false;
        }
        return true;
    }
})
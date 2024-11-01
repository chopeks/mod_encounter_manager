::ModEncounterManager.Hooks.hook("scripts/events/events/legends/legend_swordmaster_fav_enemy_event", function(q) {
    q.m.isValidForEncounter <- false;

    q.onUpdateScore = @(__original) function() {
        __original();
        this.m.isValidForEncounter = this.m.Score > 0 && this.Time.getVirtualTimeF() > this.m.CooldownUntil;
        this.m.Score = 0; // this disables event from happening normally
    }
});
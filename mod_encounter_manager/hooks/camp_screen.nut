::ModEncounterManager.Hooks.hook("scripts/ui/screens/world/camp_screen", function(q) {
    /**
     * Screen handler method, passes clicks to camp callback
     */
    q.onEncounterClicked <- function(_data) {
        if (this.isAnimating()) {
            return;
        }
        this.World.Camp.onEncounterClicked(_data, this);
    }

    /**
     * Remove original bullshit from view implementation, keep it in business model classes
     */
    q.getUITerrain = @() function() {
        return this.World.Camp.getUITerrain();
    }

    /**
     * Remove original bullshit from view implementation, keep it in business model classes
     * Still not perfect solution, as queryAssetsInformation should actually be called separatelly,
     * check town window implentation
     */
    q.getUIInformation = @() function() {
        local result = this.World.Camp.getUIInformation();
        result.Assets <- this.queryAssetsInformation();
        return result;
    }

    /**
     * This is dirty little hack, but it's actually camp class that should call it, not the other way around
     */
    q.show = @(__original) function() {
        this.World.Camp.onEnter();
        __original();
    }
});
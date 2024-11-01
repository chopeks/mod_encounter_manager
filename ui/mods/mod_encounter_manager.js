var mod_encounter_manager = {
    ID : "mod_encounter_manager",
    Hooks : {},
}

/**
 * Called on encounter click
 * @param _data
 */
WorldTownScreen.prototype.notifyBackendEncounterClicked = function (_data) {
    if(this.mSQHandle !== null) {
        SQ.call(this.mSQHandle, 'onEncounterClicked', _data);
    }
};

/**
 * Creates container for encounters
 * @param _parentDiv
 * @returns {*|jQuery|HTMLElement}
 */
WorldTownScreenMainDialogModule.prototype.createEncountersDIV = function (_parentDiv)
{
    var self = this;
    var layout = $('<div class=""/>');
    _parentDiv.append(layout);
    return layout;
};

/**
 * Updates list of encounters
 * @param _data
 */
WorldTownScreenMainDialogModule.prototype.updateEncounters = function (_data)
{
    var content = this.mDialogContainer.findDialogContentContainer();

    for (var i = 0; i < 10; ++i) {
        for (var j = 0; j < 3; ++j) {
            var c = content.find('.encounter' + i + ':first');

            if (c !== undefined && c !== null) {
                c.unbindTooltip();
                c.remove();
            }
        }
    }

    if (_data.Encounters.length != 0) {
        for (var i = 0; i < _data.Encounters.length; ++i) {
            this.createEncounter(_data.Encounters[i], i, content);
        }
    }
}

/**
 * Creates single encounter
 * @param _data encounter ui mapping
 * @param _i index in array
 * @param _content html
 */
WorldTownScreenMainDialogModule.prototype.createEncounter = function (_data, _i, _content) {
    if (_data == null) {
        return;
    }

    var self = this;
    var classes = 'display-block is-status-effect encounter' + _i;
    var encounter = _content.createImage(Path.GFX + _data.Icon, null, null, classes);
    // var overlay = _content.createImage(Path.GFX + "ui/encounters/encounter_overlay.png", null, null, classes + ' opacity-none');

    encounter.click(function (_event) {
        self.mParent.notifyBackendEncounterClicked(_i);
    });

    encounter.bindTooltip({ contentType: 'msu-generic', modId: mod_encounter_manager.ID, elementId: "EncounterElement", encounterId: _data.EncounterId});
}


//region hooks
mod_encounter_manager.Hooks.loadEncountersFromData = WorldTownScreenMainDialogModule.prototype.loadFromData;
WorldTownScreenMainDialogModule.prototype.loadFromData = function (_data){
    mod_encounter_manager.Hooks.loadEncountersFromData.call(this, _data);
    if ('Encounters' in _data && _data['Encounters'] !== null) {
        this.updateEncounters(_data);
    }
}
//endregion
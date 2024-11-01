::ModEncounterManager.getEncounterUIData <- function(_data) {
	local encounterId = _data.encounterId;
	local title = "Error"
	foreach (e in this.World.EncounterManager.m.SettlementEncounters) {
		if (e.getID() == encounterId) {
			title = e.getName();
			break;
		}
	}
 	return [
		{
			id = 1,
			type = "title",
			text = title
		},
		{
			id = 2,
			type = "description",
			text = "Click to check what is going on here."
		},
	];
}

::ModEncounterManager.Mod.Tooltips.setTooltips({
	EncounterElement = ::MSU.Class.CustomTooltip(function(_data) {
		return ::ModEncounterManager.getEncounterUIData(_data);
	}),
})

::ModEncounterManager <- {
	ID = "mod_encounter_manager",
	Name = "Trigger event manager",
	Version = "0.1.0"
}
local mod = ::Hooks.register(::ModEncounterManager.ID, ::ModEncounterManager.Version, ::ModEncounterManager.Name);
::ModEncounterManager.Hooks <- mod;

mod.require("mod_msu >= 1.2.6", "mod_modern_hooks >= 0.4.0");

mod.queue(">mod_msu", ">mod_modern_hooks", ">mod_legends", function() {
	::ModEncounterManager.Mod <- ::MSU.Class.Mod(::ModEncounterManager.ID, ::ModEncounterManager.Version, ::ModEncounterManager.Name);

	::Hooks.registerLateJS("ui/mods/mod_encounter_manager.js");
	::Hooks.registerCSS("ui/mods/mod_encounter_manager.css");

	foreach (file in ::IO.enumerateFiles("mod_encounter_manager/hooks/")) {
		::include(file);
	}
	::include("mod_encounter_manager/tooltips.nut");
});
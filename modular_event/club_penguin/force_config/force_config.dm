/datum/controller/configuration/LoadEntries(filename, list/stack)
	. = ..()

	if (filename == "config.txt")
		LoadEntries("strings/force_config.txt")

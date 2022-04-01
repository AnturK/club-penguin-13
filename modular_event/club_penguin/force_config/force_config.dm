/datum/controller/configuration/LoadEntries(filename, list/stack)
	. = ..()

	if (filename == "config.txt")
		directory = "strings"
		LoadEntries("force_config.txt")
		directory = "config"

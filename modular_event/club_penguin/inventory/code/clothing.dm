GLOBAL_LIST_INIT(club_penguin_clothing, init_club_penguin_clothing())

// Do this instead of initial because checking pixel offsets is a PITA outside of live
/proc/init_club_penguin_clothing()
	var/list/output = list()

	for (var/clothing_type in subtypesof(/datum/club_penguin_clothing))
		output[clothing_type] = new clothing_type

	return output

/datum/club_penguin_clothing
	var/name

	/// The actual item ID on Club Penguin.
	/// Important because this grabs directly from icer.ink.
	var/club_penguin_id

	var/icon

	var/slot

/datum/club_penguin_inventory/proc/get_items_by_slot_ui_data()
	var/list/items_by_slot = list()

	var/index = 0

	for (var/datum/club_penguin_clothing/clothing_type as anything in owned_items)
		index += 1

		var/clothing_slot = initial(clothing_type.slot)

		var/list/clothing_data = list(
			"index" = index,
			"club_penguin_id" = initial(clothing_type.club_penguin_id),
		)

		if (clothing_slot in items_by_slot)
			items_by_slot[clothing_slot] += clothing_data
		else
			items_by_slot[clothing_slot] = clothing_data

	return items_by_slot

/datum/club_penguin_inventory/proc/toggle_clothing(datum/club_penguin_clothing/clothing_type)
	if (clothing_type in equipped_clothing)
		equipped_clothing -= clothing_type
		return TRUE

	// Unequip whatever is in the same slot
	var/equipping_slot = initial(clothing_type.slot)
	for (var/datum/club_penguin_clothing/equipped_clothing_type as anything in equipped_clothing)
		if (initial(equipped_clothing_type.slot) == equipping_slot)
			equipped_clothing -= equipped_clothing_type
			break

	equipped_clothing += clothing_type

	return TRUE

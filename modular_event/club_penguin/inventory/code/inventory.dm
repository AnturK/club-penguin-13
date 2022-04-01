/mob/living/basic/club_penguin
	var/datum/club_penguin_inventory/inventory

/datum/club_penguin_inventory
	var/list/equipped_clothing = list()
	var/list/owned_items = list()

/datum/club_penguin_inventory/New()
	. = ..()
	owned_items = subtypesof(/datum/club_penguin_clothing)

/datum/club_penguin_inventory/proc/create_penguin_overlays(item_state)
	var/list/overlays = list()

	for (var/clothing_type as anything in equipped_clothing)
		var/datum/club_penguin_clothing/clothing = GLOB.club_penguin_clothing[clothing_type]
		overlays += image(clothing.icon, icon_state = item_state)

	return overlays

/datum/club_penguin_inventory/proc/get_worn_item_ids()
	var/list/worn_item_ids = list()

	for (var/clothing_type in equipped_clothing)
		var/datum/club_penguin_clothing/clothing = GLOB.club_penguin_clothing[clothing_type]
		worn_item_ids += clothing.club_penguin_id

	return worn_item_ids

/mob/living/basic/club_penguin
	var/inventory_ui_open = FALSE

/mob/living/basic/club_penguin/Click(location, control, params)
	var/list/modifiers = params2list(params)

	if (!LAZYACCESS(modifiers, LEFT_CLICK))
		return ..()

	ui_interact(usr)

/mob/living/basic/club_penguin/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "PlayerCard")
		ui.open()

/mob/living/basic/club_penguin/ui_status(mob/user)
	if (user == src)
		return UI_INTERACTIVE
	else
		return UI_UPDATE

/mob/living/basic/club_penguin/ui_data(mob/user)
	var/list/data = list()

	data["name"] = name
	data["color"] = penguin_color
	data["worn_items"] = inventory.get_worn_item_ids()
	data["can_edit_inventory"] = user == src

	if (inventory_ui_open)
		data["inventory"] = inventory.get_items_by_slot_ui_data()

	return data

/mob/living/basic/club_penguin/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if (.)
		return .

	switch (action)
		if ("open_inventory")
			inventory_ui_open = TRUE
		if ("toggle")
			var/index = round(params["index"])
			if (!index)
				stack_trace("[params["index"]] was an invalid index")
				return TRUE

			var/clothing_type = LAZYACCESS(inventory.owned_items, index)
			if (isnull(clothing_type))
				stack_trace("[index] points to null")
				return TRUE

			if (inventory.toggle_clothing(clothing_type))
				update_appearance(UPDATE_OVERLAYS)

	return TRUE

/mob/living/basic/club_penguin/ui_close(mob/user)
	inventory_ui_open = FALSE

/mob/living/basic/club_penguin/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/penguin),
	)
/datum/asset/simple/penguin
	assets = list(
		"penguin-body.png" = 'modular_event/club_penguin/penguin/icons/playercard/body.png',
		"penguin-features.png" = 'modular_event/club_penguin/penguin/icons/playercard/features.png',
	)

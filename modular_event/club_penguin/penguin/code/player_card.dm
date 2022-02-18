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
	return UI_INTERACTIVE

/mob/living/basic/club_penguin/ui_data(mob/user)
	var/list/data = list()

	data["name"] = name
	data["color"] = penguin_color

	return data

/mob/living/basic/club_penguin/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/penguin),
	)

/datum/asset/simple/penguin
	assets = list(
		"penguin-body.png" = 'modular_event/club_penguin/penguin/icons/playercard/body.png',
		"penguin-features.png" = 'modular_event/club_penguin/penguin/icons/playercard/features.png',
	)

GLOBAL_DATUM_INIT(club_penguin_map_ui, /datum/club_penguin_map_ui, new)

/mob/verb/open_map()
	set category = "TEST"
	set name = "Open Map"
	GLOB.club_penguin_map_ui.ui_interact(usr)

/datum/club_penguin_map_ui

/datum/club_penguin_map_ui/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/penguin_map_ui)
	)

/datum/club_penguin_map_ui/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CpMap")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/club_penguin_map_ui/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE

/datum/club_penguin_map_ui/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if (.)
		return .

	switch (action)
		if ("teleport")
			var/location = params["location"]
			var/area_typepath = text2path("/area/club_penguin/[location]")

			if (isnull(area_typepath))
				CRASH("Club Penguin map: Area typepath '[location]' does not exist!")

			if (!(area_typepath in GLOB.areas_by_type))
				CRASH("Club Penguin map: Area typepath '[location]' is not a UNIQUE_AREA!")

			var/area/current_area = get_area(usr)
			if (current_area.type != area_typepath)
				usr.create_temporary_loading_screen()
				usr.forceMove(get_safe_turf_in_area(GLOB.areas_by_type[area_typepath]))

			ui.close()

	return FALSE

/datum/asset/simple/penguin_map_ui
	assets = list(
		"club-penguin-map.png" = 'modular_event/club_penguin/hud/icons/map.png',
	)

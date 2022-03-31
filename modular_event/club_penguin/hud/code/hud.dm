/datum/hud/club_penguin

/datum/hud/club_penguin/New(mob/owner)
	. = ..()

	var/atom/movable/screen/club_penguin_hud_button/map/map_button = new(null, owner)
	map_button.hud = src
	static_inventory += map_button

	static_inventory += create_club_penguin_bottom_hud(src, owner)

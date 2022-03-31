/area/club_penguin/cove
	name = "Cove"

/obj/effect/backdrop/cove
	icon = 'modular_event/club_penguin/maps/icons/cove.dmi'

/obj/effect/landmark/area_ambience/cove
	ambience_to_play = 'modular_event/club_penguin/maps/sound/town_ambience.mp3'

/datum/map_template/club_penguin_map/cove
	name = "Cove"
	mappath = "modular_event/club_penguin/maps/map_files/cove.dmm"

/obj/effect/barticle_bonfire
	icon = null

/obj/effect/barticle_bonfire/Initialize(mapload)
	. = ..()
	particles = new /particles/bonfire()

/datum/controller/subsystem/club_penguin_finale/proc/summon_npc_drillers()
	for (var/username in world.file2list("strings/stupid_usernames.txt"))
		if (!username)
			continue
		create_npc_driller(username)
		stoplag(5 SECONDS)

/datum/controller/subsystem/club_penguin_finale/proc/create_npc_driller(username)
	new /mob/living/basic/club_penguin/driller(
		get_safe_turf_in_area(GLOB.areas_by_type[/area/club_penguin/iceberg]),
		username,
		"#[random_color()]"
	)

/mob/living/basic/club_penguin/driller

/mob/living/basic/club_penguin/driller/Initialize(mapload, name, penguin_color)
	. = ..()

	inventory.toggle_clothing(/datum/club_penguin_clothing/miners_helmet)
	RegisterSignal(SSdcs, COMSIG_GLOB_CLUB_PENGUIN_FINALE_PROGRESSION, .proc/on_finale_progression)
	update_icon(UPDATE_OVERLAYS)

/mob/living/basic/club_penguin/driller/Life(delta_time, times_fired)
	. = ..()

	if (!is_dancing())
		dance()

/mob/living/basic/club_penguin/driller/proc/on_finale_progression()
	SIGNAL_HANDLER

	var/static/list/phrases = list(
		"tiiiip",
		"its tipping!!",
		"crack?",
		"drill drill drill",
		"nice",
		"drill!!",
		"keep drilling guys",
		"driiill",
		"hard hats",
		"come on",
		"driiiiiill",
		"drill more",
		"we'll tip it",
		"tipping tipping",
		"its tipping",
		"looool",
		"drill it",
		"just keep drilling",
		"its hard hat and dance",
	)

	if (prob(40) && phrases.len > 0)
		addtimer(CALLBACK(src, /atom/movable/proc/say, pick_n_take(phrases), 30), rand(4 SECONDS, 9 SECONDS))

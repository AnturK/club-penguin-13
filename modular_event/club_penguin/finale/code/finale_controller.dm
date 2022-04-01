SUBSYSTEM_DEF(club_penguin_finale)
	name = "Club Penguin - Iceberg"
	flags = SS_NO_FIRE | SS_NO_INIT

	var/stage = 0

/datum/controller/subsystem/club_penguin_finale/stat_entry(msg)
	return ..("[msg] | Stage [stage]")

#define VV_PROGRESS_STAGE "progress_stage"

/datum/controller/subsystem/club_penguin_finale/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "---")
	VV_DROPDOWN_OPTION(VV_PROGRESS_STAGE, "Progress Stage")

/datum/controller/subsystem/club_penguin_finale/vv_do_topic(list/href_list)
	. = ..()
	if (href_list[VV_PROGRESS_STAGE])
		if (tgui_alert(usr, "This will progress to stage [stage + 1], are you sure?", "Progress Stage", list("Yes", "No")) == "Yes")
			message_admins("[key_name(usr)] has progressed to stage [stage + 1].")
			progress_stage()

#undef VV_PROGRESS_STAGE

/datum/controller/subsystem/club_penguin_finale/proc/progress_stage()
	SIGNAL_HANDLER

	if (stage == 4)
		return

	stage += 1

	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_CLUB_PENGUIN_FINALE_PROGRESSION, stage)

	switch (stage)
		if (1)
			INVOKE_ASYNC(src, .proc/start_stage_one)
		if (2)
			INVOKE_ASYNC(src, .proc/start_stage_two)
		if (3)
			INVOKE_ASYNC(src, .proc/start_stage_three)
		if (4)
			INVOKE_ASYNC(src, .proc/finale)

/datum/controller/subsystem/club_penguin_finale/proc/start_stage_one()
	SEND_SOUND(world, sound('sound/ai/default/attention.ogg'))
	to_chat(world, span_boldnotice("<h1>ATTENTION ALL PENGUINS!</h1>"))
	to_chat(world, span_notice("<span style='font-size: 18px'>My friend told me you can <b>TIP THE ICEBERG??</b></span>"))
	to_chat(world, span_notice("<span style='font-size: 16px; color: green'>Use your map to visit the iceberg...I GOTTA see this.</span>"))
	stoplag(10 SECONDS)
	summon_npc_drillers()

/datum/controller/subsystem/club_penguin_finale/proc/start_stage_two()
	alert_penguins_on_iceberg(span_userdanger("You feel the ice underneath you shake..."))
	stoplag(6 SECONDS)
	GLOB.iceberg_cracking.icon_state = "1"
	alert_penguins_on_iceberg(span_userdanger("...and notice a crack forming in the iceberg! It's working!"))
	stoplag(4 SECONDS)
	SEND_SOUND(world, sound('sound/ai/default/attention.ogg'))
	to_chat(world, span_notice("<span style='font-size: 18px'>Okay you will NOT believe this but the <b>ICEBERG IS TIPPING</b>. You GOTTA check this out if you're not already on the iceberg. Open your map!</span>"))

/datum/controller/subsystem/club_penguin_finale/proc/start_stage_three()
	alert_penguins_on_iceberg(span_userdanger("The ice underneath you shakes once more..."))
	stoplag(6 SECONDS)
	GLOB.iceberg_cracking.icon_state = "2"
	alert_penguins_on_iceberg(span_userdanger("...causing the crack in the iceberg to double in size! It's almost tipped!"))
	stoplag(4 SECONDS)
	SEND_SOUND(world, sound('sound/ai/default/attention.ogg'))
	to_chat(world, span_notice("<span style='font-size: 18px'>BROS I'M SERIOUS WE ARE LIKE <b>A FEW MINUTES AWAY</b> FROM THE ICEBERG BEING TIPPED, THIS IS SO AWESOME</span>"))

/datum/controller/subsystem/club_penguin_finale/proc/finale()
	alert_penguins_on_iceberg(span_userdanger("The ice underneath you crumbles underneath your flippers..."))
	stoplag(6 SECONDS)
	GLOB.iceberg_cracking.icon_state = "3"
	stoplag(2 SECONDS)
	SEND_SOUND(world, sound('sound/ai/default/attention.ogg'))
	to_chat(world, span_notice("<span style='font-size: 28px'>YOOOOOOO</span>"))
	stoplag(3 SECONDS)
	alert_penguins_on_iceberg(span_userdanger("...maybe this was a bad idea...?"))
	stoplag(1 SECONDS)
	SEND_SOUND(world, sound('sound/ai/default/attention.ogg'))
	to_chat(world, span_notice("<span style='font-size: 28px'>YO ITS ABOUT TO TIP</span>"))
	stoplag(6 SECONDS)
	INVOKE_ASYNC(src, .proc/shake_the_penguins)
	stoplag(2 SECONDS)
	SEND_SOUND(world, sound('sound/ai/default/attention.ogg'))
	to_chat(world, span_notice("<span style='font-size: 16px'>UHHHHH</span>"))
	stoplag(8 SECONDS)

	for (var/mob/living/mob as anything in GLOB.penguins)
		mob.dust()

	stoplag(3 SECONDS)
	to_chat(world, span_notice("<span style='font-size: 16px'>oop</span>"))
	stoplag(2 SECONDS)
	SSticker.force_ending = TRUE

/datum/controller/subsystem/club_penguin_finale/proc/alert_penguins_on_iceberg(message)
	for (var/mob/mob in GLOB.areas_by_type[/area/club_penguin/iceberg])
		to_chat(mob, message)

/datum/controller/subsystem/club_penguin_finale/proc/shake_the_penguins()
	for (var/_ in 1 to 5)
		shake_penguin()
		stoplag(1 SECONDS)

	for(var/_ in 1 to 20)
		shake_penguin()
		stoplag(0.2 SECONDS)

/datum/controller/subsystem/club_penguin_finale/proc/shake_penguin()
	var/mob/penguin = pick(GLOB.penguins)
	if (isnull(penguin))
		return

	SSexplosions.shake_the_room(get_turf(penguin), near_distance = 30, far_distance = 30, creaking = FALSE)

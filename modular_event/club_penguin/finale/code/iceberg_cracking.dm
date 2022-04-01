GLOBAL_DATUM(iceberg_cracking, /obj/effect/iceberg_cracking)

/obj/effect/iceberg_cracking
	anchored = TRUE
	density = FALSE
	icon = 'modular_event/club_penguin/finale/icons/iceberg_cracking.dmi'

/obj/effect/iceberg_cracking/Initialize(mapload)
	. = ..()
	GLOB.iceberg_cracking = src

/obj/effect/iceberg_cracking/Destroy(force)
	if (GLOB.iceberg_cracking == src)
		GLOB.iceberg_cracking = null
	return ..()

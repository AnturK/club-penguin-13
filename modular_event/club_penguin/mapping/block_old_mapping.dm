// HER SIMPLE TRICK SAVES 10-20 SECONDS OF INIT TIME (MAINTAINERS HATE HER)
/datum/controller/subsystem/mapping/Initialize()
	// Spatial gridmaps need this
	z_list = list()

	// Need *some* z-level for the incrementMaxZ code to run
	transit = add_new_zlevel("Transit/Reserved", list(ZTRAIT_RESERVED = TRUE))

// There are shuttles on CentCom, we don't want them
/datum/controller/subsystem/shuttle/Initialize(timeofday)
	return

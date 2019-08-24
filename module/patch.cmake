pacmake_include(log)

#pacmake_run_patch(patchname [PRECONFIGURE|PREBUILD|POSTBUILD|POSTINSTALL] package version)
function(pacmake_run_patch package version type workdir)
	set(patchdir "${PACMAKE_BASEDIR}/package/${package}/patch")
	
	if(EXISTS "${workdir}/patch.${type}")
		pacmake_log(GENERIC "pacmake_run_patch(${package}, ${version}): ${type} patch has already been run, skipping...")
		return()
	endif()
	
	string(TOLOWER ${type} type_lower)
	if(EXISTS "${patchdir}/${type_lower}.cmake")
		pacmake_log(INFO "pacmake_run_patch(${package}, ${version}): Running ${type} patch...")
		include("${patchdir}/${type_lower}.cmake")
		pacmake_patch(${patchdir} ${workdir} ${package} ${version})
	else()
		pacmake_log(GENERIC "pacmake_run_patch(${package}, ${version}): No ${type} patch to run.")
		return()
	endif()
		
	file(WRITE "${workdir}/patch.${type}" "")
endfunction(pacmake_run_patch)

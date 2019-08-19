pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch_preconfigure package version dir)
endfunction(pacmake_patch_preconfigure)

function(pacmake_patch_prebuild package version dir)
endfunction(pacmake_patch_prebuild)

function(pacmake_patch_postbuild package version dir)
endfunction(pacmake_patch_postbuild)

function(pacmake_patch_postinstall package version dir)
	set(cmake_dir "${dir}/install/lib/cmake")
	if(EXISTS ${cmake_dir})
		file(RENAME "${cmake_dir}/SDL2" "${cmake_dir}/SDL2_ttf")
		set(target_dir "${cmake_dir}/SDL2_ttf")
	elseif(EXISTS "${dir}/install/cmake")
		set(target_dir "${dir}/install/cmake")
	endif()
	if(target_dir)
		pacmake_textfile_replace("${target_dir}/SDL2_ttfConfig.cmake" "/SDL2_TTFTargets.cmake" "/SDL2_ttfTargets.cmake")
	endif()
endfunction(pacmake_patch_postinstall)

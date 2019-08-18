pacmake_include(log)

function(pacmake_patch_preconfigure package version dir)
endfunction(pacmake_patch_preconfigure)

function(pacmake_patch_prebuild package version dir)
endfunction(pacmake_patch_prebuild)

function(pacmake_patch_postbuild package version dir)
endfunction(pacmake_patch_postbuild)

function(pacmake_patch_postinstall package version dir)
	set(cmake_dir "${dir}/install/lib/cmake")
	if(EXISTS "${cmake_dir}/SDL2/SDL2_ttfTargets.cmake" AND NOT EXISTS "${cmake_dir}/SDL2/SDL2_TTFTargets.cmake")
		file(RENAME "${cmake_dir}/SDL2/SDL2_ttfTargets.cmake" "${cmake_dir}/SDL2/SDL2_TTFTargets.cmake")
	endif()
	if(EXISTS "${cmake_dir}/SDL2" AND IS_DIRECTORY "${cmake_dir}/SDL2" AND NOT EXISTS "${cmake_dir}/SDL2_ttf")
		file(RENAME "${cmake_dir}/SDL2" "${cmake_dir}/SDL2_ttf")
	endif()
endfunction(pacmake_patch_postinstall)

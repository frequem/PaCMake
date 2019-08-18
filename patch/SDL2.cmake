pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch_preconfigure package version dir)
	if(NOT EXISTS "${dir}/patched")
		#replace SDL2-static target name with SDL2 so the static library can be linked with SDL2::SDL2
		pacmake_textfile_replace("${dir}/source/CMakeLists.txt" "SDL2-static" "SDL2")
		file(WRITE "${dir}/patched" "ok")
	endif()
endfunction(pacmake_patch_preconfigure)

function(pacmake_patch_prebuild package version dir)
endfunction(pacmake_patch_prebuild)

function(pacmake_patch_postbuild package version dir)
endfunction(pacmake_patch_postbuild)

function(pacmake_patch_postinstall package version dir)
endfunction(pacmake_patch_postinstall)

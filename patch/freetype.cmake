pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch_preconfigure package version dir)
	if(NOT EXISTS "${dir}/patched")
		pacmake_textfile_remove("${dir}/source/CMakeLists.txt" 187 5)#remove harfbuzz
		file(WRITE "${dir}/patched" "ok")
	endif()
endfunction(pacmake_patch_preconfigure)

function(pacmake_patch_prebuild package version dir)
endfunction(pacmake_patch_prebuild)

function(pacmake_patch_postbuild package version dir)
endfunction(pacmake_patch_postbuild)

function(pacmake_patch_postinstall package version dir)
endfunction(pacmake_patch_postinstall)

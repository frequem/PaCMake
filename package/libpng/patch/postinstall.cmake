pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch patchdir workdir package version)
	file(RENAME "${workdir}/install/lib/libpng/libpng.cmake" "${workdir}/install/lib/libpng/libpngConfig.cmake")
endfunction(pacmake_patch)

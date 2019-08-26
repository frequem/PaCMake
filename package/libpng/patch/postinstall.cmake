pacmake_include(log)
pacmake_include(textfile)

function(pacmake_patch patchdir installdir package version)
	file(RENAME "${installdir}/lib/libpng/libpng.cmake" "${installdir}/lib/libpng/libpngConfig.cmake")
endfunction(pacmake_patch)

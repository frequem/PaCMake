pacmake_include(parse_args)

#pacmake_set_default_version(name version)
function(pacmake_set_default_version)
	pacmake_parse_args(name version VALUES ${ARGV})
	set(PACMAKE_DEFAULT_VERSION_${name} "${version}" CACHE INTERNAL "PACMAKE_DEFAULT_VERSION_${name}")
endfunction(pacmake_set_default_version)

#pacmake_get_default_version(name out_version)
function(pacmake_get_default_version name out_version)
	set(${out_version} "${PACMAKE_DEFAULT_VERSION_${name}}" PARENT_SCOPE)
endfunction(pacmake_get_default_version)

#pacmake_set_default_version(name version)
function(pacmake_set_default_version args_NAME args_VERSION)
	set(PACMAKE_DEFAULT_VERSION_${args_NAME} "${args_VERSION}" CACHE INTERNAL "PACMAKE_DEFAULT_VERSION_${args_NAME}")
endfunction(pacmake_set_default_version)

#pacmake_get_default_version(name out_version)
function(pacmake_get_default_version args_NAME out_version)
	set(${out_version} "${PACMAKE_DEFAULT_VERSION_${args_NAME}}" PARENT_SCOPE)
endfunction(pacmake_get_default_version)

#pacmake_util_parse_args([var1] [var2...] VALUES [args])
function(pacmake_parse_args)
	list(FIND ARGV VALUES val_idx)
	
	if(val_idx LESS 0) #VALUES not found
		return()
	endif()
	
	set(i 0)
	math(EXPR j "${val_idx}+1")
	
	while(${i} LESS ${val_idx} AND ${j} LESS ${ARGC})
		list(GET ARGV ${i} key)
		list(GET ARGV ${j} val)
		set(${key} ${val} PARENT_SCOPE)
		math(EXPR i "${i}+1")
		math(EXPR j "${val_idx}+${i}+1")
	endwhile()
	
	if(${j} LESS ${ARGC})
		math(EXPR unused_len "${ARGC}-${j}")
		list(SUBLIST ARGV ${j} ${unused_len} unused)
		set(PACMAKE_UNUSED_ARGS ${unused} PARENT_SCOPE)
	endif()
endfunction(pacmake_parse_args)

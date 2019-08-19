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
	
	while(${i} LESS ${val_idx})
		list(GET ARGV ${i} key)
		set(${key} "" PARENT_SCOPE)
		math(EXPR i "${i}+1")
	endwhile()
	
	set(unused_args "")
	while(${j} LESS ${ARGC})
		list(GET ARGV ${j} arg)
		list(APPEND unused_args ${arg})
		math(EXPR j "${j}+1")
	endwhile()
	set(PACMAKE_UNUSED_ARGS ${unused_args} PARENT_SCOPE)
endfunction(pacmake_parse_args)

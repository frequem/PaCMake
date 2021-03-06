function(pacmake_log type msg)
	if(NOT PACMAKE_PRINT_${type} AND NOT PACMAKE_DEBUG)
		return()
	endif()
	if(NOT CMAKE_HOST_WIN32)
		string(ASCII 27 Esc)
		set(COLOR_RESET "${Esc}[m")
		set(COLOR_RED      "${Esc}[31m")
		set(COLOR_GREEN      "${Esc}[32m")
		set(COLOR_YELLOW      "${Esc}[33m")
		set(COLOR_BOLD_RED     "${Esc}[1;31m")
		set(COLOR_BOLD_GREEN     "${Esc}[1;32m")
		set(COLOR_BOLD_YELLOW  "${Esc}[1;33m")
		set(COLOR_BOLD_CYAN  "${Esc}[1;36m")
	endif()
	
	if("${type}" STREQUAL "WARNING")
		set(msg_prefix "${COLOR_BOLD_YELLOW}PACMAKE WARNING:${COLOR_RESET}")
		set(msg "${COLOR_YELLOW}${msg}${COLOR_RESET}")
	elseif("${type}" STREQUAL "ERROR")
		set(msg_prefix "${COLOR_BOLD_RED}PACMAKE ERROR:${COLOR_RESET}")
		set(msg "${COLOR_RED}${msg}${COLOR_RESET}")
	elseif("${type}" STREQUAL "INFO")
		set(msg_prefix "${COLOR_BOLD_GREEN}PACMAKE INFO:${COLOR_RESET}")
		set(msg "${COLOR_GREEN}${msg}${COLOR_RESET}")
	else()
		set(msg_prefix "${COLOR_BOLD_CYAN}PACMAKE DEBUG:${COLOR_RESET}")
	endif()
	
	message("${msg_prefix} ${msg}")
endfunction(pacmake_log)

cmake_minimum_required(VERSION 3.6)

option(PACMAKE_FORCE_FETCH "Force fetch PaCMake files" OFF)
set(PACMAKE_FETCH_INTERVAL 43200 CACHE STRING "Interval after which PaCMake is updated") # every 12 hours
set(PACMAKE_SKIP_SOURCES "" CACHE STRING "Indices of PaCMake sources to be skipped") # e.g. "0;2;4"
set(PACMAKE_PREFER_SOURCES "" CACHE STRING "Indices of preferred PaCMake sources") # e.g. "3;5"


file(TO_CMAKE_PATH "${CMAKE_BINARY_DIR}/PaCMake" homeDirectory)
if(DEFINED ENV{HOME})
	file(TO_CMAKE_PATH "$ENV{HOME}/.PaCMake" homeDirectory)
elseif(DEFINED ENV{USERPROFILE})
	file(TO_CMAKE_PATH "$ENV{USERPROFILE}/.PaCMake" homeDirectory)
endif()
set(PACMAKE_TARGET_HOME "${homeDirectory}" CACHE PATH "PaCMake home directory")
message(STATUS "PaCMake Loader: Target home directory: ${PACMAKE_TARGET_HOME}")

# set default sources
list(APPEND PACMAKE_SOURCES
	GIT "https://github.com/frequem/PaCMake.git"
	URL "https://github.com/frequem/PaCMake/archive/refs/heads/master.zip"
)

get_filename_component(homePathAbsolute "${PACMAKE_TARGET_HOME}" ABSOLUTE)

set(prevSource "")
set(prevSourceTimestamp 0)
set(prevSourceAvailable TRUE)
if(EXISTS "${homePathAbsolute}/fetch/DONE")
	file(STRINGS "${homePathAbsolute}/fetch/DONE" prevSource)
	file(TIMESTAMP "${homePathAbsolute}/fetch/DONE" prevSourceTimestamp "%s" UTC)
	set(prevSourceAvailable FALSE)
endif()

string(TIMESTAMP now "%s" UTC)
math(EXPR prevSourceTimePassed "${now} - ${prevSourceTimestamp}")

set(nSources -1)
set(sourceOrder "")
set(sourceTypes LOCAL URL GIT SVN HG CVS)
foreach(entry IN LISTS PACMAKE_SOURCES)
	if(${entry} IN_LIST sourceTypes)
		math(EXPR nSources "${nSources} + 1")
		list(APPEND sourceOrder ${nSources})
		set(sourceType_${nSources} ${entry})
		set(source_${nSources} "")
		set(sourceParams_${nSources} "")
	elseif(NOT source_${nSources})
		if(sourceType_${nSources} STREQUAL "LOCAL")
			get_filename_component(source_${nSources} "${entry}" ABSOLUTE)
		else()
			set(source_${nSources} "${entry}")
		endif()
	else()
		list(APPEND sourceParams_${nSources} "${entry}")
	endif()
endforeach()

if(${nSources} GREATER_EQUAL 0)
	set(preferredCount 0)
	foreach(i RANGE ${nSources})
		string(REPLACE ";" " " sourceParams_${i} "${sourceParams_${i}}")
		
		if(${i} IN_LIST PACMAKE_SKIP_SOURCES)
			list(REMOVE_ITEM sourceOrder ${i})
		elseif("${sourceType_${i}} ${source_${i}} ${sourceParams_${i}}" STREQUAL "${prevSource}")
			set(prevSourceAvailable TRUE)
			
			# try previous source first, unless another is preferred
			list(REMOVE_ITEM sourceOrder ${i})
			if(${i} IN_LIST PACMAKE_PREFER_SOURCES)
				list(INSERT sourceOrder 0 ${i})
				math(EXPR preferredCount "${preferredCount} + 1")
			else()
				list(INSERT sourceOrder ${preferredCount} ${i})
			endif()
		elseif(${i} IN_LIST PACMAKE_PREFER_SOURCES)
			list(REMOVE_ITEM sourceOrder ${i})
			list(INSERT sourceOrder ${preferredCount} ${i})
			math(EXPR preferredCount "${preferredCount} + 1")
		endif()
	endforeach()
endif()

math(EXPR nSources "${nSources} + 1")
message(STATUS "PaCMake Loader: ${nSources} source(s) available:")
math(EXPR nSources "${nSources} - 1")

if(${nSources} GREATER_EQUAL 0)
	foreach(i RANGE ${nSources})
		set(status "")
		if("${sourceType_${i}} ${source_${i}} ${sourceParams_${i}}" STREQUAL "${prevSource}")
			list(APPEND status "previous")
		endif()
		if(${i} IN_LIST PACMAKE_SKIP_SOURCES)
			list(APPEND status "skipped")
		elseif(${i} IN_LIST PACMAKE_PREFER_SOURCES)
			list(APPEND status "preferred")
		endif()
		if(status)
			string(REPLACE ";" ", " status "${status}")
			set(status " (${status})")
		endif()
		message(STATUS "├─ #${i}${status}: ${sourceType_${i}} ${source_${i}} ${sourceParams_${i}}")
	endforeach()
endif()

set(PACMAKE_UPDATED FALSE CACHE INTERNAL "")
if(NOT PACMAKE_FORCE_FETCH AND prevSource AND prevSourceAvailable AND (${PACMAKE_FETCH_INTERVAL} LESS 0 OR ${prevSourceTimePassed} LESS ${PACMAKE_FETCH_INTERVAL}))
	if(${PACMAKE_FETCH_INTERVAL} LESS 0)
		set(nextFetchTime "the end of time")
	else()
		math(EXPR nextFetchTime "${prevSourceTimestamp} + ${PACMAKE_FETCH_INTERVAL}")
		set(ENV{SOURCE_DATE_EPOCH} ${nextFetchTime})
		string(TIMESTAMP nextFetchTime "%Y-%m-%d %H:%M:%S")
		unset(ENV{SOURCE_DATE_EPOCH})
	endif()
	message(STATUS "PaCMake Loader: PaCMake files exist and are current until ${nextFetchTime}, skipping fetch operation.")
else()
	if(NOT prevSource)
		message(STATUS "PaCMake Loader: Fetching PaCMake files (Initial fetch).")
	elseif(${PACMAKE_FETCH_INTERVAL} GREATER_EQUAL 0 AND ${prevSourceTimePassed} GREATER_EQUAL ${PACMAKE_FETCH_INTERVAL})
		message(STATUS "PaCMake Loader: Fetching PaCMake files (Update interval exceeded).")
	elseif(NOT prevSourceAvailable)
		message(STATUS "PaCMake Loader: Fetching PaCMake files (Previous source unavailable: ${prevSource}).")
	elseif(PACMAKE_FORCE_FETCH)
		message(STATUS "PaCMake Loader: Fetching PaCMake files (Forced fetch).")
	else()
		message(FATAL_ERROR "PaCMake Loader: Invalid fetch initiation.")
	endif()
	
	file(WRITE
		"${homePathAbsolute}/fetch/CMakeLists.txt"
		"cmake_minimum_required(VERSION 3.6)\n\n"
		"project(PaCMake-fetcher DESCRIPTION \"PaCMake fetcher\" LANGUAGES NONE)\n\n"
		"add_custom_target(\${PROJECT_NAME}_removePrevSourceFiles COMMAND \${CMAKE_COMMAND} -E rm -Rf \"${homePathAbsolute}/src/*\")\n"
		"include(ExternalProject)\n\n"
		"if(NOT PACMAKE_SOURCE_INDEX)\n"
		"\tset(PACMAKE_SOURCE_INDEX 0)\n"
		"endif()\n\n"
		"set(sourceArgs \"\")\n"
	)
	
	if(${nSources} GREATER_EQUAL 0)
		foreach(i RANGE ${nSources})			
			file(APPEND 
				"${homePathAbsolute}/fetch/CMakeLists.txt" 
				"if(\${PACMAKE_SOURCE_INDEX} EQUAL ${i})\n"
				"\tset(sourceArgs\n"
			)
			
			if(sourceType_${i} STREQUAL "LOCAL")
				file(APPEND 
					"${homePathAbsolute}/fetch/CMakeLists.txt" 
					"\t\tDOWNLOAD_COMMAND \${CMAKE_COMMAND} -E copy_directory \"${source_${i}}/\" \"${homePathAbsolute}/src\"\n"
					"\t\tUPDATE_COMMAND \${CMAKE_COMMAND} -E copy_directory \"${source_${i}}/\" \"${homePathAbsolute}/src\"\n"
					"\t\tDEPENDS \${PROJECT_NAME}_removePrevSourceFiles\n"
				)
			elseif(sourceType_${i} STREQUAL "URL")
				file(APPEND 
					"${homePathAbsolute}/fetch/CMakeLists.txt" 
					"\t\tDOWNLOAD_DIR \"${homePathAbsolute}/fetch\"\n"
					"\t\tURL \"${source_${i}}\"\n"
					"\t\tDOWNLOAD_EXTRACT_TIMESTAMP TRUE\n"
				)
			else()
				file(APPEND "${homePathAbsolute}/fetch/CMakeLists.txt" "\t\t${sourceType_${i}}_REPOSITORY \"${source_${i}}\"\n")
			endif()
			
			if(sourceParams_${i})
				file(APPEND "${homePathAbsolute}/fetch/CMakeLists.txt" "\t\t${sourceParams_${i}}\n")
			endif()
			
			file(APPEND "${homePathAbsolute}/fetch/CMakeLists.txt" "\t)\nelse")
		endforeach()
	endif()
	
	file(APPEND 
		"${homePathAbsolute}/fetch/CMakeLists.txt" 
		"if(TRUE)\n"
		"\tmessage(FATAL_ERROR \"PaCMake Fetcher: No valid source index given.\")\n"
		"endif()\n\n"
		"ExternalProject_Add(\n"
		"\t\${PROJECT_NAME}\n"
		"\tSOURCE_DIR \"${homePathAbsolute}/src\"\n"
		"\t\${sourceArgs}\n"
		"\tCONFIGURE_COMMAND \"\" BUILD_COMMAND \"\" INSTALL_COMMAND \"\"\n"
		")\n"
	)
	
	set(finalSource "")
	foreach(i IN LISTS sourceOrder)
		if(NOT "${sourceType_${i}} ${source_${i}} ${sourceParams_${i}}" STREQUAL "${prevSource}")
			file(REMOVE_RECURSE "${homePathAbsolute}/fetch/build")
		endif()
		
		message(STATUS "PaCMake Loader: Selecting source #${i}: ${sourceType_${i}} ${source_${i}} ${sourceParams_${i}}")
		execute_process(
			COMMAND "${CMAKE_COMMAND}" -B "build" -S "." -DPACMAKE_SOURCE_INDEX=${i}
			WORKING_DIRECTORY "${homePathAbsolute}/fetch"
			RESULT_VARIABLE result
			OUTPUT_QUIET
		)
		if(NOT result EQUAL 0)
			message(WARNING "PaCMake Loader: Source #${i} configuration step failed, this is unusual.")
			continue()
		endif()
		
		message(STATUS "PaCMake Loader: Performing fetch operation, please be patient...")
		execute_process(
			COMMAND "${CMAKE_COMMAND}" --build "build"
			WORKING_DIRECTORY "${homePathAbsolute}/fetch"
			RESULT_VARIABLE result
			OUTPUT_QUIET
		)
		if(result EQUAL 0)
			set(finalSource "${sourceType_${i}} ${source_${i}} ${sourceParams_${i}}")
			break()
		else()
			message(STATUS "PaCMake Loader: Source #${i} fetch operation failed.")
		endif()
	endforeach()
	
	if(finalSource)
		set(PACMAKE_UPDATED TRUE CACHE INTERNAL "")
		file(WRITE "${homePathAbsolute}/fetch/DONE" "${finalSource}")
	else()
		message(FATAL_ERROR "PaCMake Loader: Could not fetch any PaCMake source.")
	endif()
endif()

message(STATUS "PaCMake Loader: Running PaCMake.")
include("${homePathAbsolute}/src/PaCMake.cmake")

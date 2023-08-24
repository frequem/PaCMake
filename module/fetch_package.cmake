pacmake_include(log)
pacmake_include(run_patch)
pacmake_include(compare_files)

function(pacmake_fetch_package packageName packageVersion out_packageUpdated)
	pacmake_log("fetch_package(${packageName} ${packageVersion}):" INCREMENT)
	
	set(prevSource "")
	set(prevSourceTimestamp 0)
	set(prevSourceAvailable TRUE)
	if(EXISTS "${PACMAKE_HOME}/package/${packageName}/${packageVersion}/fetch/DONE")
		file(STRINGS "${PACMAKE_HOME}/package/${packageName}/${packageVersion}/fetch/DONE" prevSource)
		file(TIMESTAMP "${PACMAKE_HOME}/package/${packageName}/${packageVersion}/fetch/DONE" prevSourceTimestamp "%s" UTC)
		set(prevSourceAvailable FALSE)
	endif()
	
	string(TIMESTAMP now "%s" UTC)
	math(EXPR prevSourceTimePassed "${now} - ${prevSourceTimestamp}")

	set(nSources -1)
	set(sourceOrder "")
	set(sourceTypes EMPTY LOCAL URL GIT SVN HG CVS)
	foreach(entry IN LISTS PACMAKE_PACKAGE_${packageName}_${packageVersion}_SOURCES)
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
		foreach(i RANGE ${nSources})
			string(REPLACE ";" " " sourceParams_${i} "${sourceParams_${i}}")
			
			if("${sourceType_${i}} ${source_${i}} ${sourceParams_${i}}" STREQUAL "${prevSource}")
				set(prevSourceAvailable TRUE)
				
				# try previous source first
				list(REMOVE_ITEM sourceOrder ${i})
				list(INSERT sourceOrder 0 ${i})
			endif()
		endforeach()
	endif()
	
	math(EXPR nSources "${nSources} + 1")
	pacmake_log("${nSources} source(s) available:")
	math(EXPR nSources "${nSources} - 1")
	
	if(${nSources} GREATER_EQUAL 0)
		pacmake_log_indent(INCREMENT)
		foreach(i RANGE ${nSources})
			set(status "")
			if("${sourceType_${i}} ${source_${i}} ${sourceParams_${i}}" STREQUAL "${prevSource}")
				set(status " (previous)")
			endif()
			
			set(decrementFlag "")
			if(${i} EQUAL ${nSources})
				set(decrementFlag DECREMENT)
			endif()
			pacmake_log("#${i}${status}: ${sourceType_${i}} ${source_${i}} ${sourceParams_${i}}" ${decrementFlag})
		endforeach()
	endif()
	
	set(forcedSourceUpdate FALSE)
	foreach(packageRegex IN LISTS PACMAKE_FORCE_SOURCE_UPDATE_PACKAGES)
		if("${packageName} ${packageVersion}" MATCHES "^${packageRegex}$" OR "${packageName}" MATCHES "^${packageRegex}$")
			set(forcedSourceUpdate TRUE)
			break()
		endif()
	endforeach()
	
	set(forcedFetch FALSE)
	foreach(packageRegex IN LISTS PACMAKE_FORCE_FETCH_PACKAGES)
		if("${packageName} ${packageVersion}" MATCHES "^${packageRegex}$" OR "${packageName}" MATCHES "^${packageRegex}$")
			set(forcedFetch TRUE)
			break()
		endif()
	endforeach()
	
	
	set(${out_packageUpdated} FALSE PARENT_SCOPE)
	if(NOT forcedFetch AND prevSource AND prevSourceAvailable AND (${PACMAKE_PACKAGE_FETCH_INTERVAL} LESS 0 OR ${prevSourceTimePassed} LESS ${PACMAKE_PACKAGE_FETCH_INTERVAL}))
		if(${PACMAKE_PACKAGE_FETCH_INTERVAL} LESS 0)
			set(nextFetchTime "the end of time")
		else()
			math(EXPR nextFetchTime "${prevSourceTimestamp} + ${PACMAKE_PACKAGE_FETCH_INTERVAL}")
			set(ENV{SOURCE_DATE_EPOCH} ${nextFetchTime})
			string(TIMESTAMP nextFetchTime "%Y-%m-%d %H:%M:%S")
			unset(ENV{SOURCE_DATE_EPOCH})
		endif()
		
		pacmake_log("Package files exist and are current until ${nextFetchTime}, skipping fetch operation.")
		if(NOT forcedSourceUpdate)
			pacmake_log_indent(DECREMENT)
			return()
		endif()
	else()
		if(NOT prevSource)
			pacmake_log("Fetching package files (Initial fetch).")
		elseif(${PACMAKE_PACKAGE_FETCH_INTERVAL} GREATER_EQUAL 0 AND ${prevSourceTimePassed} GREATER_EQUAL ${PACMAKE_PACKAGE_FETCH_INTERVAL})
			pacmake_log("Fetching package files (Update interval exceeded).")
		elseif(NOT prevSourceAvailable)
			pacmake_log("Fetching package files (Previous source unavailable: ${prevSource}).")
		elseif(forcedFetch)
			pacmake_log("Fetching package files (Forced fetch).")
		else()
			message(FATAL_ERROR "PaCMake: Invalid package fetch initiation.")
		endif()
		
		file(WRITE
			"${PACMAKE_HOME}/package/${packageName}/${packageVersion}/fetch/CMakeLists.txt"
			"cmake_minimum_required(VERSION 3.6)\n\n"
			"project(PaCMake-packageFetcher_${packageName} DESCRIPTION \"PaCMake package fetcher (${packageName} ${packageVersion})\" LANGUAGES NONE)\n\n"
			"add_custom_target(\${PROJECT_NAME}_removePrevSourceFiles COMMAND \${CMAKE_COMMAND} -E rm -Rf \"${PACMAKE_HOME}/package/${packageName}/${packageVersion}/src/next/*\")\n"
			"include(ExternalProject)\n\n"
			"if(NOT PACMAKE_PACKAGE_SOURCE_INDEX)\n"
			"\tset(PACMAKE_PACKAGE_SOURCE_INDEX 0)\n"
			"endif()\n\n"
			"set(sourceArgs \"\")\n"
		)
		
		if(${nSources} GREATER_EQUAL 0)
			foreach(i RANGE ${nSources})
				file(APPEND 
					"${PACMAKE_HOME}/package/${packageName}/${packageVersion}/fetch/CMakeLists.txt" 
					"if(\${PACMAKE_PACKAGE_SOURCE_INDEX} EQUAL ${i})\n"
					"\tset(sourceArgs\n"
				)
				
				if(sourceType_${i} STREQUAL "EMPTY")
					file(APPEND
						"${PACMAKE_HOME}/package/${packageName}/${packageVersion}/fetch/CMakeLists.txt" 
						"\t\tDOWNLOAD_COMMAND \${CMAKE_COMMAND} -E make_directory \"${PACMAKE_HOME}/package/${packageName}/${packageVersion}/src/next\"\n"
						"\t\tDEPENDS \${PROJECT_NAME}_removePrevSourceFiles\n"
					)
				elseif(sourceType_${i} STREQUAL "LOCAL")
					file(APPEND
						"${PACMAKE_HOME}/package/${packageName}/${packageVersion}/fetch/CMakeLists.txt" 
						"\t\tDOWNLOAD_COMMAND \${CMAKE_COMMAND} -E copy_directory \"${source_${i}}/\" \"${PACMAKE_HOME}/package/${packageName}/${packageVersion}/src/next\"\n"
						"\t\tUPDATE_COMMAND \${CMAKE_COMMAND} -E copy_directory \"${source_${i}}/\" \"${PACMAKE_HOME}/package/${packageName}/${packageVersion}/src/next\"\n"
						"\t\tDEPENDS \${PROJECT_NAME}_removePrevSourceFiles\n"
					)
				elseif(sourceType_${i} STREQUAL "URL")
					file(APPEND 
						"${PACMAKE_HOME}/package/${packageName}/${packageVersion}/fetch/CMakeLists.txt"
						"\t\tDOWNLOAD_DIR \"${PACMAKE_HOME}/package/${packageName}/${packageVersion}/fetch\"\n"
						"\t\tURL \"${source_${i}}\"\n"
					)
				else()
					file(APPEND "${PACMAKE_HOME}/package/${packageName}/${packageVersion}/fetch/CMakeLists.txt" "\t\t${sourceType_${i}}_REPOSITORY \"${source_${i}}\"\n")
				endif()
				
				if(sourceParams_${i})
					file(APPEND "${PACMAKE_HOME}/package/${packageName}/${packageVersion}/fetch/CMakeLists.txt" "\t\t${sourceParams_${i}}\n")
				endif()
				
				file(APPEND "${PACMAKE_HOME}/package/${packageName}/${packageVersion}/fetch/CMakeLists.txt" "\t)\nelse")
			endforeach()
		endif()
		
		file(APPEND 
			"${PACMAKE_HOME}/package/${packageName}/${packageVersion}/fetch/CMakeLists.txt"
			"if(TRUE)\n"
			"\tmessage(FATAL_ERROR \"PaCMake package fetcher (${packageName} ${packageVersion}): No valid package source index given.\")\n"
			"endif()\n\n"
			"ExternalProject_Add(\n"
			"\t\${PROJECT_NAME}\n"
			"\tSOURCE_DIR \"${PACMAKE_HOME}/package/${packageName}/${packageVersion}/src/next\"\n"
			"\t\${sourceArgs}\n"
			"\tCONFIGURE_COMMAND \"\" BUILD_COMMAND \"\" INSTALL_COMMAND \"\"\n"
			")\n"
		)
		
		set(finalSource "")
		foreach(i IN LISTS sourceOrder)
			if(NOT "${sourceType_${i}} ${source_${i}} ${sourceParams_${i}}" STREQUAL "${prevSource}")
				file(REMOVE_RECURSE "${PACMAKE_HOME}/package/${packageName}/${packageVersion}/fetch/build")
			endif()
			
			pacmake_log("Selecting source #${i}: ${sourceType_${i}} ${source_${i}} ${sourceParams_${i}}")
			execute_process(
				COMMAND "${CMAKE_COMMAND}" -B "build" -S "." -Wno-dev -DPACMAKE_PACKAGE_SOURCE_INDEX=${i}
				WORKING_DIRECTORY "${PACMAKE_HOME}/package/${packageName}/${packageVersion}/fetch"
				RESULT_VARIABLE result
				OUTPUT_QUIET
			)
			if(NOT result EQUAL 0)
				pacmake_log("Source #${i} configuration step failed, this is unusual.")
				continue()
			endif()
			
			pacmake_log("Performing package fetch operation, please be patient...")
			execute_process(
				COMMAND "${CMAKE_COMMAND}" --build "build"
				WORKING_DIRECTORY "${PACMAKE_HOME}/package/${packageName}/${packageVersion}/fetch"
				RESULT_VARIABLE result
				OUTPUT_QUIET
			)
			if(result EQUAL 0)
				set(finalSource "${sourceType_${i}} ${source_${i}} ${sourceParams_${i}}")
				break()
			else()
				pacmake_log("Source #${i} fetch operation failed.")
			endif()
		endforeach()
		
		if(NOT finalSource)
			message(FATAL_ERROR "PaCMake: fetch_package(${packageName} ${packageVersion}): Could not fetch any source.")
		endif()
		file(WRITE "${PACMAKE_HOME}/package/${packageName}/${packageVersion}/fetch/DONE" "${finalSource}")
	endif()
	
	set(packageSourcesEqual FALSE)
	if(forcedSourceUpdate)
		pacmake_log("Performing (forced) source update.")
	else() # skip compare if update is forced anyway
		pacmake_compare_files("${PACMAKE_HOME}/package/${packageName}/${packageVersion}/src/next" "${PACMAKE_HOME}/package/${packageName}/${packageVersion}/src/orig" packageSourcesEqual)
	endif()
	
	if(packageSourcesEqual)
		pacmake_log("Sources unchanged, keeping previous package.")
	else()
		file(REMOVE_RECURSE "${PACMAKE_HOME}/package/${packageName}/${packageVersion}/src/orig")
		file(COPY "${PACMAKE_HOME}/package/${packageName}/${packageVersion}/src/next/" DESTINATION "${PACMAKE_HOME}/package/${packageName}/${packageVersion}/src/orig/")
		
		file(COPY "${PACMAKE_HOME}/package/${packageName}/${packageVersion}/src/orig/" DESTINATION "${PACMAKE_HOME}/package/${packageName}/${packageVersion}/src/cur/")
		pacmake_run_patch(${packageName} ${packageVersion} SOURCE)
		set(${out_packageUpdated} TRUE PARENT_SCOPE)
	endif()
	
	pacmake_log_indent(DECREMENT)
endfunction(pacmake_fetch_package)

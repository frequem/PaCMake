pacmake_include(log)
pacmake_include(run_patch)

include(CMakeParseArguments)

function(pacmake_find_config_directory packageName installPath out_configDirectory)
	file(GLOB_RECURSE configPath 
		"${installPath}/*/${packageName}Config.cmake"
		"${installPath}/*/${packageName}-config.cmake"
	)
	list(LENGTH configPath nConfigs)
	if(${nConfigs} EQUAL 0)
		message(FATAL_ERROR "PaCMake: pacmake_find_config_directory(${packageName}): Could not find cmake config file.")
	endif()
	
	list(GET configPath 0 configPath)
	get_filename_component(configPath "${configPath}" DIRECTORY)
	set(${out_configDirectory} "${configPath}" PARENT_SCOPE)
endfunction(pacmake_find_config_directory)

# pacmake_build_package(packageName packageVersion STATIC|SHARED|MODULE [FORCE] [REBUILT_VARIABLE rebuiltVariable])
function(pacmake_build_package packageName packageVersion packageType)
	cmake_parse_arguments(args "FORCE" "REBUILT_VARIABLE" "" ${ARGN})
	
	string(REPLACE ";" " " functionCall "build_package(${packageName} ${packageVersion} ${packageType}")
	if(args_FORCE)
		string(APPEND functionCall " FORCE")
	endif()
	string(APPEND functionCall ")")
	pacmake_log("${functionCall}:" INCREMENT)
	
	set(packageDirectory "${PACMAKE_HOME}/package/${packageName}/${packageVersion}")
	set(buildDirectory "${packageDirectory}/build/${CMAKE_SYSTEM}-${CMAKE_SYSTEM_PROCESSOR}/${PACMAKE_BUILD_TYPE}/${packageType}")
	set(installDirectory "${packageDirectory}/install/${CMAKE_SYSTEM}-${CMAKE_SYSTEM_PROCESSOR}/${PACMAKE_BUILD_TYPE}/${packageType}")
	
	if(EXISTS ${installDirectory} AND NOT args_FORCE)
		pacmake_log("Installation directory exists, skipping build and installation.")
		if(args_REBUILT_VARIABLE)
			set(${args_REBUILT_VARIABLE} FALSE PARENT_SCOPE)
		endif()
	else()
		if(NOT EXISTS "${buildDirectory}/PaCMake_build_package")
			file(MAKE_DIRECTORY "${buildDirectory}/PaCMake_build_package")
		endif()
		
		if(EXISTS "${buildDirectory}/CMakeCache.txt" AND NOT args_FORCE)
			pacmake_log("CMakeCache exists in build directory, skipping configuration.")
		else()
			set(prefixPath "")
			if(PACMAKE_PACKAGE_${packageName}_${packageVersion}_${packageType}_DEPENDENCY_CONFIG_PATH)
				set(prefixPath "-DCMAKE_PREFIX_PATH=${PACMAKE_PACKAGE_${packageName}_${packageVersion}_${packageType}_DEPENDENCY_CONFIG_PATH}")
			endif()
			
			set(emptyDependencyDirs "")
			foreach(dependencyName IN LISTS PACMAKE_PACKAGE_${packageName}_${packageVersion}_DEPENDENCY_NAMES)
				list(APPEND emptyDependencyDirs "-D${dependencyName}_DIR=")
			endforeach()
			list(REMOVE_DUPLICATES emptyDependencyDirs)
			
			set(buildSharedLibs ON)
			if(packageType STREQUAL "STATIC")
				set(buildSharedLibs OFF)
			endif()
			
			pacmake_log("Configuring package...")
			execute_process(
				COMMAND "${CMAKE_COMMAND}"
				--no-warn-unused-cli -Wno-deprecated
				-B "${buildDirectory}" -S "."
				"-DCMAKE_INSTALL_PREFIX=${installDirectory}"
				"-DBUILD_SHARED_LIBS=${buildSharedLibs}"
				"-DCMAKE_BUILD_TYPE=${PACMAKE_BUILD_TYPE}"
				${emptyDependencyDirs}
				${prefixPath}
				"-DPACMAKE_PACKAGE_FETCH_INTERVAL=-1" # don't refetch any packages
				"-DPACMAKE_DEFAULT_LIBRARY_TYPE=${packageType}"
				"-DPACMAKE_BUILD_TYPE=${PACMAKE_BUILD_TYPE}"
				${PACMAKE_PACKAGE_${packageName}_${packageVersion}_CMAKE_ARGS}
				WORKING_DIRECTORY "${packageDirectory}/src/cur"
				RESULT_VARIABLE result
				OUTPUT_FILE "${buildDirectory}/PaCMake_build_package/configure.log"
				ERROR_FILE "${buildDirectory}/PaCMake_build_package/configure.log"
			)
			if(NOT result EQUAL 0)
				message(FATAL_ERROR "PaCMake: ${functionCall}: Configuration failed, see ${buildDirectory}/PaCMake_build_package/configure.log for details.")
			endif()
			pacmake_run_patch(${packageName} ${packageVersion} ${packageType} CONFIGURE)
		endif()
		
		if(EXISTS "${buildDirectory}/PaCMake_build_package/DONE" AND NOT args_FORCE)
			pacmake_log("Package binaries exist, skipping build.")
		else()
			pacmake_log("Executing build step, please be patient...")
			execute_process(
				COMMAND "${CMAKE_COMMAND}" --build "."
				WORKING_DIRECTORY "${buildDirectory}"
				RESULT_VARIABLE result
				OUTPUT_FILE "${buildDirectory}/PaCMake_build_package/build.log"
				ERROR_FILE "${buildDirectory}/PaCMake_build_package/build.log"
			)
			if(NOT result EQUAL 0)
				message(FATAL_ERROR "PaCMake: ${functionCall}: Build failed, see ${buildDirectory}/PaCMake_build_package/build.log for details.")
			endif()
			pacmake_run_patch(${packageName} ${packageVersion} ${packageType} BUILD)
			file(WRITE "${buildDirectory}/PaCMake_build_package/DONE")
		endif()
		
		pacmake_log("Installing package...")
		execute_process(
			COMMAND "${CMAKE_COMMAND}" --build "." --target install
			WORKING_DIRECTORY "${buildDirectory}"
			RESULT_VARIABLE result
			OUTPUT_FILE "${buildDirectory}/PaCMake_build_package/install.log"
			ERROR_FILE "${buildDirectory}/PaCMake_build_package/install.log"
		)
		if(NOT result EQUAL 0)
			message(FATAL_ERROR "PaCMake: ${functionCall}: Installation failed, see ${buildDirectory}/PaCMake_build_package/install.log for details.")
		endif()
		pacmake_run_patch(${packageName} ${packageVersion} ${packageType} INSTALL)
		
		if(args_REBUILT_VARIABLE)
			set(${args_REBUILT_VARIABLE} TRUE PARENT_SCOPE)
		endif()
	endif()
	
	pacmake_find_config_directory(${packageName} ${installDirectory} configDirectory)
	set(PACMAKE_PACKAGE_${packageName}_${packageVersion}_${packageType}_CONFIG_PATH "${PACMAKE_PACKAGE_${packageName}_${packageVersion}_${packageType}_DEPENDENCY_CONFIG_PATH}" CACHE INTERNAL "")
	list(APPEND PACMAKE_PACKAGE_${packageName}_${packageVersion}_${packageType}_CONFIG_PATH "${configDirectory}")
	set(PACMAKE_PACKAGE_${packageName}_${packageVersion}_${packageType}_CONFIG_PATH "${PACMAKE_PACKAGE_${packageName}_${packageVersion}_${packageType}_CONFIG_PATH}" CACHE INTERNAL "")
	
	set(PACMAKE_PACKAGE_${packageName}_${packageVersion}_${packageType}_CONFIG_DIR "${configDirectory}" CACHE INTERNAL "")
	pacmake_log_indent(DECREMENT)
endfunction()

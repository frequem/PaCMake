pacmake_include(log)
pacmake_include(run_patch)

include(CMakeParseArguments)

function(pacmake_transfer_system_variables out_variables)
	function(add_var varList newVar)
		if(DEFINED ${newVar})
			string(REPLACE ";" "\\;" escapedValue "${${newVar}}") # escape lists
			string(REPLACE "\n" "\\n" escapedValue "${escapedValue}") # escape newlines
			
			list(APPEND ${varList} "-D${newVar}=${escapedValue}")
			set(${varList} "${${varList}}" PARENT_SCOPE)
		endif()
	endfunction(add_var)

	set(varNames "")
	list(APPEND varNames CMAKE_GENERATOR CMAKE_GENERATOR_PLATFORM CMAKE_GENERATOR_TOOLSET CMAKE_GENERATOR_INSTANCE CMAKE_BUILD_PARALLEL_LEVEL)
	list(APPEND varNames CMAKE_SYSTEM_NAME CMAKE_SYSTEM_VERSION CMAKE_SYSTEM_PROCESSOR)
	list(APPEND varNames CMAKE_TRY_COMPILE_PLATFORM_VARIABLES CMAKE_SYSROOT CMAKE_LIBRARY_ARCHITECTURE CMAKE_SYSTEM_PREFIX_PATH CMAKE_MAKE_PROGRAM)
	list(APPEND varNames CMAKE_C_COMPILER CMAKE_CXX_COMPILER CMAKE_RC_COMPILER CMAKE_MC_COMPILER CMAKE_Fortran_COMPILER)
	list(APPEND varNames CMAKE_C_COMPILER_LAUNCHER CMAKE_CXX_COMPILER_LAUNCHER CMAKE_C_COMPILER_TARGET CMAKE_CXX_COMPILER_TARGET CMAKE_ASM_COMPILER_TARGET CMAKE_C_COMPILER_ID_RUN CMAKE_CXX_COMPILER_ID_RUN CMAKE_C_COMPILER_ID CMAKE_CXX_COMPILER_ID CMAKE_C_STANDARD_LIBRARIES_INIT CMAKE_CXX_STANDARD_LIBRARIES_INIT)
	list(APPEND varNames CMAKE_FIND_ROOT_PATH_MODE_PROGRAM CMAKE_FIND_ROOT_PATH_MODE_LIBRARY CMAKE_FIND_ROOT_PATH_MODE_INCLUDE CMAKE_FIND_ROOT_PATH_MODE_PACKAGE)
	list(APPEND varNames CMAKE_CROSSCOMPILING_EMULATOR CMAKE_AR:FILEPATH CMAKE_RANLIB:FILEPATH)
	
	list(APPEND varNames QT_BINARY_DIR QT_INCLUDE_DIRS_NO_SYSTEM QT_INCLUDE_DIRS_NO_SYSTEM QT_HOST_PATH Boost_THREADAPI)
	
	list(APPEND varNames CMAKE_ANDROID_NDK CMAKE_ANDROID_ARCH_ABI CMAKE_ANDROID_ARM_MODE CMAKE_ANDROID_STL_TYPE CMAKE_ANDROID_RTTI CMAKE_ANDROID_EXCEPTIONS)
		
	list(APPEND varNames ANDROID_NDK_TOOLCHAIN_INCLUDED ANDROID_NDK ANDROID_NDK_SOURCE_PROPERTIES ANDROID_NDK_REVISION_REGEX ANDROID_NDK_EXPECTED_PATH ANDROID_NDK_MAJOR ANDROID_NDK_MINOR ANDROID_NDK_BUILD ANDROID_NDK_BETA ANDROID_NDK_REVISION NDK_CCACHE)
	list(APPEND varNames ANDROID_PLATFORM ANDROID_STL ANDROID_STL_FORCE_FEATURES ANDROID_ABI ANDROID_ARM_NEON ANDROID_ARM_MODE ANDROID_PIE ANDROID_APP_PIE ANDROID_NATIVE_API_LEVEL ANDROID_CCACHE ANDROID_CXX_STANDARD_LIBRARIES)
	list(APPEND varNames ANDROID_TOOLCHAIN ANDROID_TOOLCHAIN_NAME ANDROID_TOOLCHAIN_PREFIX ANDROID_TOOLCHAIN_SUFFIX ANDROID_TOOLCHAIN_ROOT ANDROID_USE_LEGACY_TOOLCHAIN_FILE)
	list(APPEND varNames ANDROID_FORCE_ARM_BUILD ANDROID_CPP_FEATURES ANDROID_NO_UNDEFINED ANDROID_ALLOW_UNDEFINED_SYMBOLS ANDROID_SO_UNDEFINED)
	list(APPEND varNames ANDROID_HOST_TAG ANDROID_HOST_PREBUILTS)
	list(APPEND varNames ANDROID_C_COMPILER ANDROID_CXX_COMPILER ANDROID_ASM_COMPILER ANDROID_AR ANDROID_RANLIB ANDROID_STRIP)
	
	set(vars "")
	foreach(varName IN LISTS varNames)
		add_var(vars ${varName})
	endforeach()	
	set(${out_variables} "${vars}" PARENT_SCOPE)
endfunction(pacmake_transfer_system_variables)

function(pacmake_find_config_directory packageName installPath out_configDirectory)
	string(TOLOWER ${packageName} packageNameLower)
	file(GLOB_RECURSE configPath 
		"${installPath}/*/${packageName}Config.cmake"
		"${installPath}/*/${packageNameLower}-config.cmake"
	)
	list(LENGTH configPath nConfigs)
	if(${nConfigs} EQUAL 0)
		message(FATAL_ERROR "PaCMake: pacmake_find_config_directory(${packageName}): Could not find cmake config file.")
	endif()
	
	list(GET configPath 0 configPath)
	get_filename_component(configPath "${configPath}" DIRECTORY)
	set(${out_configDirectory} "${configPath}" PARENT_SCOPE)
endfunction(pacmake_find_config_directory)

# pacmake_build_package(packageName packageVersion STATIC|SHARED|MODULE PIC|NO_PIC [FORCE] [REBUILT_VARIABLE rebuiltVariable])
function(pacmake_build_package packageName packageVersion packageType packagePIC)
	cmake_parse_arguments(args "FORCE" "REBUILT_VARIABLE" "" ${ARGN})
	
	string(REPLACE ";" " " functionCall "build_package(${packageName} ${packageVersion} ${packageType} ${packagePIC}")
	if(args_FORCE)
		string(APPEND functionCall " FORCE")
	endif()
	string(APPEND functionCall ")")
	pacmake_log("${functionCall}:" INCREMENT)
	
	set(packageDirectory "${PACMAKE_HOME}/package/${packageName}/${packageVersion}")
	set(buildDirectory "${packageDirectory}/build/${CMAKE_SYSTEM}-${CMAKE_SYSTEM_PROCESSOR}/${packageType}-${packagePIC}-${PACMAKE_BUILD_TYPE}/")
	set(installDirectory "${packageDirectory}/install/${CMAKE_SYSTEM}-${CMAKE_SYSTEM_PROCESSOR}/${packageType}-${packagePIC}-${PACMAKE_BUILD_TYPE}/")
	
	if(EXISTS ${installDirectory} AND NOT args_FORCE)
		pacmake_log("Installation directory exists, skipping build and installation.")
		if(args_REBUILT_VARIABLE)
			set(${args_REBUILT_VARIABLE} FALSE PARENT_SCOPE)
		endif()
	else()
		if(NOT EXISTS "${buildDirectory}/PaCMake_build_package")
			file(MAKE_DIRECTORY "${buildDirectory}/PaCMake_build_package")
		endif()
		
		if(EXISTS "${buildDirectory}/PaCMake_build_package/configure.DONE" AND NOT args_FORCE)
			pacmake_log("Build files exists, skipping configuration.")
		else()
			set(prefixPath "")
			set(findRootPath "-DCMAKE_FIND_ROOT_PATH=${CMAKE_FIND_ROOT_PATH}")
			if(PACMAKE_PACKAGE_${packageName}_${packageVersion}_${packageType}_${packagePIC}_DEPENDENCY_CONFIG_PATH)
				set(prefixPath "-DCMAKE_PREFIX_PATH=${PACMAKE_PACKAGE_${packageName}_${packageVersion}_${packageType}_${packagePIC}_DEPENDENCY_CONFIG_PATH}")
				set(findRootPath "-DCMAKE_FIND_ROOT_PATH=${PACMAKE_PACKAGE_${packageName}_${packageVersion}_${packageType}_${packagePIC}_DEPENDENCY_CONFIG_PATH}")
				if(CMAKE_FIND_ROOT_PATH)
					string(APPEND findRootPath ";${CMAKE_FIND_ROOT_PATH}")
				endif()
			endif()
			string(REPLACE ";" "\\;" prefixPath "${prefixPath}")
			string(REPLACE ";" "\\;" findRootPath "${findRootPath}")
									
			set(emptyDependencyDirs "")
			foreach(dependencyName IN LISTS PACMAKE_PACKAGE_${packageName}_${packageVersion}_DEPENDENCY_NAMES)
				list(APPEND emptyDependencyDirs "-D${dependencyName}_DIR=")
			endforeach()
			list(REMOVE_DUPLICATES emptyDependencyDirs)
			
			set(buildSharedLibs ON)
			if(packageType STREQUAL "STATIC")
				set(buildSharedLibs OFF)
			endif()
			
			set(pic OFF)
			if(packagePIC STREQUAL "PIC")
				set(pic ON)
			endif()
			
			pacmake_transfer_system_variables(systemVariables)
			
			pacmake_log("Configuring package...")
			execute_process(
				COMMAND "${CMAKE_COMMAND}"
				#--no-warn-unused-cli -Wno-deprecated
				-B "${buildDirectory}" -S "."
				"-DCMAKE_INSTALL_PREFIX=${installDirectory}"
				"-DBUILD_SHARED_LIBS=${buildSharedLibs}"
				"-DCMAKE_BUILD_TYPE=${PACMAKE_BUILD_TYPE}"
				"-DCMAKE_POSITION_INDEPENDENT_CODE=${pic}"
				${emptyDependencyDirs}
				${prefixPath}
				${systemVariables}
				${findRootPath}
				"-DPACMAKE_PACKAGE_FETCH_INTERVAL=-1" # don't refetch any packages
				"-DPACMAKE_DEFAULT_LIBRARY_TYPE=${packageType}"
				"-DPACMAKE_DEFAULT_PIC=${packagePIC}"
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
			pacmake_run_patch(${packageName} ${packageVersion} ${packageType} ${packagePIC} CONFIGURE)
			file(WRITE "${buildDirectory}/PaCMake_build_package/configure.DONE")
		endif()
		
		if(EXISTS "${buildDirectory}/PaCMake_build_package/build.DONE" AND NOT args_FORCE)
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
			pacmake_run_patch(${packageName} ${packageVersion} ${packageType} ${packagePIC} BUILD)
			file(WRITE "${buildDirectory}/PaCMake_build_package/build.DONE")
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
		pacmake_run_patch(${packageName} ${packageVersion} ${packageType} ${packagePIC} INSTALL)
		
		if(args_REBUILT_VARIABLE)
			set(${args_REBUILT_VARIABLE} TRUE PARENT_SCOPE)
		endif()
	endif()
	
	pacmake_find_config_directory(${packageName} ${installDirectory} configDirectory)
	set(PACMAKE_PACKAGE_${packageName}_${packageVersion}_${packageType}_${packagePIC}_CONFIG_PATH "${PACMAKE_PACKAGE_${packageName}_${packageVersion}_${packageType}_${packagePIC}_DEPENDENCY_CONFIG_PATH}" CACHE INTERNAL "")
	list(APPEND PACMAKE_PACKAGE_${packageName}_${packageVersion}_${packageType}_${packagePIC}_CONFIG_PATH "${configDirectory}")
	set(PACMAKE_PACKAGE_${packageName}_${packageVersion}_${packageType}_${packagePIC}_CONFIG_PATH "${PACMAKE_PACKAGE_${packageName}_${packageVersion}_${packageType}_${packagePIC}_CONFIG_PATH}" CACHE INTERNAL "")
	
	set(PACMAKE_PACKAGE_${packageName}_${packageVersion}_${packageType}_${packagePIC}_CONFIG_DIR "${configDirectory}" CACHE INTERNAL "")
	pacmake_log_indent(DECREMENT)
endfunction()

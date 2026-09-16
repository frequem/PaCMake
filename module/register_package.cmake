pacmake_include(package_version)

include(CMakeParseArguments)

# pacmake_register_package([VARIANT packageVariant] packageVersion [FINAL] [DEPENDENCIES dependency1Name dependency1Version [...]] [SOURCES ...] [CMAKE_ARGS ...])
function(pacmake_register_package)
	set(packageName ${PACMAKE_CURRENT_PACKAGE}) # save package name overwritten by dependency loading

	cmake_parse_arguments(args "FINAL" "VARIANT" "DEPENDENCIES;SOURCES;CMAKE_ARGS" ${ARGN})

	set(packageVariant "default")
	if(args_VARIANT)
		set(packageVariant "${args_VARIANT}")
	endif()

	list(LENGTH args_UNPARSED_ARGUMENTS unparsedLength)
	if(${unparsedLength} GREATER 1)
		message(FATAL_ERROR "PaCMake: pacmake_register_package(${packageName} ${packageVariant}): Too many arguments.")
	elseif(${unparsedLength} EQUAL 0)
		message(FATAL_ERROR "PaCMake: pacmake_register_package(${packageName} ${packageVariant}): Missing version argument.")
	endif()
	list(GET args_UNPARSED_ARGUMENTS 0 packageVersion)

	if(${packageVersion} IN_LIST PACMAKE_PACKAGE_${packageName}_${packageVariant}_VERSIONS)
		message(FATAL_ERROR "PaCMake: pacmake_register_package(${packageName} ${packageVariant}): Duplicate package version (${packageVersion}).")
	endif()

	set(dependencyNames "")
	set(dependencyVariants "")
	set(dependencyVersions "")
	set(dependencyTypes "")
	set(dependencyPICs "")
	if(args_DEPENDENCIES) # load dependencies at register time to avoid circular dependency on add
		set(firstDependencyType TRUE)
		list(LENGTH args_DEPENDENCIES nDependencies)
		set(i 1)
		while(i LESS ${nDependencies})
			math(EXPR iDependencyNameVariant "${i} - 1")
			list(GET args_DEPENDENCIES ${iDependencyNameVariant} dependencyNameVariant)


			string(REGEX REPLACE "^([^:]+)(::.*)?$" "\\1" dependencyName "${dependencyNameVariant}")
			string(REGEX REPLACE "^${dependencyName}(::(.*))?$" "\\2" dependencyVariant "${dependencyNameVariant}")
			if(NOT dependencyVariant)
				set(dependencyVariant "default")
			endif()

			math(EXPR iDependencyVersionRequested "${i}")
			list(GET args_DEPENDENCIES ${iDependencyVersionRequested} dependencyVersionRequested)


			set(dependencyType "")
			set(dependencyPIC "")
			foreach(j RANGE 1 2)
				math(EXPR iPossibleArgName "${i} + 1")
				if(${iPossibleArgName} LESS ${nDependencies})
					list(GET args_DEPENDENCIES ${iPossibleArgName} possibleArgName)
					set(possibleArgNames "TYPE;PIC")
					if(NOT "${possibleArgName}" IN_LIST possibleArgNames)
						break()
					endif()

					math(EXPR iPossibleArgValue "${i} + 2")
					if(${iPossibleArgValue} GREATER_EQUAL ${nDependencies})
						message(FATAL_ERROR "PaCMake: pacmake_register_package(${packageName} ${packageVersion}): Missing ${possibleArgName} dependency argument.")
					endif()
					list(GET args_DEPENDENCIES ${iPossibleArgValue} argValue)

					set(argValues "")
					if(possibleArgName STREQUAL "TYPE")
						set(argValues "STATIC;SHARED;MODULE;DEFAULT;INHERIT")
						set(dependencyType "${argValue}")
					elseif(possibleArgName STREQUAL "PIC")
						set(argValues "TRUE;FALSE;DEFAULT;INHERIT")
						set(dependencyPIC "${argValue}")
					endif()
					if(NOT "${argValue}" IN_LIST argValues)
						message(FATAL_ERROR "PaCMake: pacmake_register_package(${packageName} ${packageVersion}): Invalid ${possibleArgName} dependency argument(${argValue}).")
					endif()

					math(EXPR i "${i} + 2")
				endif()
			endforeach()
			math(EXPR i "${i} + 2")

			if(dependencyType STREQUAL "")
				set(dependencyType "INHERIT")
			endif()
			if(dependencyPIC STREQUAL "")
				set(dependencyPIC "INHERIT")
			endif()

			if(NOT packageName STREQUAL dependencyName)
				pacmake_load_package(${dependencyName})
			endif()

			pacmake_find_package_version(${dependencyName} ${dependencyVariant} ${dependencyVersionRequested} dependencyVersion) # error if no compatible version is found

			list(FIND dependencyNames "${dependencyName}" iPrevDependencyName)
			if(${iPrevDependencyName} GREATER_EQUAL 0)
				message(FATAL_ERROR "PaCMake: pacmake_register_package(${packageName} ${packageVariant} ${packageVersion}): Duplicate dependency(${dependencyName}).")
			endif()

			list(APPEND dependencyNames "${dependencyName}")
			list(APPEND dependencyVariants "${dependencyVariant}")
			list(APPEND dependencyVersions "${dependencyVersion}")
			list(APPEND dependencyTypes "${dependencyType}")
			list(APPEND dependencyPICs "${dependencyPIC}")
		endwhile()
		if(${i} LESS_EQUAL ${nDependencies})
			string(REPLACE ";" " " dependencyString "${args_DEPENDENCIES}")
			message(FATAL_ERROR "PaCMake: pacmake_register_package(${packageName} ${packageVariant} ${packageVersion}): Invalid dependencies: ${dependencyString}. Version missing?")
		endif()
	endif()

	set(PACMAKE_PACKAGE_${packageName}_${packageVariant}_${packageVersion}_DEPENDENCY_NAMES "${dependencyNames}" CACHE INTERNAL "")
	set(PACMAKE_PACKAGE_${packageName}_${packageVariant}_${packageVersion}_DEPENDENCY_VARIANTS "${dependencyVariants}" CACHE INTERNAL "")
	set(PACMAKE_PACKAGE_${packageName}_${packageVariant}_${packageVersion}_DEPENDENCY_VERSIONS "${dependencyVersions}" CACHE INTERNAL "")
	set(PACMAKE_PACKAGE_${packageName}_${packageVariant}_${packageVersion}_DEPENDENCY_TYPES "${dependencyTypes}" CACHE INTERNAL "")
	set(PACMAKE_PACKAGE_${packageName}_${packageVariant}_${packageVersion}_DEPENDENCY_PICS "${dependencyPICs}" CACHE INTERNAL "")
	set(PACMAKE_PACKAGE_${packageName}_${packageVariant}_${packageVersion}_FINAL "${args_FINAL}" CACHE INTERNAL "")
	set(PACMAKE_PACKAGE_${packageName}_${packageVariant}_${packageVersion}_SOURCES "${args_SOURCES}" CACHE INTERNAL "")
	set(PACMAKE_PACKAGE_${packageName}_${packageVariant}_${packageVersion}_CMAKE_ARGS "${args_CMAKE_ARGS}" CACHE INTERNAL "")

	list(APPEND PACMAKE_PACKAGE_${packageName}_${packageVariant}_VERSIONS ${packageVersion})
	list(SORT PACMAKE_PACKAGE_${packageName}_${packageVariant}_VERSIONS COMPARE NATURAL ORDER DESCENDING)
	set(PACMAKE_PACKAGE_${packageName}_${packageVariant}_VERSIONS "${PACMAKE_PACKAGE_${packageName}_${packageVariant}_VERSIONS}" CACHE INTERNAL "")

	list(APPEND PACMAKE_PACKAGE_${packageName}_VARIANTS ${packageVariant})
	set(PACMAKE_PACKAGE_${packageName}_VARIANTS "${PACMAKE_PACKAGE_${packageName}_VARIANTS}" CACHE INTERNAL "")
endfunction(pacmake_register_package)

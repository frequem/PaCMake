include(CMakeParseArguments)

pacmake_include(default_version)
pacmake_include(package_property)
pacmake_include(log)

function(pacmake_register_package args_NAME)
	cmake_parse_arguments(
        args
        ""
        "PATCH;VERSION;URL_HASH;HTTP_USERNAME;HTTP_PASSWORD;GIT_REPOSITORY;GIT_TAG;SVN_REPOSITORY;SVN_REVISION;SVN_USERNAME;SVN_PASSWORD;HG_REPOSITORY;HG_TAG;CVS_REPOSITORY;CVS_MODULE;CVS_TAG"
        "URL;HTTP_HEADER;DEPENDENCIES;CMAKE_ARGS"
        ${ARGN}
    )
	
	if(NOT args_VERSION)
		pacmake_log(ERROR "pacmake_register_package(${args_NAME}): No version specified.")
		return()
	elseif(NOT args_URL AND NOT args_GIT_REPOSITORY AND NOT args_SVN_REPOSITORY AND NOT args_HG_REPOSITORY AND NOT CVS_REPOSITORY)
		pacmake_log(ERROR "pacmake_register_package(${args_NAME}): No source specified. Specify URL, GIT_REPOSITORY, SVN_REPOSITORY, HG_REPOSITORY or CVS_REPOSITORY.")
		return()
	endif()
	
	#append to package list
	list(FIND PACMAKE_PACKAGE_LIST ${args_NAME} i)
	if(${i} LESS 0)
		list(APPEND PACMAKE_PACKAGE_LIST ${args_NAME})
		set(PACMAKE_PACKAGE_LIST ${PACMAKE_PACKAGE_LIST} CACHE INTERNAL "PACMAKE_PACKAGE_LIST")
	endif()
	
	pacmake_set_package_property(${args_NAME} ${args_VERSION} DEPENDENCIES GENERIC "${args_DEPENDENCIES}")
	pacmake_set_package_property(${args_NAME} ${args_VERSION} PATCH GENERIC "${args_PATCH}")
	pacmake_set_package_property(${args_NAME} ${args_VERSION} CMAKE_ARGS GENERIC "${args_CMAKE_ARGS}")
		
	pacmake_set_package_property(${args_NAME} ${args_VERSION} URL DOWNLOAD "${args_URL}")
	pacmake_set_package_property(${args_NAME} ${args_VERSION} URL_HASH DOWNLOAD "${args_URL_HASH}")
	pacmake_set_package_property(${args_NAME} ${args_VERSION} HTTP_USERNAME DOWNLOAD "${args_HTTP_USERNAME}")
	pacmake_set_package_property(${args_NAME} ${args_VERSION} HTTP_PASSWORD DOWNLOAD "${args_HTTP_PASSWORD}")
	pacmake_set_package_property(${args_NAME} ${args_VERSION} HTTP_HEADER DOWNLOAD "${args_HTTP_HEADER}")
	
	pacmake_set_package_property(${args_NAME} ${args_VERSION} GIT_REPOSITORY DOWNLOAD "${args_GIT_REPOSITORY}")
	pacmake_set_package_property(${args_NAME} ${args_VERSION} GIT_TAG DOWNLOAD "${args_GIT_TAG}")
	
	pacmake_set_package_property(${args_NAME} ${args_VERSION} SVN_REPOSITORY DOWNLOAD "${args_SVN_REPOSITORY}")
	pacmake_set_package_property(${args_NAME} ${args_VERSION} SVN_REVISION DOWNLOAD "${args_SVN_REVISION}")
	pacmake_set_package_property(${args_NAME} ${args_VERSION} SVN_USERNAME DOWNLOAD "${args_SVN_USERNAME}")
	pacmake_set_package_property(${args_NAME} ${args_VERSION} SVN_PASSWORD DOWNLOAD "${args_SVN_PASSWORD}")
	
	pacmake_set_package_property(${args_NAME} ${args_VERSION} HG_REPOSITORY DOWNLOAD "${args_HG_REPOSITORY}")
	pacmake_set_package_property(${args_NAME} ${args_VERSION} HG_TAG DOWNLOAD "${args_HG_TAG}")
	
	pacmake_set_package_property(${args_NAME} ${args_VERSION} CVS_REPOSITORY DOWNLOAD "${args_CVS_REPOSITORY}")
	pacmake_set_package_property(${args_NAME} ${args_VERSION} CVS_MODULE DOWNLOAD "${args_CVS_MODULE}")
	pacmake_set_package_property(${args_NAME} ${args_VERSION} CVS_TAG DOWNLOAD "${args_CVS_TAG}")
endfunction(pacmake_register_package)

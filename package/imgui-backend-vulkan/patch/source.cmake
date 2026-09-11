function(pacmake_patch packageName packageVersion workingDirectory)
	file(COPY "${PACMAKE_HOME}/package/imgui/${packageVersion}/src/orig/backends/imgui_impl_vulkan.h" DESTINATION "${workingDirectory}/")
	file(COPY "${PACMAKE_HOME}/package/imgui/${packageVersion}/src/orig/backends/imgui_impl_vulkan.cpp" DESTINATION "${workingDirectory}/")

	file(COPY "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/imgui-backend-vulkanConfig.cmake" DESTINATION "${workingDirectory}/")
	file(COPY "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/CMakeLists.txt" DESTINATION "${workingDirectory}/")
endfunction(pacmake_patch)

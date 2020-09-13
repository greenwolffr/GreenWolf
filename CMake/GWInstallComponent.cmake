####################################################################################################
#
# Copyright 2020 Benoît Gradit (GreenWolf)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
# associated documentation files (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge, publish, distribute,
# sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or
# substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
# OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
####################################################################################################

include(GWTargetInstallResources)
include(GWTargetTransitiveSources)


function(gw_install_component PACKAGE)
    cmake_parse_arguments(
        ARGS
        ""
        "COMPONENT"
        "TARGETS"
        ${ARGN}
    )

    # Face name for config files:
    set(EXPORT_PREFIX "${PACKAGE}${ARGS_COMPONENT}")
    set(EXPORT_CONFIG "${EXPORT_PREFIX}Config.cmake")
    set(EXPORT_TARGETS "${EXPORT_PREFIX}Targets")

    # Prepare configuration file:
    if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/${EXPORT_CONFIG}")
        set(EXPORT_CONFIG_SOURCE "${CMAKE_CURRENT_LIST_DIR}/${EXPORT_CONFIG}")
        set(EXPORT_CONFIG_OPTION "COPYONLY")
    elseif(EXISTS "${CMAKE_CURRENT_LIST_DIR}/${EXPORT_CONFIG}.in")
        set(EXPORT_CONFIG_SOURCE "${CMAKE_CURRENT_LIST_DIR}/${EXPORT_CONFIG}.in")
        set(EXPORT_CONFIG_OPTION "@ONLY")
    endif()

    set(INCLUDE_TARGETS "include(\"\${CMAKE_CURRENT_LIST_DIR}/${EXPORT_TARGETS}.cmake\")\n")
    if(EXPORT_CONFIG_SOURCE)
        configure_file(${EXPORT_CONFIG_SOURCE} ${EXPORT_CONFIG} ${EXPORT_CONFIG_OPTION})
        file(APPEND "${CMAKE_CURRENT_BINARY_DIR}/${EXPORT_CONFIG}" "\n${INCLUDE_TARGETS}")

        # Add the file in targets:
        foreach(TARGET IN LISTS ARGS_TARGETS)
            gw_target_transitive_sources(
                ${TARGET}
                GROUP "CMake files"
                SOURCES ${EXPORT_CONFIG_SOURCE}
            )
        endforeach()
    else()
        file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${EXPORT_CONFIG}" "${INCLUDE_TARGETS}")
    endif()

    # Install files:
    foreach(TARGET IN LISTS ARGS_TARGETS)
        gw_target_install_resources(
            ${TARGET}
            PUBLIC_HEADER DESTINATION include/${PACKAGE}/${ARGS_COMPONENT} DISPOSE
        )

        # Alias the target:
        add_library("${PACKAGE}::${TARGET}" ALIAS ${TARGET})
    endforeach()

    install(
        TARGETS ${ARGS_TARGETS}
        EXPORT ${EXPORT_TARGETS}
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
    )

    install(
        EXPORT ${EXPORT_TARGETS}
        COMPONENT ${COMPONENT}
        DESTINATION cmake
        NAMESPACE "${PACKAGE}::"
    )

    install(
        FILES
        "${CMAKE_CURRENT_BINARY_DIR}/${EXPORT_CONFIG}"
        DESTINATION cmake
    )
endfunction()

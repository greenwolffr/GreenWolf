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

include(CMakePackageConfigHelpers)


function(gw_install_package PACKAGE)
    cmake_parse_arguments(
        ARGS
        "EXPORT_CMAKE_MODULE_PATH"
        "COMPATIBILITY"
        "ADDITIONAL_DIRECTORIES"
        ${ARGN}
    )

    set(EXPORT_CONFIG "${PACKAGE}Config")
    set(SOURCE_CONFIG "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/gw-package-config.cmake.in")

    configure_file(${SOURCE_CONFIG} "${EXPORT_CONFIG}.cmake" @ONLY)

    write_basic_package_version_file(
        ${EXPORT_CONFIG}Version.cmake
        COMPATIBILITY ${ARGS_COMPATIBILITY}
    )

    install(
        FILES
        "${CMAKE_CURRENT_BINARY_DIR}/${EXPORT_CONFIG}.cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/${EXPORT_CONFIG}Version.cmake"
        DESTINATION cmake
    )

    if(ARGS_ADDITIONAL_DIRECTORIES)
        install(DIRECTORY ${ARGS_ADDITIONAL_DIRECTORIES})
    endif()

    if(ARGS_EXPORT_CMAKE_MODULE_PATH)
        set(EXPORT_CMAKE_MODULE "list(APPEND CMAKE_MODULE_PATH \${CMAKE_CURRENT_LIST_DIR})\n")
        file(APPEND "${CMAKE_CURRENT_BINARY_DIR}/${EXPORT_CONFIG}.cmake" "\n${EXPORT_CMAKE_MODULE}")
    endif()
endfunction()

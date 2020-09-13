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

include(GWGenerateGlobalHeader)


function(gw_add_library TARGET)
    cmake_parse_arguments(
        ARGS
        ""
        "NAMESPACE"
        "PUBLIC;PRIVATE"
        ${ARGN}
    )


    # Library sources:
    set(SOURCES ${ARGS_PUBLIC} ${ARGS_PRIVATE})

    # Create the target:
    add_library(${TARGET} SHARED ${SOURCES})


    # Public headers:
    set(PUBLIC_HEADERS ${ARGS_PUBLIC})
    list(FILTER PUBLIC_HEADERS INCLUDE REGEX "\.h$")

    # Target file name (SampleTarget):
    string(REPLACE "-" "" TARGET_FILE_NAME "${TARGET}")

    # Header prefix (SAMPLE_TARGET):
    if(ARGS_NAMESPACE)
        string(REPLACE "-" "_" TARGET_HEADER_PREFIX "${ARGS_NAMESPACE}_${TARGET}")

        set_target_properties(${TARGET} PROPERTIES OUTPUT_NAME "${ARGS_NAMESPACE}-${TARGET}")
    else()
        string(REPLACE "-" "_" TARGET_HEADER_PREFIX "${TARGET}")
    endif()
    string(TOUPPER "${TARGET_HEADER_PREFIX}" TARGET_HEADER_PREFIX)

    # Global header:
    gw_generate_global_header(
        ${TARGET}
        NAME "${TARGET_FILE_NAME}.h"
        PREFIX "${TARGET_HEADER_PREFIX}"
    )


    # Manage publis headers:
    set_target_properties(
        ${TARGET} PROPERTIES

        PUBLIC_HEADER
        "${PUBLIC_HEADERS};${CMAKE_CURRENT_BINARY_DIR}/${TARGET_FILE_NAME}.h"
    )
endfunction()

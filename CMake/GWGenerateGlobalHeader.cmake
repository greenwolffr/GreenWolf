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


function(gw_generate_global_header TARGET)
    cmake_parse_arguments(
        ARGS
        ""
        "NAME;PREFIX"
        ""
        ${ARGN}
    )


    # Export variable with sweat names for the configure part:
    set(HEADER_PREFIX ${ARGS_PREFIX})

    configure_file("${CMAKE_CURRENT_FUNCTION_LIST_DIR}/gw-global-header.h.in" "${ARGS_NAME}" @ONLY)

    # Add the file to the target:
    target_compile_definitions(
        ${TARGET}
        PRIVATE "${HEADER_PREFIX}_LIBRARY"
    )

    target_include_directories(
        ${TARGET}

        PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        $<INSTALL_INTERFACE:include/>
    )
endfunction()

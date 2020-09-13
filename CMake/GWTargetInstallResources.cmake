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


function(gw_target_install_resources TARGET RESOURCE)
    cmake_parse_arguments(
        ARGS
        "DISPOSE"
        "DESTINATION"
        ""
        ${ARGN}
    )

    get_target_property(FILES ${TARGET} ${RESOURCE})

    foreach(FILE IN LISTS FILES)
        if(IS_ABSOLUTE "${FILE}")
            file(RELATIVE_PATH REL_FILE ${CMAKE_CURRENT_BINARY_DIR} "${FILE}")
        else()
            set(REL_FILE "${FILE}")
        endif()
        get_filename_component(FOLDER ${REL_FILE} DIRECTORY)
        install(FILES ${FILE} DESTINATION ${ARGS_DESTINATION}/${FOLDER})
    endforeach()

    if(ARGS_DISPOSE)
        set_target_properties(${TARGET} PROPERTIES ${RESOURCE} "")
    endif()
endfunction()

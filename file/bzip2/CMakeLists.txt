cmake_minimum_required(VERSION 3.0)

project(bzip2
    VERSION 1.0.6
    LANGUAGES C
)

set(local_lib_name bz2)

set(bzip2_lib_SRCS
    blocksort.c
    huffman.c
    crctable.c
    randtable.c
    compress.c
    decompress.c
    bzlib.c
)

set(bzip2_lib_HDRS
    bzlib.h
    bzlib_private.h
)
set(bzip2_scripts
    bzdiff
    bzgrep
    bzmore
)
set(bzip2_docs
    bzip2.txt
    manual.pdf
)
set(bzip2_html
    manual.html
)

set(CMAKE_DEBUG_POSTFIX "d")

add_library(${local_lib_name} SHARED ${bzip2_lib_SRCS} ${bzip2_lib_HDRS} ${bzip2_DLLSRCS})
set_target_properties(${local_lib_name} PROPERTIES 
    SOVERSION ${PROJECT_VERSION}
    VERSION ${PROJECT_VERSION_MAJOR}    
    PUBLIC_HEADER bzlib.h
)

# bzip2recover
add_executable(bzip2recover bzip2recover.c)
target_link_libraries(bzip2recover bz2)

# bzip2
add_executable(bzip2_bin bzip2.c)
target_link_libraries(bzip2_bin bz2)
set_target_properties(bzip2_bin PROPERTIES OUTPUT_NAME bzip2)


install(TARGETS bz2 bzip2recover bzip2_bin
    RUNTIME DESTINATION bin
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    PUBLIC_HEADER DESTINATION include
    )

file(GLOB man1 ${bzip2_SOURCE_DIR}/*.1)

if(NOT WIN32)
  install(PROGRAMS ${bzip2_scripts} DESTINATION bin)
endif(NOT WIN32)

install(FILES ${man1}          DESTINATION share/man/man1)
install(FILES ${bzip2_docs}    DESTINATION doc)
install(FILES ${bzip2_html}    DESTINATION doc/html)

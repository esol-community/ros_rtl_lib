cmake_minimum_required(VERSION 2.8)

project(uuid)

add_definitions(-DHAVE_INTTYPES_H)

add_library(${PROJECT_NAME} STATIC
  clear.c
  compare.c
  copy.c
  gen_uuid.c
  isnull.c
  pack.c
  parse.c
  unpack.c
  unparse.c
  uuid_time.c
)

install(TARGETS ${PROJECT_NAME} ARCHIVE DESTINATION
  ${BUILD_GCC_PREFIX}/${BUILD_AARCH_NAME}/lib/
)

install(FILES uuid.h DESTINATION ${BUILD_GCC_PREFIX}/${BUILD_AARCH_NAME}/include/uuid )

cmake_minimum_required(VERSION 3.10)
project(MyProject)

include_directories(include)

add_library(mylib STATIC src/mylib.cpp)

add_executable(myapp src/main.cpp)

target_link_libraries(myapp PRIVATE mylib)
target_include_directories(myapp PRIVATE include)

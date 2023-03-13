---@diagnostic disable: undefined-global
return {
	s(
		"cppstart",
		fmt(
			[[
cmake_minimum_required(VERSION 3.10 FATAL_ERROR)

project({1} LANGUAGES CXX)
set(CMAKE_VERBOSE_MAKEFILE true)
set(CMAKE_EXPORT_COMPILE_COMMANDS true)

if(NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE Release)
endif()

set(CMAKE_CXX_FLAGS "-Wall -Wextra -Wpedantic -Wshadow -Wconversion")
set(CMAKE_CXX_FLAGS_DEBUG "-O0 -ggdb -DFULLDEBUG -fsanitize=address -fsanitize=undefined -D_GLIBCXX_DEBUG")
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -flto")

set(CMAKE_CXX_LINK_OPTIONS_DEBUG "-fsanitize=address -fsanitize=undefined -rdynamic")
set(CMAKE_CXX_LINK_OPTIONS_RELEASE "")

set(CMAKE_CXX_STANDARD 20)

include_directories(inc)
file(GLOB SOURCES "src/*.cpp")

add_executable(
	{2}
	${{SOURCES}}
)

if (CMAKE_BUILD_TYPE STREQUAL "Debug")
	add_definitions(-DDEBUG)
endif()
]],
			{ i(1), i(0) }
		)
	),
	s(
		"cstart",
		fmt(
			[[
cmake_minimum_required(VERSION 3.10 FATAL_ERROR)

project({1} LANGAGES C)
set(CMAKE_VERBOSE_MAKEFILE true)
set(CMAKE_EXPORT_COMPILE_COMMANDS true)

if(NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE Release)
endif()

set(CMAKE_C_FLAGS "-Wall -Wextra -Wpedantic -Wshadow -Wconversion")
set(CMAKE_C_FLAGS_DEBUG "-O0 -ggdb -DFULLDEBUG -fsanitize=address -fsanitize=undefined -D_GLIBCXX_DEBUG")
set(CMAKE_C_FLAGS_RELEASE "-O3 -flto")

set(CMAKE_C_LINK_OPTIONS_DEBUG "-fsanitize=address -fsanitize=undefined -rdynamic")
set(CMAKE_C_LINK_OPTIONS_RELEASE "")

set(CMAKE_C_STANDARD 99)

include_directories(inc)
file(GLOB SOURCES "src/*.c")

add_executable(
	{2}
	${{SOURCES}}
)

if (CMAKE_BUILD_TYPE STREQUAL "Debug")
	add_definitions(-DDEBUG)
endif()
]],
			{ i(1), i(0) }
		)
	),
}

cmake_minimum_required(VERSION 3.5)
project(eduvoda-app)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
find_package(Qt5 COMPONENTS Qml Quick Core Widgets REQUIRED)

include_directories(
    components
)

set (SRCS
    main.cpp
    net.h
)

add_executable(${CMAKE_PROJECT_NAME} ${SRCS} resources.qrc qml.qrc)

target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE Qt5::Core Qt5::Widgets Qt5::Qml Qt5::Quick)

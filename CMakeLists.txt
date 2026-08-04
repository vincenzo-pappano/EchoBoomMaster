cmake_minimum_required(VERSION 3.16)

project(EchoBoomMaster VERSION 0.1 LANGUAGES CXX)

if(NOT WIN32)
    message(FATAL_ERROR "EchoBoomMaster currently supports Windows only.")
endif()

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt5 5.15 REQUIRED COMPONENTS
    Core
    Qml
    Quick
    QuickControls2
    Multimedia
    Widgets)

set(GSTREAMER_ROOT
    "C:/Program Files/gstreamer/1.0/mingw_x86_64"
)

set(
    PKG_CONFIG_EXECUTABLE
    "${GSTREAMER_ROOT}/bin/pkg-config.exe"
    CACHE FILEPATH "GStreamer pkg-config executable"
    FORCE
)

set(
    ENV{PKG_CONFIG_PATH}
    "${GSTREAMER_ROOT}/lib/pkgconfig"
)

find_package(PkgConfig REQUIRED)

pkg_check_modules(
    GSTREAMER
    REQUIRED
    IMPORTED_TARGET
    gstreamer-1.0
    gstreamer-app-1.0
)

add_executable(EchoBoomMaster WIN32
    main.cpp
    qml.qrc
    FixedAspectRatioWindow.h
    FixedAspectRatioWindow.cpp
    GstVideoItem.h
    GstVideoItem.cpp
    logging/LoggerConfig.h
    logging/Logger.h
    logging/Logger.cpp
)

target_link_libraries(EchoBoomMaster
    PRIVATE
        Qt5::Core
        Qt5::Quick
        Qt5::Widgets
        Qt5::Qml
        Qt5::QuickControls2
        Qt5::Multimedia
        PkgConfig::GSTREAMER)

execute_process(
    COMMAND git rev-parse --short HEAD
    WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
    OUTPUT_VARIABLE GIT_COMMIT_HASH
    OUTPUT_STRIP_TRAILING_WHITESPACE
    ERROR_QUIET
)

if(NOT GIT_COMMIT_HASH)
    set(GIT_COMMIT_HASH "unknown")
endif()

target_compile_definitions(EchoBoomMaster
    PRIVATE
        GIT_COMMIT_ID="${GIT_COMMIT_HASH}"
        PROJECT_VERSION_STRING="${PROJECT_VERSION}"
)

install(
    TARGETS EchoBoomMaster
    RUNTIME DESTINATION .
)
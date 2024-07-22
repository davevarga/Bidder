cmake_minimum_required(VERSION 3.16)

project(Bidder VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()

qt_add_executable(appBidder
    main.cpp
    assets.qrc
)

qt_add_qml_module(appBidder
    URI Bidder
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/ControlPanel.qml
        qml/MenuSideBar.qml

    QML_FILES
        qml/ExplorePage.qml
        qml/WatchlistPage.qml
        qml/BidsPage.qml
        qml/OwnGoodsPage.qml
        qml/AccountPage.qml
        qml/Form.qml

    SOURCES BidElement.h BidElement.cpp
    SOURCES User.h User.cpp
    SOURCES BidsList.h BidsList.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appBidder PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appBidder
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appBidder
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appBidder
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

import QtQuick
import QtQuick.Controls

Item {
    id: root

    property color baseColor: "lightyellow"
    property color fontColor: "grey"
    property int itemHeight: 40

    Menu {
        id: menu
        implicitWidth: parent.width
        implicitHeight: parent.height
        spacing:3

        property color baseColor: root.baseColor
        property color fontColor: root.fontColor

        Action {
            text: qsTr("Explore")
            onTriggered: root.changePage("ExplorePage.qml")
        }
        Action {
            text: qsTr("Watchlist")
            onTriggered: root.changePage("WatchlistPage.qml")
        }
        Action {
            text: qsTr("Bid")
            onTriggered: root.changePage("BidsPage.qml")
        }
        Action {
            text: qsTr("Own Goods")
            onTriggered: root.changePage("OwnGoodsPage.qml")
        }

        Menu {
             title: qsTr("Advanced")
        }

        MenuSeparator {
            contentItem: Rectangle {
                implicitWidth: parent.width
                implicitHeight: 1
                color: menu.fontColor
            }
        }

        Action {
            text: qsTr("Sign In")
            onTriggered: {
                root.changePage("AccountPage.qml")
            }
        }

        Action {
            text: qsTr("Sign Up")
            onTriggered: {
                root.changePage("AccountPage.qml")
            }
        }



        delegate: MenuItem {
            id: menuItem
            height: root.itemHeight

            arrow: Canvas {
                x: parent.width - width
                implicitWidth: 40
                implicitHeight: 40
                visible: menuItem.subMenu
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.fillStyle = menuItem.highlighted ?
                                Qt.darker(menu.fontColor) : menu.fontColor
                    ctx.moveTo(15, 15)
                    ctx.lineTo(width - 15, height / 2)
                    ctx.lineTo(15, height - 15)
                    ctx.closePath()
                    ctx.fill()
                }
            }

            contentItem: Text {
                rightPadding: menuItem.arrow.width
                text: menuItem.text
                font: menuItem.font
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight

                opacity: enabled ? 1.0 : 0.3
                color: if(menuItemMouseArea.containsPress) {
                           return Qt.darker(menu.fontColor)
                       } else if (menuItemMouseArea.containsMouse) {
                           return Qt.darker(menu.fontColor)
                       } else {
                           return menu.fontColor
                       }
            }

            background: Rectangle {
                width: parent.width
                height: 40
                opacity: enabled ? 1 : 0.3
                color: if(menuItemMouseArea.containsPress) {
                           return Qt.darker(menu.baseColor)
                       } else if (menuItemMouseArea.containsMouse) {
                           return Qt.darker(menu.baseColor)
                       } else {
                           return menu.baseColor
                       }

                MouseArea {
                    id: menuItemMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                }

            }
        }

        background: Rectangle {
            width:200
            color: menu.baseColor
            border.color: Qt.darker(menu.baseColor, 1.1)

            anchors {
                top : parent.top
                bottom: parent.bottom
                left: parent.left
            }
        }
    }

    function open() {
        menu.open()
    }

    function changePage(page) {
        pageStackView.push(page)
        controlPanel.label = pageStackView.currentItem.title
        console.log("CurrentPage changed to: ", page)
    }
}

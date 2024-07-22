import QtQuick

Rectangle {
    id: root
    height: 50
    color: baseColor;

    property color baseColor: "blue"
    property int selected: 1

    anchors {
        top: parent.top
        right: parent.right
        left: parent.left
    }

    Rectangle {
        id: exploreButton
        width: parent.width / 5

        anchors {
            top: parent.top
            left: parent.left
            bottom: parent.bottom
        }

        color: {
            if(root.selected != 0) {
                if(exploreMouseArea.containsPress) {
                    return Qt.darker(root.baseColor)
                } else if (exploreMouseArea.containsMouse){
                    return Qt.lighter(root.baseColor)
                } else {
                    return root.baseColor
                }
            } else {
                return "lightyellow"
            }
        }

        Text {
            text: "Explore"
            font.bold: true
            font.pixelSize: 14
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        MouseArea {
            id:exploreMouseArea
            anchors.fill: parent
            hoverEnabled: true;

            onClicked: {
                root.selected = 0
                console.log("Explore Window Active")
            }
        }
    }

    Rectangle {
        id: watchlistButton
        width: parent.width / 5

        anchors {
            top: parent.top
            left: exploreButton.right
            bottom: parent.bottom
        }

        color: {
            if(root.selected != 1) {
                if(watchlistMouseArea.containsPress) {
                    return Qt.darker(root.baseColor)
                } else if (watchlistMouseArea.containsMouse){
                    return Qt.lighter(root.baseColor)
                } else {
                    return root.baseColor
                }
            } else {
                return "lightyellow"
            }
        }

        Text {
            text: "Watchlist"
            font.bold: true
            font.pixelSize: 14
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        MouseArea {
            id:watchlistMouseArea
            anchors.fill: parent
            hoverEnabled: true;

            onClicked: {
                root.selected = 1
                console.log("Watchlist Window Active")
            }
        }
    }

    Rectangle {
        id: bidsButton
        property color baseColor: "grey"
        width: parent.width / 5

        anchors {
            top: parent.top
            left: watchlistButton.right
            bottom: parent.bottom
        }

        color: {
            if(root.selected != 2) {
                if(bidsMouseArea.containsPress) {
                    return Qt.darker(root.baseColor)
                } else if (bidsMouseArea.containsMouse){
                    return Qt.lighter(root.baseColor)
                } else {
                    return root.baseColor
                }
            } else {
                return "lightyellow"
            }
        }

        Text {
            text: "Bids"
            font.bold: true
            font.pixelSize: 14
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        MouseArea {
            id:bidsMouseArea
            anchors.fill: parent
            hoverEnabled: true;

            onClicked: {
                root.selected = 2
                console.log("Purchase Window Active")
            }
        }
    }

    Rectangle {
        id: ownGoodsButton
        property color baseColor: "grey"
        width: parent.width / 5

        anchors {
            top: parent.top
            left: bidsButton.right
            bottom: parent.bottom
        }

        color: {
            if(root.selected != 4) {
                if(ownGoodsMouseArea.containsPress) {
                    return Qt.darker(root.baseColor)
                } else if (ownGoodsMouseArea.containsMouse){
                    return Qt.lighter(root.baseColor)
                } else {
                    return root.baseColor
                }
            } else {
                return "lightyellow"
            }
        }

        Text {
            text: "Own Goods"
            font.bold: true
            font.pixelSize: 14
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        MouseArea {
            id:ownGoodsMouseArea
            anchors.fill: parent
            hoverEnabled: true;

            onClicked: {
                root.selected = 4
                console.log("Explore Window Active")
            }
        }
    }
}

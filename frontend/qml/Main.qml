import QtQuick
import QtQuick.Controls

Window {
    id: applicationWindow
    width: 640
    height: 480
    visible: true
    title: qsTr("Bidder")

    property color baseColor: "lightyellow"
    property color fontColor: "black"

    Rectangle {
        id: controlPanel
        height: 50
        color: controlPanel.baseColor

        property string label: "Home"
        property color baseColor: "lightgreen"
        property color fontColor: "black"

        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
        }

        Image {
            id: menuImage
            width: 50
            source: "qrc:/assets/icons/menu.svg"

            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
            }

            MouseArea {
                anchors.fill: parent
                onClicked: sideBar.open()
            }
        }

        Image {
            id: backImage
            width: 50
            source: "qrc:/assets/icons/back.png"
            visible: pageStackView.depth > 1

            anchors {
                top: parent.top
                bottom: parent.bottom
                left: menuImage.right
            }

            MouseArea {
                anchors.fill: parent
                onClicked: if(pageStackView.depth > 1)
                               controlPanel.popPage()
            }
        }

        Text {
            text: controlPanel.label
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: controlPanel.fontColor

            font {
                pixelSize: 20
                bold: true
            }

            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
        }

        function popPage() {
            pageStackView.pop()
            controlPanel.label = pageStackView.currentItem.title
            console.log("CurrentPage changed to: ", controlPanel.label)
        }
    }

    MenuSideBar {
        id: sideBar
        baseColor: "gray"
        fontColor: "black"
        itemHeight: 45
        width: 200

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
        }
    }

    StackView {
        id: pageStackView
        background: Rectangle {
            color: applicationWindow.baseColor
        }

        anchors {
            top: controlPanel.bottom
            bottom: parent.bottom
            right: parent.right
            left: parent.left
        }
        initialItem: ExplorePage {}
    }
}

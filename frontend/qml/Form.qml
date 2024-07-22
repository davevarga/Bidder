import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import com.User
import com.model.ExploreList


Rectangle {
    id: root
    visible: isVisible

    property bool isVisible: true
    property color backgroundColor: "white"
    property color fieldColor: "lightgray"
    property color buttonColor: "blue"

    width: parent.width * 0.8
    height: 240
    radius: 10

    anchors {
        verticalCenter: parent.verticalCenter
        horizontalCenter: parent.horizontalCenter
        margins: 20
    }

    color: root.backgroundColor
    border.width: 1

    GridLayout {
        id: formLayout
        anchors.fill: parent

        rows: 3
        columns: 2

        TextField {
            id: subjectField
            activeFocusOnPress: true

            Layout.columnSpan: 2
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 10

            placeholderText: "Subject"
            verticalAlignment: TextInput.AlignVCenter
            font.pixelSize: 15

            background: Rectangle {
                implicitHeight: 32
                implicitWidth: root.width * 0.25
                radius: 8
                color: root.fieldColor
            }
        }

        TextField {
            id: priceField

            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 10

            validator: DoubleValidator {}
            verticalAlignment: TextInput.AlignVCenter
            font.pixelSize: 15

            background: Rectangle {
                implicitHeight: 32
                implicitWidth: root.width * 0.25
                radius: 8
                color: root.fieldColor
            }
        }

        Rectangle {
            id: supplierField

            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 10

            implicitHeight: 32
            implicitWidth: root.width * 0.25
            radius: 8
            color: root.fieldColor

            Text {
                anchors.fill: parent
                padding: 8

                text: User.name
                font.pixelSize: 15
                verticalAlignment: TextInput.AlignVCenter
            }
        }

        Rectangle {
            id: cancelButton

            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 10

            height: 32
            radius: 8
            color: if(cancelButtonMouseArea.containsPress) {
                       return Qt.darker(root.buttonColor)
                   } else if (cancelButtonMouseArea.containsMouse) {
                       return Qt.lighter(root.buttonColor)
                   } else {
                       return root.buttonColor
                   }

            Text {
                anchors.fill: parent

                text: "Cancel"
                font.pixelSize: 17
                font.bold: true
                color: "white"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            MouseArea {
                id: cancelButtonMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.cancel()
            }
        }

        Rectangle {
            id: confirmButton

            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 10

            height: 32
            radius: 8
            color: if(confirmButtonMouseArea.containsPress) {
                       return Qt.darker(root.buttonColor)
                   } else if (confirmButtonMouseArea.containsMouse) {
                       return Qt.lighter(root.buttonColor)
                   } else {
                       return root.buttonColor
                   }

            Text {
                anchors.fill: parent

                text: "Confirm"
                font.pixelSize: 17
                font.bold: true
                color: "white"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            MouseArea {
                id: confirmButtonMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.confirm(ExploreList)
            }
        }
    }

    function cancel() {
        root.isVisible = false
        subjectField.clear()
        priceField.clear()
        console.log("Pressed {CancelButton}  by user" + User.name)
    }

    function confirm(dataModel) {
        if(subjectField.acceptableInput && priceField.acceptableInput) {
            dataModel.addBid(
                ExploreList.count,
                subjectField.text,
                User.name,
                priceField.text,
                User.name
            )
        }
        root.isVisible = false
        subjectField.clear()
        priceField.clear()
        console.log("Pressed {ConfirmButton} by user " + User.name)
    }
}

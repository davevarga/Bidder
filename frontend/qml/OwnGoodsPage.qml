import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import com.model.OwnGoods
import com.User

Page {
    id: root
    title: "Own Goods"

    background: Rectangle {
        color: root.parent.background.color
    }

    ListView {
        id: ownGoodsListView
        width: parent.width * 0.75
        property color elementColor: "white"

        anchors {
            top: parent.top
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            margins: 20
        }

        clip: true
        spacing: 10
        model: OwnGoods


        delegate: Rectangle {
            id: delegate
            width: ListView.view.width
            height: 120
            radius: 10

            required property string subjectName
            required property string supplierName
            required property string highestBidderName
            required property double price
            required property string category
            required property int itemIndex

            color: ownGoodsListView.elementColor
            border.width: 1

            Rectangle {
                id: imageFrame
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                width: parent.width * 0.33

                bottomLeftRadius: 10
                topLeftRadius: 10
                color: "gray"

                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 24
                    width: 24
                    source: "qrc:/assets/icons/picture.svg"
                }
            }

            ColumnLayout {
                spacing: 5
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: imageFrame.right
                    right: buttonGroupBox.left
                    margins: 10
                }

                Text {
                    Layout.fillWidth: true
                    text: delegate.subjectName

                    maximumLineCount: 2
                    wrapMode: Text.WordWrap
                    elide: Text.ElideRight

                    font {
                        bold: true
                        pixelSize: 18
                    }
                }

                RowLayout {
                    spacing: 24
                    Text {
                        text: delegate.supplierName
                        font.pixelSize: 10
                        font.italic: true
                    }
                    Text {
                        text: delegate.highestBidderName
                        font.pixelSize: 10
                    }
                }

                RowLayout {
                    spacing: 10
                    Text {
                        text: delegate.price + "Ft"
                        font {
                            bold: true
                            pixelSize: 20
                        }
                    }
                    Text {
                        text: delegate.category
                        font {
                            bold: false
                            pixelSize: 10
                        }
                    }
                }

            }

            ColumnLayout {
                id: buttonGroupBox
                width: 64

                property color removeButtonColor: "red"
                property color bidButtonColor: "green"

                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                    rightMargin: 8
                }
                uniformCellSizes: true

                Rectangle {
                    id: removeButton
                    Layout.alignment: Qt.AlignRight
                    Layout.minimumHeight: 40
                    Layout.minimumWidth: 40
                    radius: 10
                    color: if(removeButtonMouseArea.containsPress) {
                               return Qt.darker(buttonGroupBox.removeButtonColor)
                           } else if (removeButtonMouseArea.containsMouse) {
                               return Qt.lighter(buttonGroupBox.removeButtonColor)
                           } else {
                               return buttonGroupBox.removeButtonColor
                           }

                    Image {
                        anchors.margins: 5
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/assets/icons/delete.svg"
                    }

                    MouseArea {
                        id: removeButtonMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: ownGoodsListView.remove(delegate.itemIndex)
                    }
                }
            }
        }
        function remove(index) {
            OwnGoods.removeBid(index)
        }

        function bid(index) {
            console.log(index);
        }
    }

    Rectangle {
        id: addButton
        width: 40
        height: 40
        radius: 20

        property color backgroundColor: "green"

        anchors {
            bottom: parent.bottom
            right: parent.right
            margins: 10
        }

        color:if(addButtonMouseArea.containsPress) {
                  return Qt.darker(addButton.backgroundColor)
              } else if (addButtonMouseArea.containsMouse) {
                  return Qt.lighter(addButton.backgroundColor)
              } else {
                  return addButton.backgroundColor
              }

        Image {
            anchors.fill: parent
            anchors.margins: 8
            source: "qrc:/assets/icons/plus.png"
        }

        MouseArea {
            id: addButtonMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: addButton.add()
        }

        function add() {
            form.isVisible = true
        }
    }

    Rectangle {
        id: form
        visible: isVisible

        property bool isVisible: false
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

        color: root.background.color
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
                    implicitWidth: form.width * 0.25
                    radius: 8
                    color: form.fieldColor
                }
            }

            TextField {
                id: priceField

                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.margins: 10

                validator: IntValidator {}
                placeholderText: "Price"
                verticalAlignment: TextInput.AlignVCenter
                font.pixelSize: 15

                background: Rectangle {
                    implicitHeight: 32
                    implicitWidth: form.width * 0.25
                    radius: 8
                    color: form.fieldColor
                }
            }

            TextField {
                id: categoryField

                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.margins: 10

                placeholderText: "Category"
                verticalAlignment: TextInput.AlignVCenter
                font.pixelSize: 15

                background: Rectangle {
                    implicitHeight: 32
                    implicitWidth: form.width * 0.25
                    radius: 8
                    color: form.fieldColor
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
                           return Qt.darker(form.buttonColor)
                       } else if (cancelButtonMouseArea.containsMouse) {
                           return Qt.lighter(form.buttonColor)
                       } else {
                           return form.buttonColor
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
                    onClicked: form.cancel()
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
                           return Qt.darker(form.buttonColor)
                       } else if (confirmButtonMouseArea.containsMouse) {
                           return Qt.lighter(form.buttonColor)
                       } else {
                           return form.buttonColor
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
                    onClicked: form.confirm(OwnGoods)
                }
            }
        }

        function cancel() {
            console.log("Pressed {CancelButton}  by user" + User.name)
            form.isVisible = false
            subjectField.clear()
            priceField.clear()
        }

        function confirm() {
            console.log("Pressed {ConfirmButton} by user " + User.name)
            if(subjectField.acceptableInput && priceField.acceptableInput) {
                OwnGoods.addBid(
                    User.id,
                    subjectField.text,
                    User.name,
                    priceField.text,
                    User.name,
                    categoryField.text
                )
                form.isVisible = false
                subjectField.clear()
                priceField.clear()
            }  
        }
    }
}

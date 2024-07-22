import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import com.User
import com.model.WatchList

Page {
    id: root
    title: "Watchlist"

    background: Rectangle {
        color: root.parent.background.color
    }

    Rectangle {
        height: 20
        width: 30
        color: "green"

        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
    }

    ListView {
        id: watchListView
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
        model: WatchList


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

            color: watchListView.elementColor
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
                        pixelSize: 19
                    }
                }

                RowLayout {
                    spacing: parent.width * 0.34
                    Text {
                        text: "Supplier:" + delegate.supplierName
                        font.pixelSize: 10
                        font.italic: true
                    }
                    Text {
                        text: "Highest Bidder: " + delegate.highestBidderName
                        font.pixelSize: 10
                        font.italic: true
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
                        onClicked: watchListView.remove(delegate.itemIndex)
                    }
                }

                Rectangle {
                    id: bidButton
                    Layout.alignment: Qt.AlignRight
                    Layout.minimumHeight: 40
                    Layout.minimumWidth: 40
                    radius: 10
                    color: if(bidButtonMouseArea.containsPress) {
                               return Qt.darker(buttonGroupBox.bidButtonColor)
                           } else if (bidButtonMouseArea.containsMouse) {
                               return Qt.lighter(buttonGroupBox.bidButtonColor)
                           } else {
                               return buttonGroupBox.bidButtonColor
                           }

                    Image {
                        anchors.margins: 5
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/Bidder/assets/icons/bid.png"
                    }

                    MouseArea {
                        id: bidButtonMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: watchListView.bid(delegate.itemIndex)
                    }
                }
            }
        }
        function remove(itemIndex) {
            console.log("Pressed {Notify Button} by: " + User.name)
            // Same signal used to unsubscribes on server side
            WatchList.subscribe(itemIndex, User.Id)
        }

        function bid(index) {
            console.log("Pressed {Bid Button} by: " + User.name);
            bidForm.isVisible = true
            bidForm.itemIndex = index
        }
    }

    Rectangle {
        id: bidForm
        visible: isVisible

        property int itemIndex
        property bool isVisible: false
        property color backgroundColor: "white"
        property color fieldColor: "lightgray"
        property color buttonColor: "blue"

        width: parent.width * 0.5
        height: 120
        radius: 10

        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
            margins: 20
        }

        color: root.background.color
        border.width: 1

        GridLayout {
            id: bidFormLayout
            anchors.fill: parent

            rows: 2
            columns: 2

            TextField {
                id: bidAmountField
                activeFocusOnPress: true

                Layout.columnSpan: 2
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.margins: 10

                placeholderText: "Bid Ammount"
                validator: DoubleValidator {}
                verticalAlignment: TextInput.AlignVCenter
                font.pixelSize: 15

                background: Rectangle {
                    implicitHeight: 32
                    implicitWidth: bidForm.width * 0.25
                    radius: 8
                    color: bidForm.fieldColor
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
                           return Qt.darker(bidForm.buttonColor)
                       } else if (cancelButtonMouseArea.containsMouse) {
                           return Qt.lighter(bidForm.buttonColor)
                       } else {
                           return bidForm.buttonColor
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
                    onClicked: bidForm.cancel()
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
                           return Qt.darker(bidForm.buttonColor)
                       } else if (confirmButtonMouseArea.containsMouse) {
                           return Qt.lighter(bidForm.buttonColor)
                       } else {
                           return bidForm.buttonColor
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
                    onClicked: bidForm.confirm()
                }
            }
        }

        function cancel(itemIndex) {
            console.log("Pressed {CancelButton}  by user" + User.name)
            bidForm.isVisible = false
            bidAmountField.clear()
        }

        function confirm() {
            console.log("Pressed {ConfirmButton} by user " + User.name)

            WatchList.placeBid(bidForm.itemIndex, bidAmountField.text, User.id, User.name)
            watchListView.modelUpdated()

            bidForm.isVisible = false
            bidAmountField.clear()
        }
    }
}

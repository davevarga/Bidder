import QtQuick
import QtQuick.Controls

Page {
    id: root
    title: "Account"
    background: Rectangle {
        color: root.parent.background.color
    }

    SwipeView {
        id: accountView
        anchors.fill: parent

        background: Rectangle {
            color: applicationWindow.baseColor
        }

        Page {
            id: signInPage
            title: "Sign In"
            background: Rectangle {
                color: parent.background.color
            }

            Rectangle {
                height: 20
                width: 30
                color: "orange"
                radius: 15

                anchors {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Page {
            id: signUpPage
            title: "Sign Up"
            background: Rectangle {
                color: parent.background.color
            }

            Rectangle {
                height: 20
                width: 30
                color: "purple"
                radius: 15

                anchors {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    PageIndicator {
        id: accountSwipePageIndicator
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        currentIndex: accountView.currentIndex
        count: accountView.count
    }

    function swipe(index) {
        accountView.setCurrentIndex(index)
        console.log("Swiped to page:", index)
    }
}



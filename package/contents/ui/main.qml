import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import "utils.js" as Utils

Item {
    // Always display the compact view.
    // Never show the full popup view even if there is space for it.

    property string imageUrl: ""

    property var imageUrls: [] // Array to store the image URLs
    property var imageUrlsDecoded: [] // Array to store the image URLs

    Component.onCompleted: {
        fetchWebContent("https://webview.fate-go.us/");
    }

    function fetchWebContent(url) {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", url); // Replace with your desired URL
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    // Update the image URL with the fetched data
                    var arrayBuffer = xhr.response;
                   /*  console.log(xhr.responseText); */
                    imageUrls = Utils.parseHTML(xhr.responseText, imageUrls)
                    console.log("Image URLs:", imageUrls);
                } else {
                    console.error("Failed to fetch content");
                }
            }
        };
        xhr.responseType = "arraybuffer"; // Set response type to arraybuffer to handle binary data
        xhr.send();
    }


    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    Plasmoid.fullRepresentation: Item {
        Layout.minimumWidth: label.implicitWidth
        Layout.minimumHeight: label.implicitHeight
        Layout.preferredWidth: 850 * PlasmaCore.Units.devicePixelRatio
        Layout.preferredHeight: 380  * PlasmaCore.Units.devicePixelRatio
        
        

        ColumnLayout {
            anchors.fill: parent

            SwipeView {
                id: swipeView
                Layout.fillWidth: true
                Layout.fillHeight: true

                Repeater {
                    model: imageUrls.length

                    Item {
                        Image {
                            source: imageUrls[index]
                            anchors.centerIn: parent
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
            }

            PageIndicator {
                id: pageIndicator
                Layout.fillWidth: true
                count: swipeView.count
                currentIndex: swipeView.currentIndex
                interactive: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        
    }
}
import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

import org.kde.plasma.welcome as Welcome
import org.kde.plasma.welcome.private as Private

Welcome.Page {
    id: root

    heading: i18nc("@title:window", "Enjoy the dancing h thats below")
    description: xi18nc("@info:usagetip", "h")

    ColumnLayout {
        anchors.fill: parent

        spacing: root.padding

        Image {
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumWidth: Kirigami.Units.gridUnit * 25

            fillMode: Image.PreserveAspectFit
            mipmap: true
            source: "/usr/weenos/h.gif"
        }
    }
}

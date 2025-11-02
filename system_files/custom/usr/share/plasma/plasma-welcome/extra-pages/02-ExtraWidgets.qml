import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

import org.kde.plasma.welcome as Welcome
import org.kde.plasma.welcome.private as Private

Welcome.Page {
    id: root

    heading: i18nc("@title:window", "Extra Widgets")
    description: xi18nc("@info:usagetip", "unlike base kinoite, weenOS comes with a google balls widget, weenie widget, dancing h widget, and, of course, the bouncy ball widget! oh yeah, maxwell the cat is here too!\nyou can see em all in action below")

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
            source: "/usr/weenos/welcomecenter/widgets.png"
        }
    }
}

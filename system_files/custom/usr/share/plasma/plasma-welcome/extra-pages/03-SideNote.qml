import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

import org.kde.plasma.welcome as Welcome
import org.kde.plasma.welcome.private as Private

Welcome.Page {
    id: root

    heading: i18nc("@title:window", "Side Note")
    description: xi18nc("@info:usagetip", "this os isnt really made to be taken seriously lol.\n\ncreated by weenie mount in 2025. the last page is the KDE 'Enjoy It!' page. enjoy weenOS!")
}

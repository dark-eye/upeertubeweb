import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import QtQuick.LocalStorage 2.0

ListItem {
    id: task

    property var titleText: ""
	property var domain:""
    property var subtitleText : ""
    property var summaryText: ""
    property var iconSource: "../../assets/diaspora-asterisk.png"
	property var status: 0
	property var rating: 0

    height: layout.height

    onClicked: {
        settings.instance = domain
        mainStack.push (Qt.resolvedUrl("../pages/MainWebview.qml"))
    }

    ListItemLayout {
        id: layout
        title.text: titleText
        subtitle.text: subtitleText
        summary.text: summaryText
        Image {
            id: icon
            source: iconSource
            width: units.gu(4)
            height: units.gu(4)
            SlotsLayout.position: SlotsLayout.Leading;
            anchors.verticalCenter: parent.verticalCenter
            visible: false
            onStatusChanged: if (status == Image.Ready) visible = true
        }
        Icon {
			name: status == 0 ? "flash-off" : "flash-on"
			SlotsLayout.position: SlotsLayout.Last;
			width: units.gu(2)
		}
		Row {
			width:units.gu(10)
			SlotsLayout.position: SlotsLayout.Trailing;
// 			SlotsLayout.padding.top:units.gu(4)
			
			layoutDirection:Qt.RightToLeft
			spacing: units.gu(0.25)
			
			Repeater {
				model: parseInt(rating / 20)
				delegate: starIcon
			}
		}
    }
    Component {
		id:starIcon
		Icon {
			width:units.gu(2)
			height:width
			name:"starred"
		}
	}
}

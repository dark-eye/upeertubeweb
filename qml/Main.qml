import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Qt.labs.settings 1.0
import Ubuntu.Web 0.2

import "components"
import "pages"

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'upeertubeweb.darkeye'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

    readonly property var version: "0.1.0"

    property var token: ""

    // automatically anchor items to keyboard that are anchored to the bottom
    anchorToKeyboard: true

    PageStack {
        id: mainStack
    }

    Settings {
        id: settings
        property var instance
        property bool openLinksExternally: false
        property bool incognitoMode: false
        property bool hideBottomControls: false
    }
    
    QtObject {
		id:appConfig
		property var loginPath : "/login"
		property var instancesAPIPath : "https://instances.joinpeertube.org/api/v1/instances"
		property list<Action> mainActions : [
				Action {
					text:i18n.tr("OverView")
					iconSource:"../assets/PeerTube.png"
					onTriggered:{ webviewPage.currentView().goHome() }
				}
			]
	}
	
    
    WebContext {
		id:appWebContext
	}
	
	WebContext {
		id:incognitoWebContext
	}
    
    QtObject {
		id:helperFunctions
		
		function getInstanceURL() {
			return settings.instance.indexOf("http") != -1 ? settings.instance : "https://" + settings.instance
		}
	}

    Component.onCompleted: {
        if ( settings.instance ) {
            mainStack.push(Qt.resolvedUrl("./pages/MainWebview.qml"))
        }
        else {
            mainStack.push(Qt.resolvedUrl("./pages/InstancePicker.qml"))
        }
    }
}

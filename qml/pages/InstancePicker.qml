import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3

Page {
    id: instancePickerPage
    anchors.fill: parent
    
    property bool searchRunning:false
    property var lastList: []
    property var updateTime: null

    Component.onCompleted: getSample ()
	
	WorkerScript {
		id:asyncProcess
		source:'../components/jslibs/FilterInstances.js'
		onMessage:instanceList.writeInList (  messageObject.reply );
	}

    function getSample () {
		if(searchRunning) { return; }
		searchRunning = true;
		var data = 'start=0&count=500';
        var http = new XMLHttpRequest();
        http.open("GET", "https://instances.joinpeertube.org/api/v1/instances?" , true);
        http.setRequestHeader('Content-type', 'application/json; charset=utf-8')
        http.onreadystatechange = function() {
			searchRunning = false;
            if (http.readyState === XMLHttpRequest.DONE) {
                var response = JSON.parse(http.responseText);
				var pods = response.data;
				lastList = pods;
				updateTime = Date.now();
				asyncProcess.sendMessage( {searchTerm : customInstanceInput.displayText , inData : pods });
            }
        }
        loading.running = true;
        http.send();
    }


    function search ()  {

		var searchTerm = customInstanceInput.displayText;
		//If  the  search starts with http(s) then go to the url 
		if(searchTerm.indexOf("http") == 0 ) {
			settings.instance = searchTerm
			mainStack.push (Qt.resolvedUrl("./MainWebview.qml"))
			return
		}
	
		if(updateTime < Date.now()-60000) {
			loading.visible = true
			instanceList.children = ""
			getSample();
		} else {
			asyncProcess.sendMessage( {searchTerm : searchTerm , inData : lastList });
		}
    }



    header: PageHeader {
        id: header
        title: i18n.tr('Choose a Diaspora instance')
        StyleHints {
            foregroundColor: theme.palette.normal.backgroundText
            backgroundColor: theme.palette.normal.background
        }
        trailingActionBar {
            actions: [
            Action {
                text: i18n.tr("Info")
                iconName: "info"
                onTriggered: {
                    mainStack.push(Qt.resolvedUrl("./Information.qml"))
                }
            },
            Action {
                iconName: "search"
                onTriggered: {
                    if ( customInstanceInput.displayText == "" ) {
                        customInstanceInput.focus = true
                    } else search ()
                }
            }
            ]
        }
    }

    ActivityIndicator {
        id: loading
        visible: true
        running: true
        anchors.centerIn: parent
    }


    TextField {
        id: customInstanceInput
        anchors.top: header.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: height
        width: parent.width - height
        placeholderText: i18n.tr("Search or enter a custom address")
		onDisplayTextChanged: if(displayText.length > 2) {search();}
        Keys.onReturnPressed: search ()
    }
    
    ScrollView {
        id: scrollView
        width: parent.width
        height: parent.height - header.height - 3*customInstanceInput.height
        anchors.top: customInstanceInput.bottom
        anchors.topMargin: customInstanceInput.height
        contentItem: Column {
            id: instanceList
            width: root.width


            // Write a list of instances to the ListView
            function writeInList ( list ) {
                instanceList.children = ""
                loading.visible = false
                list.sort(function(a,b) {return !a.health ? (!b.health ? 0 : 1) : (!b.health ? -1 : parseFloat(b.health) - parseFloat(a.health));});
                for ( var i = 0; i < list.length; i++ ) {
                    var item = Qt.createComponent("../components/InstanceItem.qml")
                    item.createObject(this, {
                        "titleText": list[i].name,
						"domain":list[i].host,
                        "subtitleText": list[i].host != null ? list[i].host : "",
                        "summaryText": list[i].totalVideos != null ? list[i].totalVideos : "",
                        "iconSource":  list[i].thumbnail != null ? list[i].thumbnail : "../../assets/PeerTube.png",
						"status":  list[i].signupAllowed != null ? list[i].signupAllowed : 0,
						"rating":  list[i].health != null ? list[i].health : 0
                    })
                }
            }
        }
    }
    
    Label {
		id:noResultsLabel
		visible: !instanceList.children.length && !loading.visible
		anchors.centerIn: scrollView;
		text:customInstanceInput.length ? i18n.tr("No pods fund for search : %1").arg(customInstanceInput.displayText) :  i18n.tr("No pods returned from server");
	}

}

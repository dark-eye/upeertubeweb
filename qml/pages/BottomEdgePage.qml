/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright 2018  eran <email>
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import Ubuntu.Components 1.3

import "../components"

Page {
	id:_bottomEdgePage
	property var filePickerComponent: null 
	
	header: BottomEdgeControlsHeader {
		extension: Sections {
					id:_headerSections
					selectedIndex: 0
					anchors {
						left: parent.left
						leftMargin: units.gu(2)
						bottom: parent.bottom
					}
					model: [ i18n.tr("My Subscription"),  i18n.tr("My Videos") ]
		}
		z:10
	}
	

	BottomEdgeSection {
		anchors.topMargin : header.height
		visible:_headerSections.selectedIndex == 0
		filePickerComponent:_bottomEdgePage.filePickerComponent
		sectionPath: "/my-account/subscriptions"
	}

	BottomEdgeSection {
		anchors.topMargin : header.height
		visible:_headerSections.selectedIndex == 1
		filePickerComponent:_bottomEdgePage.filePickerComponent
		sectionPath: "/my-account/videos"
	}
	
	// 	BottomEdgeSection {
// 		anchors.topMargin : header.height
// 		visible:_headerSections.selectedIndex == 2
// 		filePickerComponent:_bottomEdgePage.filePickerComponent
// 		sectionPath: "/my-account/settings"
// 	}

}

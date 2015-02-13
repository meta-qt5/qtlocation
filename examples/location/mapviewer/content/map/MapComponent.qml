/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick 2.4
import QtQuick.Controls 1.3
import QtLocation 5.3
import QtPositioning 5.2

//! [top]
Map {
    id: map
    zoomLevel: (maximumZoomLevel - minimumZoomLevel)/2

    //! [coord]
    center {
        latitude: 59.9485
        longitude: 10.7686
    }
    //! [coord]

    // Enable pinch gestures to zoom in and out
    gesture.flickDeceleration: 3000
    gesture.enabled: true

//! [top]
    property variant markers
    property variant mapItems
    property int markerCounter: 0 // counter for total amount of markers. Resets to 0 when number of markers = 0
    property int currentMarker
    signal showMainMenu(variant coordinate)
    signal showMarkerMenu(variant coordinate)
    signal showRouteMenu(variant coordinate)
    signal showPointMenu(variant coordinate)
    signal showRouteList()

    property int lastX : -1
    property int lastY : -1
    property int pressX : -1
    property int pressY : -1
    property int jitterThreshold : 30
    property bool followme: false
    property variant scaleLengths: [5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000, 200000, 500000, 1000000, 2000000]
    signal requestLocale()

    /* @todo
    Binding {
        target: map
        property: 'center'
        value: positionSource.position.coordinate
        when: followme
    }*/

    onCopyrightLinkActivated: Qt.openUrlExternally(link)

    PositionSource{
        id: positionSource
        active: followme

        onPositionChanged: {
            map.center = positionSource.position.coordinate
        }
    }

    MapQuickItem {
        id: poiTheQtComapny
        sourceItem: Rectangle { width: 14; height: 14; color: "#1c94fc"; border.width: 2; border.color: "#242424"; smooth: true; radius: 7 }
        coordinate {
           latitude: 59.9485
           longitude: 10.7686
        }
        opacity:0.7
        anchorPoint.x: sourceItem.width/2
        anchorPoint.y: sourceItem.height/2
    }

    MapQuickItem {
        sourceItem: Text{
            text: "The Qt Company"
            color:"#242424"
            font.bold: true
            styleColor: "#ECECEC"
            style: Text.Outline
        }
        coordinate: poiTheQtComapny.coordinate
        anchorPoint.x: -poiTheQtComapny.sourceItem.width * 0.5
        anchorPoint.y: poiTheQtComapny.sourceItem.height * 1.5
    }


    Slider {
        id: zoomSlider;
        z: map.z + 3
        minimumValue: map.minimumZoomLevel;
        maximumValue: map.maximumZoomLevel;
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottomMargin: 15
        anchors.rightMargin: 10
        anchors.leftMargin: 90
        value: map.zoomLevel
        onValueChanged: {
            map.zoomLevel = value
            map.state=""
        }
    }

//! [routemodel0]
    property RouteQuery routeQuery: RouteQuery {}

    property RouteModel routeModel: RouteModel {
        plugin : map.plugin
        query: routeQuery
//! [routemodel0]

//! [routemodel1]
        onStatusChanged: {
            if (status == RouteModel.Ready) {
                switch (count) {
                case 0:
                     // technically not an error
                    map.routeError()
                    break
                case 1:
                    showRouteList()
                    break
                }
            } else if (status == RouteModel.Error) {
                map.routeError()
            }
        }
//! [routemodel1]

//! [routemodel2]

//! [routemodel2]
//! [routemodel3]
    }
//! [routemodel3]

//! [geocodemodel0]
    property GeocodeModel geocodeModel: GeocodeModel {
//! [geocodemodel0]
//! [geocodemodel0 body]
        plugin: map.plugin
        onStatusChanged: {
            if ((status == GeocodeModel.Ready) || (status == GeocodeModel.Error))
                map.geocodeFinished()
        }
        onLocationsChanged:
        {
            if (count == 1) {
                map.center.latitude = get(0).coordinate.latitude
                map.center.longitude = get(0).coordinate.longitude
            }
        }
//! [geocodemodel0 body]
//! [geocodemodel1]
    }
//! [geocodemodel1]

    signal showGeocodeInfo()

    signal geocodeFinished()
    signal routeError()
    signal coordinatesCaptured(double latitude, double longitude)

    Component.onCompleted: {
        markers = new Array();
        mapItems = new Array();
    }

//! [routedelegate0]
    Component {
        id: routeDelegate

        MapRoute {
            id: route
            route: routeData
            line.color: routeMouseArea.containsMouse ? "lime" : "red"
            line.width: 5
            smooth: true
            opacity: 0.8
//! [routedelegate0]
            MouseArea {
                id: routeMouseArea
                anchors.fill: parent
                hoverEnabled: false
                property variant lastCoordinate

                onPressed : {
                    map.lastX = mouse.x + parent.x
                    map.lastY = mouse.y + parent.y
                    map.pressX = mouse.x + parent.x
                    map.pressY = mouse.y + parent.y
                    lastCoordinate = map.toCoordinate(Qt.point(mouse.x, mouse.y))
                }

                onPositionChanged: {
                    if (Math.abs(map.pressX - parent.x- mouse.x ) > map.jitterThreshold ||
                        Math.abs(map.pressY - parent.y -mouse.y ) > map.jitterThreshold) {
                        map.state = ""
                    }
                    if ((mouse.button == Qt.LeftButton) & (map.state == "")) {
                        map.lastX = mouse.x + parent.x
                        map.lastY = mouse.y + parent.y
                    }
                }

                onPressAndHold:{
                    if (Math.abs(map.pressX - parent.x- mouse.x ) < map.jitterThreshold
                            && Math.abs(map.pressY - parent.y - mouse.y ) < map.jitterThreshold) {
                         showRouteMenu(lastCoordinate);
                    }
                }
            }
        }
//! [routedelegate1]
    }
//! [routedelegate1]

//! [pointdel0]
    Component {
        id: pointDelegate

        MapCircle {
            id: point
            radius: 1000
            color: circleMouseArea.containsMouse ? "lime" : "red"
            opacity: 0.6
            center: locationData.coordinate
//! [pointdel0]
            MouseArea {
                anchors.fill:parent
                id: circleMouseArea
                hoverEnabled: false
                property variant lastCoordinate

                onPressed : {
                    map.lastX = mouse.x + parent.x
                    map.lastY = mouse.y + parent.y
                    map.pressX = mouse.x + parent.x
                    map.pressY = mouse.y + parent.y
                    lastCoordinate = map.toCoordinate(Qt.point(mouse.x, mouse.y))
                }

                onPositionChanged: {
                    if (Math.abs(map.pressX - parent.x- mouse.x ) > map.jitterThreshold ||
                        Math.abs(map.pressY - parent.y -mouse.y ) > map.jitterThreshold) {
                        map.state = ""
                        if (pressed) parent.radius = parent.center.distanceTo(
                                         map.toCoordinate(Qt.point(mouse.x, mouse.y)))
                    }
                    if ((mouse.button == Qt.LeftButton) & (map.state == "")) {
                        map.lastX = mouse.x + parent.x
                        map.lastY = mouse.y + parent.y
                    }
                }

                onPressAndHold:{
                    if (Math.abs(map.pressX - parent.x- mouse.x ) < map.jitterThreshold
                            && Math.abs(map.pressY - parent.y - mouse.y ) < map.jitterThreshold) {
                        showPointMenu(lastCoordinate);
                    }
                }
            }
//! [pointdel1]
        }
    }
//! [pointdel1]

//! [routeview]
    MapItemView {
        model: routeModel
        delegate: routeDelegate
        autoFitViewport: true
    }
//! [routeview]

//! [geocodeview]
    MapItemView {
        model: geocodeModel
        delegate: pointDelegate
    }
//! [geocodeview]

    Item {//scale
        id: scale
        parent: zoomSlider.parent
        visible: scaleText.text != "0 m"
        z: map.z + 2
        opacity: 0.6
        anchors {
            bottom: zoomSlider.top;
            bottomMargin: 8;
            left: zoomSlider.left
        }
        Image {
            id: scaleImageLeft
            source: "../../resources/scale_end.png"
            anchors.bottom: parent.bottom
            anchors.left: parent.left
        }
        Image {
            id: scaleImage
            source: "../../resources/scale.png"
            anchors.bottom: parent.bottom
            anchors.left: scaleImageLeft.right
        }
        Image {
            id: scaleImageRight
            source: "../../resources/scale_end.png"
            anchors.bottom: parent.bottom
            anchors.left: scaleImage.right
        }
        Text {
            id: scaleText
            color: "#004EAE"
            horizontalAlignment: Text.AlignHCenter
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.bottomMargin: 3
            text: "0 m"
            font.pixelSize: 14
        }
        Component.onCompleted: {
            map.calculateScale();
        }
    }

    Timer {
        id: scaleTimer
        interval: 100
        running: false
        repeat: false
        onTriggered: {
            map.calculateScale()
        }
    }

    onCenterChanged:{
        scaleTimer.restart()
        if (map.followme)
            if (map.center != positionSource.position.coordinate) map.followme = false
    }

    onZoomLevelChanged:{
        scaleTimer.restart()
        if (map.followme) map.center = positionSource.position.coordinate
    }

    onWidthChanged:{
        scaleTimer.restart()
    }

    onHeightChanged:{
        scaleTimer.restart()
    }

    Rectangle {
        id: infoLabel
        width: backgroundRect.width + 10
        height: infoText.height + 5
        y: 440
        anchors.left: map.left
        z: map.z + 1
        color: "dimgrey"
        opacity: (infoText.text !="") ? 0.8 : 0

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
        Text {
            id: infoText
            width: parent.width
            elide: Text.ElideLeft
            maximumLineCount: 4
            wrapMode: Text.Wrap
            font.bold: true
            font.pixelSize: 14
            style: Text.Raised;
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            color: "white"
        }
    }

    MouseArea {
        id: mouseArea
        property variant lastCoordinate
        anchors.fill: parent

        onPressed : {
            map.lastX = mouse.x
            map.lastY = mouse.y
            map.pressX = mouse.x
            map.pressY = mouse.y
            lastCoordinate = map.toCoordinate(Qt.point(mouse.x, mouse.y))
            //            if (mouse.button == Qt.MiddleButton)
            //                addMarker()
        }

        onPositionChanged: {
            if (map.state != "PopupMenu" ||
                Math.abs(map.pressX - mouse.x ) > map.jitterThreshold ||
                Math.abs(map.pressY - mouse.y ) > map.jitterThreshold) {
                map.state = ""
            }
            if ((mouse.button == Qt.LeftButton) & (map.state == "")) {
                //                if ((map.lastX != -1) && (map.lastY != -1)) {
                //                    var dx = mouse.x - map.lastX
                //                    var dy = mouse.y - map.lastY
                //                    map.pan(-dx, -dy)
                //                }
                map.lastX = mouse.x
                map.lastY = mouse.y
            }
        }

        onDoubleClicked: {
            map.center = map.toCoordinate(Qt.point(mouse.x, mouse.y))
            if (mouse.button == Qt.LeftButton){
                map.zoomLevel += 1
            } else if (mouse.button == Qt.RightButton) map.zoomLevel -= 1
            lastX = -1
            lastY = -1
        }

        onPressAndHold:{
            if (Math.abs(map.pressX - mouse.x ) < map.jitterThreshold
                    && Math.abs(map.pressY - mouse.y ) < map.jitterThreshold) {
                showMainMenu(lastCoordinate);
            }
          }
        }


    Keys.onPressed: {
        if ((event.key == Qt.Key_Plus) || (event.key == Qt.Key_VolumeUp)) {
            map.zoomLevel += 1
        } else if ((event.key == Qt.Key_Minus) || (event.key == Qt.Key_VolumeDown)){
            map.zoomLevel -= 1
        }
    }

    function calculateScale(){
        var coord1, coord2, dist, text, f
        f = 0
        coord1 = map.toCoordinate(Qt.point(0,scale.y))
        coord2 = map.toCoordinate(Qt.point(0+scaleImage.sourceSize.width,scale.y))
        dist = Math.round(coord1.distanceTo(coord2))

        if (dist === 0) {
            // not visible
        } else {
            for (var i = 0; i < scaleLengths.length-1; i++) {
                if (dist < (scaleLengths[i] + scaleLengths[i+1]) / 2 ) {
                    f = scaleLengths[i] / dist
                    dist = scaleLengths[i]
                    break;
                }
            }
            if (f === 0) {
                f = dist / scaleLengths[i]
                dist = scaleLengths[i]
            }
        }

        text = formatDistance(dist)
        scaleImage.width = (scaleImage.sourceSize.width * f) - 2 * scaleImageLeft.sourceSize.width
        scaleText.text = text
    }


    function deleteMarkers(){
        var count = map.markers.length
        for (var i = 0; i<count; i++){
            map.removeMapItem(map.markers[i])
            map.markers[i].destroy()
        }
        map.markers = []
        markerCounter = 0
    }

    function deleteMapItems(){
        var count = map.mapItems.length
        for (var i = 0; i<count; i++){
            map.removeMapItem(map.mapItems[i])
            map.mapItems[i].destroy()
        }
        map.mapItems = []
    }

    function addMarker(){
        var count = map.markers.length
        markerCounter++
        var marker = Qt.createQmlObject ('Marker {}', map)
        map.addMapItem(marker)
        marker.z = map.z+1
        marker.coordinate = mouseArea.lastCoordinate

        //update list of markers
        var myArray = new Array()
        for (var i = 0; i<count; i++){
            myArray.push(markers[i])
        }
        myArray.push(marker)
        markers = myArray
    }

    function addGeoItem(item){
        var count = map.mapItems.length
        var co = Qt.createComponent(item+'.qml')
        if (co.status == Component.Ready) {
            var o = co.createObject(map)
            o.setGeometry(map.markers, currentMarker)
            map.addMapItem(o)
            //update list of items
            var myArray = new Array()
            for (var i = 0; i<count; i++){
                myArray.push(mapItems[i])
            }
            myArray.push(o)
            mapItems = myArray

        } else {
            console.log(item + " is not supported right now, please call us later.")
        }
    }

    function deleteMarker(index){
        //update list of markers
        var myArray = new Array()
        var count = map.markers.length
        for (var i = 0; i<count; i++){
            if (index != i) myArray.push(map.markers[i])
        }

        map.removeMapItem(map.markers[index])
        map.markers[index].destroy()
        map.markers = myArray
        if (markers.length == 0) markerCounter = 0
    }

    function calculateRoute(){
        routeQuery.clearWaypoints();
        for (var i = currentMarker; i< map.markers.length; i++){
            routeQuery.addWaypoint(markers[i].coordinate)
        }
        routeQuery.travelModes = RouteQuery.CarTravel
        routeQuery.routeOptimizations = RouteQuery.ShortestRoute
        routeQuery.setFeatureWeight(0, 0)
        routeModel.update();
    }

    function roundNumber(number, digits) {
        var multiple = Math.pow(10, digits);
        return Math.round(number * multiple) / multiple;
    }

    function formatTime(sec){
        var value = sec
        var seconds = value % 60
        value /= 60
        value = (value > 1) ? Math.round(value) : 0
        var minutes = value % 60
        value /= 60
        value = (value > 1) ? Math.round(value) : 0
        var hours = value
        if (hours > 0) value = hours + "h:"+ minutes + "m"
        else value = minutes + "min"
        return value
    }

    function formatDistance(meters)
    {
        var dist = Math.round(meters)
        if (dist > 1000 ){
            if (dist > 100000){
                dist = Math.round(dist / 1000)
            }
            else{
                dist = Math.round(dist / 100)
                dist = dist / 10
            }
            dist = dist + " km"
        }
        else{
            dist = dist + " m"
        }
        return dist
    }

//! [end]
}
//! [end]

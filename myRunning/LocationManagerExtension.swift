//
//  LocationManagerExtension.swift
//  myRunning
//
//  Created by stephane joussin on 23/07/2016.
//  Copyright © 2016 stephane joussin. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: CLLocationManagerDelegate {
    
    func initLocationManager() {
        self.locationManager = CLLocationManager()
        locationManager!.requestAlwaysAuthorization()
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        locationManager!.delegate = self
    }
    
    func userLocationChanged () {
        centerMapWithUser()
    }
    
    func centerMapWithUser() {
        if !userLocationIsSet {
            userLocationIsSet = true
            let span = MKCoordinateSpanMake(0.005, 0.005)
            let region = MKCoordinateRegionMake(userCurrentLocation!.coordinate, span)
            mapView.setRegion(region, animated: false)
        } else {
            if followStatus == .Follow {
                mapView.setCenterCoordinate(userCurrentLocation!.coordinate, animated: true)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        userCurrentLocation = locations[0] as CLLocation
        userLocations.append(locations[0] as CLLocation)
        
        if sessionStatus == .Start  {
            
            if (userLocations.count > 1){
                
                sessions.last!.location.append(userCurrentLocation)
                sessions.last!.date.append(NSDate())
                
                let sourceIndex = userLocations.count - 1
                let destinationIndex = userLocations.count - 2
                
                let c1 = userLocations[sourceIndex].coordinate
                let c2 = userLocations[destinationIndex].coordinate
                
                var a : [CLLocationCoordinate2D] = [c1, c2]
                
                let polyline = CustomOverlay(coordinates: &a, count: a.count)
                polyline.color = UIColor.redColor()
                polyline.type = .Way
                
                if sessions.last!.location.count > 1 {
                    var d = sessions.last!.location.first!.distanceFromLocation(sessions.last!.location.last!)
                    
                    if d > Double(( sessions.last!.section + 1) * 100) {
                        let text = String(( sessions.last!.section + 1) * 100 ) + "m"
                        addAnnotation(userCurrentLocation, type: .Segment, text:  text)
                        sessions.last!.section += 1
                    }
                }
                mapView.addOverlay(polyline)
            }
        }
    }
    
    
}

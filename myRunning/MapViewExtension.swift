//
//  MapViewExtension.swift
//  myRunning
//
//  Created by stephane joussin on 23/07/2016.
//  Copyright © 2016 stephane joussin. All rights reserved.
//

import Foundation
import MapKit


extension MapViewController: MKMapViewDelegate {
    
    
    func addAnnotation(location : CLLocation, type: AnnotationType, text : String?){
        var pin : CustomAnnotation
        
        if type == .Start {
            let temps = sessions.last!.date.first!.toString()
            pin = CustomAnnotation(coordinate: location.coordinate, type: .Start, text: nil)
            pin.title = "start"
            pin.subtitle = "\(temps)"
            self.mapView.addAnnotation(pin)
        }
        
        if type == .Stop {
            
            let distance = ceil(sessions.last!.location.first!.distanceFromLocation(sessions.last!.location.last!) * 100 )/100
            let temps =  sessions.last!.date.last!.offsetFrom(sessions.last!.date.first!)
            
            pin = CustomAnnotation(coordinate: location.coordinate, type: .Stop, text: nil)
            pin.title = "stop"
            pin.subtitle = "\(temps) / \(distance)m"
            self.mapView.addAnnotation(pin)
        }
        
        if type == .Segment {
            pin = CustomAnnotation(coordinate: location.coordinate, type: .Segment, text: text)
            self.mapView.addAnnotation(pin)
        }
    }
    

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let pin = annotation as! CustomAnnotation
        
        let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pinView.canShowCallout = true
        
        if pin.type == .Start {
            pinView.image = UIImage(named:"flag-start")!
            pinView.centerOffset = CGPointMake(12, -32 / 2)
        }
        else if pin.type == .Stop {
            pinView.image = UIImage(named:"flag-finish")!
            pinView.centerOffset = CGPointMake(12, -32 / 2)
        } else if pin.type == .Segment {
            let label = UILabel(frame: CGRect(x: 5, y: -20, width: 40, height: 20))
            label.backgroundColor = UIColor.whiteColor()
            label.font = UIFont(name: "Arial-BoldMT", size: 11)
            label.textAlignment = .Center
            label.text =  ( pin.text != nil ) ?  pin.text!   : ""
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 5.0
            pinView.addSubview(label)
            pinView.image = UIImage(named:"flag-segment")!
            pinView.centerOffset = CGPointMake(6, -16 / 2)
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let overlay  = overlay as! CustomOverlay
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = overlay.color
        polylineRenderer.lineWidth = 2
        return polylineRenderer
    }
    

}
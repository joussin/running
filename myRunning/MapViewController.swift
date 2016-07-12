//
//  ViewController.swift
//  myRunning
//
//  Created by stephane joussin on 12/07/2016.
//  Copyright © 2016 stephane joussin. All rights reserved.
//

import UIKit
import MapKit

enum RunningStatus {
    case Stop, Start
}

enum FollowStatus {
    case Follow, Unfollow
}


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var runningStatus : RunningStatus  =  .Stop
    var followStatus : FollowStatus  =  .Follow
    
    var userLocationIsSet = false
    var locationManager: CLLocationManager!
    
    var userCurrentLocation:CLLocation! {
        didSet {
            userLocationChanged ()
        }
    }
    var userLocations: [CLLocation] = []
    var startLocation : CLLocation!
    var stopLocation : CLLocation!
    var startDate : NSDate!
    var stopDate : NSDate!
    
    @IBOutlet var followButton : UIButton!
    @IBOutlet var startButton : UIButton!
    @IBOutlet var stopButton : UIButton!
    @IBOutlet var mapView : MKMapView!
    
    @IBAction func followButtonPressed () {
        switch followStatus {
        case .Follow:
            followStatus = .Unfollow
            followButton.setTitle("Follow", forState: .Normal)
        case .Unfollow:
            followStatus = .Follow
            followButton.setTitle("Unfollow", forState: .Normal)
        }
    }
    
    @IBAction func startButtonPressed () {
       runningStatus = .Start
        startLocation = userCurrentLocation
        startDate = NSDate()
        addAnnotation(startLocation, type: .Start)
    }
  
    @IBAction func stopButtonPressed () {
        let alertController = UIAlertController(title: "Session", message: "Do you want to stop this session ?", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { Element in
            self.runningStatus  = .Stop
            let overlays = self.mapView.overlays
           // self.mapView.removeOverlays(overlays)
            self.stopLocation = self.userCurrentLocation
            self.stopDate = NSDate()
            self.addAnnotation(self.stopLocation, type: .Stop )
            
        })
        alertController.addAction(defaultAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        initLocationManager()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addAnnotation(location : CLLocation, type: RunningStatus){
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        pin.title = ( type == .Start ) ? "start" : "stop"
        pin.subtitle = ( type == .Start ) ? startDate.toString() :  stopDate.offsetFrom(startDate)
        self.mapView.addAnnotation(pin)

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
    
    func initLocationManager() {
        self.locationManager = CLLocationManager()
        locationManager!.requestWhenInUseAuthorization()
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.distanceFilter = 0.1
        locationManager!.delegate = self
        locationManager!.startUpdatingLocation()
    }
    
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation){
       // userCurrentLocation = userLocation.location!
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userCurrentLocation = locations[0] as CLLocation
        
       userLocations.append(locations[0] as CLLocation)
        
        if runningStatus == .Start  {
            
            if (userLocations.count > 1){
                let sourceIndex = userLocations.count - 1
                let destinationIndex = userLocations.count - 2
                
                let c1 = userLocations[sourceIndex].coordinate
                let c2 = userLocations[destinationIndex].coordinate
                
                var a : [CLLocationCoordinate2D] = [c1, c2]

                let polyline = MKPolyline(coordinates: &a, count: a.count)
                mapView.addOverlay(polyline)
            }
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.redColor()
        polylineRenderer.lineWidth = 2
        return polylineRenderer
        
    }
    
    
    
}






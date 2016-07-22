//
//  ViewController.swift
//  myRunning
//
//  Created by stephane joussin on 12/07/2016.
//  Copyright © 2016 stephane joussin. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, TimelineDelegate {
    
    var sessionStatus : SessionStatus  =  .Stop
    var followStatus : FollowStatus  =  .Follow
    
    var locationManager: CLLocationManager!
    var userLocationIsSet = false
    var userLocations: [CLLocation] = []
    var userCurrentLocation:CLLocation! {
        didSet {
            userLocationChanged ()
        }
    }

    var sessions = [Session]()
    var timer : Timeline!
    
    @IBOutlet var chronoLabel: UILabel!
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
        timer.start()
        sessionStatus = .Start
        sessions.append(Session())
        sessions.last!.location.append(self.userCurrentLocation)
        sessions.last!.date.append(NSDate())
        addAnnotation(sessions.last!.location.first!, type: .Start, text: nil)
    }
    
    @IBAction func stopButtonPressed () {
        
        let alertController = UIAlertController(title: "Session", message: "Do you want to stop this session ?", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { Element in
            self.timer.stop()
            self.sessionStatus  = .Stop
            self.sessions.last!.location.append(self.userCurrentLocation)
            self.sessions.last!.date.append(NSDate())
            self.addAnnotation(self.sessions.last!.location.last!, type: .Stop, text: nil )
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
        
        timer = Timeline(step: 0.1)
        timer.delegate = self
        
    }
    
    func update() {
        
        let time = NSDate().offsetFrom(sessions.last!.date.first!)
        print(time)
        
        chronoLabel.text =  time
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    
    
    
}






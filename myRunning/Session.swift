//
//  Session.swift
//  myRunning
//
//  Created by stephane joussin on 21/07/2016.
//  Copyright © 2016 stephane joussin. All rights reserved.
//

import Foundation
import CoreLocation

class Session {
    var location = [CLLocation]()
    var date = [NSDate]()
    var section : Int = 0 //chaque session represente 100m
}
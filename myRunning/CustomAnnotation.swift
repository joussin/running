//
//  CustomPin.swift
//  myRunning
//
//  Created by stephane joussin on 21/07/2016.
//  Copyright © 2016 stephane joussin. All rights reserved.
//

import Foundation
import MapKit


enum AnnotationType {
    case Stop, Start, Segment
}


class CustomAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
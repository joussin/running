//
//  CustomPin.swift
//  myRunning
//
//  Created by stephane joussin on 21/07/2016.
//  Copyright © 2016 stephane joussin. All rights reserved.
//

import Foundation
import MapKit




class CustomAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var type : AnnotationType
    var text : String?
    
    init(coordinate: CLLocationCoordinate2D, type: AnnotationType, text : String?) {
        self.coordinate = coordinate
        self.type = type
        if text != nil {
            self.text = text
        }
    }
}
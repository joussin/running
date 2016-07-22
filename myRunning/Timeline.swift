//
//  Chronometre.swift
//  myRunning
//
//  Created by stephane joussin on 22/07/2016.
//  Copyright © 2016 stephane joussin. All rights reserved.
//

import Foundation
import UIKit

protocol TimelineDelegate {
    func update()
}

class Timeline : NSObject {
    
    var delegate : TimelineDelegate?
    var timer : NSTimer!
    var step: Double
    
    init(step: Double) {
        self.step = step
    }
    
    func start() {
       timer = NSTimer.scheduledTimerWithTimeInterval(step, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    
    func stop () {
        timer.invalidate()
    }
    
    func update() {
         delegate?.update()
    }
}
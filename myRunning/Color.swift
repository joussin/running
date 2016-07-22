//
//  Color.swift
//  myRunning
//
//  Created by stephane joussin on 21/07/2016.
//  Copyright © 2016 stephane joussin. All rights reserved.
//

import Foundation
import UIKit


struct Color {
    var colors: [UIColor] = [UIColor.redColor(),UIColor.blackColor(),UIColor.blueColor(),UIColor.brownColor(),UIColor.yellowColor(),UIColor.cyanColor(),UIColor.greenColor()]
    func getRandomColor () -> UIColor {
        let lower : UInt32 = 0
        let upper : UInt32 = UInt32 (colors.count - 1 )
        let randomNumber = Int( arc4random_uniform(upper - lower) + lower )
        return colors[randomNumber]
    }
}

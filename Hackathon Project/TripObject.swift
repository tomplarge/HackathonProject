//
//  TripObject.swift
//  Hackathon Project
//
//  Created by Tom Large on 11/19/16.
//  Copyright © 2016 WildHacks. All rights reserved.
//

import UIKit

class TripObject: NSObject {
    var title : String?
    var startdate:String?
    var enddate:String?
    var caption:String?
    var photos: [UIImage] = []
    var stations: [Station] = []
    var index: Int?
}

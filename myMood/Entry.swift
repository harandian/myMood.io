//
//  Entry.swift
//  myMood
//
//  Created by Martin Tsang on 2017-09-05.
//  Copyright © 2017 Hirad. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Entry:NSObject {
    var ID:String
    var date:Date!
    var descr:String?
    var photo:Photo?
    var mood:Int!
    var location:CLLocation?

    init(date:Date, descr:String, photo:Photo, mood:Int, location:CLLocation) {
        self.ID = ""
        self.date = date
        self.descr = descr
        self.photo = photo
        self.mood = mood
        self.location = location
    }
    
    init(date:Date, descr:String, photo:Photo, mood:Int) {
        self.ID = ""
        self.date = date
        self.descr = descr
        self.photo = photo
        self.mood = mood
    }
}

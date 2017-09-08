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
    var ID:String?
    var date:Date!
    var entryDescription:String?
    var photo:Photo?
    var mood:Int!
    var location:CLLocation?

    init(date:Date, descr:String, photo:Photo, mood:Int, location:CLLocation) {
        self.date = date
        self.entryDescription = descr
        self.photo = photo
        self.mood = mood
        self.location = location
    }
    
    init(date:Date, descr:String, photo:Photo, mood:Int) {
        self.date = date
        self.entryDescription = descr
        self.photo = photo
        self.mood = mood
    }
    
    init(date:Date, mood:Int){
        self.date = date
        self.mood = mood
    }
}

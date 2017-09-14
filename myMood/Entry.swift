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

struct Entry:NSObject {
    var ID:String?
    var date:Double!
    var entryDescription:String?
    var photo:Photo?
    var photoURL:String?
    var mood:Int!
    var location:CLLocation?

    init(date:Double, id: String, mood:Int) {
        self.date = date
        self.ID = id
        self.mood = mood
    }
    
    init(date:Double, mood:Int){
        self.date = date
        self.mood = mood
    }
    
    init(mood:Int){
        self.date = floor(Date().timeIntervalSince1970)
        self.mood = mood
    }
}

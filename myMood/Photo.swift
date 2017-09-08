//
//  Photo.swift
//  myMood
//
//  Created by Elle Ti on 2017-09-05.
//  Copyright © 2017 Hirad. All rights reserved.
//

import Foundation
import UIKit

class Photo: NSObject {
    var photoURL:String?
    var photoObject:UIImage
    
    init(photo: UIImage) {
        self.photoObject = photo
    }

}

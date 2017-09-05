//
//  Photo.swift
//  myMood
//
//  Created by Elle Ti on 2017-09-05.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

class Photo: NSObject {
    let photoOTD: UIImage
    let photoName: String
    
    init(photoOTD: UIImage, photoName: String) {
        self.photoOTD = photoOTD
        self.photoName = photoName
    }

}

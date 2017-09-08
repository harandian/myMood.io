//
//  wordCloudLayoutGenerator.swift
//  myMood
//
//  Created by Hirad on 2017-09-06.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

class wordCloudLayoutGenerator: UIView {
    
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var topRL: UILabel!
    @IBOutlet weak var botLL: UILabel!
    @IBOutlet weak var botROL: UILabel!
    @IBOutlet weak var topLL: UILabel!
    
    
    
    func setupLabel(word:Array<(String,Int)>) {
        let labelArray:Array<UILabel> = [centerLabel,topLL,topRL,botLL,botROL]
        for label in labelArray {
            label.textColor = UIColor.black
        }
        centerLabel.text = word.first?.0.capitalized
        topRL.text = word[1].0
        botLL.text = word[2].0
        botROL.text = word[3].0
        botROL.transform = CGAffineTransform(rotationAngle:CGFloat.pi/2)
        topLL.text = word[4].0
    }
    
    func initalLabelSetup() {
        let labelArray:Array<UILabel> = [centerLabel,topLL,topRL,botLL,botROL]
        for label in labelArray {
            label.text = "myMood"
            label.textColor = UIColor.lightGray
        }
    }
}

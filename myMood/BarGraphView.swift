//
//  BarGraphView.swift
//  myMood
//
//  Created by Elle Ti on 2017-09-11.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

class BarGraphView: UIView {
    
    var graphArray: [(height: CGFloat, color: UIColor)] = [(height: CGFloat, color: UIColor)]()
    
    var centerY: CGFloat = 0.0
    
    var chartWidth: CGFloat = 40
    var chartMargin: CGFloat = 5
    

    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        FirebaseDBController.shared.getAllEntries {entries in
            for bars in entries ["Entries"] as! NSDictionary {
                let tuple = (height: bars.value as! CGFloat, color: UIColor.red)
                self.graphArray.append(tuple)
            }
            self.setNeedsDisplay()
        }
        //self.view.addSubview(lineGraphView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        
        //TODO - range is -10 to 10 = 21 values
        
        for barItems in graphArray {
            addGraph(height: CGFloat(barItems.height), wColor: barItems.color)
        }  
        
    }
    
    func addGraph(height:CGFloat, wColor:UIColor) {
        // Draws next bar
        let nextXOrigin = CGFloat(self.subviews.count - 2) * chartWidth
        
        //Mid point - line in middle
        let heightFrame = self.frame.size.height / 2
        let normalizedHeight: CGFloat = (height / 100 * heightFrame)
        
        let graphButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: chartWidth, height: normalizedHeight))
        graphButton.backgroundColor = wColor
        graphButton.frame.size = CGSize(width: graphButton.frame.size.width - chartMargin, height: graphButton.frame.size.height)
        
        graphButton.setTitle("\(height)", for: UIControlState.normal)
        
        //graphButton.addTarget(self, action: #selector(clickAction(_:)), for: UIControlEvents.touchUpInside)
        
        //graphArray.add(graphButton)
        
        var centY: CGFloat!
        if (wColor == UIColor.green) {
            centY = centerY - (graphButton.frame.size.height/2)
        } else {
            centY = centerY + (graphButton.frame.size.height / 2)
        }
        
        let center: CGPoint = CGPoint(x: nextXOrigin, y: centY)
        graphButton.center = center
        
        self.addSubview(graphButton)
    }
    
    

}

//
//  BarGraphView.swift
//  myMood
//
//  Created by Elle Ti on 2017-09-11.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

class BarGraphView: UIView {
    
    var graphArray: [CGFloat] = []
    
    var centerY: CGFloat = 0.0
    
    var chartWidth: CGFloat = 40
    var chartMargin: CGFloat = 5
    

    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        FirebaseDBController.shared.getAllEntries {entries in
            for bars in entries.value(forKey: "Entries") as! Dictionary<String, Int>
            {
                self.graphArray.append(CGFloat(bars.value))
            }
            self.setNeedsDisplay()
        }
       // self.graphArray = [4,5,6,7,-10,-9,-8,-7,-6]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        
        // Draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()
        
        // Center line
        linePath.move(to: CGPoint(x:0,
                                  y: self.frame.size.height / 2))
        linePath.addLine(to: CGPoint(x:self.frame.size.width,
                                     y:self.frame.size.height/2))
        
        let color = UIColor.blue
        color.setStroke()
        
        linePath.lineWidth = 2.0
        linePath.stroke()
        
        //Vertical line
        linePath.move(to: CGPoint(x:5,
                                  y:0))
        linePath.addLine(to: CGPoint(x:5,
                                     y:self.frame.size.height))
        linePath.stroke()
        
        for barItems in graphArray {
            addGraph(height: barItems )
        }  
        
    }
    
    func addGraph(height:CGFloat) {
        // Draws next bar
        let nextXOrigin = CGFloat(self.subviews.count+1) * chartWidth
        
        //Mid point - line in middle
        let heightFrame:CGFloat = self.frame.size.height / 2

        let normalizedHeight = ((height / 10) * heightFrame)+5
  
        let graphButton: UIButton = UIButton()
        graphButton.backgroundColor = UIColor.green
        graphButton.frame = CGRect(x: 0, y: 0, width: chartWidth, height: normalizedHeight)
        
        graphButton.setTitle("\(Int(height))", for: UIControlState.normal)
        
        graphButton.addTarget(self, action: #selector(clickAction), for: UIControlEvents.touchUpInside)
        
        //Change the Y position
        var centY: CGFloat!
        if (height < 0) {
            centY = centerY + (graphButton.frame.size.height/2)
        } else {
            centY = centerY - (graphButton.frame.size.height / 2)
        }
        
        let center: CGPoint = CGPoint(x: nextXOrigin, y: centY+(self.frame.size.height/2))
        graphButton.center = center
        
        self.addSubview(graphButton)
    }
    
    func clickAction() {
        print("Click")
        
    }
    
    

}

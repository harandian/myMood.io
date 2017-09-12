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
    
    var chartWidth: CGFloat = 40
    
    //increment values
    var incrementVal:CGFloat!
    
    //Axis measurement values
    let topBottomMargins:CGFloat = 20
    let leftMargin:CGFloat = 40
    let rightMargin:CGFloat = 20
    let textPositionRightMargin:CGFloat = 10
    let textLabelWidth:CGFloat = 20
    var textLabelHeight:CGFloat = 10

    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        incrementVal = (self.frame.height - (topBottomMargins*2)) / 10.0
        textLabelHeight = incrementVal
        
        self.graphArray = [4,5,6,7,-10,-9,-8]
        FirebaseDBController.shared.getAllEntries {entries in
            for bars in entries.value(forKey: "Entries") as! Dictionary<String, Int>
            {
                self.graphArray.append(CGFloat(bars.value))
            }
            self.setNeedsDisplay()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        
        for barItems in graphArray {
            addGraph(height: barItems )
        }
        //self.chartLayer()
        self.chartAxis()
        
    }
    
    func addGraph(height:CGFloat) {
        // Draws next bar
        let nextXOrigin = CGFloat(self.subviews.count+1) * chartWidth
        
        //Mid point - line in middle
        let heightFrame:CGFloat = self.frame.size.height / 2

        let normalizedHeight = ((height / 10) * heightFrame)
  
        let graphButton: UIButton = UIButton()
        graphButton.backgroundColor = UIColor.green
        graphButton.frame = CGRect(x: 0, y: 0, width: chartWidth, height: normalizedHeight)
        
        graphButton.setTitle("\(Int(height))", for: UIControlState.normal)
        
        graphButton.addTarget(self, action: #selector(clickAction), for: UIControlEvents.touchUpInside)
        
        //Change the Y position
        var centY: CGFloat!
        if (height < 0) {
            centY = graphButton.frame.size.height/2
        } else {
            centY = -graphButton.frame.size.height / 2
        }
        
        let center: CGPoint = CGPoint(x: nextXOrigin, y: centY+(self.frame.size.height/2))
        graphButton.center = center
        
        self.addSubview(graphButton)
    }
    
    func clickAction() {
        print("Click")
        
    }
    
    func chartAxis() {
        // Draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()
        let color = UIColor.blue
        
        // Center line
        linePath.move(to: CGPoint(x:leftMargin,y: self.frame.size.height / 2))
        linePath.addLine(to: CGPoint(x:self.frame.size.width-rightMargin,y:self.frame.size.height/2))
        
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
        
        //Vertical line
        linePath.move(to: CGPoint(x:leftMargin,
                                  y:topBottomMargins))
        linePath.addLine(to: CGPoint(x:leftMargin,
                                     y:self.frame.size.height-topBottomMargins))
        linePath.stroke()
        
        //Set the labels
        var label:Int = 10
        for i in 0 ... 10{
            
            //Position of label
            let yCenter = topBottomMargins + CGFloat(i) * incrementVal!
            let xCenter = textPositionRightMargin
            
            //Create the text label
            let text = UILabel()
            text.frame = CGRect(x: xCenter, y: yCenter, width: textLabelWidth, height: textLabelHeight)
            text.center = CGPoint(x: xCenter, y: yCenter)
            text.text = "\(label)"
            text.font = UIFont.boldSystemFont(ofSize: 10)
            self.addSubview(text)
            label -= 2
        }
        
        

        
    }
    
    func chartLayer() {
        
        for h in 1...10 {
            let barWidth:CGFloat = 40
            let linePath = UIBezierPath()
            let xPoint:CGFloat = barWidth * CGFloat(h)
            
            linePath.move(to: CGPoint(x: xPoint, y: 0))
            linePath.addLine(to: CGPoint(x: xPoint, y: self.frame.height))
            
            linePath.setLineDash([5.0,5.0], count: 2, phase: 1)
            linePath.lineWidth = 1
            //linePath.stroke(with: CGBlendMode, alpha: 0.5)
            linePath.stroke()
        }
        
        for h in 1...10 {
            let barWidth:CGFloat = 40
            let linePath = UIBezierPath()
            let yPoint:CGFloat = barWidth * CGFloat(h)
            
            linePath.move(to: CGPoint(x: 0, y: yPoint))
            linePath.addLine(to: CGPoint(x: self.frame.width, y: yPoint))
            
            linePath.setLineDash([5.0,5.0], count: 2, phase: 1)
            linePath.lineWidth = 1
            linePath.stroke()
            
        }
    }
    
    

}

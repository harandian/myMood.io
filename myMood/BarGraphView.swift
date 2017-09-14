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
    
    //Graph Height
    var graphHeight:CGFloat!
    
    //increment values
    var incrementVal:CGFloat!
    
    //Axis measurement values
    let topBottomMargins:CGFloat = 20
    let leftMargin:CGFloat = 40
    let rightMargin:CGFloat = 20
    let textPositionRightMargin:CGFloat = 20
    let textLabelWidth:CGFloat = 20
    var textLabelHeight:CGFloat = 10

    //Bars on chart
    var barsOnGraph:Int = 0
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        graphHeight = (self.frame.height - (topBottomMargins*2))
        incrementVal = graphHeight / 10.0
        textLabelHeight = incrementVal
        chartWidth = incrementVal
        
        let temp:[Entry] = FirebaseDBController.shared.get_allEntries()
        for item in temp {
            self.graphArray.append(CGFloat(item.mood))
            if self.graphArray.count > 7 {
                break
            }
        }
    }    
    
    override func draw(_ rect: CGRect) {
        
        for barItems in graphArray {
            addGraph(height: barItems)
        }
        self.chartLayer()
        self.chartAxis()
        
    }
    
    func addGraph(height:CGFloat) {
        // Draws next bar
        //left margin + width of graph bar + barwidth/2 + (subviewCount * incrementalVal) + border
        let nextXOrigin = leftMargin + 1.0 + (incrementVal/2) + (CGFloat(barsOnGraph) * incrementVal)
        
        //Height of the bar
        let normalizedHeight = ((height / 10) * (graphHeight / 2))
  
        //Create bar/Button
        let graphButton: UIButton = UIButton()
        
        //bar properties
        graphButton.backgroundColor = UIColor.green
        graphButton.frame = CGRect(x: 0, y: 0, width: chartWidth, height: normalizedHeight)
        graphButton.layer.borderColor = UIColor.black.cgColor
        graphButton.layer.borderWidth = 1.0
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
        barsOnGraph += 1
    }
    
    func clickAction() {
        print("Click")
        
    }
    
    
    /*
 
     Draw Axis and title labels
 
    */
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
    
    /*
 
     Draw background graph dotted lines
 
    */
    func chartLayer() {
        
        //Draw horizontal
        for h in 0...10 {
            let linePath = UIBezierPath()
            let yPoint = topBottomMargins + (CGFloat(h) * incrementVal)
            
            //Set Color
            let color:UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            color.setStroke()
            
            linePath.move(to: CGPoint(x: leftMargin, y: yPoint))
            linePath.addLine(to: CGPoint(x: self.frame.width - rightMargin, y: yPoint))
            
            linePath.setLineDash([5.0,5.0], count: 2, phase: 1)
            linePath.lineWidth = 1
            linePath.stroke()
        }
    }

}

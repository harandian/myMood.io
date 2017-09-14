//
//  LineGraphView.swift
//  myMood
//
//  Created by Elle Ti on 2017-09-06.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit
import Foundation


class LineGraphView: UIView {
    
    // Hard coded values for now for plotted points
    var graphPoints:[Int] = [4, 2, 6, 4, 5, 8, 3]
    
    //Graph Height
    var graphHeight:CGFloat!
    
    //Increment Values
    var incrementVal:CGFloat!
    
    //Graph Incremental Dot Width
    var incrementWidth:CGFloat!
    
    //Axis measurement values
    let topBottomMargins:CGFloat = 20
    let leftMargin:CGFloat = 40
    let rightMargin:CGFloat = 20
    let textPositionRightMargin:CGFloat = 20
    let textLabelWidth:CGFloat = 20
    var textLabelHeight:CGFloat = 10
    
    //Dot Size
    let dotSize:CGFloat = 5
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        self.graphPoints.removeAll()
        var weekAverge:CGFloat = 0
        var weekDay:Int = 0
        for plots in FirebaseDBController.shared.get_allEntries().reversed() {
            weekAverge += CGFloat(plots.mood)
            
            if weekDay == 7 {
                weekAverge /= 7
                self.graphPoints.append(Int(weekAverge))
                weekDay = 0
            }
        }
        
        graphHeight = (self.frame.height - (topBottomMargins*2))
        incrementVal = graphHeight / 10.0
        let graphWidth = self.frame.width - (leftMargin + rightMargin)
        incrementWidth = graphWidth/CGFloat(self.graphPoints.count)
        
    }

    
    override func draw(_ rect: CGRect) {
        
        
        drawAxis()
        drawBackgroundLayer()
        if (graphPoints.count > 0) {
            drawDots()
            drawLines()
        }
    }
    
    func drawLines() {
        let linePath = UIBezierPath()
        
        //Move path to first Point
        //Y Position
        let pointPercentage:CGFloat = abs(CGFloat(graphPoints[0]))/10.0
        var yPoint:CGFloat = (pointPercentage * (graphHeight/2))

        //Y Position : Up or Down depending on neg/pos
        yPoint = topBottomMargins+graphHeight/2 - yPoint
        if (graphPoints[0] < 0) {
            yPoint = topBottomMargins+graphHeight/2 + yPoint
        }
        
        //First Position
        let firstPoint = CGPoint(x: leftMargin, y: yPoint)
        
        linePath.move(to: firstPoint)
        
        //loop through the rest of the points
        for circlePoint in 1..<graphPoints.count {
            // Set up the points line
            //percentage + / - depending plus/minus
            let pointPercentage:CGFloat = abs(CGFloat(graphPoints[circlePoint]))/10.0
            let yPointOffset:CGFloat = (pointPercentage * (graphHeight/2))
            
            //Y Position : Up or Down depending on neg/pos
            var yPoint:CGFloat = topBottomMargins + graphHeight/2 - yPointOffset
            if (circlePoint < 0) {
                yPoint = topBottomMargins + graphHeight/2 + yPointOffset
            }
            
            //TODO - DESIGN - HOW SPARSE
            //X Position
            let xPoint:CGFloat = leftMargin + (CGFloat(circlePoint)*incrementWidth)
            
            //Setup Point
            let point = CGPoint(x:xPoint,
                                y:yPoint)
            
            //Add Line
            linePath.addLine(to: point)
            
            let color = UIColor(red: 105/255, green: 105/255, blue: 105/255, alpha: 0.5)
            color.setStroke()
            
            linePath.stroke()
        }
        
    }
    
    func drawDots() {
        for index in 0..<graphPoints.count {
            // Set up the points line
            //percentage + / - depending plus/minus
            let yPointOffset:CGFloat = (abs(CGFloat(graphPoints[index]))/10.0) * (graphHeight/2)
            
            //Y Position : Up or Down depending on neg/pos
            var yPoint:CGFloat = graphHeight/2 - yPointOffset
            if (index < 0) {
                yPoint = graphHeight/2 + yPointOffset
            }
            
            
            //TODO - DESIGN - HOW SPARSE
            //X Position
            var xPoint:CGFloat = leftMargin + (CGFloat(index)*incrementWidth)
            
            //Normalize to dot center
            yPoint += dotSize/2
            xPoint -= dotSize/2
            
            //Setup Point
            let point = CGPoint(x:xPoint,
                                y:yPoint)
            
            //Set Circle
            let circle = UIBezierPath(ovalIn: CGRect(origin: point,
                                                     size: CGSize(width: dotSize, height: dotSize)))
            circle.fill()
        }
    }
    
    func drawBackgroundLayer() {
        let linePath = UIBezierPath()
        
        //Draw horizontal
        for h in 0...10 {
            let yPoint = topBottomMargins + (CGFloat(h) * incrementVal)
        
            //Drawing chart
            linePath.move(to: CGPoint(x: leftMargin, y: yPoint))
            linePath.addLine(to: CGPoint(x: self.frame.width - rightMargin, y: yPoint))
            
            linePath.setLineDash([5.0,5.0], count: 2, phase: 1)
            linePath.lineWidth = 1
            let color = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 0.25)
            color.setStroke()
            linePath.stroke()
        }
        
    }
    
    
    func drawAxis() {
        // Draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()
        
        // Center line
        linePath.move(to: CGPoint(x:leftMargin,
                                  y: self.frame.size.height/2))
        linePath.addLine(to: CGPoint(x:self.frame.size.width - rightMargin,
                                     y: self.frame.size.height/2))

        linePath.lineWidth = 1.0
        linePath.stroke()
        
//        //Vertical Line
//        linePath.move(to: CGPoint(x:leftMargin,
//                                  y: topBottomMargins))
//        linePath.addLine(to: CGPoint(x:leftMargin,
//                                     y:self.frame.size.height - topBottomMargins))
//        linePath.stroke()
        
        
        //Set the labels
//        var label:Int = 10
//        for i in 0 ... 10{
//            
//            //Position of label
//            let yCenter = topBottomMargins + CGFloat(i) * incrementVal!
//            let xCenter = textPositionRightMargin
//            
//            //Create the text label
//            let text = UILabel()
//            text.frame = CGRect(x: xCenter, y: yCenter, width: textLabelWidth, height: textLabelHeight)
//            text.center = CGPoint(x: xCenter, y: yCenter)
//            text.text = "\(label)"
//            text.font = UIFont.boldSystemFont(ofSize: 10)
//            self.addSubview(text)
//            label -= 2
//        }
    }
    
    
    
    
}

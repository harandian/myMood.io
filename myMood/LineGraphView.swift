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
    
    //Axis measurement values
    let topBottomMargins:CGFloat = 20
    let leftMargin:CGFloat = 40
    let rightMargin:CGFloat = 20
    let textPositionRightMargin:CGFloat = 20
    let textLabelWidth:CGFloat = 20
    var textLabelHeight:CGFloat = 10
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        graphHeight = (self.frame.height - (topBottomMargins*2))
        incrementVal = graphHeight / 10.0
        
        FirebaseDBController.shared.getAllEntries {entries in
            
            // Clear array in the beginning
            self.graphPoints.removeAll()
            
            for plots in entries ["Entries"] as! NSDictionary {
                self.graphPoints.append(plots.value as! Int)
            }
            self.setNeedsDisplay()
        }
    }

    
    override func draw(_ rect: CGRect) {
        
        drawAxis()
        drawBackgroundLayer()
        
        let width = rect.width
        let height = rect.height
        
        /*
 
         Draw background Color
 
        */
//        let startColor = UIColor.blue
//        let endColor = UIColor.white
//
//        // Get the current context
//        let context = UIGraphicsGetCurrentContext()
//        let colors = [startColor.cgColor, endColor.cgColor]
//        
//        // Set up the color space
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        
//        //4 - set up the color stops
//        let colorLocations:[CGFloat] = [0.0, 1.0]
//        
//        //5 - create the gradient
//        let gradient = CGGradient(colorsSpace: colorSpace,
//                                  colors: colors as CFArray,
//                                  locations: colorLocations)
//        
//        // Draw the gradient
//        let startPoint = CGPoint.zero
//        let endPoint = CGPoint(x:0, y:self.bounds.height)
//        context?.drawLinearGradient(gradient!,
//                                    start: startPoint,
//                                    end: endPoint,
//                                    options: CGGradientDrawingOptions(rawValue: 0))
        
        // Calculate the x point
        let margin: CGFloat = 20.0
        let columnXPoint = {(column: Int) -> CGFloat in
            // Calculate gap between points
            let spacer = (width - margin*2 - 4) / CGFloat((self.graphPoints.count - 1))
            var x:CGFloat = CGFloat(column) * spacer
            x += margin + 2
            return x
        }
        
        // Calculate the y point
        let topBorder: CGFloat = 60
        let bottomBorder: CGFloat = 50
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = graphPoints.max()
        
        let columnYPoint = {(graphPoint:Int) -> CGFloat in
            let y: CGFloat = CGFloat(graphPoint) / CGFloat(maxValue!) * graphHeight
            return y
        }
        

        
        // Set up the points line
        let graphPath = UIBezierPath()
        
        // Go to start of line
        graphPath.move(to: CGPoint(x:columnXPoint(0),
                                   y:columnYPoint(graphPoints[0])))
        
        // Add points for each item in the graphPoints array at the correct (x, y) for the point
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x:columnXPoint(i),
                                    y:columnYPoint(graphPoints[i]))
            graphPath.addLine(to: nextPoint)
        }
        
        // Draw the line on top of the gradient
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        // Draw the circles at each point
        for i in 0..<graphPoints.count {
            var point = CGPoint(x:columnXPoint(i), y:columnYPoint(graphPoints[i]))
            point.x -= 5.0/2
            point.y -= 5.0/2
            
            let circle = UIBezierPath(ovalIn:
                CGRect(origin: point,
                       size: CGSize(width: 10.0, height: 10.0)))
            
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
            linePath.stroke()
        }
        
        //Draw Vertical
        for h in 1...10 {
            let xPoint = leftMargin + (CGFloat(h) * incrementVal)
            
            //Drawing Chart
            linePath.move(to: CGPoint(x: xPoint, y: topBottomMargins))
            linePath.addLine(to: CGPoint(x: xPoint,
                                         y: self.frame.height - topBottomMargins))
            
            linePath.setLineDash([5.0,5.0], count: 2, phase: 1)
            linePath.lineWidth = 1
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
        
        //Vertical Line
        linePath.move(to: CGPoint(x:leftMargin,
                                  y: topBottomMargins))
        linePath.addLine(to: CGPoint(x:leftMargin,
                                     y:self.frame.size.height - topBottomMargins))
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
    
    
    
    
}

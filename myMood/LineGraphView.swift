//
//  LineGraphView.swift
//  myMood
//
//  Created by Elle Ti on 2017-09-06.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit
import Foundation

protocol LineGraphDelegate {
    func passEntryThrough(entry:[Entry])
}

class LineGraphView: UIView {
    //Delegate
    var delegate:LineGraphDelegate? = nil
    
    // Plotted Points
    var graphPoints:[[Entry]] = []
    
    //Graph Height
    var graphHeight:CGFloat!
    var graphWidth:CGFloat!
    
    //Increment Values
    var incrementVal:CGFloat!
    
    //Graph Incremental Dot Width
    var incrementWidth:CGFloat!
    
    //Axis measurement values
    let topBottomMargins:CGFloat = 20
    let leftMargin:CGFloat = 20
    let rightMargin:CGFloat = 20
    let textPositionRightMargin:CGFloat = 20
    let textLabelWidth:CGFloat = 20
    var textLabelHeight:CGFloat = 10
    
    //ScrollView
    var myScrollView:UIScrollView!
    
    //Dot Size
    let dotSize:CGFloat = 10
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        myScrollView = self.superview as! UIScrollView
        populateGraphPoints()
        
       // self.graphPoints.append(contentsOf: [1,-5,5,6,3,3,6,3,-3,4,-9,3,10])
        
        graphHeight = myScrollView.frame.height - (topBottomMargins*2)
        incrementVal = graphHeight / 10.0
        incrementWidth = UIScreen.main.bounds.width / 4
        
        setupScrollView()

    }
    
    
    func setupScrollView () {
        // SET SCROLL VIEW CONTENTSIZE
        myScrollView.alwaysBounceHorizontal = false
        var fullWidth = leftMargin+(incrementWidth * CGFloat(graphPoints.count-1))+(myScrollView.frame.width/2)
        if graphPoints.count == 0 {
            fullWidth = myScrollView.frame.width
        }
        self.frame.size.width = fullWidth
        myScrollView.contentSize = CGSize(width: fullWidth, height: myScrollView.frame.size.height-20)
        
        myScrollView.contentOffset = CGPoint(x:fullWidth-UIScreen.main.bounds.width ,y:0)
        self.frame.size.height = myScrollView.frame.size.height
    }
    
    func populateGraphPoints() {
        var weekEntries:[Entry] = []
        for plots in FirebaseDBController.shared.get_allEntries().reversed() {
            weekEntries.append(plots)
            
            if weekEntries.count == 7 {
                self.graphPoints.append(weekEntries)
                weekEntries.removeAll()
            }
        }
        if weekEntries.count > 0 {
            self.graphPoints.append(weekEntries)
        }
        

    }

    
    override func draw(_ rect: CGRect) {
        drawAxis()
        drawBackgroundLayer()
        if self.graphPoints.count > 0 {
            drawDots()
            drawLines()
        }
    }
    
    func drawLines() {
        let linePath = UIBezierPath()
        
        //Move path to first Point
        //Y Position
        let pointPercentage:CGFloat = abs(averageEntry(graphPoints[0]))/10.0
        var yPoint:CGFloat = (pointPercentage * (graphHeight/2))

        //Y Position : Up or Down depending on neg/pos
        if (averageEntry(graphPoints[0]) < 0) {
            yPoint = topBottomMargins+graphHeight/2 + yPoint
        } else {
            yPoint = topBottomMargins+graphHeight/2 - yPoint
        }
        
        //First Position
        let firstPoint = CGPoint(x: leftMargin, y: yPoint)
        
        linePath.move(to: firstPoint)
        
        //loop through the rest of the points
        for circlePoint in 1..<graphPoints.count {
            // Set up the points line
            //percentage + / - depending plus/minus
            let pointPercentage:CGFloat = abs(averageEntry(graphPoints[circlePoint]))/10.0
            let yPointOffset:CGFloat = (pointPercentage * (graphHeight/2))
            
            //Y Position : Up or Down depending on neg/pos
            var yPoint:CGFloat = topBottomMargins + graphHeight/2 - yPointOffset
            if (averageEntry(graphPoints[circlePoint]) < 0) {
                yPoint = topBottomMargins + graphHeight/2 + yPointOffset
            }
            
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
            //percentage + / - depending plus/minus
            let pointPercentage:CGFloat = abs(averageEntry(graphPoints[index]))/10.0
            let yPointOffset:CGFloat = pointPercentage * (graphHeight/2)
            
            //Y Position : Up or Down depending on neg/pos
            var yPoint:CGFloat = (topBottomMargins + graphHeight/2) - yPointOffset
            if (averageEntry(graphPoints[index]) < 0) {
                yPoint = (topBottomMargins + graphHeight/2) + yPointOffset
            }
            
            
            //TODO - DESIGN - HOW SPARSE
            //X Position
            var xPoint:CGFloat = leftMargin + (CGFloat(index)*incrementWidth)
            
            //Normalize to dot center
            yPoint -= dotSize/2
            xPoint -= dotSize/2
            
            //Setup Point
            let point = CGPoint(x:xPoint,
                                y:yPoint)
            
            //Set Circle
            let circle = UIBezierPath(ovalIn: CGRect(origin: point,
                                                     size: CGSize(width: dotSize, height: dotSize)))
            var color:UIColor = UIColor(red: 115/255, green: 1, blue: 115/255, alpha: 0.75)
            if (averageEntry(graphPoints[index]) < 0) {
                color = UIColor(red: 115/255, green: 115/255, blue: 1, alpha: 0.75)
            }

            color.setFill()
            circle.fill()
            
            
            //Draw labels
            let textLabel:UILabel = UILabel()
            textLabel.text = "W\(index)"
            textLabel.frame = CGRect(x: xPoint-(textLabelWidth/2),
                                     y: self.frame.height/2,
                                     width: textLabelWidth*2,
                                     height: textLabelHeight*2)
            textLabel.sizeToFit()
            textLabel.backgroundColor = UIColor.clear
            self.addSubview(textLabel)
            
            //Draw Buttons
            let weekButton:UIButton = UIButton()
            weekButton.frame = CGRect(x: xPoint-(textLabelWidth/2),
                                      y: 0,
                                      width: textLabelWidth*2,
                                      height: self.frame.height)
            weekButton.backgroundColor = UIColor.clear
            weekButton.addTarget(self, action: #selector(tapWeek), for: .touchUpInside)
            weekButton.tag = index
            self.addSubview(weekButton)
        }
    }
    
    func tapWeek(sender: UIButton){
        self.delegate?.passEntryThrough(entry: graphPoints[sender.tag])
        print("Reset table")
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
    }
    
    
    func averageEntry(_ e:[Entry]) -> CGFloat{
        var average:CGFloat = 0
        for obj in e {
            average += CGFloat(obj.mood)
        }
        return average/CGFloat(e.count)
    }
    
    
    
    
}

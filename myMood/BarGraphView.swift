//
//  BarGraphView.swift
//  myMood
//
//  Created by Elle Ti on 2017-09-11.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

class BarGraphView: UIView {
    
    var graphArray: [[Entry]] = []
    
    var chartWidth: CGFloat = 40
    
    //Graph Height
    var graphHeight:CGFloat!
    
    //increment values
    var incrementVal:CGFloat!
    
    //Axis measurement values
    let topBottomMargins:CGFloat = 20
    let leftMargin:CGFloat = 20
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
        textLabelHeight = incrementVal/2
        chartWidth = (self.frame.width - leftMargin - 5 - rightMargin-5)/7
        
        var currentDate:Date = Date()
        var dayOfEntries:[Entry] = []
        for item in FirebaseDBController.shared.get_allEntries() {
            //Store x amount of entries on the same day
            if !Calendar.current.isDate(Date(timeIntervalSince1970: item.date), inSameDayAs: currentDate)
            {
                //New Day
                graphArray.append(dayOfEntries)
                if self.graphArray.count == 7 {
                    break
                }
                currentDate = Date(timeIntervalSince1970: item.date)
                dayOfEntries.removeAll()
            }
            dayOfEntries.append(item)
        }
    }    
    
    override func draw(_ rect: CGRect) {
        for barItems in graphArray.reversed() {
            //Grab average
            //Grab Date
            
            addGraph(height:  averageOfAllEntries(entries: barItems),date: barItems[0].date)
        }
        self.chartLayer()
        self.chartAxis()
        
    }
    
    func addGraph(height:CGFloat, date:Double) {
       // let height:CGFloat = CGFloat(entry.mood)
        
        // Draws next bar
        //left margin + width of graph bar + barwidth/2 + (subviewCount * incrementalVal) + border
        let nextXOrigin = (1.25*leftMargin) + 1.0 + (chartWidth/2) + (CGFloat(barsOnGraph) * chartWidth)
        
        //Height of the bar
        let normalizedHeight = ((height / 10) * (graphHeight / 2))
  
        //Create bar/Button
        let graphBar:UIButton = UIButton()

        //bar properties
        graphBar.backgroundColor = UIColor(red: 115/255, green: 1, blue: 115/255, alpha: 0.75)
        if height < 0 {
            graphBar.backgroundColor = UIColor(red: 115/255, green: 115/255, blue: 1, alpha: 0.75)
        }
        graphBar.frame = CGRect(x: 0, y: 0, width: chartWidth, height: 0)
        graphBar.isUserInteractionEnabled = false
        graphBar.layer.borderColor = UIColor.black.cgColor
        graphBar.layer.cornerRadius = 1
        graphBar.layer.borderWidth = 1
        
        if (Int(height) != 0) {
            graphBar.setTitle("\(Int(height))", for: UIControlState.normal)
        }
        
        
        //Create Button
        let graphButton: UIButton = UIButton()
        graphButton.backgroundColor = UIColor.init(white: 0, alpha: 0)
        graphButton.frame = CGRect(x: 0, y: 0, width: chartWidth, height: graphHeight)
        graphButton.addTarget(self, action: #selector(clickAction), for: UIControlEvents.touchUpInside)
        
        
        //Set up date - Label
        //let newDate:Double = date// + Double(barsOnGraph*86400) //DEBUG TODO
        let textLabel:UILabel = UILabel()
        textLabel.frame = CGRect(x: nextXOrigin-(chartWidth/10),
                                 y: self.frame.height/2-textLabelHeight/2,
                                 width: chartWidth/5,
                                 height: textLabelHeight*2)
        textLabel.textColor = UIColor.black
        textLabel.backgroundColor = UIColor.init(white: 1.0, alpha: 0.5)
        textLabel.font = UIFont(name:"Roboto", size:textLabel.font.pointSize)
        
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.text = UnixToDate(date: date)
        
        
        //Change the Y position
        var centY: CGFloat!
        if (height < 0) {
            centY = graphBar.frame.size.height/2
        } else {
            centY = -1-graphBar.frame.size.height / 2
        }
        
        //Change position of both button and bar
        let center: CGPoint = CGPoint(x: nextXOrigin, y: (self.frame.size.height/2)+centY)
        graphButton.center = center
        graphBar.center = center
        
        self.addSubview(graphBar)
        self.addSubview(textLabel)
        self.addSubview(graphButton)
        
        
        
        UIView.animate(withDuration: 1.0) {
            graphBar.frame.size.height = -normalizedHeight
        }
        
        
        barsOnGraph += 1
    }
    
    func clickAction() {
       print("Cliked bar")
    }
    
    
    /*
 
     Draw Axis and title labels
 
    */
    func chartAxis() {
        // Draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()
        let color = UIColor(red: 0, green: 0, blue: 1, alpha: 0.2)
        
        // Center line
        linePath.move(to: CGPoint(x:leftMargin,y: self.frame.size.height / 2))
        linePath.addLine(to: CGPoint(x:self.frame.size.width-rightMargin,y:self.frame.size.height/2))
        
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
        
//        //Vertical line
//        linePath.move(to: CGPoint(x:leftMargin,
//                                  y:topBottomMargins))
//        linePath.addLine(to: CGPoint(x:leftMargin,
//                                     y:self.frame.size.height-topBottomMargins))
//        linePath.stroke()
//        
//
//        //Set the labels
//        var label:Int = 10
//        for i in 0 ... 10{
//            
//            //Position of label
//            let yCenter = topBottomMargins + (CGFloat(i) * incrementVal!)
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
    
    func averageOfAllEntries(entries:[Entry]) -> CGFloat {
        var total:CGFloat = 0
        for obj in entries {
            total += CGFloat(obj.mood)
        }
        return total/CGFloat(entries.count)
    }
    
    
    func UnixToDate(date: Double) -> String {
        let dateObj:Date = Date(timeIntervalSince1970: date)
        
        let calender = NSCalendar(calendarIdentifier: .gregorian)
        let myComponent:Int = (calender?.component(.weekday, from: dateObj))!
        
        switch(myComponent){
        case 1:
            return "S"
        case 2:
            return "M"
        case 3:
            return "T"
        case 4:
            return "W"
        case 5:
            return "T"
        case 6:
            return "F"
        case 7:
            return "S"
        default:
            return "M"
        }

        
    }

}

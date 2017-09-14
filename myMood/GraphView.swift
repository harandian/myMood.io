//
//  GraphView.swift
//  myMood
//
//  Created by Elle Ti on 2017-09-06.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit
import Foundation


class GraphView: UIView {
    
    // Hard coded values for now for plotted points
    
    var graphPoints:[Int] = [4, 2, 6, 4, 5, 8, 3]
    var entries:[Entry] = []
    
    // create rect property
//    var rect: CGRect
    
//    @IBInspectable var startColor: UIColor = UIColor.red
//    @IBInspectable var endColor: UIColor = UIColor.green
    
    override init(frame: CGRect) {
        //set rect
//        self.rect = frame
        super.init(frame: frame)

        // TODO: Get all data from the user from FirebaseDB class
        entries = FirebaseDBController.shared.get_allEntries()
        graphPoints.removeAll()
        
        print("This is all of my entries \(entries)")
        for entry in entries {
            graphPoints.append(entry.mood)
        }
        
//        FirebaseDBController.shared.getAllEntries { (userMood) in
//            if let error = userMood["error"] {
//                print(error)
//                return
//            }
//            //Fix this so it becomes an array
////            self.graphPoints = userMood["Entries"]! as! [Int]
//            
////            print("Graphpoints \(self.graphPoints)")
//            
//            // Clear array in the beginning
//            self.graphPoints.removeAll()
//            
//            for (_, value) in userMood["Entries"] as! NSDictionary {
//                self.graphPoints.append(value as! Int)
//            }
//            
//            self.setNeedsDisplay() // This need to be redrawn
////            print("Mood \(self.graphPoints)")
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
        
        
        //set up background clipping area
//        let path = UIBezierPath(roundedRect: rect,
//                                byRoundingCorners: UIRectCorner.allCorners,
//                                cornerRadii: CGSize(width: 8.0, height: 8.0))
//        path.addClip()
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
        
        // Draw the line graph
        
        UIColor.red.setFill()
        UIColor.red.setStroke()
        
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
                       size: CGSize(width: 5.0, height: 5.0)))
            circle.fill()
        }
        
        // Draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()
        
        // Center line
        linePath.move(to: CGPoint(x:margin,
                                  y: graphHeight/2 + topBorder))
        linePath.addLine(to: CGPoint(x:width - margin,
                                     y:graphHeight/2 + topBorder))
        
        let color = UIColor(white: 1.0, alpha: 0.3)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
    }

}

//
//  BarGraphView.swift
//  myMood
//
//  Created by Elle Ti on 2017-09-11.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

class BarGraphView: UIView {
    
    var graphArray: NSMutableArray = [(height: CGFloat, color: UIColor)]() as! NSMutableArray
    
    var centerY: CGFloat = 0.0
    
    var chartWidth: CGFloat = 40
    var chartMargin: CGFloat = 5
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        FirebaseDBController.shared.getAllEntries {entries in
            for bars in entries ["Entries"] as! NSDictionary {
                let tuple = [(height: bars.value as! CGFloat, color: UIColor.red)] as [Any]
                self.graphArray.addObjects(from: tuple)
            }
            self.setNeedsDisplay()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
        graphArray =
                    [addGraph(height: 60, wColor: UIColor.green),
                      addGraph(height: 70, wColor: UIColor.red),
                      addGraph(height: 90, wColor: UIColor.red),
                      addGraph(height: 20, wColor: UIColor.red),
                      addGraph(height: 10, wColor: UIColor.green),
                      addGraph(height: 70, wColor: UIColor.red),
                      addGraph(height: 60, wColor: UIColor.green),
                      addGraph(height: 70, wColor: UIColor.red),
                      addGraph(height: 90, wColor: UIColor.red),
                      addGraph(height: 20, wColor: UIColor.red),
                      addGraph(height: 10, wColor: UIColor.red),
                      addGraph(height: 70, wColor: UIColor.red),
                      addGraph(height: 95, wColor: UIColor.green),
        ]
        
        
    }
    
    func addGraph(height:CGFloat, wColor:UIColor) {
        // Draws next bar
        let nextXOrigin = CGFloat(self.subviews.count - 2) * chartWidth
        self.frame.size = CGSize(width:300, height: 300)
        //graphScrollView.contentSize = CGSize(width: nextXOrigin + chartWidth, height: graphScrollView.frame.size.height)
        
        
        //Mid point - line in middle
        let normalizedHeight: CGFloat = height / 100 * (self.frame.size.height / 2)
        
        let graphButton: UIButton = UIButton(frame: CGRect(x: nextXOrigin, y: 0, width: chartWidth, height: normalizedHeight))
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
        
        let center: CGPoint = CGPoint(x: graphButton.center.x, y: centY)
        graphButton.center = center
        
        self.addSubview(graphButton)
    }
    
    

}

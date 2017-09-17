//
//  ChartScrollController.swift
//  myMood
//
//  Created by Martin Tsang on 2017-09-15.
//  Copyright © 2017 Hirad. All rights reserved.
//

import Foundation
import UIKit

class ChartScrollController:UIView, UIScrollViewDelegate {
    let barChart = Bundle.main.loadNibNamed("BarGraphView", owner: self, options: nil)?.first as! BarGraphView
    let lineChart = Bundle.main.loadNibNamed("LineGraphView", owner: self, options: nil)?.first as! LineScrollGraph
    var wordCloudLayout = Bundle.main.loadNibNamed("wordCloudLayout", owner: nil, options: nil)?.first! as! wordCloudLayoutGenerator

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var chartScrollView: UIScrollView!
    
    override func willMove(toWindow newWindow: UIWindow?) {
        let content:UIView = UIView()
        content.frame = CGRect(x: 0, y: 0, width: self.frame.width*3, height: super.frame.height)
        
        barChart.frame.size = self.frame.size
        lineChart.frame.size = self.frame.size
        wordCloudLayout.frame.size = self.frame.size
        
        lineChart.center = CGPoint(x:self.frame.width*0.5, y:self.center.y)
        barChart.center = CGPoint(x:self.frame.width*1.5, y:self.center.y)
        wordCloudLayout.center = CGPoint(x:self.frame.width*2.5, y:self.center.y)
         content.addSubview(lineChart)
        content.addSubview(barChart)
        content.addSubview(wordCloudLayout)
        
        
        content.backgroundColor = UIColor.red
        chartScrollView.contentMode = UIViewContentMode.scaleAspectFit
        chartScrollView.isPagingEnabled = true
        chartScrollView.contentSize = content.frame.size
        chartScrollView.addSubview(content)
        chartScrollView.delegate = self
        
    }

    
}

//
//  SliderMoodViewController.swift
//  myMood
//
//  Created by Mohammad Shahzaib Ather on 2017-09-05.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

class SliderMoodViewController: UIViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //VIEW HEIRARCHY TO SHOW GRAPH -- CAN MOVE
        //        var temp = CGRect()
        let graphTemp:LineGraphView = LineGraphView(frame: CGRect(x: 50, y: 50, width: 300, height: 300))
        graphTemp.backgroundColor = .blue
        self.view.addSubview(graphTemp)
        //        graphTemp.draw()
        
        let barGraph:BarGraphView = BarGraphView(frame: CGRect(x: 50, y: 300, width: 300, height: 300))
        barGraph.backgroundColor = .red
        self.view.addSubview(barGraph)
        
    
    }


}

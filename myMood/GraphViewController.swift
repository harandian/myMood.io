//
//  GraphViewController.swift
//  myMood
//
//  Created by Elle Ti on 2017-09-08.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    @IBOutlet weak var graphScrollView: UIScrollView!

    var lineGraphView: LineGraphView!
    
    let cellID = "cellID"
    
//    var centerY: CGFloat = 0.0
//    
//    var chartWidth: CGFloat = 40
//    var chartMargin: CGFloat = 5
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        //VIEW HEIRARCHY TO SHOW GRAPH -- CAN MOVE
//        //        var temp = CGRect()
//        let graphTemp:GraphView = GraphView(frame: CGRect(x: 50, y: 50, width: 300, height: 300))
//        graphTemp.backgroundColor = .blue
//        self.view.addSubview(graphTemp)
//        //        graphTemp.draw()
        
   //     centerY = graphScrollView.frame.size.height / 2
        
        lineGraphView = Bundle.main.loadNibNamed("GraphView", owner: nil, options: nil)?.first! as! LineGraphView
        self.view.addSubview(lineGraphView)

    }

    func addGraph(height:CGFloat, wColor:UIColor) {
        
        
//        let nextXOrigin = CGFloat(graphScrollView.subviews.count - 2) * chartWidth
//        graphScrollView.contentSize = CGSize(width: nextXOrigin + chartWidth, height: graphScrollView.frame.size.height)
//        
//        let normalizedHeight: CGFloat = height / 100 * (graphScrollView.frame.size.height / 2)
//        
//        let graphButton: UIButton = UIButton(frame: CGRect(x: nextXOrigin, y: 0, width: chartWidth, height: normalizedHeight))
//        
//        graphButton.frame.size = CGSize(width: graphButton.frame.size.width - chartMargin, height: graphButton.frame.size.height)
//        
//        graphButton.setTitle(String(describing:height), for: UIControlState.normal)
//        
//        graphButton.addTarget(self, action: #selector(clickAction(_:)), for: UIControlEvents.touchUpInside)
//        
//        //graphArray.add(graphButton)
//        
//        var centY: CGFloat!
//        if (wColor == UIColor.green) {
//            centY = centerY - graphButton.frame.size.height / 2
//        } else {
//            centY = centerY + graphButton.frame.size.height / 2
//        }
//        
//        let center: CGPoint = CGPoint(x: graphButton.center.x, y: centY)
//        graphButton.center = center
//        
//        graphScrollView.addSubview(graphButton)
        
    }
    
    @IBAction func clickAction(_ sender: Any) {
        let thisButton: UIButton = sender as! UIButton
        print("Clicked on %@", thisButton.title(for: UIControlState.normal) as Any)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}

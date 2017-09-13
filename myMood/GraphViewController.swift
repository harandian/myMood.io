//
//  GraphViewController.swift
//  myMood
//
//  Created by Elle Ti on 2017-09-08.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

class GraphViewController: UIView {

    let cellID = "cellID"
    
//    var centerY: CGFloat = 0.0
//    
//    var chartWidth: CGFloat = 40
//    var chartMargin: CGFloat = 5
    

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)

        //self.view.addSubview(lineGraphView)
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

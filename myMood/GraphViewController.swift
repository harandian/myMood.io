//
//  GraphViewController.swift
//  myMood
//
//  Created by Elle Ti on 2017-09-08.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, UICollectionViewDataSource {
    
    
    
    let graphView = Bundle.main.loadNibNamed("GraphView", owner: nil, options: nil)?.first! as! GraphView
    
    let cellID = "cellID"

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Data Sourse
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return graphView.graphPoints.count
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! GraphCollectionViewCell
        
        
        
        return cell
    }

}

//
//  DetailViewController.swift
//  myMood
//
//  Created by Mohammad Shahzaib Ather on 2017-09-07.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var happinessIndex : Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.lightGray
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }

}

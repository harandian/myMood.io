//
//  History.swift
//  myMood
//
//  Created by Hirad on 2017-09-11.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let moodLineGraph = GraphView()

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToTable))
        self.view.backgroundColor = UIColor.cyan
        moodLineGraph.isUserInteractionEnabled = true
        moodLineGraph.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        view.addSubview(moodLineGraph)
        moodLineGraphSetup()
        
        // Do any additional setup after loading the view.
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
    
    func moodLineGraphSetup(){
        
        moodLineGraph.translatesAutoresizingMaskIntoConstraints = false
        
        moodLineGraph.heightAnchor.constraint(equalToConstant: view.bounds.height/3).isActive = true
        moodLineGraph.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        moodLineGraph.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
    }
    
    func goToTable() {
        let historyListViewController = HistoryListViewController()
        self.navigationController?.pushViewController(historyListViewController, animated: true)
        
    }
    
    

}

//
//  History.swift
//  myMood
//
//  Created by Hirad on 2017-09-11.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //   let moodLineGraph = GraphView()
    
    var entries: [Entry] = []
    var dateString = ""
    
    var lineGraphView = Bundle.main.loadNibNamed("LineGraphView", owner: nil, options: nil)?.first! as! LineGraphView
    var barGraphView = Bundle.main.loadNibNamed("BarGraphView", owner: nil, options: nil)?.first! as! BarGraphView
    
    let scrollViewGraphView: UIScrollView = {
        let view = UIScrollView.init(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToTable))
        self.view.backgroundColor = UIColor.white
        tapGesture.delegate = self
        scrollViewForGraphSetup()
        //  graphConstraints()
        
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
    func goToTable() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let historyListViewController =  storyboard.instantiateViewController(withIdentifier: "historyViewController")//HistoryListViewController()
        self.navigationController?.pushViewController(historyListViewController, animated: true)
    }
    
    func graphConstraints() {
        scrollViewGraphView.addSubview(barGraphView)
        
        barGraphView.translatesAutoresizingMaskIntoConstraints = false
        barGraphView.topAnchor.constraint(equalTo: scrollViewGraphView.topAnchor, constant: 0).isActive = true
        barGraphView.leadingAnchor.constraint(equalTo: super.view.leadingAnchor, constant: 0).isActive = true
        barGraphView.trailingAnchor.constraint(equalTo: super.view.trailingAnchor, constant: 0).isActive = true
        barGraphView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        barGraphView.layer.borderWidth = 1
        
        scrollViewGraphView.addSubview(lineGraphView)
        
        lineGraphView.translatesAutoresizingMaskIntoConstraints = false
        lineGraphView.topAnchor.constraint(equalTo: barGraphView.bottomAnchor, constant: 0).isActive = true
        lineGraphView.leadingAnchor.constraint(equalTo: super.view.leadingAnchor, constant: 0).isActive = true
        lineGraphView.trailingAnchor.constraint(equalTo: super.view.trailingAnchor, constant: 0).isActive = true
        lineGraphView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        lineGraphView.layer.borderWidth = 1
        
        
        
        
        
        
    }
    
    func scrollViewForGraphSetup() {
        self.view.addSubview(scrollViewGraphView)
        scrollViewGraphView.backgroundColor = UIColor.white
        //  scrollViewGraphView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        scrollViewGraphView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        scrollViewGraphView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        scrollViewGraphView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        scrollViewGraphView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        let scrollViewCenterXConstraint = scrollViewGraphView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        scrollViewCenterXConstraint.isActive = true
        scrollViewCenterXConstraint.identifier = "scrollviewxConstraint"
        graphConstraints()
        
        
        
    }
}

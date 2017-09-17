//
//  HistoryListViewController.swift
//  myMood
//
//  Created by Hirad on 2017-09-11.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

class HistoryListViewController: UIViewController, UITableViewDataSource {
    var scrollChartView = Bundle.main.loadNibNamed("ChartScrollView", owner: nil, options: nil)?.first! as! ChartScrollController
    
    @IBOutlet weak var historyListTableView: UITableView!
    @IBOutlet weak var myScrollView: UIView!
    
    var entries:[Entry] = []
    var dateString = ""
    let overlay = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entries = FirebaseDBController.shared.get_allEntries()
        
        view.backgroundColor = UIColor.brown
        scrollChartView.frame = myScrollView.frame
        
        myScrollView.addSubview(scrollChartView)
        setupOverlay()
        
    }
    
    func passEntryThrough(entry:[Entry]){
        entries = entry
        historyListTableView.reloadData()
    }
    
    /*
 
     Gesture Setup
 
    */
    
    func setupOverlay() {
        overlay.frame = myScrollView.frame
        overlay.backgroundColor = UIColor.clear
        
        //Gestures
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        leftSwipe.direction = UISwipeGestureRecognizerDirection.left
        overlay.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
        overlay.addGestureRecognizer(rightSwipe)
        
        //Taps
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(tapChart))
        overlay.addGestureRecognizer(tapGest)
        
        self.view.addSubview(overlay)
    }
    
    func tapChart(sender: UITapGestureRecognizer){
        print(self.overlay.alpha)
        if self.overlay.frame == self.historyListTableView.frame{
            UIView.animate(withDuration: 0.25, animations: { 
                self.overlay.backgroundColor = UIColor.clear
            }, completion: { (true) in
                self.overlay.frame = self.myScrollView.frame
            })
        } else {
            self.overlay.frame = self.historyListTableView.frame
            UIView.animate(withDuration: 0.25) {
                self.overlay.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
            }
        }
    }
    
    func swipeLeft(sender: UISwipeGestureRecognizer) {
        let scrollView:UIScrollView = scrollChartView.chartScrollView
        var xVal = scrollView.contentOffset.x + scrollView.frame.width
        if xVal == scrollView.frame.width*3 {
            xVal = 0
        }
        let rect = CGRect(x: xVal,
                          y: scrollView.center.y,
                          width: scrollView.frame.width,
                          height: scrollView.frame.height)
        scrollChartView.chartScrollView.scrollRectToVisible(rect, animated: true)
        changePageControl(scrollView: scrollChartView, xValue:xVal)
    }
    
    func swipeRight(sender:UISwipeGestureRecognizer){
        let scrollView:UIScrollView = scrollChartView.chartScrollView
        var xVal = scrollView.contentOffset.x - scrollView.frame.width
        if xVal == -scrollView.frame.width {
            xVal = scrollView.frame.width*2
        }
        let rect = CGRect(x: xVal,
                          y: scrollView.center.y,
                          width: scrollView.frame.width,
                          height: scrollView.frame.height)
        scrollChartView.chartScrollView.scrollRectToVisible(rect, animated: true)
        changePageControl(scrollView: scrollChartView, xValue:xVal)
    }
    
    func changePageControl(scrollView:ChartScrollController, xValue:CGFloat){
        switch xValue {
        case 0.0:
            scrollView.pageControl.currentPage = 0
            break
        case scrollView.frame.width:
            scrollView.pageControl.currentPage = 1
            break
        case scrollView.frame.width*2:
            scrollView.pageControl.currentPage = 2
            break
        default: break
        }
    }
    
    /*
 
 
     Table View Setup
 
 
    */
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryTableViewCell
        
        
        
        let entry = entries[indexPath.row]
        cell.moodLabel.text = String(entry.mood)
        cell.dateLabel.text = convertDateFromUnix(unixDate: entry.date) //String(entry.date)
        
        return cell
    }
    
    func convertDateFromUnix(unixDate: Double) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(unixDate))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd YYYY"
        
        dateString = dateFormatter.string(from: date as Date)
        return dateString
    }
}

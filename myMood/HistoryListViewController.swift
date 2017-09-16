//
//  HistoryListViewController.swift
//  myMood
//
//  Created by Hirad on 2017-09-11.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

class HistoryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var scrollChartView = Bundle.main.loadNibNamed("ChartScrollView", owner: nil, options: nil)?.first! as! ChartScrollController
    
    @IBOutlet weak var historyListTableView: UITableView!
    @IBOutlet weak var myScrollView: UIView!
    
    var entries:[Entry] = []
    var dateString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        entries = FirebaseDBController.shared.get_allEntries()
        
        view.backgroundColor = UIColor.brown
        scrollChartView.frame = myScrollView.frame
        myScrollView.addSubview(scrollChartView)
        setupOverlay()
        
    }
    
    func setupOverlay() {
        let overlay = UIView()
        overlay.frame = myScrollView.frame
        overlay.backgroundColor = UIColor.clear
        
        //Gestures
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        leftSwipe.direction = UISwipeGestureRecognizerDirection.left
        overlay.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
        overlay.addGestureRecognizer(rightSwipe)
        
        self.view.addSubview(overlay)
    }
    
    func swipeLeft(sender: UISwipeGestureRecognizer) {
        let scrollView:UIScrollView = scrollChartView.myScrollView
        var xVal = scrollView.contentOffset.x + scrollView.frame.width
        if xVal == scrollView.frame.width*3 {
            xVal = 0
        }
        let rect = CGRect(x: xVal,
                          y: scrollView.center.y,
                          width: scrollView.frame.width,
                          height: scrollView.frame.height)
        scrollChartView.myScrollView.scrollRectToVisible(rect, animated: true)
        changePageControl(scrollView: scrollChartView, xValue:xVal)
    }
    
    func swipeRight(sender:UISwipeGestureRecognizer){
        let scrollView:UIScrollView = scrollChartView.myScrollView
        var xVal = scrollView.contentOffset.x - scrollView.frame.width
        if xVal == -scrollView.frame.width {
            xVal = scrollView.frame.width*2
        }
        let rect = CGRect(x: xVal,
                          y: scrollView.center.y,
                          width: scrollView.frame.width,
                          height: scrollView.frame.height)
        scrollChartView.myScrollView.scrollRectToVisible(rect, animated: true)
        changePageControl(scrollView: scrollChartView, xValue:xVal)
    }
    
    func changePageControl(scrollView:ChartScrollController, xValue:CGFloat){
        print(scrollView.myScrollView.contentOffset.x)
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

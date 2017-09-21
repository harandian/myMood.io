//
//  HistoryListViewController.swift
//  myMood
//
//  Created by Hirad on 2017-09-11.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit
import Firebase


class HistoryListViewController: UIViewController, UITableViewDataSource,LineGraphViewDelegate, BarGraphViewDelegate, UINavigationControllerDelegate {
    var scrollChartView = Bundle.main.loadNibNamed("ChartScrollView", owner: nil, options: nil)?.first! as! ChartScrollController

    @IBOutlet weak var historyListTableView: UITableView!
    @IBOutlet weak var myScrollView: UIView!
    
    var entries:[Entry] = []
    var dateString = ""
    let overlay = UIView()
    var allStrings:String = String()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutUser))
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        entries = FirebaseDBController.shared.get_allEntries()
        
       

        view.backgroundColor = UIColor.brown
        scrollChartView.frame = myScrollView.frame
        
        scrollChartView.lineChart.lineGraph.delegate = self
        scrollChartView.barChart.delegate = self
        
        myScrollView.addSubview(scrollChartView)
        setupOverlay()
        
        navigationController?.delegate = self
        
    }
    func passWeekEvent(e: [Entry]) {
        entries = e
        historyListTableView.reloadData()
    }
    
    func passDayEntry(e: [Entry]) {
        entries = e
        historyListTableView.reloadData()
    }
    
   override func viewDidAppear(_ animated: Bool) {
        let tempString = setupStrings(entries: entries)
        
        let stringArray = scrollChartView.wordCount(s: tempString)
        
        scrollChartView.wordCloudLayout.setupLabel(word: stringArray)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? SliderMoodViewController {
            controller.cancelButtonPressed() // If 'Back' button pressed in HistoryListViewController, act as if 'Cancel' button in SliderMoodViewController was activated.
        }
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
        //print(self.overlay.alpha)
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
        
        cell.moodLabel.text = "Mood: \(String(entry.mood))"
        cell.dateLabel.text = convertDateFromUnix(unixDate: entry.date) //String(entry.date)
        
        return cell
    }
    
    func convertDateFromUnix(unixDate: Double) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(unixDate))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM dd YYYY"
        
        dateString = dateFormatter.string(from: date as Date)
        return dateString
    }


    // MARK: - Navigation

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Journal", sender: entries[indexPath.row])
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Journal" {
            if let indexPath = historyListTableView.indexPathForSelectedRow {
                let journalVC = segue.destination as! JournalFormViewController
                journalVC.entry = entries[indexPath.row]
            }
        }
    }
    func logoutUser()  {
        
        try! Auth.auth().signOut()
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let loginController = mainStoryBoard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginController
    }
    
    func setupStrings(entries: Array<Entry>) -> String {
        
        for entry in entries {
            if let tempString = entry.entryDescription {
                allStrings.append(tempString)
            }
        }
       // print ("these are your strings",allStrings)
        return allStrings
    }

}

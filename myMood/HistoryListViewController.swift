//
//  HistoryListViewController.swift
//  myMood
//
//  Created by Hirad on 2017-09-11.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

class HistoryListViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var historyListTableView: UITableView!
    
    var entries:[Entry] = []
    var dateString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.brown
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        entries = FirebaseDBController.shared.get_allEntries()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}

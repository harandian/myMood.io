//
//  HistoryListViewController.swift
//  myMood
//
//  Created by Hirad on 2017-09-11.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

class HistoryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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

}

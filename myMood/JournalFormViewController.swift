//
//  JournalFormViewController.swift
//  myMood
//
//  Created by Hirad on 2017-09-11.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

protocol JournalEntry {
    var journalEntry: String {get}
}

struct DayEntry: JournalEntry {
    let journalEntry: String
}

class JournalFormViewController: UIViewController {
    
    var journalTextEntryView = Bundle.main.loadNibNamed("textEntry", owner: nil, options: nil)?.first! as! TextEntry
    
    var entry: Entry?
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("SAVE", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.translatesAutoresizingMaskIntoConstraints =  false
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetup()
        buttonSaveButtonSetup()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.lightGray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewSetup()  {
        view.addSubview(journalTextEntryView)
        journalTextEntryView.translatesAutoresizingMaskIntoConstraints = false
        journalTextEntryView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        journalTextEntryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        journalTextEntryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 5).isActive = true
        journalTextEntryView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        journalTextEntryView.labelHeaderSetup()
        
    }
    
    func buttonSaveButtonSetup(){
        view.addSubview(saveButton)
        saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        saveButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        saveButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func saveButtonPressed(){
        
        let historyViewController = HistoryViewController()
        //   self.navigationController?.show(JournalFormViewController(), sender: self)
        self.navigationController?.pushViewController(historyViewController, animated: true)        
        saveMoodDescription()
    }
    
    func saveMoodDescription() {
        let myEntry = journalTextEntryView.journalText.text
//        entry.entryDescription = journalTextEntryView.journalText.text
        entry?.entryDescription = myEntry
        if let entry = self.entry {
            FirebaseDBController.shared.updateEntry(entry: entry)
        }
    }
    
}

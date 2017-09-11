//
//  JournalFormViewController.swift
//  myMood
//
//  Created by Hirad on 2017-09-11.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

class JournalFormViewController: UIViewController {
    
      var journalTextEntryView = Bundle.main.loadNibNamed("textEntry", owner: nil, options: nil)?.first! as! TextEntry

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetup()

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

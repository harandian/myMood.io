//
//  TextEntry.swift
//  myMood
//
//  Created by Hirad on 2017-09-11.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

class TextEntry: UIView, UITextViewDelegate {

    @IBOutlet weak var textEntryHeader: UILabel!
    @IBOutlet weak var journalText: UITextView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        journalText.delegate = self
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        journalText.delegate = self
        journalText.textColor = UIColor.white
        journalText.text = " How was your day?"
    }

    func labelHeaderSetup() {
        textEntryHeader.translatesAutoresizingMaskIntoConstraints = false
        textEntryHeader.bottomAnchor.constraint(equalTo: journalText.topAnchor, constant: 5).isActive = true
        textEntryHeader.leadingAnchor.constraint(equalTo: journalText.leadingAnchor, constant: 0).isActive = true
        textEntryHeader.trailingAnchor.constraint(equalTo: journalText.trailingAnchor, constant: 0).isActive = true
        textEntryHeader.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
 
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n")
        {
            self.endEditing(true)
           // let inputText = textView.text
            if textView.text.isEmpty {
                journalText.text = " How was your day?"
                return true
            }
            return false
        } else {
            return true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.white {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
}

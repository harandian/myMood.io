//
//  TextEntry.swift
//  myMood
//
//  Created by Hirad on 2017-09-11.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

protocol TextEntryDelegate {
    func updateEventWithText(journalEntry: String)
}

class TextEntry: UIView, UITextViewDelegate {
    
    var delegate: TextEntryDelegate? = nil
    
    @IBOutlet weak var journalText: UITextView!
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelHeaderSetup()
        journalText.delegate = self
        journalText.textColor = UIColor.white
        journalText.text = " How was your day?"
        
        
    }
    
    func labelHeaderSetup() {

        
        journalText.translatesAutoresizingMaskIntoConstraints = false
        journalText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        journalText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        journalText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        journalText.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        
        
        
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.delegate?.updateEventWithText(journalEntry: textView.text)
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
    
//    func textViewDidChangeSelection(_ textView: UITextView) {
//        let textString = textView.text
//        let index = textString.index(textString?.endIndex)!
//    }
    
}

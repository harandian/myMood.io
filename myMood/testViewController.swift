//
//  testViewController.swift
//  myMood
//
//  Created by Hirad on 2017-09-06.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

class testViewController: UIViewController, UITextViewDelegate {
    
    let tempview:UIView = wordCloudLayoutGenerator()
    var wordCloudLayout = Bundle.main.loadNibNamed("wordCloudLayout", owner: nil, options: nil)?.first! as! wordCloudLayoutGenerator
    @IBOutlet weak var journalText: UITextView!
    
    //    var customLayout = Bundle.main.loadNibNamed("CustomWordCloudLayout1", owner: nil, options: nil)?.first! as! WordCloudLayout1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        journalText.delegate = self
        // Do any additional setup after loading the view.
        
        wordCloudLayout.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        wordCloudLayout.center.y = self.view.center.y + 100
        wordCloudLayout.center.x = self.view.center.x
        self.view.addSubview(wordCloudLayout)
        wordCloudLayout.initalLabelSetup()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func wordCount(s: String) -> Array <(String, Int)>{
        var sortedArray:Array<(String,Int)> = Array()
        let myString = s.lowercased()
        let words:Array = myString.components(separatedBy: .whitespaces).map { (word) -> String in
            return word.trimmingCharacters(in: .punctuationCharacters)
        }
        let wordToIngore:Array = ["is","your", "a","i","in","to","it", "as", "on", "blah", "had", "the", "am", "of"]
        let filterdWords = words.filter { (string) -> Bool in
            if wordToIngore.contains(string) {
                return false
            } else {
                return true
            }
        }
        var wordDictionary:Dictionary = Dictionary<String, Int>()
        for word:String in filterdWords {
            if let count = wordDictionary[word] {
                wordDictionary[word] = count + 1
            } else {
                wordDictionary[word] = 1
            }
        }
        for (word,repeated) in wordDictionary {
            sortedArray.append((word,repeated))
        }
        sortedArray.sort(by: { (value1: (String, Int), value2: (String, Int)) -> Bool in
            return value1.1 < value2.1
        })
        sortedArray = sortedArray.reversed()
        print ((sortedArray))
        return sortedArray
        
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n")
        {
            //sortedArray.removeAll()
            view.endEditing(true)
            let inputText = textView.text
            let tempArray:Array<(String, Int)> = wordCount(s: inputText!)
            if tempArray.count < 5
            {
                throwAllert(alertTitle: "Alert", alertMessage: "Please type at least 20 characters")
                throwAllert(alertTitle: "Alert", alertMessage: "Please type at least 20 words")
                return true
            }
            wordCloudLayout.setupLabel(word: tempArray)
            return false
        } else {
            return true
        }
    }
    
    func throwAllert(alertTitle:String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle , message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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

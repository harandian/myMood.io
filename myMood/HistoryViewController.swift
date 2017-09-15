//
//  History.swift
//  myMood
//
//  Created by Hirad on 2017-09-11.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //   let moodLineGraph = GraphView()
    
    var entries: [Entry] = []
    var dateString = ""
    
    var lineGraphView = Bundle.main.loadNibNamed("LineGraphView", owner: nil, options: nil)?.first! as! LineGraphView
    var barGraphView = Bundle.main.loadNibNamed("BarGraphView", owner: nil, options: nil)?.first! as! BarGraphView
    let tempview:UIView = wordCloudLayoutGenerator()
    
    var wordCloudLayout = Bundle.main.loadNibNamed("wordCloudLayout", owner: nil, options: nil)?.first! as! wordCloudLayoutGenerator
    
    let scrollViewGraphView: UIScrollView = {
        let view = UIScrollView.init(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToTable))
        
        self.view.backgroundColor = UIColor.white
        tapGesture.delegate = self
        scrollViewForGraphSetup()
        wordCloudLayout.initalLabelSetup()

        //  graphConstraints()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func goToTable() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let historyListViewController =  storyboard.instantiateViewController(withIdentifier: "historyViewController")//HistoryListViewController()
        self.navigationController?.pushViewController(historyListViewController, animated: true)
    }
    
    func graphConstraints() {
        scrollViewGraphView.addSubview(barGraphView)
        
        barGraphView.translatesAutoresizingMaskIntoConstraints = false
        barGraphView.topAnchor.constraint(equalTo: scrollViewGraphView.topAnchor, constant: 0).isActive = true
        barGraphView.leadingAnchor.constraint(equalTo: super.view.leadingAnchor, constant: 0).isActive = true
        barGraphView.trailingAnchor.constraint(equalTo: super.view.trailingAnchor, constant: 0).isActive = true
        barGraphView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        barGraphView.layer.borderWidth = 1
        
        scrollViewGraphView.addSubview(lineGraphView)
        
        lineGraphView.translatesAutoresizingMaskIntoConstraints = false
        lineGraphView.topAnchor.constraint(equalTo: barGraphView.bottomAnchor, constant: 0).isActive = true
        lineGraphView.leadingAnchor.constraint(equalTo: super.view.leadingAnchor, constant: 0).isActive = true
        lineGraphView.trailingAnchor.constraint(equalTo: super.view.trailingAnchor, constant: 0).isActive = true
        lineGraphView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        lineGraphView.layer.borderWidth = 1
        
        
        
        
        
        
    }
    
    func scrollViewForGraphSetup() {
        self.view.addSubview(scrollViewGraphView)
        scrollViewGraphView.backgroundColor = UIColor.white
        //  scrollViewGraphView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        scrollViewGraphView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        scrollViewGraphView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        scrollViewGraphView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        scrollViewGraphView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        let scrollViewCenterXConstraint = scrollViewGraphView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        scrollViewCenterXConstraint.isActive = true
        scrollViewCenterXConstraint.identifier = "scrollviewxConstraint"
        graphConstraints()

    }
    
    func wordCloudViewSetup() {
        scrollViewGraphView.addSubview(wordCloudLayout)
        
        
        
        
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
    
    
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if(text == "\n")
//        {
//            //sortedArray.removeAll()
//            view.endEditing(true)
//            let inputText = textView.text
//            let tempArray:Array<(String, Int)> = wordCount(s: inputText!)
//            if tempArray.count < 5
//            {
//                throwAllert(alertTitle: "Alert", alertMessage: "Please type at least 20 characters")
//                throwAllert(alertTitle: "Alert", alertMessage: "Please type at least 20 words")
//                return true
//            }
//            wordCloudLayout.setupLabel(word: tempArray)
//            return false
//        } else {
//            return true
//        }
//    }
//    
//    func throwAllert(alertTitle:String, alertMessage: String) {
//        let alert = UIAlertController(title: alertTitle , message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }

}

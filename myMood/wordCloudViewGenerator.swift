//
//  wordCloudViewGenerator.swift
//  myMood
//
//  Created by Hirad on 2017-09-06.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

class wordCloudViewGenerator: UIView {

    
    
    
    var wordCloudView:UIView = UIView(frame: CGRect.zero)
    var mainLabel:UILabel = UILabel()
    
    var customLayout = Bundle.main.loadNibNamed("CustomWordCloudLayout1", owner: nil, options: nil)?.first! as! WordCloudLayout1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        let myString:String = "Once you are locked in the journaling habit, you will automatically see an increase in other positive life habits. Personally, I started to feel less worried about things. Before I journaled, I sometimes felt a big confusion in my head; now, all that confusion is resting on Day One, ready for me to analyze it when I’m in a calmer state of mind."
        
        
        wordCloudView.translatesAutoresizingMaskIntoConstraints = false
        wordCloudView.backgroundColor = UIColor.white
        self.view.addSubview(wordCloudView)
        let horizontalConstraint = wordCloudView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = wordCloudView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let widthConstraint = wordCloudView.widthAnchor.constraint(equalToConstant: self.view.frame.width)
        let heighConstraint = wordCloudView.heightAnchor.constraint(equalToConstant: self.view.frame.height/3)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heighConstraint])
        
        print((wordCount(s: myString)))
        
      //  self.view.addSubview(customLayout)
        
        
        
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
    
    func wordCount(s: String) -> Array<(String, Int)> {
        let myString = s.lowercased()
        let words:Array = myString.components(separatedBy: .whitespaces).map { (word) -> String in
            return word.trimmingCharacters(in: .punctuationCharacters)
        }
        var sortedArray:Array<(String,Int)> = Array()
        let wordToIngore:Array = ["my","is","your", "a","i","in","to","it"]
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
        anchorLabelSetup(wordArray: sortedArray.reversed())
        customLayout.setupLabelXib(word: (sortedArray.reversed().first?.0)!)
        return sortedArray.reversed()
    }
    
    func anchorLabelSetup(wordArray: Array<(String, Int)>) {
        
        var n = wordArray.count
        
        if n > 10 {
            n = 10
        }
        var wordArray = Array(wordArray[0..<n])
        mainLabelConstraint(mainLabel: mainLabel)
        mainLabel.text = wordArray.first?.0.capitalized
        //mainLabel.textColor = UIColor.red
        mainLabel.font = UIFont.systemFont(ofSize: CGFloat(randomNumberGen(lower: 40, upper: 60)), weight: 3)
        wordArray.remove(at: 0)
        addLabels(wordArray: wordArray, anchorLabel: mainLabel)
    }
    
    func addLabels(wordArray: Array<(String, Int)>, anchorLabel: UILabel ) {
        var labelsArray:Array<UILabel> = Array()
        for word in wordArray {
            let wordCloudLabel:UILabel = UILabel ()
            wordCloudView.addSubview(wordCloudLabel)
            labelSetup(wordCloudLabel: wordCloudLabel)
            wordCloudLabel.text = word.0.capitalized
            wordCloudLabel.transform = CGAffineTransform(rotationAngle: randomAngle())
            wordCloudLabel.font = UIFont.systemFont(ofSize: CGFloat(randomNumberGen(lower: 20, upper: 40)), weight: CGFloat(randomNumberGen(lower: 1, upper: 4)))
            labelsArray.append(wordCloudLabel)
            checkIntersection(labelsArray: labelsArray)
            
            
            
        }
        
    }
    func randomNumberGen(lower: Int32, upper: Int32) -> Int {
        
        return Int(lower + Int32(arc4random_uniform(UInt32(abs(upper - lower)))))
    }
    
    func mainLabelConstraint(mainLabel: UILabel) {
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.backgroundColor = UIColor.blue
        wordCloudView.addSubview(mainLabel)
        let labelHorConstraint = mainLabel.centerXAnchor.constraint(equalTo: wordCloudView.centerXAnchor)
        let labelVerConstraint = mainLabel.centerYAnchor.constraint(equalTo: wordCloudView.centerYAnchor)
        mainLabel.clipsToBounds = false
        NSLayoutConstraint.activate([labelHorConstraint,labelVerConstraint])
        mainLabel.transform = CGAffineTransform(rotationAngle: randomAngle())
        
    }
    
    func labelSetup(wordCloudLabel: UILabel) {
        wordCloudLabel.translatesAutoresizingMaskIntoConstraints = false
        let yConstraint = wordCloudLabel.centerYAnchor.constraint(equalTo: mainLabel.centerYAnchor, constant: CGFloat(randomNumberGen(lower: -100, upper: 100)))
        let xConstraint = wordCloudLabel.centerXAnchor.constraint(equalTo: mainLabel.centerXAnchor, constant: CGFloat(randomNumberGen(lower: -100, upper: 100)))
        let zConstraint = wordCloudLabel.bottomAnchor.constraint(equalTo: mainLabel.topAnchor)
        wordCloudLabel.clipsToBounds = true
        NSLayoutConstraint.activate([yConstraint, xConstraint, zConstraint])
        wordCloudLabel.isHidden = false
    }
    
    func checkIntersection(labelsArray: Array<UILabel>) {
        var newArray:Array<UILabel> = Array()
        for label in labelsArray {
            
            if label.frame.intersects(mainLabel.frame)
            {
                let yConstraint = label.centerYAnchor.constraint(equalTo: mainLabel.centerYAnchor, constant: CGFloat(randomNumberGen(lower: -150, upper: 150)))
                let xConstraint = label.centerXAnchor.constraint(equalTo: mainLabel.centerXAnchor, constant: CGFloat(randomNumberGen(lower: -150, upper: 150)))
                NSLayoutConstraint.activate([yConstraint, xConstraint])
                label.isHidden = false
                newArray.append(label)
            }
            
        }
        
    }
    
    func randomAngle() -> CGFloat {
        let x = Int(arc4random_uniform(5))
        
        switch x {
        case 0:
            return 0.0
        case 1:
            return CGFloat.pi/2
        case 2:
            return -CGFloat.pi/2
        case 3:
            return 0.0
        case 4:
            return 0.0
        case 5:
            return 0.0
        default:
            return 0.0
        }
    }
}

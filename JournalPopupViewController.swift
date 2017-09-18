//
//  JournalPopupViewController.swift
//  myMood
//
//  Created by Elle Ti on 2017-09-15.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

class JournalPopupViewController: UIViewController {

    @IBOutlet weak var segmentedView: UISegmentedControl!
    @IBOutlet weak var entryView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    
    let textEntry:UIView = Bundle.main.loadNibNamed("textEntry", owner: nil, options: nil)?.first! as! TextEntry
    let imageEntry:UIView = Bundle.main.loadNibNamed("ImagePicker", owner: nil, options: nil)?.first! as! ImagePicker
    let locationEntry:UIView = Bundle.main.loadNibNamed("map", owner: nil, options: nil)?.first! as! MapController
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        showAnimate()

        let tappedOutside = UITapGestureRecognizer(target: self, action: #selector(removeAnimate))
        self.view.addGestureRecognizer(tappedOutside)


        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupOverlapViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupOverlapViews() {
        
        
//     textEntry.frame = entryView.frame
//     imageEntry.frame = entryView.frame
//     locationEntry.frame = entryView.frame
//     textEntry.center = entryView.center
        textEntry.layer.borderWidth = 1
        imageEntry.layer.borderWidth = 1
        locationEntry.layer.borderWidth = 1
    

        
        textEntry.isHidden = false
        imageEntry.isHidden = true
        locationEntry.isHidden = true
        
    }
    

    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
                self.view.alpha = 1.0
                self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    //TODO - Call this where you need to dismiss
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished: Bool) in
            if (finished) {
                self.view.removeFromSuperview()
            } })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func nextOrDoneButton(_ sender: UIButton) {
        
        
    }
    

    @IBAction func segmentedView(_ sender: UISegmentedControl) {
        switch segmentedView.selectedSegmentIndex {
        case 0:
            textEntry.isHidden = false
            imageEntry.isHidden = true
            locationEntry.isHidden = true
            break
        case 1:
            textEntry.isHidden = true
            imageEntry.isHidden = false
            locationEntry.isHidden = true
            break
        case 2:
            textEntry.isHidden = true
            imageEntry.isHidden = true
            locationEntry.isHidden = false
            break
        default:
            break
        }
    }
    
    func setConstraints() {
        entryView.addSubview(textEntry)
        entryView.addSubview(imageEntry)
        entryView.addSubview(locationEntry)
        
        textEntry.translatesAutoresizingMaskIntoConstraints = false
        textEntry.topAnchor.constraint(equalTo: segmentedView.bottomAnchor, constant: 0).isActive = true
        textEntry.leadingAnchor.constraint(equalTo: entryView.leadingAnchor, constant: 0).isActive = true
        textEntry.trailingAnchor.constraint(equalTo: entryView.trailingAnchor, constant: 0).isActive = true
        textEntry.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: 0).isActive = true
        
        imageEntry.translatesAutoresizingMaskIntoConstraints = false
        imageEntry.topAnchor.constraint(equalTo: segmentedView.bottomAnchor, constant: 0).isActive = true
        imageEntry.leadingAnchor.constraint(equalTo: entryView.leadingAnchor, constant: 0).isActive = true
        imageEntry.trailingAnchor.constraint(equalTo: entryView.trailingAnchor, constant: 0).isActive = true
        imageEntry.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: 0).isActive = true
        
        locationEntry.translatesAutoresizingMaskIntoConstraints = false
        locationEntry.topAnchor.constraint(equalTo: segmentedView.bottomAnchor, constant: 0).isActive = true
        locationEntry.leadingAnchor.constraint(equalTo: entryView.leadingAnchor, constant: 0).isActive = true
        locationEntry.trailingAnchor.constraint(equalTo: entryView.trailingAnchor, constant: 0).isActive = true
        locationEntry.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: 0).isActive = true
    
    }
    
}

//
//  JournalFormViewController.swift
//  myMood
//
//  Created by Hirad on 2017-09-11.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit
import CoreLocation


protocol JournalEntry {
    var journalEntry: String {get}
}

struct DayEntry: JournalEntry {
    let journalEntry: String
}


class JournalFormViewController: UIViewController, ImagePickerDelegate, MapControllerDelegate {

    
    var journalTextEntryView = Bundle.main.loadNibNamed("textEntry", owner: nil, options: nil)?.first! as! TextEntry
    var mapView = Bundle.main.loadNibNamed("map", owner: nil, options: nil)?.first! as! MapController
    
    var imagePicker = Bundle.main.loadNibNamed("ImagePicker", owner: nil, options: nil)?.first! as! ImagePicker
    
    
    var entry: Entry?
    
    let scrollView: UIScrollView = {
        let view = UIScrollView.init(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("SAVE", for: .normal)
        button.backgroundColor = UIColor.green
        button.translatesAutoresizingMaskIntoConstraints =  false
        button.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
        button.alpha = 0.5
        return button
        
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("BACK", for: .normal)
        button.backgroundColor = UIColor.blue
        button.translatesAutoresizingMaskIntoConstraints =  false
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.alpha = 0.5
        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(continueButton)
        view.addSubview(backButton)
        subViewSetup()
        // saveButtonSetup()
        setButtonConstraints()
        //  viewSetup()
        
        //Delegate setup
        let imagePicker = ImagePicker()
        imagePicker.delegate = self
        
        let mapController = MapController()
        mapController.delegate = self
        
        //Update map location if entry includes location
        if let loc = entry?.location {
            mapView.turnOnMap(location: loc)
        }
        
        self.view.backgroundColor = UIColor.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewSetup()  {
        journalTextEntryViewSetup()
    }
    
    
    func saveMoodDescription() {
        let myEntry = journalTextEntryView.journalText.text
        //        entry.entryDescription = journalTextEntryView.journalText.text
        entry?.entryDescription = myEntry
        if let entry = self.entry {
            FirebaseDBController.shared.updateEntry(entry: entry)
        }
    }
    
    func journalTextEntryViewSetup() {
        scrollView.addSubview(journalTextEntryView)
        journalTextEntryView.layer.borderWidth = 1
        journalTextEntryView.translatesAutoresizingMaskIntoConstraints = false
        journalTextEntryView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        journalTextEntryView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        journalTextEntryView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        journalTextEntryView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        journalTextEntryView.labelHeaderSetup()
        imageViewSetup()
        
    }
    
    func mapViewSetup() {
        scrollView.addSubview(mapView)
        mapView.layer.borderWidth = 1
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        mapView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        mapView.topAnchor.constraint(equalTo: imagePicker.bottomAnchor, constant: 0).isActive = true
        mapView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        mapView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        // mapView.removeFromSuperview()
        
        
    }
    
    func imageViewSetup(){
        scrollView.addSubview(imagePicker)
        mapViewSetup()
        imagePicker.layer.borderWidth = 1
        imagePicker.translatesAutoresizingMaskIntoConstraints = false
        imagePicker.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        imagePicker.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        imagePicker.heightAnchor.constraint(equalToConstant: 300).isActive = true
        imagePicker.topAnchor.constraint(equalTo: journalTextEntryView.bottomAnchor, constant: 0).isActive = true
        imagePicker.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        imagePicker.backgroundColor = UIColor.red
        
        
    }
    
    func subViewSetup() {
        
        self.view.addSubview(scrollView)
        journalTextEntryViewSetup()
        scrollView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: 0).isActive = true
        let scrollViewCenterXConstraint = scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        scrollViewCenterXConstraint.isActive = true
        scrollViewCenterXConstraint.identifier = "scrollviewxConstraint"
        
        
    }
    
    func continueButtonPressed() {
        let historyViewController = HistoryViewController()
        
        self.navigationController?.pushViewController(historyViewController, animated: true)
        saveMoodDescription()
        
    }
    
    func backButtonPressed() {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setButtonConstraints () {
        continueButton.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 0).isActive = true
        continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        backButton.heightAnchor.constraint(equalTo: continueButton.heightAnchor, constant: 0).isActive = true
        backButton.bottomAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 0).isActive = true
    }
    
    
    //Delegation functions
    func updateEventWithImage(image: UIImage) {
        let photo:Photo = Photo(photo: image)
        self.entry?.photo = photo
        FirebaseDBController.shared.insertPhoto(entry: self.entry!)
    }
    
    func updateEventWithLocation(location: CLLocation) {
        self.entry?.location = location
    }
    
    func removeEventLocation() {
        self.entry?.location = nil
    }
}

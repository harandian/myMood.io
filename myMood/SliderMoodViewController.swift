//
//  SliderMoodViewController.swift
//  myMood
//
//  Created by Mohammad Shahzaib Ather on 2017-09-05.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit
import CoreGraphics
import QuartzCore

class SliderMoodViewController: UIViewController , UIGestureRecognizerDelegate {
    
    let step = Float(10)
    
    var happinessIndex: Int  = 0
    
    var entry: Entry = Entry.init(mood: 0)
    
    var tapLocation = CGFloat()
    
    let containerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray
        view.alpha = 0.5
        view.layer.cornerRadius = 5
        return view
        
    }()
    
    
    let topColoredView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.green
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 3
        return view
        
    }()
    let bottomColoredView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.blue
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 3
        return view
        
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("SAVE", for: .normal)
        button.backgroundColor = UIColor.green
        button.translatesAutoresizingMaskIntoConstraints =  false
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        button.alpha = 0.5
        return button
        
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("CANCEL", for: .normal)
        button.backgroundColor = UIColor.blue
        button.translatesAutoresizingMaskIntoConstraints =  false
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        button.alpha = 0.5
        return button
        
    }()
    
    let topNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let botNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "myMood"
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.black.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 60)
        return label
    }()
    
    let discLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Please Swipe Up or Down\nto Rate your Mood"
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.black.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    } ()
    
    
    // VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // let nav = UINavigationBar()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))

        view.addSubview(containerView)
        view.addSubview(saveButton)
        view.addSubview(cancelButton)
        view.addSubview(topNumberLabel)
        view.addSubview(botNumberLabel)
        view.addSubview(mainLabel)
        view.addSubview(discLabel)
        navigationItem.rightBarButtonItem = add
        saveButton.isEnabled = false
        saveButton.backgroundColor = UIColor.gray
        
        labelSetup()
        containerViewContraints()
        topColoredViewConstraints()
        bottomColoredViewConstraints()
        setButtonConstraints()
        drawDashLine()
        
        
        let swipe = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        containerView.addGestureRecognizer(swipe)
        
        let touch = UITapGestureRecognizer(target: self, action: #selector(touchGesture))
        containerView.addGestureRecognizer(touch)
        
        self.view.backgroundColor = UIColor.white
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dashBoarder()
    }
    
    
    var containerViewHeight : NSLayoutConstraint?
    var topViewHeightConstraint : NSLayoutConstraint?
    var bottomViewHeightContraint: NSLayoutConstraint?
    
    
    func containerViewContraints(){
        containerView.addSubview(topColoredView)
        containerView.addSubview(bottomColoredView)
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = false
        containerView.widthAnchor.constraint(equalToConstant: view.bounds.width/5).isActive = true
        containerViewHeight = containerView.heightAnchor.constraint(equalToConstant: 385)
        containerViewHeight?.isActive = true
        
    }
    
    
    func topColoredViewConstraints() {
        
        topColoredView.bottomAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        topColoredView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        topColoredView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        topViewHeightConstraint = topColoredView.heightAnchor.constraint(equalToConstant: 0)
        topViewHeightConstraint?.isActive = true
        
    }
    
    func bottomColoredViewConstraints () {
        
        bottomColoredView.topAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        bottomColoredView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        bottomColoredView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        bottomViewHeightContraint = bottomColoredView.heightAnchor.constraint(equalToConstant: 0)
        bottomViewHeightContraint?.isActive = true
    }
    
    func setButtonConstraints () {
        
        saveButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 0).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: saveButton.heightAnchor, constant: 0).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 0).isActive = true
        
    }
    
    func labelSetup () {
        
        topNumberLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        topNumberLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100).isActive = true
        topNumberLabel.isHidden = true
        botNumberLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        botNumberLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 100).isActive = true
        botNumberLabel.isHidden = true
        
        topNumberLabel.font = UIFont.boldSystemFont(ofSize: 60)
        topNumberLabel.textColor = UIColor.white
        botNumberLabel.font = UIFont.boldSystemFont(ofSize: 60)
        botNumberLabel.textColor = UIColor.white
        
        mainLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        mainLabel.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 0)
        mainLabel.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -30).isActive = true
        mainLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width/2).isActive = true
        
        discLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        discLabel.bottomAnchor.constraint(equalTo: self.saveButton.topAnchor, constant: 30).isActive = true
        discLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10).isActive = true
        //   discLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width/2).isActive = true
        
        
    }
    
    
    func saveButtonPressed () {
        //        let journalFormViewController = JournalFormViewController()
        //   self.navigationController?.show(JournalFormViewController(), sender: self)
        //        self.navigationController?.pushViewController(journalFormViewController, animated: true)
        print(123)
        saveNewMood()
        
        //******** Go to JournalView ********
        performSegue(withIdentifier: "Journal", sender: self)
        
        //******** Show new view with objects on top of Slider VC ********
        //        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popupvc") as! JournalPopupViewController
        //        self.addChildViewController(popOverVC)
        //        popOverVC.view.frame = self.view.frame
        //        self.view.addSubview(popOverVC.view)
        //        popOverVC.didMove(toParentViewController: self)
        
        //******** Show Action Controller ********
   
    }
    
    func addTapped()  {
        
        self.popupJournalEntry()
//        let alertController = UIAlertController(title: "myMood", message: "Please select an action", preferredStyle: .actionSheet)
//        alertController.addAction(UIAlertAction(title: "Add Entry Details", style: .default, handler: self.popupJournalEntry))
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        self.present(alertController, animated: true, completion: nil)    
    }
    
    func saveNewMood() {
        let myEntry: Entry = Entry.init(mood: happinessIndex)
        entry = myEntry
        FirebaseDBController.shared.insertEntry(entry: myEntry)
    }
    
    func cancelButtonPressed() {
        
        tapLocation = CGFloat(containerView.frame.height/2)
        setupSliders(tapLocation: tapLocation)
        happinessIndex = 0
        labelTextSetup(happinessIndex: happinessIndex)
        print("this is the tap location",tapLocation,"happiness index is",happinessIndex)
        saveButton.backgroundColor = UIColor.gray
        saveButton.isEnabled = false
    }
    
    
    // GESTURE RECGONIZERS
    
    func panGesture (sender: UIPanGestureRecognizer) {
        
        tapLocation = sender.location(in: containerView).y
        setupSliders(tapLocation: tapLocation)
        saveButton.isEnabled = true
        saveButton.backgroundColor = UIColor.green
        let point:CGPoint = sender.location(in: containerView)
        let percentage:CGFloat = point.y/containerView.frame.height
        var value:CGFloat = -1*((21.0 * percentage)-10.0)
        if (value > 10 ) {
            value = 10
        } else if(value < -10) {
            value = -10
        }
        
        happinessIndex = valueSetToOne(value: value)
        labelTextSetup(happinessIndex: happinessIndex)
    }
    func setupSliders(tapLocation: CGFloat) {
        //Bottom Section
        if tapLocation > containerView.frame.size.height/2 {
            topViewHeightConstraint?.constant = 0
            if (bottomViewHeightContraint?.constant)! <= containerView.frame.height/2 {
                bottomViewHeightContraint?.constant = abs(tapLocation - (containerView.frame.size.height/2))
            }
        } else {
            //Top Section
            bottomViewHeightContraint?.constant = 0
            if ((topViewHeightConstraint?.constant)! <= containerView.frame.height/2){
                topViewHeightConstraint?.constant = abs(tapLocation - (containerView.frame.size.height/2))
            } else {
                topViewHeightConstraint?.constant = containerView.frame.size.height/2
            }
        }
        
        if (bottomViewHeightContraint?.constant)! > containerView.frame.height/2 {
            bottomViewHeightContraint?.constant = containerView.frame.size.height/2
        }
        
        if (topViewHeightConstraint?.constant)! > containerView.frame.height/2 {
            topViewHeightConstraint?.constant = containerView.frame.size.height/2
        }
        
        
        //TODO - GET THE VALUE OF THE MEASUREMENT - DEPENDENT ON HEIGHT OF RECTANGLE
        // Range is -10 -> 10
        
    }
    
    
    func touchGesture(sender: UITapGestureRecognizer)  {
        print ("Tap here \(sender.location(in: containerView))")
        let tapLocation:CGFloat = sender.location(in: containerView).y
        saveButton.isEnabled = true
        saveButton.backgroundColor = UIColor.green
        
        //Bottom Section
        if tapLocation > containerView.frame.size.height/2 {
            topViewHeightConstraint?.constant = 0
            bottomViewHeightContraint?.constant = abs(tapLocation - (containerView.frame.size.height/2))
        } else {
            //Top Section
            bottomViewHeightContraint?.constant = 0
            topViewHeightConstraint?.constant = abs(tapLocation - (containerView.frame.size.height/2))
        }
        
        let point:CGPoint = sender.location(in: containerView)
        let percentage:CGFloat = point.y/containerView.frame.height
        var value:CGFloat = -1*((21.0 * percentage)-10.0)
        if (value > 10 ) {
            value = 10
        } else if(value < -10) {
            value = -10
        }
        
        
        happinessIndex = valueSetToOne(value: value)
        labelTextSetup(happinessIndex: happinessIndex)
        
    }
    
    func drawDashLine() {
        let layer = CAShapeLayer()
        let path:UIBezierPath = UIBezierPath.init()
        let p0 = CGPoint(x: view.frame.width/4,
                         y: view.center.y)
        let  p1 = CGPoint(x: view.frame.width * 0.75,
                          y: view.center.y)
        
        path.move(to:p0)
        path.addLine(to:p1)
        
        let  dashes: [ CGFloat ] = [ 16.0, 32.0 ]
        path.setLineDash(dashes, count: dashes.count, phase: 0.0)
        
        // path.lineWidth = 12.0
        // path.lineCapStyle = .butt
        UIColor.black.setStroke()
        path.stroke()
        UIColor.black.setFill()
        path.fill()
        layer.path = path.cgPath
        layer.strokeColor = UIColor.lightGray.cgColor
        layer.lineDashPattern = [15,15,15,15]
        layer.lineWidth = 2.5
        layer.lineCap = kCALineCapSquare
        layer.backgroundColor = UIColor.red.cgColor
        self.view.layer.addSublayer(layer)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        performSegue(withIdentifier: "formSeg", sender: sender)
        
        if segue.identifier == "Journal" {
            let journal = segue.destination as? JournalFormViewController
            journal?.entry = entry
        }
    }
    
    
    
    func dashBoarder (){
        
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = UIColor.black.cgColor
        yourViewBorder.frame = containerView.bounds
        yourViewBorder.fillColor = nil
        yourViewBorder.path = UIBezierPath(rect: containerView.bounds).cgPath
        // yourViewBorder.lineDashPattern = [10,2]
        yourViewBorder.lineWidth = 3
        containerView.layer.addSublayer(yourViewBorder)
        
    }
    
    func labelTextSetup (happinessIndex: Int) {
        
        let hText = String(abs(happinessIndex))
        
        if happinessIndex > 0 {
            topNumberLabel.isHidden = false
            botNumberLabel.isHidden = true
            topNumberLabel.text = hText
        } else if happinessIndex == 0 {
            topNumberLabel.isHidden = true
            botNumberLabel.isHidden = false
            topNumberLabel.text = hText
            botNumberLabel.text = hText
        } else if happinessIndex < 0{
            topNumberLabel.isHidden = true
            botNumberLabel.isHidden = false
            botNumberLabel.text = hText
            
        } else {
            topNumberLabel.isHidden = false
            botNumberLabel.isHidden = false
        }
        
    }
    
    func valueSetToOne(value:CGFloat) -> Int {
        
        var newValue = value
        
        if value > 0 && value < 1 {
            newValue = 0
        }
        
        if value < 0 && value > -1 {
            newValue = 0
        }
        
        return Int(newValue)
    }
    
    
    //MARK: - Journal Entry Popup
    
    func popupJournalEntry() {
        let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popupvc") as! JournalPopupViewController
        self.addChildViewController(popupVC)
        popupVC.view.frame = self.view.frame
        self.view.addSubview(popupVC.view)
        popupVC.didMove(toParentViewController: self)
    }
    
}

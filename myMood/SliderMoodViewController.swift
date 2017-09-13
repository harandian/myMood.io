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
        button.backgroundColor = UIColor.cyan
        button.translatesAutoresizingMaskIntoConstraints =  false
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        return button
        
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("CANCEL", for: .normal)
        button.backgroundColor = UIColor.red
        button.translatesAutoresizingMaskIntoConstraints =  false
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return button
        
    }()
    
    
    
// VIEW DID LOAD 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: true)
        view.addSubview(containerView)
        view.addSubview(saveButton)
        view.addSubview(cancelButton)
        
        
        
        let swipe = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        containerView.addGestureRecognizer(swipe)
        
        let touch = UITapGestureRecognizer(target: self, action: #selector(touchGesture))
        containerView.addGestureRecognizer(touch)
        
        containerViewContraints()
        topColoredViewConstraints()
        bottomColoredViewConstraints()
        setButtonConstraints()
        drawDashLine()
        
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
    

    func saveButtonPressed () {
//        let journalFormViewController = JournalFormViewController()
     //   self.navigationController?.show(JournalFormViewController(), sender: self)
//        self.navigationController?.pushViewController(journalFormViewController, animated: true)
        print(123)
        saveNewMood()
        performSegue(withIdentifier: "Journal", sender: self)
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
        print("this is the tap location",tapLocation,"happiness index is",happinessIndex)        
    }

    
// GESTURE RECGONIZERS 
    
    func panGesture (sender: UIPanGestureRecognizer) {
        
        tapLocation = sender.location(in: containerView).y
        setupSliders(tapLocation: tapLocation)
        
        let point:CGPoint = sender.location(in: containerView)
        let percentage:CGFloat = point.y/containerView.frame.height
        var value:CGFloat = -1*((21.0 * percentage)-10.0)
        if (value > 10 ) {
            value = 10
        } else if(value < -10) {
            value = -10
        }
        happinessIndex = Int(value)
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
        happinessIndex = Int(value)
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

}

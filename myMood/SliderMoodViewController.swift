//
//  SliderMoodViewController.swift
//  myMood
//
//  Created by Mohammad Shahzaib Ather on 2017-09-05.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit

class SliderMoodViewController: UIViewController , UIGestureRecognizerDelegate {

    let step = Float(10)
    
    var happinessIndex: Int  = 0
    
    
    let containerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray
        view.layer.cornerRadius = 5
        return view
        
    }()
    
 
    let topColoredView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.green
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 5
        return view
        
    }()
    let bottomColoredView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.blue
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 5
        return view
        
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("SAVE", for: .normal)
        button.backgroundColor = UIColor.darkGray
        button.translatesAutoresizingMaskIntoConstraints =  false
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)

        
  
        return button
        
    }()
    
    
// VIEW DID LOAD 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        view.addSubview(containerView)
        view.addSubview(saveButton)
        
        let swipe = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        containerView.addGestureRecognizer(swipe)
        
        let touch = UITapGestureRecognizer(target: self, action: #selector(touchGesture))
        containerView.addGestureRecognizer(touch)
        
        containerViewContraints()
        topColoredViewConstraints()
        bottomColoredViewConstraints()
        setButtonConstraints()
        
        self.view.backgroundColor = UIColor.white
        
    }
    
    
    var containerViewHeight : NSLayoutConstraint?
    var topViewHeightConstraint : NSLayoutConstraint?
    var bottomViewHeightContraint: NSLayoutConstraint?


    func containerViewContraints(){
        containerView.addSubview(topColoredView)
        containerView.addSubview(bottomColoredView)
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 200).isActive = true
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
        
        saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width/2 - saveButton.bounds.width).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        
    }
    

    func saveButtonPressed () {

        let journalFormViewController = JournalFormViewController()
     //   self.navigationController?.show(JournalFormViewController(), sender: self)
        self.navigationController?.pushViewController(journalFormViewController, animated: true)
        print(123)
    }

    
// GESTURE RECGONIZERS 
    
    func panGesture (sender: UIPanGestureRecognizer) {
        let tapLocation:CGFloat = sender.location(in: containerView).y

        
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
    
    

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        performSegue(withIdentifier: "formSeg", sender: sender)
    }

}

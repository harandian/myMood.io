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
    
    var happinessIndex: Float = 0.0
    
    
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
//      var upPanGesture = UIPanGestureRecognizer(target: self, action: #selector(upGesture))
//      view.addGestureRecognizer(upPanGesture)
        return view
        
    }()
    let bottomColoredView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.blue
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 5
//      var downPanGesture = UIPanGestureRecognizer(target: self, action: #selector(downGesture))
//      view.addGestureRecognizer(downPanGesture)
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
        
        makeCoolSlider()
        containerViewContraints()
        topColoredViewConstraints()
        bottomColoredViewConstraints()
        setButtonConstraints()
        
    }
    
    
    var containerViewHeight : NSLayoutConstraint?
    var topViewHeightConstraint : NSLayoutConstraint?
    var bottomViewHeightContraint: NSLayoutConstraint?
  

    
    func makeCoolSlider() {
        let frame = CGRect(x: 125, y: view.center.y/2, width: view.bounds.width-20, height: (view.bounds.height-100)/2)
        let moodSlider = UISlider(frame: frame)
        view.addSubview(moodSlider)
        view.backgroundColor = UIColor.white
        moodSlider.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        moodSlider.minimumValue = 0
        moodSlider.maximumValue = 100
        moodSlider.value = 50
        moodSlider.minimumTrackTintColor = UIColor.gray
        moodSlider.maximumTrackTintColor = UIColor.gray
        moodSlider.addTarget(self, action: #selector(SliderMoodViewController.sliderValueDidChange(_:)), for: .valueChanged)
    }


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
    
// SLIDER VALUE CHANGED 
    
    func sliderValueDidChange(_ sender:UISlider!) {
        let roundedStepValue = round(sender.value / step) * step
         sender.value = roundedStepValue
       
        if sender.value > 50 {
            topViewHeightConstraint?.constant = CGFloat(sender.value)*((containerViewHeight?.constant)!/100) - (containerViewHeight?.constant)!/2
            topColoredView.setNeedsDisplay()
        }
        else if sender.value < 50 {
            bottomViewHeightContraint?.constant = (containerViewHeight?.constant)!/2 - CGFloat(sender.value)*((containerViewHeight?.constant)!/100)
            bottomColoredView.setNeedsDisplay()
        }
        
        else if sender.value == 50 {
            bottomViewHeightContraint?.constant  = 0
            topViewHeightConstraint?.constant = 0
        }
        print("Slider step value \(Int(roundedStepValue))")
        happinessIndex = sender.value
    }

    func saveButtonPressed () {
        let detailVC = DetailViewController()
        detailVC.happinessIndex = happinessIndex
        navigationController?.pushViewController(detailVC, animated: true)

//        //VIEW HEIRARCHY TO SHOW GRAPH -- CAN MOVE
//        //        var temp = CGRect()
//        let graphTemp:GraphView = GraphView(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
//        graphTemp.backgroundColor = .blue
//        self.view.addSubview(graphTemp)
//        //        graphTemp.draw()

    
    }

//    
//// GESTURE RECGONIZERS 
//    
//    func upGesture (sender: UIPanGestureRecognizer) {
//
//        
//    }
//    
//    func downGesture (sender: UIPanGestureRecognizer) {
//        
//        
//    }
//    

}

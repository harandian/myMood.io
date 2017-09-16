//
//  RegisterViewController.swift
//  myMood
//
//  Created by Mohammad Shahzaib Ather on 2017-09-15.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit
import Firebase


class RegisterViewController: UIViewController {
    
    var sliderMoodViewController: SliderMoodViewController?
    
    let colors = Colors()
    
    
    let emailContainerView : UIView  = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        return view
        
    }()
    
    let passwordContainerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    let nameContainerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    let nameTextField : UITextField = {
        let nametf = UITextField()
        nametf.placeholder = "Name"
        nametf.translatesAutoresizingMaskIntoConstraints = false
        nametf.layer.masksToBounds = true
        return nametf
    } ()
    
    let emailTextField : UITextField = {
        let emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.layer.masksToBounds = true
        return emailTextField
    } ()
    
    let passwordTextField : UITextField = {
        let passwordtf = UITextField()
        passwordtf.placeholder = "Password"
        passwordtf.translatesAutoresizingMaskIntoConstraints = false
        passwordtf.isSecureTextEntry = true
        passwordtf.layer.masksToBounds = true
        return passwordtf
    } ()
    
    lazy var RegisterButton : UIButton = {
        let button = UIButton(type:.system)
        button.backgroundColor = UIColor.gray
        button.layer.cornerRadius = 5
        button.setTitle("Register", for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    
    
    func handleRegister() {
        guard let email = emailTextField.text , let password = passwordTextField.text , let name = nameTextField.text
            else {
                print("form is not valid")
                return
        }
       
        Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error) in
            if error != nil{
                return
            }
            
            guard let uid = user?.uid else{
                return
            }
            
            //SUCCESSFULLY AUTHENTICATED USER
            let ref = Database.database().reference(fromURL:"https://mymood-io.firebaseio.com/" )
            let usersRef = ref.child("Users").child(uid)
            let values = ["Name": name, "Email" :email]
            usersRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if error != nil{
                    return
                }
                
                let alertController = UIAlertController(title: "Register", message: "Congratulations, user successfully saved ", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                    
                    self.present(self.sliderMoodViewController!, animated: true, completion: nil)
                }))
                    
                self.present(alertController, animated: true, completion: nil)
                
                let sliderMoodController = SliderMoodViewController()
                self.present(sliderMoodController, animated: true, completion: nil)
            
                
                print("Saved user successfully into Firebase database")
            })
            
            
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   

        view.addSubview(nameContainerView)
        view.addSubview(emailContainerView)
        view.addSubview(passwordContainerView)
        view.addSubview(RegisterButton)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
       
        refresh()
        setupNameContainerView ()
        setupEmailContainerView()
        setupPasswordContainerView ()
        setupRegisterButtonView ()
        
        sliderMoodViewController = SliderMoodViewController()
        
    }
    

    func setupNameContainerView (){
        nameContainerView.addSubview(nameTextField)
        nameContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        nameContainerView.bottomAnchor.constraint(equalTo: emailContainerView.topAnchor, constant: -20).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: nameContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.centerYAnchor.constraint(equalTo: nameContainerView.centerYAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: nameContainerView.rightAnchor).isActive = true
        
    }
    
    func setupEmailContainerView() {
        
        emailContainerView.addSubview(emailTextField)
        emailContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        emailContainerView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: emailContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.centerYAnchor.constraint(equalTo: emailContainerView.centerYAnchor).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: emailContainerView.rightAnchor).isActive = true
        
    }
    
    func setupPasswordContainerView (){
        
        passwordContainerView.addSubview(passwordTextField)
        passwordContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        passwordContainerView.topAnchor.constraint(equalTo: emailContainerView.bottomAnchor, constant: 20).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: passwordContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.centerYAnchor.constraint(equalTo: passwordContainerView.centerYAnchor).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: passwordContainerView.rightAnchor).isActive = true
    }
    
    func setupRegisterButtonView () {
        RegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        RegisterButton.topAnchor.constraint(equalTo: passwordContainerView.bottomAnchor, constant: 20).isActive = true
        RegisterButton.widthAnchor.constraint(equalTo: passwordContainerView.widthAnchor).isActive = true
        RegisterButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func refresh() {
        view.backgroundColor = UIColor.clear
        let backgroundLayer = colors.gl
        backgroundLayer?.frame = view.frame
        view.layer.insertSublayer(backgroundLayer!, at: 0)
    }
    
    
}

//
//  LoginViewController.swift
//  myMood
//
//  Created by Hirad on 2017-09-05.
//  Copyright © 2017 Hirad. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications


    
class Colors {
        var gl:CAGradientLayer!
    
        init() {
            let colorBottom = UIColor(red: 155.0 / 255.0, green: 155.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0).cgColor
            let colorTop = UIColor(red: 155.0 / 255.0, green: 255.0 / 255.0, blue: 155.0 / 255.0, alpha: 1.0).cgColor
            self.gl = CAGradientLayer()
            self.gl.colors = [colorTop, colorBottom]
            self.gl.locations = [0.0, 1.0]
        }
    }
    
class LoginViewController: UIViewController {
        
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
        
        lazy var loginButton : UIButton = {
            let button = UIButton(type:.system)
            button.backgroundColor = UIColor.gray
            button.layer.cornerRadius = 5
            button.setTitle("Login", for: UIControlState.normal)
            button.setTitleColor(UIColor.white, for: UIControlState.normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
            return button
        }()
        
//        let createAccountLabel : UILabel = {
//            let label = UILabel()
//            label.text = "Don't have an account?"
//            label.backgroundColor = UIColor.clear
//            label.textColor = UIColor.white
//            label.font = UIFont.systemFont(ofSize: 15)
//            label.translatesAutoresizingMaskIntoConstraints = false
//            return label
//        }()
    
        let createAccountButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Create Account", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.addTarget(self, action: #selector(registerUser), for: .touchUpInside)
            return button
        }()
        
        
        
        // Login User
        
        func handleLogin() {
            
            guard let email = emailTextField.text , let password = passwordTextField.text, !(emailTextField.text?.isEmpty)!
                else {
                    print("form is not valid")
                    
                    // ************ REMOVE BEFORE PUSHING TO STORE **********
                    // Force login if field is empty -> save time to log in.
                    Auth.auth().signIn(withEmail: "sample@gmail.com", password: "123456") { (user: User?,  error) in
                        
                        if  error != nil {
                            print(error!)
                            return
                        }
                        
                        //            self.dismiss(animated: true, completion: nil)
                        let sliderController = SliderMoodViewController()
                        //    self.navigationController?.show(SliderMoodViewController(), sender: self)
                        self.navigationController?.pushViewController(sliderController, animated: true)
                        print(123)
                    }
                    
                    
                    return
            }
            Auth.auth().signIn(withEmail: email, password: password) { (user: User?,  error) in
                
                if  error != nil {
                    print(error!)
                    return
                }
                
                
                let sliderController = SliderMoodViewController()
                self.navigationController?.pushViewController(sliderController, animated: true)
            }
        }
        
        
        
        
        
        
        
        
        //VIEW DID LOAD
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.addSubview(emailContainerView)
            view.addSubview(passwordContainerView)
            view.addSubview(loginButton)
//            view.addSubview(createAccountLabel)
            view.addSubview(createAccountButton)
            
            refresh()
            
            
            setupEmailContainerView ()
            setupPasswordContainerView()
            setupLoginButtonView ()
//            setuplabelContraints()
            createAccountButtonConstraints()
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
        
        func refresh() {
            view.backgroundColor = UIColor.clear
            let backgroundLayer = colors.gl
            backgroundLayer?.frame = view.frame
            view.layer.insertSublayer(backgroundLayer!, at: 0)
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
        
        func setupLoginButtonView () {
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            loginButton.topAnchor.constraint(equalTo: passwordContainerView.bottomAnchor, constant: 20).isActive = true
            loginButton.widthAnchor.constraint(equalTo: passwordContainerView.widthAnchor).isActive = true
            loginButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        
//        func setuplabelContraints() {
//            createAccountLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
//            createAccountLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
//            createAccountLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
//            createAccountLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
//        }
    
        func createAccountButtonConstraints() {
//            createAccountButton.leftAnchor.constraint(equalTo: createAccountLabel.rightAnchor, constant: 10).isActive = true
            createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor , constant: 10).isActive = true
            createAccountButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
            // createAccountButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
            createAccountButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//            createAccountButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
            
        }
        
        func registerUser() {
            let registerVC = RegisterViewController()
            self.navigationController?.pushViewController(registerVC, animated: true)
        }
        
        override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent;
        }
        
    }
    
    extension UIColor {
        convenience init(r :CGFloat ,  g:CGFloat, b: CGFloat) {
            self.init (red: r/255 , green: g/255, blue: b/255, alpha:1 )
        }
}

//
//  SignUpViewController.swift
//  AIRide
//
//  Created by Oleh Komarnitsky on 28.04.2018.
//  Copyright © 2018 SeventyFly. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SignUpViewController:UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var dismissButton: UIButton!
    
    var continueButton:RoundedWhiteButton!
    var activityView:UIActivityIndicatorView!
    
    let balance: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        continueButton = RoundedWhiteButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.setTitle("Продовжити", for: .normal)
        continueButton.titleLabel?.font = UIFont(name: "Futura-Bold", size: 18)
        continueButton.center = CGPoint(x: view.center.x, y: view.frame.height - continueButton.frame.height - 24)
        continueButton.highlightedColor = UIColor.clear
        continueButton.defaultColor = UIColor.clear
        continueButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        view.addSubview(continueButton)
        setContinueButton(enabled: false)
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.color = secondaryColor
        activityView.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        activityView.center = continueButton.center
        
        view.addSubview(activityView)
        
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        usernameField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        emailField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillAppear), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        usernameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    @IBAction func handleDismissButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    /**
     Adjusts the center of the **continueButton** above the keyboard.
     - Parameter notification: Contains the keyboardFrame info.
     */
    
    @objc func keyboardWillAppear(notification: NSNotification){
        
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        continueButton.center = CGPoint(x: view.center.x,
                                        y: view.frame.height - keyboardFrame.height - 16.0 - continueButton.frame.height / 2)
        activityView.center = continueButton.center
    }
    
    /**
     Enables the continue button if the **username**, **email**, and **password** fields are all non-empty.
     
     - Parameter target: The targeted **UITextField**.
     */
    
    @objc func textFieldChanged(_ target:UITextField) {
        let username = usernameField.text
        let email = emailField.text
        let password = passwordField.text
        let formFilled = username != nil && username != "" && email != nil && email != "" && password != nil && password != ""
        setContinueButton(enabled: formFilled)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Resigns the target textField and assigns the next textField in the form.
        
        switch textField {
        case usernameField:
            usernameField.resignFirstResponder()
            emailField.becomeFirstResponder()
            break
        case emailField:
            emailField.resignFirstResponder()
            passwordField.becomeFirstResponder()
            break
        case passwordField:
            handleSignUp()
            break
        default:
            break
        }
        return true
    }
    
    /**
     Enables or Disables the **continueButton**.
     */
    
    func setContinueButton(enabled:Bool) {
        if enabled {
            continueButton.alpha = 1.0
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
    }
    
    @objc func handleSignUp() {
        guard let username = usernameField.text else { return }
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else { return }
        
        setContinueButton(enabled: false)
        continueButton.setTitle("", for: .normal)
        activityView.startAnimating()
        
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                print("User created!")
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = username
                        
                changeRequest?.commitChanges { error in
                    if error == nil {
                        print("User display name changed!")
                        
                        self.saveProfile(username: username, email: email, password: password, balance: self.balance) { success in
                            if success {
                                self.dismiss(animated: true, completion: nil)
                                } else {
                                    self.elseProblemsWithSignUp()
                                }
                            }
                        } else {
                            self.elseProblemsWithSignUp()
                        }
                    }
                } else if (error?.localizedDescription == "The email address is badly formatted.") {
                    self.emailBadlyFormatted()
                } else if (error?.localizedDescription == "The email address is already in use by another account.") {
                    self.emailUsed()
            } else if (error?.localizedDescription == "Network error (such as timeout, interrupted connection or unreachable host) has occurred.") {
                self.networkUnavaible()
            } else if (error?.localizedDescription == "The password must be 6 characters long or more.") {
                self.passwordBadlyFormatted()
            } else {
                self.elseProblemsWithSignUp()
            }
        }
    }
    
    func resetForm(username: Bool, email: Bool, password: Bool) {
        if (username) {
        self.usernameField.text = ""
        } else if (email) {
        self.emailField.text = ""
        } else if (password) {
        self.passwordField.text = ""
        } else {
            self.usernameField.text = ""
            self.emailField.text = ""
            self.passwordField.text = ""
        }
    }
    
    func elseProblemsWithSignUp() {
        let alert = UIAlertController(title: "От халепа!", message: """
Щось пішло не так.
Можливо, спробуєте ще раз?
""", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Спробувати ще раз", style: .default, handler: nil))
        
        
        alert.addAction(UIAlertAction(title: "Повернутись у головне меню", style: .default, handler: { (handler) in
            self.handleDismissButton((Any).self)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        resetForm(username: true, email: true, password: true)
        setContinueButton(enabled: true)
        continueButton.setTitle("Продовжити", for: .normal)
        activityView.stopAnimating()
    }
    
    func passwordBadlyFormatted() {
        let alert = UIAlertController(title: "От халепа!", message: """
Ваш пароль повинен містити не менше 6 символів.
Можливо, спробуєте ще раз?
""", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Спробувати ще раз", style: .default, handler: nil))
        
        
        alert.addAction(UIAlertAction(title: "Повернутись у головне меню", style: .default, handler: { (handler) in
            self.handleDismissButton((Any).self)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        resetForm(username: false, email: false, password: true)
        setContinueButton(enabled: true)
        continueButton.setTitle("Продовжити", for: .normal)
        activityView.stopAnimating()
    }
    
    func networkUnavaible() {
        let alert = UIAlertController(title: "От халепа!", message: """
Відсутнє підключення до Інтернету.
Можливо, спробуєте ще раз?
""", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Спробувати ще раз", style: .default, handler: nil))
        
        
        alert.addAction(UIAlertAction(title: "Повернутись у головне меню", style: .default, handler: { (handler) in
            self.handleDismissButton((Any).self)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        setContinueButton(enabled: true)
        continueButton.setTitle("Продовжити", for: .normal)
        activityView.stopAnimating()
    }
            
    func emailBadlyFormatted() {
        let alert = UIAlertController(title: "От халепа!", message: "Ваш e-mail введено неправильно. Можливо, спробуєте ще раз?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Спробувати ще раз", style: .default, handler: nil))
        
        
        alert.addAction(UIAlertAction(title: "Повернутись у головне меню", style: .default, handler: { (handler) in
            self.handleDismissButton((Any).self)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        resetForm(username: false, email: true, password: false)
        setContinueButton(enabled: true)
        continueButton.setTitle("Продовжити", for: .normal)
        activityView.stopAnimating()
    }
    
    func emailUsed() {
        let alert = UIAlertController(title: "От халепа!", message: """
Користувач з даним e-mail вже існує.
Можливо, спробуєте ще раз?
""", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Спробувати ще раз", style: .default, handler: nil))

        
        alert.addAction(UIAlertAction(title: "Повернутись у головне меню", style: .default, handler: { (handler) in
            self.handleDismissButton((Any).self)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        resetForm(username: false, email: true, password: false)
        setContinueButton(enabled: true)
        continueButton.setTitle("Продовжити", for: .normal)
        activityView.stopAnimating()
    }
    
    func saveProfile(username: String, email: String, password: String, balance: Int, completion: @escaping ((_ success:Bool)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("users/\(uid)")
        
        let userObject = [
            "id": uid,
            "username": username,
            "email": email,
            "password": password,
            "balance": balance
            ] as [String: Any]
        
        databaseRef.setValue(userObject) { error, ref in
            completion(error == nil)
        }
    }
}

//
//  LogInViewController.swift
//  Chat
//
//  Created by Yusuf Bayindir on 2/7/24.
//

import UIKit
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
class LogInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var buttonLabel: UIButton!
    @IBOutlet weak var forgotPasswordLabel: UIButton!
    @IBOutlet weak var sendEmailLabel: UIButton!
    @IBOutlet weak var backButtonLabel: UIButton!
    
    var email = ""
    var password = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        backButtonLabel.isHidden = true
        sendEmailLabel.isHidden = true
        
        mainView.backgroundColor = UIColor(hex: Constants.ColorsPattern.blueColor)

        buttonLabel.tintColor = UIColor(hex: Constants.ColorsPattern.orangeColor)
        buttonLabel.backgroundColor = UIColor(hex: Constants.ColorsPattern.whiteColor)
        buttonLabel.layer.cornerRadius = 15.0
    
        forgotPasswordLabel.tintColor = UIColor(hex: Constants.ColorsPattern.orangeColor)
        sendEmailLabel.tintColor = UIColor(hex: Constants.ColorsPattern.orangeColor)
        backButtonLabel.tintColor = UIColor(hex: Constants.ColorsPattern.orangeColor)
        navigationController?.navigationBar.tintColor = UIColor(hex: Constants.ColorsPattern.orangeColor)
        
        mailText.returnKeyType = .next
        passwordText.returnKeyType = .done
        mailText.delegate = self
        passwordText.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    @IBAction func logInButton(_ sender: Any) {
        // Unwrap safely the email and password text
        guard let email = mailText.text, !email.isEmpty,
              let password = passwordText.text, !password.isEmpty else {
            // Show an error message to your user
            errorLabel.text = "Email and password must not be empty."
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                // Handle errors like wrong password, no internet connection etc.
                self?.passwordText.text = ""
                self!.errorLabel.text = "Login error: \(error.localizedDescription)"
                return
            }
            
            guard let strongSelf = self else { return }
            // No error, proceed to the chat
            DispatchQueue.main.async {
                strongSelf.performSegue(withIdentifier: Constants.goChatwithLoginPage, sender: strongSelf)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.placeholder == "E-mail"{
            email = textField.text ?? ""
        }else{
            password = textField.text ?? ""
        }
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        passwordText.isHidden = true
        sendEmailLabel.isHidden = false
        forgotPasswordLabel.isHidden = true
        backButtonLabel.isHidden = false
    }
    
    @IBAction func sendEmail(_ sender: UIButton) {
        Auth.auth().sendPasswordReset(withEmail: mailText.text ?? ""){ error in
            if let error = error {
                self.errorLabel.text = "\(error.localizedDescription)"
                
            } else {
                // E-posta başarıyla gönderildiğinde kullanıcıya bilgi ver
                self.errorLabel.text = "Sent password reset link successfuly"
            }
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        passwordText.isHidden = false
        sendEmailLabel.isHidden = true
        backButtonLabel.isHidden = true
        forgotPasswordLabel.isHidden = false
    }
}

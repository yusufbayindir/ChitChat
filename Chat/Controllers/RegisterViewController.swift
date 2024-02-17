//
//  RegisterViewController.swift
//  Chat
//
//  Created by Yusuf Bayindir on 2/7/24.
//

import UIKit
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
class RegisterViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var buttonLabel: UIButton!
    @IBOutlet var mainView: UIView!
    
    var mail = ""
    var password = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.backgroundColor = UIColor(hex: Constants.ColorsPattern.blueColor)

        buttonLabel.tintColor = UIColor(hex: Constants.ColorsPattern.orangeColor)
        buttonLabel.backgroundColor = UIColor(hex: Constants.ColorsPattern.whiteColor)
        buttonLabel.layer.cornerRadius = 15.0
    
        navigationController?.navigationBar.tintColor = UIColor(hex: Constants.ColorsPattern.orangeColor)

        mailText.returnKeyType = .next
        passwordText.returnKeyType = .done
        mailText.delegate = self
        passwordText.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    @IBAction func registeredButton(_ sender: UIButton) {
        if let email = mailText.text, let password = passwordText.text, !email.isEmpty, !password.isEmpty {
               Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                   if let error = error {
                       // Handle the error (e.g., show an alert to the user)
                       self.errorLabel.text =   error.localizedDescription
                   } else if let authResult = authResult {
                       // Proceed with the successful registration
                       print(authResult.user)
                       self.performSegue(withIdentifier: Constants.goChatwithRegisterPage, sender: self)
                   } else {
                       // Handle unexpected error
                       print("Unexpected error during registration.")
                   }
               }
           } else {
               errorLabel.text = "E-mail or password cannot be empty"
           }
    }
    

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.placeholder == "E-mail"{
            mail = textField.text ?? ""
        }else{
            password = textField.text ?? ""
        }
        
    }
}

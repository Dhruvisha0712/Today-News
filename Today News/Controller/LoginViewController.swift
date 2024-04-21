//
//  ViewController.swift
//  Today News
//
//  Created by Nandan on 27/03/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var passInvalidLbl: UILabel!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var emailInvalidLbl: UILabel!
    @IBOutlet weak var passTxtField: UITextField!
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        emailTxtField.delegate = self
        passTxtField.delegate = self

        emailInvalidLbl.isHidden = true
        passInvalidLbl.isHidden = true
    }
    
    // Function to validate email address
    func isValidEmail(_ email: String) -> Bool {
        guard !email.isEmpty else { return false } // Check for empty string
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    // Function to validate password
    func isValidPassword(_ password: String) -> Bool {
        guard !password.isEmpty else { return false } // Check for empty string
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*]).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if isValidEmail(emailTxtField.text ?? "") && isValidPassword(passTxtField.text ?? "") {
            login()
        } else {
            if !isValidEmail(emailTxtField.text ?? "") {
                emailInvalidLbl.isHidden = false
            }
            
            if !isValidPassword(passTxtField.text ?? "") {
                passInvalidLbl.isHidden = false
            }
            
            if !isValidEmail(emailTxtField.text ?? "") && !isValidPassword(passTxtField.text ?? "") {
                emailInvalidLbl.isHidden = false
                passInvalidLbl.isHidden = false
            }
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        emailInvalidLbl.isHidden = true
        passInvalidLbl.isHidden = true
    }
    
    func login() {
        if let email = emailTxtField.text, let password = passTxtField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    let err = e.localizedDescription
                    let alert = UIAlertController(title: "Error", message: err, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.defaults.set(true, forKey: "loginOrNot")
                    self.defaults.set(email, forKey: "email")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    
    @IBAction func loginPressed(_ sender: UIButton) {
        if isValidEmail(emailTxtField.text ?? "") && isValidPassword(passTxtField.text ?? "") {
            login()
        } else {
            if !isValidEmail(emailTxtField.text ?? "") {
                emailInvalidLbl.isHidden = false
            }
            
            if !isValidPassword(passTxtField.text ?? "") {
                passInvalidLbl.isHidden = false
            }
            
            if !isValidEmail(emailTxtField.text ?? "") && !isValidPassword(passTxtField.text ?? "") {
                emailInvalidLbl.isHidden = false
                passInvalidLbl.isHidden = false
            }
        }
    }
}


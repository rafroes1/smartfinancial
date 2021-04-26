//
//  LogInViewController.swift
//  smartfinancial
//
//  Created by Rafael Fróes Monteiro Carvalho
//  Copyright © rafafroes. All rights reserved.
//

import UIKit
import FirebaseAuth
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextFieldsTheming

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var loginContainer: UIView!
    
    @IBOutlet weak var passwordContainer: UIView!
    
    var emailTextField = MDCOutlinedTextField()
    
    var pwdTextField = MDCOutlinedTextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        //todo: fazer progress indicator
        
        setUpElements()
        
        emailTextField.keyboardType = UIKeyboardType.emailAddress
        emailTextField.autocapitalizationType = UITextAutocapitalizationType.none
        emailTextField.delegate = self
        
        pwdTextField.keyboardType = UIKeyboardType.namePhonePad
        pwdTextField.autocapitalizationType = UITextAutocapitalizationType.none
        pwdTextField.isSecureTextEntry = true
        pwdTextField.delegate = self
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        
        if(validateFields()){
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = pwdTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            signIn(email: email, password: password)
        }else{
            let alert = UIAlertController(title: "Campos em branco", message: "Preencher email e senha", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func setUpElements() {
        Decorator.styleTextField(emailTextField, loginContainer, "Login", "Digite seu email")
        Decorator.styleTextField(pwdTextField, passwordContainer, "Senha", "Digite sua senha")
        Decorator.styleFilledButton(loginButton)
    }
    
    func validateFields() -> Bool {
        if(emailTextField.text == "" || pwdTextField.text == ""){
            return false
        }else{
            return true
        }
    }
    
    func signIn(email: String, password: String) {
        //login teste: rafafroes@outlook.com rafael123
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                let errorMessage = error!.localizedDescription
                // create the alert
                let alert = UIAlertController(title: "Failed to login", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "HomeNavigationC") as! UINavigationController
                _ = navigationController.topViewController as! HomeViewController
                
                self.view.window?.rootViewController = navigationController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      if textField == emailTextField {
        textField.resignFirstResponder()
        pwdTextField.becomeFirstResponder()
      } else {
        textField.resignFirstResponder()
      }
     return false
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

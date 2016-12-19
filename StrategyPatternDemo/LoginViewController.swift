//
//  LoginViewController.swift
//  StrategyPatternDemo
//
//  Created by ZHOU DENGFENG on 19/12/16.
//  Copyright © 2016 ZHOU DENGFENG DEREK. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    private lazy var validationManager = ValidationManager()
    
    @IBAction func tapLoginButton(_ sender: UIButton) {
        let emailValidation = validationManager.validationForText(text: emailField.text, withValidationType: .Email)
        let passValidation = validationManager.validationForText(text: passwordField.text, withValidationType: .Password)
        
        if emailValidation && passValidation {
            // Log in successfully and enter main view
            performSegue(withIdentifier: "ShowMainView", sender: self)
        } else {
            // validation failed. You can do anything you want to alert user.
            let alert = UIAlertController(title: "Failed", message: "Email or password is not valid.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
}


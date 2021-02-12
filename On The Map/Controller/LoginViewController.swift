//
//  LoginViewController.swift
//  On The Map
//
//  Created by user on 03/02/2021.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, HelperFunction {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signupButton: UIButton!
    
    // Mark: Properties
    
    let authService = Authentication()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loggingIn(true)
        authService.getFaceBookData(completionHandler: navigateToHomeScreen)
    }
    

    @IBAction func signUp(_ sender: Any) {
        let url: URL = Authentication.EndPoints.signUp.url
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func login(_ sender: Any) {
       
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
       
        let isvalidEmail = Validation.isValidEmail(email)
        
        if(!isvalidEmail){
            return present(errorMessageDisplay(title: "Email Error", message: .emailError), animated: true)
        } else if (password.isEmpty){
           return present(errorMessageDisplay(title: "Password Error", message: .passwordError), animated: true)
        }
        
        loggingIn(true)
        authService.login(username: email, password: password, completionHandler: navigateToHomeScreen)
        
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        loggingIn(true)
        authService.facebookAuthentication(viewController: self, completionHandler: navigateToHomeScreen)
    }
    
    func loggingIn(_ isLogging: Bool){
        if isLogging {
            activityIndicator.startAnimating()
        }else {
            activityIndicator.stopAnimating()
        }
        
        loginButton.isEnabled = !isLogging
        facebookButton.isEnabled = !isLogging
        signupButton.isEnabled = !isLogging
    }
    
    func navigateToHomeScreen(result: Any?, error: Error?){
        self.loggingIn(false)
        
        if let error = error {
            if !error.localizedDescription.isEmpty {
                 self.present(self.errorMessage(title: "Login Error", message: error.localizedDescription), animated: true)
            }
            return
        }
        emailTextField.text = ""
        passwordTextField.text = ""
        self.performSegue(withIdentifier: "homeScreen", sender: nil)
    }

}


extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
    }
}

    

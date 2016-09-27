/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    var activityIndicator = UIActivityIndicatorView()
    var state = true
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    func createAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: {(action)
            in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBOutlet var alreadyAMember: UILabel!
    @IBOutlet var signUpOrLoginButton: UIButton!
    
    @IBAction func signUpOrLoginAction(_ sender: AnyObject) {
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            
            createAlert(title: "Error in form", message: "Please enter an email and password")
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if state  {
                
                PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                        var displayErrorMessage = "Please try again later."
                        let error = error as NSError?
                        
                        if let errorMessage = error?.userInfo["error"] as? String {
                            displayErrorMessage = errorMessage
                        }
                        self.createAlert(title: "Login Error", message: displayErrorMessage)
                        
                    } else {
                        
                        print("Logged in")
                        self.performSegue(withIdentifier: "loginSignUp", sender: self)
                        
                    }
                })
                
            } else {
                
                let user = PFUser()
                user.username = emailTextField.text
                user.password = passwordTextField.text
                user.signUpInBackground(block: { (success, error) in
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                        var displayErrorMessage = "Please try again later."
                        let error = error as NSError?
                        
                        if let errorMessage = error?.userInfo["error"] as? String {
                            displayErrorMessage = errorMessage
                        }
                        self.createAlert(title: "Signup Error", message: displayErrorMessage)
                    } else {
                        print("user signed up")
                        self.performSegue(withIdentifier: "loginSignUp", sender: self)
                    }
                    
                })
            }
            
        }
    }
    
    
    
    @IBOutlet var changeLoginSignUpButton: UIButton!
    
    @IBAction func changeLoginSignUpAction(_ sender: AnyObject)
    {
        if state {
            
            
            changeLoginSignUpButton.setTitle("Login", for: [])
            signUpOrLoginButton.setTitle("Sign Up", for: [])
            alreadyAMember.text = "Already a member?"
            state = false
            
        } else {
            
            changeLoginSignUpButton.setTitle("Sign Up", for: [])
            signUpOrLoginButton.setTitle("Login", for: [])
            
            alreadyAMember.text = "Not a member?"
            state = true
            
        }
    }
    
    /*
     // skip login if logged in previously
     
     override func viewDidAppear(_ animated: Bool) {
     if PFUser.current() != nil {
     performSegue(withIdentifier: "loginSignUp", sender: self)
     }
     self.navigationController?.navigationBar.isHidden = true
     }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

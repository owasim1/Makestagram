 //
//  LoginViewController.swift
//  Makestagram
//
//  Created by Omar Wasim on 6/26/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
typealias FIRUser = FirebaseAuth.User
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup after loading the view
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        print("login button tapped")
        guard let authUI = FUIAuth.defaultAuthUI()
            else {return}
        authUI.delegate = self
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
        
    }
    
    
}

extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
        }

        guard let user = user
            else { return }
        
        let userRef = Database.database().reference().child("users").child(user.uid)
        
        userRef.observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
            if let user = User(snapshot: snapshot) {
                print("Welcome back, \(user.username).")
            } else {
                print("New User!")
    
            }
        })
        
        
        UserService.show(forUID: user.uid) { (user) in
            if let user = user {
                // handle existing user
                User.setCurrent(user, writeToUserDefaults: true)
                
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
                
            } else {
                // handle new user
               self.performSegue(withIdentifier: Constants.Segue.toCreateUsername, sender: self)
            
            }
        }
    }
}


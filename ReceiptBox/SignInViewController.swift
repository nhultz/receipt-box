//
//  SignInViewController.swift
//  ReceiptBox
//
//  Created by Nick Hultz on 11/11/17.
//  Copyright © 2017 nhultz. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInUIDelegate {

    var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isToolbarHidden = true

        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user != nil {
                self.performSegue(withIdentifier: "ToReceiptList", sender: self)
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}

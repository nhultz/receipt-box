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
        view.backgroundColor = Stylesheet.Colors.green
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user != nil {
                let vc = MainViewController()
                self.present(vc, animated: true, completion: nil)
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func setupViews() {
        view.addSubview(signInButton)
        signInButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: View Definitions
    
    let signInButton = GIDSignInButton()

}

//
//  LoginViewController.swift
//  twitter
//
//  Created by emersonmalca on 10/30/16.
//  Copyright © 2016 Emerson Malca. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate: class {
    func didFinishLogin(withSuccess success: Bool, controller: LoginViewController)
}

class LoginViewController: UIViewController {
    
    weak var delegate: LoginViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onLoginButton(sender: AnyObject) {
        APIClient.instance.fetchRequestToken(withSuccess: { (token: String) in
            let path = "https://api.twitter.com/oauth/authorize?oauth_token=\(token)"
            let url = URL(string: path)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            
        }, failure: { (error: Error?) in
            print("error: \(error!.localizedDescription)")
        })
    }
    
    func process(oauthCredentialsString: String) {
        APIClient.instance.fetchAccessToken(withOauthCredentialsString: oauthCredentialsString, success: {() -> Void in
            if let del = self.delegate {
                del.didFinishLogin(withSuccess: true, controller: self)
            }
        }) {(error: Error?) -> Void in
            if let del = self.delegate {
                del.didFinishLogin(withSuccess: false, controller: self)
            }
        }
    }

}

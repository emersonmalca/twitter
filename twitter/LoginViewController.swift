//
//  LoginViewController.swift
//  twitter
//
//  Created by emersonmalca on 10/30/16.
//  Copyright © 2016 Emerson Malca. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onLoginButton(sender: AnyObject) {
        let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "QNPI0H6RYyx6AykIqoaVXpK6f", consumerSecret: "1dhfqDmM1XteQJc5K3nKQYaQAdjmGQX1lE0oaiPmHDBNxQCnSE")
        
        twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "tweets://oath"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            
            if let credential = requestToken {
                let path = "https://api.twitter.com/oauth/authorize?oauth_token=\(credential.token!)"
                let url = URL(string: path)
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }
            
        }, failure: { (error: Error?) in
            print("error: \(error!.localizedDescription)")
        })
    }

}

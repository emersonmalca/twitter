//
//  ViewController.swift
//  twitter
//
//  Created by emersonmalca on 10/30/16.
//  Copyright © 2016 Emerson Malca. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    internal var loginController: LoginViewController!

    @IBOutlet weak var loadingFullView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If we are not authorized yet we want to show the login screen
        if (!APIClient.instance.isAuthorized()) {
            loginController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            loginController.delegate = self
            addChildViewController(loginController)
            loginController.view.frame = view.bounds
            view.addSubview(loginController.view)
            loginController.didMove(toParentViewController: self)
        
        } else {
            
            // We want to show cached items so we animate out the full loading view
            animateOutFullLoadingView()
            
            // Fetch new tweets
            APIClient.instance.getRecentTweets(withSuccess: { (tweets :[Tweet]) in
                //
            }, failure: { (error: Error?) in
                //
            })
        }
    }

    func process(oauthCredentialsString: String) {
        loginController.process(oauthCredentialsString: oauthCredentialsString)
    }
    
    func animateOutFullLoadingView() {
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.loadingFullView.alpha = 0.0
            self.loadingFullView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        })
    }

}

extension ViewController: LoginViewControllerDelegate {
    
    func didFinishLogin(withSuccess success: Bool, controller: LoginViewController) {
        
        // Remove the login controller
        controller.willMove(toParentViewController: nil)
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            controller.view.alpha = 0.0
            controller.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) {(Bool) -> Void in
            controller.view.removeFromSuperview()
            controller.removeFromParentViewController()
            self.loginController = nil
        }
    }
}


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
    var tweets = [Tweet]()

    @IBOutlet weak var loadingFullView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.estimatedItemSize = CGSize(width: 200.0, height: 60.0)
        */
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
            fetchRecentTweets()
        }
    }

    func process(oauthCredentialsString: String) {
        loginController.process(oauthCredentialsString: oauthCredentialsString)
    }
    
    func fetchRecentTweets() {
        APIClient.instance.getRecentTweets(withSuccess: { (tweets :[Tweet]) in
            // Reload data
            self.tweets.removeAll()
            self.tweets.append(contentsOf: tweets)
            self.collectionView.reloadData()
            
        }, failure: { (error: Error?) in
            print(error!.localizedDescription)
        })
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
            
            // We want to show cached items so we animate out the full loading view
            self.animateOutFullLoadingView()
            
            // Fetch new tweets
            self.fetchRecentTweets()
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        let tweet = tweets[indexPath.row]
        cell.update(withTweet: tweet)
        return cell
    }
}


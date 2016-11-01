//
//  APIClient.swift
//  twitter
//
//  Created by emersonmalca on 10/31/16.
//  Copyright © 2016 Emerson Malca. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class APIClient: NSObject {
    
    let sessionManager = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "QNPI0H6RYyx6AykIqoaVXpK6f", consumerSecret: "1dhfqDmM1XteQJc5K3nKQYaQAdjmGQX1lE0oaiPmHDBNxQCnSE")!

    class var instance: APIClient {
        struct Static {
            static let instance = APIClient()
        }
        return Static.instance
    }
    
    /*
     Login methods
    */
    
    func fetchRequestToken(withSuccess success:((String) -> Swift.Void)!, failure: ((Error?) -> Swift.Void)!) {
        
        sessionManager.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "tweets://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            
            if let credential = requestToken {
                success(credential.token)
            }
            
        }, failure: { (error: Error?) in
            failure(error)
        })
    }
    
    func fetchAccessToken(withOauthCredentialsString oauthCredentialsString: String, success:(() -> Swift.Void)!, failure: ((Error?) -> Swift.Void)!) {
        
        let requestToken = BDBOAuth1Credential(queryString: oauthCredentialsString)
        
        sessionManager.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: {(accessToken: BDBOAuth1Credential?) -> Void in
            
            print("Access token fetched")
            success()
            
        }) {(error: Error?) -> Void in
            failure(error)
        }
    }
}

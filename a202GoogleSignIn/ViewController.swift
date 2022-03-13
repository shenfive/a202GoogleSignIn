//
//  ViewController.swift
//  a202GoogleSignIn
//
//  Created by 申潤五 on 2022/3/13.
//

import UIKit
import GoogleSignIn
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var status: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user{
                let theEmail = user.email ?? ""
                print("登入狀態\(theEmail)")
                self.status.text = "歡迎:\(theEmail)"
            }else{
                print("登出狀態")
                self.status.text = "登出狀態"
            }
        }
        
        
    }
    
    
    @IBAction func googleSignIn(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            if let error = error {
                // ...
                print(error.localizedDescription)
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { result, error in
                if error != nil{
                    print(error?.localizedDescription)
                }
            }
            
            // ...
        }
        
        
    }
    
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }catch{
            print(error.localizedDescription)
        }
        
    }
}


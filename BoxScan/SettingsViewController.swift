//
//  SettingsViewController.swift
//  BoxScan
//
//  Created by Jeremy Kim on 8/7/17.
//  Copyright © 2017 SimpleSwift. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    func logOutSegue(viewController : UIViewController){
        let alertController = UIAlertController(title: "Are you sure you want to log out?", message: nil, preferredStyle: .actionSheet)
        
        let signOutAction = UIAlertAction(title: "Log Out", style: .destructive) { _ in
            self.logUserOut()
            // UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            UserDefaults.standard.set(nil, forKey: Constants.UserDefaults.currentUser)
            
            UserDefaults.standard.synchronize()
            
            let loginstoryboard = UIStoryboard(name: "Login", bundle: .main)
            let controller = UIStoryboard.initialViewController(for: .login)
            self.present(controller, animated: false, completion: nil)
        }
        
        alertController.addAction(signOutAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true)
        
    }
    
    func logUserOut(){
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            assertionFailure("Error signing out: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        print("sign out button tapped")
        logOutSegue(viewController: self)
        
    }
}

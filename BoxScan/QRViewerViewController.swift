//
//  QRViewerViewController.swift
//  BoxScan
//
//  Created by Jeremy Kim on 8/1/17.
//  Copyright © 2017 SimpleSwift. All rights reserved.
//

import UIKit
import QRCode
import FirebaseDatabase
import EZLoadingActivity

class QRViewerViewController: UIViewController {
    let ezLoadingActivity = EZLoadingActivity.self
    
    @IBAction func saveTapped(_ sender: Any) {
        PostService.createQR(for: self.qrImageView.image!, completion: { (success) -> Void in
            
            if success != "nil" {
                
                let ref = Database.database().reference()
                
                self.ezLoadingActivity.show("Loading...", disableUI: true)
                ref.child("Boxes").child(boxHouseArray!).child(keyOfHouse!).updateChildValues(qrArray)
                Database.database().reference().child("Boxes").child(boxHouseArray!).observe(.childAdded, with: {
                    snapshot in
                    let snapshotValue1 = snapshot.value as? NSDictionary
                    let qrURLS = snapshotValue1?["qrURL"] as? String
                    var urlARRA = [String]()
                    let urlARRACount = urlARRA.count
                    urlARRA.append(qrURLS!)
                    if (urlARRA.count == urlARRACount + 1) {
                        self.ezLoadingActivity.hide(true, animated: false)
                    }
                })
                
//                self.navigationController?.popToViewController(BoxTableViewController() as! UIViewController, animated: true)
                self.navigationController?.popToRootViewController(animated: true)
            

            
            }
            
        })
    }

    @IBOutlet weak var qrImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ezLoadingActivity.show("Loading...", disableUI: true)
        
        qrImageView.image = {
            var qrCode = QRCode(url)!
            qrCode.size = self.qrImageView.bounds.size
            qrCode.color = CIColor(rgba: "8e44ad")
            return qrCode.image
        }()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    

}

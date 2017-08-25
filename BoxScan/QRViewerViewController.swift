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
    
    
    @IBOutlet weak var qrImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ezLoadingActivity.hide()
        
        qrImageView.image = {
            var qrCode = QRCode(url)!
            qrCode.size = self.qrImageView.bounds.size
            qrCode.color = CIColor(rgba: "8e44ad")
            return qrCode.image
        }()
        
        if qrImageView != nil {
            PostService.createQR(for: self.qrImageView.image!, completion: { (success) -> Void in
                
                if success != "nil" {
                    
                    let ref = Database.database().reference()
                    
                    self.ezLoadingActivity.show("Loading...", disableUI: true)
                    ref.child("Boxes").child(boxHouseArray!).child(loc[cellPath!].firLocationUID).child("boxIDS").child(keyOfHouse!).updateChildValues(qrArray)
                    Database.database().reference().child("Boxes").child(boxHouseArray!).child(loc[cellPath!].firLocationUID).child("boxIDS").observeSingleEvent(of: .childAdded, with: {
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
                    
                    
                    
                    
                    
                }
                
            })
        }
        
        
        
    }
    
    
    @IBAction func quitTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func printQRImage(_ sender: Any) {
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = UIPrintInfoOutputType.general
        printInfo.jobName = "My Print Job"
        
        // Set up print controller
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        
        // Assign a UIImage version of my UIView as a printing iten
        printController.printingItem = self.view.toImage()
        
        // Do it
        printController.present(from: self.view.frame, in: self.view, animated: true, completionHandler: nil)
    }
}





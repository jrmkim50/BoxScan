//
//  ImageSaverViewController.swift
//  BoxScan
//
//  Created by Jeremy Kim on 8/8/17.
//  Copyright © 2017 SimpleSwift. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseStorage
import Kingfisher
import EZLoadingActivity

class ImageSaverViewController: UIViewController {
    let ezLoadingActivity = EZLoadingActivity.self
    var qrAndImage = [imageAndQR]()
    var urlToPrint: URL?
    var qrurlToPrint: URL?
    
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var qrImageViewer: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let ref = Database.database().reference()
        self.ezLoadingActivity.show("Loading...", disableUI: true)
        PostService.imageQRAppend(completion: {(arra) -> Void in
            self.qrAndImage = arra
            if (self.qrAndImage[cellIndexPath!].imageURL != nil && self.qrAndImage[cellIndexPath!].qRURL != nil) {
                self.urlToPrint = URL(string: self.qrAndImage[cellIndexPath!].imageURL)
                self.qrurlToPrint = URL(string: self.qrAndImage[cellIndexPath!].qRURL)
                self.qrImageView.kf.setImage(with: self.urlToPrint)
                self.qrImageViewer.kf.setImage(with: self.qrurlToPrint)
            }
            else {
                self.qrImageView.kf.setImage(with: "https://firebasestorage.googleapis.com/v0/b/boxscan-a76fb.appspot.com/o/Bitmap.png?alt=media&token=8420878c-db30-4ba5-b656-793ab414a4f4" as? Resource)
                self.qrImageViewer.kf.setImage(with: "https://firebasestorage.googleapis.com/v0/b/boxscan-a76fb.appspot.com/o/Bitmap.png?alt=media&token=8420878c-db30-4ba5-b656-793ab414a4f4" as? Resource)
            }
            
            self.ezLoadingActivity.hide()
            
//            print("qrImageDICT = \(self.qrAndImage)")

        })
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func quit(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
     
    }
    
    @IBAction func print(_ sender: Any) {
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

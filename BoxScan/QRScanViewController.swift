//
//  QRScanViewController.swift
//  BoxScan
//
//  Created by Jeremy Kim on 7/24/17.
//  Copyright © 2017 SimpleSwift. All rights reserved.
//

import UIKit
import QRCode
import Cloudinary
import Firebase
import FirebaseDatabase
import EZLoadingActivity

var url: String = ""
var QRSCANKEY: String?
class QRScanViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    var fileURL1: NSURL?
    
    let ezLoadingActivity = EZLoadingActivity.self
    
    override func viewDidLoad() {
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(QRScanViewController.myObserverMethod(notification:)), name:NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    func myObserverMethod(notification : NSNotification) {
        print("Observer method called")
        myDeleteFunction()
    }
    
    let firebase = Database.database().reference()
    
    func myDeleteFunction() {
        
        let imageNotFound: [String: String] = ["imageURL": "https://firebasestorage.googleapis.com/v0/b/boxscan-a76fb.appspot.com/o/Bitmap.png?alt=media&token=8420878c-db30-4ba5-b656-793ab414a4f4"]
        let qrImageNotFound: [String: String] = ["qrURL": "https://firebasestorage.googleapis.com/v0/b/boxscan-a76fb.appspot.com/o/Bitmap.png?alt=media&token=8420878c-db30-4ba5-b656-793ab414a4f4"]
        self.performSegue(withIdentifier: "unwind", sender: self)
        Database.database().reference().child("Boxes").child(boxHouseArray!).child(locationKey!).child(loc[cellPath!].firLocationUID).child("boxIDS").child(keyOfHouse!).updateChildValues(imageNotFound)
        Database.database().reference().child("Boxes").child(boxHouseArray!).child(locationKey!).child(loc[cellPath!].firLocationUID).child("boxIDS").child(keyOfHouse!).updateChildValues(qrImageNotFound)
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    
    //    @IBOutlet weak var nextLabel: UIButton!
    
    @IBOutlet weak var imagePicked: UIImageView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func openCameraButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func openPhotoLibraryButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePicked.contentMode = .scaleToFill
            imagePicked.image = pickedImage
            
            fileURL1 = info[UIImagePickerControllerReferenceURL] as? NSURL
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    //    func pressed(sender: UIButton) {
    //
    //        DispatchQueue.main.async {
    //            self.nextLabel.isEnabled = false
    //        }
    //    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        if imagePicked.image != nil {
            
            errorLabel.text = ""
            
            let config = CLDConfiguration(cloudName: "dyrxwd9ws", apiKey: "951511335298476")
            let cloudinary = CLDCloudinary(configuration: config)
            
            
            let imageData = UIImageJPEGRepresentation(imagePicked.image!, 1.00)
            
            let compresedImage = UIImage(data: imageData!)
            UIImageWriteToSavedPhotosAlbum(compresedImage!, nil, nil, nil)
            
            
            let params = CLDUploadRequestParams()
            
            let id = randomString(length: 20)
            
            params.setPublicId(id)
            
            cloudinary.createUploader().upload(data: imageData!, uploadPreset: "Jeremy", params: params)
            
            url = cloudinary.createUrl().generate(id)!
            
            PostService.create(for: self.imagePicked.image!, completion: { (success) -> Void in
                
                if success != "nil" {
                    
                    let ref = Database.database().reference().child("Boxes").child(boxHouseArray!).child(loc[cellPath!].firLocationUID).child("boxIDS").child(keyOfHouse!)
                    ref.updateChildValues(urlArray)
                    Database.database().reference().child("Boxes").child(boxHouseArray!).child(loc[cellPath!].firLocationUID).child("boxIDS").observeSingleEvent(of: .childAdded, with: {
                        snapshot in
                        let snapshotValue1 = snapshot.value as? NSDictionary
                        let imageURLS = snapshotValue1!["imageURL"] as? String
                        
                        var urlARRA = [String]()
                        let urlARRACount = urlARRA.count
                        urlARRA.append(imageURLS!)
                        if (urlARRA.count == urlARRACount + 1) {
                            
                            self.ezLoadingActivity.hide(true, animated: false)
                          
                        }
                        else {
                            print("error")
                            
                            self.ezLoadingActivity.show("Loading...", disableUI: true)
                            return
                        }
                        
                       //
                        
                    })
                    
                        QRSCANKEY = ref.key
                    self.ezLoadingActivity.show("Loading...", disableUI: true)
                    self.performSegue(withIdentifier: "NextSegue", sender: self)
                    return
                } else {
                    print("Fail")
                    return
                }
                
            })
          
        } else {
            errorLabel.text = "Choose a picture!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.errorLabel.text = ""
            }
        }
        
        
        
    }
    
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if imagePicked.image != nil {
            return true
        }
        else {
            return false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backButton(_ sender: Any) {
        let imageNotFound: [String: String] = ["imageURL": "https://firebasestorage.googleapis.com/v0/b/boxscan-a76fb.appspot.com/o/Bitmap.png?alt=media&token=8420878c-db30-4ba5-b656-793ab414a4f4"]
        let qrImageNotFound: [String: String] = ["qrURL": "https://firebasestorage.googleapis.com/v0/b/boxscan-a76fb.appspot.com/o/Bitmap.png?alt=media&token=8420878c-db30-4ba5-b656-793ab414a4f4"]
        self.performSegue(withIdentifier: "unwind", sender: self)
        Database.database().reference().child("Boxes").child(boxHouseArray!).child(loc[cellPath!].firLocationUID).child("boxIDS").child(keyOfHouse!).updateChildValues(imageNotFound)
        Database.database().reference().child("Boxes").child(boxHouseArray!).child(loc[cellPath!].firLocationUID).child("boxIDS").child(keyOfHouse!).updateChildValues(qrImageNotFound)
        
    }
    
    
    @IBAction func printImage(_ sender: Any) {
        if imagePicked.image == nil {
            errorLabel.text = "Choose a picture!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.errorLabel.text = ""
            }
        } else {
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
}

extension UIView {
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}


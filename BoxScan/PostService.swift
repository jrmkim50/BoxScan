//
//  PostService.swift
//  BoxScan
//
//  Created by Jeremy Kim on 7/25/17.
//  Copyright © 2017 SimpleSwift. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase


var urlArray = [String: String]()
var qrArray = [String: String]()
struct PostService {
    static func create(for image: UIImage, completion: @escaping (_ success: String) -> Void) {
        var urlString: String?
        let dateFormatter = ISO8601DateFormatter()
        let imageRef = Storage.storage().reference().child("Boxes").child("\(dateFormatter)\(User.current.uid)")
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                completion("nil")
                return
            }
            
            urlString = downloadURL.absoluteString
            urlArray = ["imageURL": urlString!]
            print("image url: \(String(describing: urlString))")
            completion(urlString!)
        }
    }
    
    static func createQR(for image: UIImage, completion: @escaping (_ success: String) -> Void) {
        var urlString: String?
        let dateFormatter = ISO8601DateFormatter()
        let imageRef = Storage.storage().reference().child("QRImages").child("\(dateFormatter)\(User.current.uid)")
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                completion("nil")
                return
            }
            
            urlString = downloadURL.absoluteString
            qrArray = ["qrURL": urlString!]
            print("image url: \(String(describing: urlString))")
            completion(urlString!)
        }
    }
    
    static func imageQRAppend(completion: @escaping ([imageAndQR]) -> Void) {
        var qrAndImage = [imageAndQR]()
        let ref = Database.database().reference()
            
        ref.child("Boxes").child(boxHouseArray!).queryOrderedByKey().observe(.value, with:  {
            snapshot in
            
            
            guard let snapshotArray = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            for individualSnapshot in snapshotArray {
                guard let snapshotValue = individualSnapshot.value as? NSDictionary else {
                    return completion([])
                }
                
                let imageURLS = snapshotValue["imageURL"] as? String
                let qrURLS = snapshotValue["qrURL"] as? String
                qrAndImage.append(imageAndQR(imageURL: imageURLS, qRURL: qrURLS))
            }
            
            
            
            completion(qrAndImage)
        })
        
        
    }
    
}

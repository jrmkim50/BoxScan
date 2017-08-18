//
//  StorageService.swift
//  BoxScan
//
//  Created by Jeremy Kim on 7/25/17.
//  Copyright © 2017 SimpleSwift. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

struct StorageService {
    static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
        guard let imageData = UIImageJPEGRepresentation(image, 0.1) else {
            return completion(nil)
        }
        
        reference.putData(imageData, metadata: nil, completion: { (metadata, error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            completion(metadata?.downloadURL())
        })
    }
}

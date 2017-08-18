//
//  Box.swift
//  BoxScan
//
//  Created by Jeremy Kim on 8/15/17.
//  Copyright © 2017 SimpleSwift. All rights reserved.
//

import Foundation

class Post {
    var key: String?
    let imageURL: String
    let creationDate: Date
    
    init(imageURL: String) {
        self.imageURL = imageURL
        self.creationDate = Date()
    }

}

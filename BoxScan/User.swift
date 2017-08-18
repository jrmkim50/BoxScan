//
//  User.swift
//  BoxScan
//
//  Created by Jeremy Kim on 7/24/17.
//  Copyright © 2017 SimpleSwift. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot
import UIKit

class User: NSObject {
    let uid: String
    let email: String
    var isFollowed = false
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
        
        super.init()
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let email = dict["email"] as? String
            else { return nil }
        
        self.uid = snapshot.key
        self.email = email
        super.init()
    }
    
    private static var _current: User?
    
    static var current: User {
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        return currentUser
    }
    
    class func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        if writeToUserDefaults {
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
        }
        
        _current = user
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: Constants.UserDefaults.uid) as? String,
            let email = aDecoder.decodeObject(forKey: Constants.UserDefaults.email) as? String
            else { return nil }
        
        self.uid = uid
        self.email = email
        
        super.init()
    }
    
}

extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: Constants.UserDefaults.uid)
        aCoder.encode(email, forKey: Constants.UserDefaults.email)
    }
}


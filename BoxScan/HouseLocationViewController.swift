//
//  BoxTableViewController.swift
//  BoxScan
//
//  Created by Jeremy Kim on 8/7/17.
//  Copyright © 2017 SimpleSwift. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

import EZLoadingActivity

class collectionViewCellHouseLocation: UICollectionViewCell {
    
    @IBOutlet weak var collectionLabel2: UILabel!
    var locate: locations?
}

var locationKey: String?
var boxHouseArray: String?
var locationArray: [String]?
var locationDict: [String]?
var loc = [locations]()
var cellPath: Int?

class HouseLocationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var boxIDS = [boxUIDS]()
    
    var indexNumber1: Int?
    var boxIDS1 = [boxIDSStruct]()
    let boxInput = ""
    var uidArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionView.isUserInteractionEnabled = true
        
        for uid in self.boxIDS1 {
            self.uidArray.append(uid.houseUIDInput)
        }
        
        boxHouseArray = self.uidArray[self.indexNumber1!]
        
        loadLocations()
        
        print(loc)
        print(self.boxIDS1)
        
        self.hideKeyboardWhenTappedAround()
        Database.database().reference().child("Boxes").child(boxHouseArray!).observe(.value, with: {
            (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else {
                    print("this did not work or there is no data?")
                    return }

            loc = [locations]()
            
            for locationSnapshot in snapshot {
                let locationData = locationSnapshot.value as! [String: Any?]
                print(locationData)
                loc.append(locations(locationHouse: locationData["locationInput"] as! String, firLocationUID: locationSnapshot.key))
//                print(loc[self.indexNumber1!].firLocationUID)
            }
        })
    }
    
    @IBAction func newLocationTapped(_ sender: Any) {
        let locName = UIAlertController(title: "Name of Box", message: "Name:", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let locInput = locName.textFields![0].text
            if (locInput!.isEmpty) {
                return
            } else {
                let locNameTitle: [String: String] = ["locationInput": locInput!]
                let databaseRef = Database.database().reference()
                //                self.boxHouseArray = self.uidArray[self.indexNumber1!]
                let temp = databaseRef.child("Boxes").child(boxHouseArray!).childByAutoId()
                temp.setValue(locNameTitle) { (error, ref) in
                    if let error = error {
                        assertionFailure(error.localizedDescription)
                        return
                    }
                    print("*** YEP, segue will occur")
                    self.loadLocations()
//                    self.performSegue(withIdentifier: "CollectionSeg2", sender: self)
                }
                locationKey = temp.key
                
            }
        }
        
        
        
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        locName.addTextField(configurationHandler: nil)
        locName.addAction(confirmAction)
        locName.addAction(cancelAction)
        
        self.present(locName, animated: true, completion: nil)
    }
    
    
    func loadLocations() {
        let databaseRef = Database.database().reference()
        databaseRef.child("Boxes").child(boxHouseArray!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else {
                    print("this did not work or there is no data?")
                    return }
            
            loc = [locations]()
            
            for boxSnapshot in snapshot {
                let boxData = boxSnapshot.value as! [String: Any?]
                print(boxData)
                loc.append(locations(locationHouse: boxData["locationInput"] as! String, firLocationUID: boxSnapshot.key))
            }
    
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        })
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellPath = indexPath.row
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //cellIndexPath = section
        return loc.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HouseLocationCell", for: indexPath) as! collectionViewCellHouseLocation
        
        collectionCell.collectionLabel2.text = loc[indexPath.row].locationHouse
        collectionCell.locate = loc[indexPath.row]
        
        return collectionCell
        
    }
    

    
}



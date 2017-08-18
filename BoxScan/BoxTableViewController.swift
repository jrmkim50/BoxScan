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

class collectionCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionLabel: UILabel!
    
}
var keyOfHouse: String?
var boxHouseArray: String?
var cellIndexPath: Int?
//var boxHouseKey = [String]()

class BoxTableViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var boxes = [Box]()  {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var indexNumber1: Int?
    var boxIDS1 = [boxIDSStruct]()
    let boxInput = ""
    var uidArray = [String]()
    //    var array = []()
    @IBAction func newBoxTapped(_ sender: Any) {
        let boxName = UIAlertController(title: "Name of Box", message: "Name:", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let boxInput = boxName.textFields![0].text
            if (boxInput!.isEmpty) {
                return
            } else {
                let boxNameTitle: [String: String] = ["boxNameInput": boxInput!, "boxUid": User.current.uid]
                let databaseRef = Database.database().reference()
//                self.boxHouseArray = self.uidArray[self.indexNumber1!]
                let temp = databaseRef.child("Boxes").child(boxHouseArray!).childByAutoId()
                temp.setValue(boxNameTitle) { (error, ref) in
                    if let error = error {
                        assertionFailure(error.localizedDescription)
                        return
                    }
                    print("*** YEP, segue will occur")
                    self.performSegue(withIdentifier: "ImageTakingSegue", sender: self)
                }
                keyOfHouse = temp.key
                
            }
        }
        

    
    
    
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        boxName.addTextField(configurationHandler: nil)
        boxName.addAction(confirmAction)
        boxName.addAction(cancelAction)
        
        self.present(boxName, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImageTakingSegue" {
            if boxInput.isEmpty {
                print("*** NOPE, segue wont occur")
            }
            else {
                print("*** YEP, segue will occur")
                let newVC = segue.destination as! QRScanViewController
            }
        }
    }
    

    override func viewDidLoad() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        super.viewDidLoad()
        for uid in self.boxIDS1 {
            self.uidArray.append(uid.houseUIDInput)
        }
        boxHouseArray = self.uidArray[self.indexNumber1!]
        let databaseRef = Database.database().reference()
        databaseRef.child("Boxes").child(boxHouseArray!).queryOrderedByKey().observe(.childAdded, with: {
            snapshot in
            let snapshotValue2 = snapshot.value as? NSDictionary
            let userBoxInput = snapshotValue2!["boxNameInput"] as? String
            let boxUID = snapshotValue2!["boxUid"] as? String
            //self.boxes.insert(Box(boxTitle: userBoxInput, firBoxUID: boxUID), at: 0)
            //Use arrays.append and reverse
            self.boxes.append(Box(boxTitle: userBoxInput, firBoxUID: boxUID))
            
            
            
        })
        
        print(self.boxes)
        print(self.boxIDS1)
        
        self.hideKeyboardWhenTappedAround()

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellIndexPath = indexPath.row
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //cellIndexPath = section
        return boxes.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCellTwo", for: indexPath) as! collectionCell
    
        print(self.boxes)
        collectionCell.collectionLabel.text = self.boxes[indexPath.row].boxTitle
        
        return collectionCell
        
    }
    
    @IBAction func unwindToBoxViewController(_ segue: UIStoryboardSegue) {
//         performSegue(withIdentifier: "unwind", sender: self)

    }
    
    
    
}

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

class collectionCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet var delete: UIButton!
    
}
var array = [String: [String]]()
var keyOfHouse: String?
var boxHouseArray: String?
var cellIndexPath: Int?


//var boxHouseKey = [String]()

class BoxTableViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    let timeStamp = Int(NSDate.timeIntervalSinceReferenceDate*1000)
    var arrayDict = [Any]()
    let ezLoadingActivity = EZLoadingActivity.self
    var item: NSMutableDictionary?
    
    func myDeleteFunction(childIWantToRemove: String) {
        let firebase = Database.database().reference()
        firebase.child("Boxes").child(boxHouseArray!).child(childIWantToRemove).removeValue { (error, ref) in
            if error != nil {
                print("error \(error)")
            }
        }
    }

    @IBAction func deleteColor(_ sender: Any) {
//        let prompt = UIAlertController(title: "Are you sure you want to delete?", message: "If so, press OK", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default)
//        prompt.addAction(okAction)
//        present(prompt, animated: true, completion: nil)
//        self.performSegue(withIdentifier: "BoxSeg123", sender: self)
////        myDeleteFunction(childIWantToRemove: String(describing: arrayDict[boxHouseArray!]))
//
//        collectionView.reloadData()
    }
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    var boxes = [Box]()  {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var boxIDS = [boxUIDS]()
    
    var indexNumber1: Int?
    var boxIDS1 = [boxIDSStruct]()
    let boxInput = ""
    var uidArray = [String]()
    var tapGesture = UITapGestureRecognizer()
    
    // function which is triggered when handleTap is called
    func handleTap(_ sender: UITapGestureRecognizer) {
        print("Hello World")
    }
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
        if boxes.count != 0 {
            self.ezLoadingActivity.show("Loading ... ", disableUI: false)
        }
        collectionView.isUserInteractionEnabled = true
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
            self.arrayDict = (snapshotValue2?.allKeys)!
            //self.boxes.insert(Box(boxTitle: userBoxInput, firBoxUID: boxUID), at: 0)
            //Use arrays.append and reverse
            self.boxes.append(Box(boxTitle: userBoxInput, firBoxUID: boxUID))
            
            self.ezLoadingActivity.hide()
            
            
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
    
//    func deleteUser(sender:UIButton) {
//        
//        myDeleteFunction()
    

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
    


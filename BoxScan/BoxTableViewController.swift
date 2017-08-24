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
    var box: Box?

    
}

var keyOfHouse: String?
var boxHouseArray: String?
var cellIndexPath: Int?


//var boxHouseKey = [String]()

class BoxTableViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var arrayDictKey = [String]()
    
    
    var arrayDict: NSDictionary?
    let ezLoadingActivity = EZLoadingActivity.self
    var item: NSMutableDictionary?
    
    func myDeleteFunction(childIWantToRemove: Box, completion: @escaping (Int?) -> Void) {
        
        let firebase = Database.database().reference()
        firebase.child("Boxes").child(boxHouseArray!).child(childIWantToRemove.firBoxUID).removeValue { (error, ref) in
            if error != nil {
                completion(nil)
                print("error \(error)")
                return
            }
            
        }
        

        completion(boxes.count)
        
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var boxes = [Box]()  {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var boxIDS = [boxUIDS]()
    
    var indexNumber2: Int?
    var locIDS1 = [boxIDSStruct]()
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
                    self.loadBoxes()
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
    
    
    
    func loadBoxes() {
        let databaseRef = Database.database().reference()
        databaseRef.child("Boxes").child(boxHouseArray!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else {
                    print("this did not work or there is no data?")
                    return }

            self.boxes = [Box]()
            
            for boxSnapshot in snapshot {
                let boxData = boxSnapshot.value as! [String: Any?]
                print(boxData)
                self.boxes.append(Box(boxTitle: boxData["boxNameInput"] as! String, firBoxUID: boxSnapshot.key))
            }
            
            
//            let snapshotValue2 = snapshot.value as? NSDictionary
//            self.arrayDictKey.append(snapshot.key)
//            let userBoxInput = snapshotValue2!["boxNameInput"] as? String
//            let boxUID = snapshotValue2!["boxUid"] as? String
//            
//            //self.boxes.insert(Box(boxTitle: userBoxInput, firBoxUID: boxUID), at: 0)
//            //Use arrays.append and reverse
//            self.boxes.append(Box(boxTitle: userBoxInput, firBoxUID: boxUID))
            
            
            
            self.boxes.sort(by: { (boxA, boxB) -> Bool in
                boxA.boxTitle < boxB.boxTitle
            })
            
            self.ezLoadingActivity.hide()
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionView.isUserInteractionEnabled = true
        
        if boxes.count != 0 {
            self.ezLoadingActivity.show("Loading ... ", disableUI: false)
        }
        
        loadBoxes()
        
        print(self.boxes)
        print(self.locIDS1)
        
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
        collectionCell.box = self.boxes[indexPath.row]
        
        return collectionCell
        
    }
    
    @IBAction func unwindToBoxViewController(_ segue: UIStoryboardSegue) {
        //         performSegue(withIdentifier: "unwind", sender: self)
        
    }
    
}



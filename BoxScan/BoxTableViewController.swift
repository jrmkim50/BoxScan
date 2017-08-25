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
var cellIndexPath: Int?
var locCellPath = loc[cellPath!].firLocationUID

//var boxHouseKey = [String]()

class BoxTableViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var arrayDictKey = [String]()
    
    var indexNumber2: Int?
    var locIDS = [locations]()
    var arrayDict: NSDictionary?
    let ezLoadingActivity = EZLoadingActivity.self
    var item: NSMutableDictionary?
    
    func myDeleteFunction(childIWantToRemove: Box, completion: @escaping (Int?) -> Void) {
        
        let firebase = Database.database().reference()
        firebase.child("Boxes").child(boxHouseArray!).child(loc[cellPath!].firLocationUID).child("boxIDS").child(childIWantToRemove.firBoxUID).removeValue { (error, ref) in
            if error != nil {
                completion(nil)
                print("error \(error)")
                return
            }
            
        }
        

        completion(boxes.count)
        
    }
    
    @IBAction func deleteColor(_ sender: Any) {
        guard let sender = sender as? UIView else {return}
        guard let boxCell = sender.superview?.superview as? collectionCell else {return}
        
        guard let box = boxCell.box else {return}
        
        
        let prompt = UIAlertController(title: "Are you sure you want to delete?", message: "If so, press OK", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.myDeleteFunction(childIWantToRemove: box, completion: { (success) in
                self.loadBoxes()
                //                    self.collectionView.reloadData()
                
            })
            
            
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        prompt.addAction(okAction)
        prompt.addAction(cancelAction)
        
        
        
        present(prompt, animated: true, completion: { (action) in
            
            
        })
        
        
        
        
    }

    @IBOutlet weak var collectionView: UICollectionView!
    
    var boxes = [Box]()  {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var boxIDS = [boxUIDS]()
    
    
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
                let temp = databaseRef.child("Boxes").child(boxHouseArray!).child(loc[cellPath!].firLocationUID).child("boxIDS").childByAutoId()
                temp.updateChildValues(boxNameTitle) { (error, ref) in
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
        databaseRef.child("Boxes").child(boxHouseArray!).child(loc[cellPath!].firLocationUID).child("boxIDS").observeSingleEvent(of: .value, with: {(snapshot) in
            
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
            
                else {
                    print("this did not work or there is no data?")
                    return }

            self.boxes = [Box]()
            
            for boxSnapshot in snapshot {
//                guard let boxData = boxSnapshot.value as? [String: Any] else {
//                    print("error!!!")
//                    return
//                }
                let boxData = boxSnapshot.value as! [String: Any]
                print(boxData)
                
                self.boxes.insert(Box(boxTitle: boxData["boxNameInput"] as! String, firBoxUID: boxSnapshot.key), at: 0)
            }
        
            
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
        
        loadBoxes()
        
        
        
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
        collectionCell.box = self.boxes[indexPath.row]
        
        return collectionCell
        
    }
    
    @IBAction func unwindToBoxViewController(_ segue: UIStoryboardSegue) {
        //         performSegue(withIdentifier: "unwind", sender: self)
        
    }
    
}



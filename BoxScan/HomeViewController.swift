//
//  HomeViewController.swift
//  BoxScan
//
//  Created by Jeremy Kim on 7/24/17.
//  Copyright © 2017 SimpleSwift. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import EZLoadingActivity

class YourCell: UITableViewCell {
    
    @IBOutlet weak var label2: UILabel!
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var houses = [House]() {
        didSet {
            tableView.reloadData()
        }
    }
    let ezLoadingActivity = EZLoadingActivity.self
    
    var boxIDS = [boxIDSStruct]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var indexNumber: Int?
    
    let userInput = ""
    
    var houseUIDValues = [Any]()
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func newHouseTapped(_ sender: Any) {
        let houseName = UIAlertController(title: "Name of House", message: "Name:", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let userInput = houseName.textFields![0].text
            if (userInput!.isEmpty) {
                return
            } else {
                
                let houseNameTitle: [String: String] = ["userHouseInput": userInput!, "uid": User.current.uid]
                let databaseRef = Database.database().reference()
                let temp = databaseRef.child("Houses").child(User.current.uid).childByAutoId()
                
                let ID = temp.key
                let boxUIDSTitle: [String: String] = ["boxUID": ID]
                databaseRef.child("MovingUID").child(User.current.uid).childByAutoId().setValue(boxUIDSTitle)
                temp.setValue(houseNameTitle)
                print(self.boxIDS)
                print(self.houseUIDValues)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        houseName.addTextField(configurationHandler: nil)
        houseName.addAction(confirmAction)
        houseName.addAction(cancelAction)
        
        print("BoxIDS[1] =  \(boxIDS)")
        
        Database.database().reference().child("MovingUID").child(User.current.uid).queryOrderedByKey().observe(.childAdded, with: {
            snapshot in
            let snapshotValue1 = snapshot.value as? NSDictionary
            let houseUIDInput = snapshotValue1!["boxUID"] as? String
            self.boxIDS.insert(boxIDSStruct(houseUIDInput: houseUIDInput), at: 0)
            print(self.boxIDS)
            self.tableView.reloadData()
            print("BoxIDS[1] =  \(self.houseUIDValues)")
        })
        
        self.tableView.reloadData()
        
        self.present(houseName, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
                    
        let databaseRef = Database.database().reference()
        databaseRef.child("Houses").child(User.current.uid).queryOrderedByKey().observe(.childAdded, with: {
            
            snapshot in

            let snapshotValue = snapshot.value as? NSDictionary
            let userHouseInput = snapshotValue!["userHouseInput"] as? String
            let uid = snapshotValue!["uid"] as? String
            self.houses.insert(House(houseNameTitle: userHouseInput, uid: uid), at: 0)
            print(self.houses)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
            
            
        })
        
        Database.database().reference().child("MovingUID").child(User.current.uid).queryOrderedByKey().observe(.childAdded, with: {
            snapshot in
            let snapshotValue1 = snapshot.value as? NSDictionary
            let houseUIDInput = snapshotValue1!["boxUID"] as? String
            self.boxIDS.insert(boxIDSStruct(houseUIDInput: houseUIDInput), at: 0)
            print(self.boxIDS)
            self.tableView.reloadData()
            print("BoxIDS[1] =  \(self.houseUIDValues)")
        })
        
        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houses.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexNumber = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! YourCell
        if( indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor(rgb: 0xF9EEEA)
            cell.textLabel?.textColor = UIColor(rgb: 0x054A91)
        }
        else {
            cell.backgroundColor = UIColor(rgb: 0x696CA7)
            cell.textLabel?.textColor = UIColor(rgb: 0xDBE4EE)
        }
        let ref = Database.database().reference().child("Houses").child(User.current.uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                DispatchQueue.main.async {
                    cell.label2.text = self.houses[indexPath.row].houseNameTitle
                    
                }
                
            } else {
                return
            }
        })
        //        print(String(cell.label2.text!))
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "CollectionSeg" {
            let BoxView = segue.destination as! BoxTableViewController
            //            BoxView.indexNumber1 = indexNumber
            BoxView.indexNumber1 = tableView.indexPathForSelectedRow?.row
            BoxView.boxIDS1 = boxIDS
            for uid in boxIDS {
                print(uid.houseUIDInput)
            }
        } else {
            return
        }
        
    }
    
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier! == "CollectionSeg" {
    //            let BoxView = segue.destination as! BoxTableViewController
    //            
    //        }
    //    }
    
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

//
//  QueueViewController.swift
//  racelace
//
//  Created by Michael Peng on 7/10/19.
//  Copyright © 2019 Michael Peng. All rights reserved.
//

import UIKit
import Firebase

class CustomTableViewCell: UITableViewCell {
    
    var points = 0
    var ref: DatabaseReference!
    @IBOutlet weak var Button: UIButton!
    var lobbyNum: Int = 0
    @IBAction func ButtonPressed(_ sender: Any) {
        retrieveData()
        ref.child("Players").child(Auth.auth().currentUser!.uid).updateChildValues(["Lobby":lobbyNum])
    }
    
    
    func retrieveData() {
        let userID = (Auth.auth().currentUser?.uid)!
        ref.child("Players").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {
                print("No Data!!!")
                return
            }
            self.points = value["Currency"] as! Int
            
        }) { (error) in
            print("error:\(error.localizedDescription)")
        }
        
        
    }
    
}

class QueueViewController: UIViewController, UITableViewDataSource {
    var bef: DatabaseReference!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bef = Database.database().reference()
        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "cell", bundle: nil) , forCellReuseIdentifier: "custom")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "custom") as! CustomTableViewCell
        cell.Button.setTitle("Lobby" + String(indexPath.row+1), for: .normal)
        cell.lobbyNum = indexPath.row+1
        cell.ref = bef
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  TripEditViewController.swift
//  Travelogue
//
//  Created by kent daniel on 3/5/2023.
//

import UIKit

class TripEditViewController: UIViewController ,passMembersDelegate{
    
    var currentUser : User?
    var members : [User]?
    
    @IBOutlet weak var membersTable: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    
    // ISSUE : rename
    @IBAction func addTrip(_ sender: Any) {
        // add admin
        let currentTrip = TripController().createNewTrip(name: nameTextField.text!, admin: self.currentUser!)
        
        print(members)
        TripController().updateTripMembers(members: members!, trip: currentTrip!)
        
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get current user
        var currentUserId = AuthController().getCurrentUser()?.uid
        UserController().getUserByID(id: currentUserId!) { user, err in
            if let user = user {
                self.currentUser = user
            } else {
                print(err?.localizedDescription)
            }
        }
        
        // Set up table view
        tableViewSetup()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    // UI set up
    func tableViewSetup(){
        membersTable.layer.borderColor = UIColor.lightGray.cgColor
        membersTable.layer.borderWidth = 1
        membersTable.layer.cornerRadius = 8
        membersTable.layer.masksToBounds = true
        
        membersTable.dataSource = self
        membersTable.delegate = self
        membersTable.register(UITableViewCell.self, forCellReuseIdentifier: "membersCell")
    }
    
    
    func passMembers(members: [User]) {
        self.members=members
        membersTable.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "tripEditAddMembers"){
            let membersVC = segue.destination as! MembersEditTableViewController
            membersVC.delegate = self
        }
    }
    
    
    
    
    
    
}


extension TripEditViewController : UITableViewDelegate , UITableViewDataSource{
    // TABLE VIEW CODE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "membersCell", for: indexPath)
        let member = members![indexPath.row]
        cell.textLabel?.text = member.name
        return cell
    }
    
    
}









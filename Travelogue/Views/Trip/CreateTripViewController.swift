//
//  TripEditViewController.swift
//  Travelogue
//
//  Created by kent daniel on 3/5/2023.
//

import UIKit

class CreateTripViewController: UIViewController ,passMembersDelegate{
    
    var currentUser : User?
    var members : [User]?
    
    @IBOutlet weak var membersTable: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    
    // ISSUE : rename
    @IBAction func addTrip(_ sender: Any) {
        // add admin
        let currentTrip = TripController().createNewTrip(name: nameTextField.text!, admin: self.currentUser!)
        
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
    func tableViewSetup() {
        membersTable.layer.cornerRadius = 8
        membersTable.layer.masksToBounds = true
        membersTable.isEditing = true
        membersTable.dataSource = self
        membersTable.delegate = self
        membersTable.layer.borderWidth = 1
        membersTable.register(MemberTableViewCell.self, forCellReuseIdentifier: "membersCell")
        membersTable.heightAnchor.constraint(equalToConstant: 0).isActive = true // Set initial height to 0
    }

    
    func passMembers(members: [User]) {
        if self.members == nil {
            self.members = []
        }
        
        for member in members {
            if !self.members!.contains(where: { $0.id == member.id }) {
                self.members!.append(member)
            }
        }
        
        membersTable.reloadData()
        // Update table height based on number of members
        membersTable.heightAnchor.constraint(equalToConstant: CGFloat(self.members?.count ?? 0) * 44.0).isActive = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "tripEditAddMembers"){
            let membersVC = segue.destination as! MembersEditTableViewController
            membersVC.delegate = self
        }
    }
    
    
    
}


extension CreateTripViewController : UITableViewDelegate , UITableViewDataSource{
    // TABLE VIEW CODE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "membersCell", for: indexPath) as! MemberTableViewCell
        let member = members![indexPath.row]
        cell.textLabel?.text = member.name
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            members?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    
}

class MemberTableViewCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 2
    }
    
}










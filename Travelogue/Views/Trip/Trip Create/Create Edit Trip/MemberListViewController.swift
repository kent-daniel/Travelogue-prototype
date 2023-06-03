//
//  MemberListViewController.swift
//  Travelogue
//
//  Created by kent daniel on 31/5/2023.
//

import UIKit

protocol memberListDelegate : NSObjectProtocol{
    func passMemberList(_ members: [User]?)
}

class MemberListViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , passMembersDelegate{
    var members : [User]?
    var selectedTrip : Trip?
    weak var delegate : memberListDelegate?
    
    
    @IBAction func saveMembersList(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        delegate?.passMemberList(members)
    }
    
    func passMembers(members: [User]) {
        if self.members == nil {
            self.members = []
        }
        
        // not append duplicate members
        for member in members {
            if !self.members!.contains(where: { $0.id == member.id }) {
                self.members!.append(member)
            }
        }
        membersTable.reloadData()
        membersCount.text = "Members count : \(self.members!.count)"
        
    }
    
    @IBOutlet weak var membersCount: UILabel!
    
    @IBOutlet weak var membersTable: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        membersTable.isEditing = true
        membersTable.dataSource = self
        membersTable.delegate = self
        membersTable.register(UINib(nibName: "MemberTableViewCell", bundle: nil), forCellReuseIdentifier: "membersCell")
        membersTable.rowHeight = 100
        

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        members?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "membersCell", for: indexPath) as! MemberTableViewCell
        let member = members![indexPath.row]
        cell.MemberName.text = member.name
        cell.memberEmail.text = member.email
        
        cell.memberProfileImage.image = UIImage(systemName: "person.circle.fill") // Set default image initially
        
        if let profileImgUrl = member.profileImgUrl {
            cell.showLoadingIndicator() // Show spinner
            
            ImageManager.downloadImage(from: profileImgUrl) { profileImage, error in
                cell.hideLoadingIndicator() // Hide spinner
                
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                } else if let profileImage = profileImage {
                    cell.memberProfileImage.image = profileImage
                }
            }
        }
        
        return cell
    }


    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            members?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            membersCount.text = "Members count: \(members?.count ?? 0)"
        }
    }


    
    // MARK: - Navigation
     // MARK: - segues
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if(segue.identifier == "tripEditAddMembers"){
             let membersVC = segue.destination as! MembersSearchTableViewController
             membersVC.delegate = self
         }
     
     }
    

}

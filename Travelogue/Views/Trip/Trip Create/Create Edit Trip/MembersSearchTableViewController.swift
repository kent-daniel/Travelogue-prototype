//
//  MembersEditTableViewController.swift
//  Travelogue
//
//  Created by kent daniel on 3/5/2023.
//

import UIKit

protocol passMembersDelegate : NSObjectProtocol{
    func passMembers(members: [User])
}
import ProgressHUD


class MembersSearchTableViewController: UITableViewController , UISearchBarDelegate{
    weak var delegate : passMembersDelegate?
    var members = [User]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search member email"
        searchController.searchBar.showsCancelButton = true
        navigationItem.searchController = searchController
        // Ensure the search bar is always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
        
        tableView.register(UINib(nibName: "MemberTableViewCell", bundle: nil), forCellReuseIdentifier: "membersCell")
        tableView.rowHeight = 100
        
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        members.removeAll()
        tableView.reloadData()
        guard let searchText = searchBar.text else{
            return
        }
        navigationItem.searchController?.dismiss(animated: true)
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.show("Searching Users")
        Task {
            await UserController().searchUsersByEmail(email: searchText.lowercased()) { (users, error) in
                if let error = error {
                    print("Error searching users: \(error.localizedDescription)")
                } else if let users = users {
                    // Handle the found users
                    print("Found \(users.count) users:")
                    for user in users {
                        print(user)
                        self.members.append(user)
                    }
                    // stop loading animation
                    ProgressHUD.dismiss()
                    self.tableView.reloadData()
                    
                } else {
                    ProgressHUD.show("No user found")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        ProgressHUD.dismiss()
                    }
                  
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "membersCell", for: indexPath) as! MemberTableViewCell
        let member = members[indexPath.row]
        cell.MemberName.text = member.name
        cell.memberEmail.text = member.email
        
        cell.memberProfileImage.image = UIImage(systemName: "person.circle.fill") // Set default image initially
        
        if let profileImgUrl = member.profileImgUrl {
            cell.memberProfileImage.showLoadingAnimation() // Show spinner
            
            ImageManager.downloadImage(from: profileImgUrl) { profileImage, error in
                cell.memberProfileImage.hideLoadingAnimation() // Hide spinner
                
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                } else if let profileImage = profileImage {
                    cell.memberProfileImage.image = profileImage
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           // Get the selected member
           let selectedMember = members[indexPath.row]
        print(selectedMember.name)
           // Call the delegate method to pass the selected member back to the previous screen
           delegate?.passMembers(members: [selectedMember])
           
           // Go back to the previous screen
           navigationController?.popViewController(animated: true)
       }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

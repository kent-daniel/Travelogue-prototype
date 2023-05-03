//
//  MembersEditTableViewController.swift
//  Travelogue
//
//  Created by kent daniel on 3/5/2023.
//

import UIKit

class MembersEditTableViewController: UITableViewController , UISearchBarDelegate{
    
    var members = [User]()
    var indicator = UIActivityIndicatorView()
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tripEditVC = storyboard.instantiateViewController(withIdentifier: "TripEditViewController") as? TripEditViewController else {
                    return
                }
        tripEditVC.members = self.members
        navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
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
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Add a loading indicator view (loading spinner)
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo:
                                                view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo:view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        members.removeAll()
        tableView.reloadData()
        guard let searchText = searchBar.text else{
            return
        }
        navigationItem.searchController?.dismiss(animated: true)
        indicator.startAnimating()
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
                    self.indicator.stopAnimating()
                    self.tableView.reloadData()
                    
                } else {
                    print("No users found")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath)
        
        // Get the member at the current index path
        let member = members[indexPath.row]
        
        // Set the cell's text label to the member's email
        cell.textLabel?.text = member.email
        
        
        return cell
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

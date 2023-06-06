import UIKit

class ViewMembersTableViewController: UITableViewController {
    var members: [User]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MemberTableViewCell", bundle: nil), forCellReuseIdentifier: "membersCell")
        tableView.rowHeight = 100
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "membersCell", for: indexPath) as! MemberTableViewCell
        
        let member = members![indexPath.row]
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
                    DispatchQueue.main.async {
                        // Ensure UI updates are done on the main queue
                        cell.memberProfileImage.image = profileImage
                    }
                }
            }
        }
        
        return cell
    }
    
    // ...
}

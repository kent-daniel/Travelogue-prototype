//
//  FavouritesViewController.swift
//  Travelogue
//
//  Created by kent daniel on 9/6/2023.
//

import UIKit
import FirebaseFirestore

func convertStringToDocumentReference(_ documentPath: String) -> DocumentReference? {
    let components = documentPath.components(separatedBy: "/")
    
    // Make sure the document path contains at least two components: collection and document ID
    guard components.count >= 2 else {
        return nil
    }
    
    let collectionPath = components.dropLast().joined(separator: "/")
    let documentID = components.last!
    
    return Firestore.firestore().document("\(collectionPath)/\(documentID)")
}

class FavouritesViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        
        // Configure the cell with post data
        let post = self.posts![indexPath.row]
            print(post)
            cell.postTitle.text = post.title
            cell.postDesc.text = post.desc ?? ""
            cell.DateTime.text = DateParser.stringFromDate(post.dateTime! , format:"yyyy-MM-dd HH:mm")
            cell.profileImage.image = UIImage(systemName: "person.circle.fill")
            cell.profileImage.showLoadingAnimation()
            cell.postImage.showLoadingAnimation()
            ImageManager.downloadImage(from: post.url!){
                image , err in
                cell.postImage.hideLoadingAnimation()
                cell.postImage.image = image
            }
            UserController().getUser(from: post.poster!){
                user in
                cell.username.text = user?.name
                ImageManager.downloadImage(from: user!.profileImgUrl!){
                    image,error  in

                    cell.profileImage.hideLoadingAnimation() // Hide spinner

                    if let error = error {
                        print("Error downloading image: \(error.localizedDescription)")
                    } else if let profileImage = image {
                        cell.profileImage.image = profileImage
                    }

                }
            
            
        }
        
        return cell
    }
    
    var posts : [Post]?
    @IBOutlet weak var postTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postTableView.dataSource = self
        postTableView.delegate = self

        postTableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        postTableView.rowHeight = 450

        // Read saved post references from UserDefaults
        if let savedPostRefs = UserDefaults.standard.array(forKey: "SavedPostRefs") as? [String] {
            var posts: [Post] = [] // Create an empty array to store the fetched posts

            let dispatchGroup = DispatchGroup() // Create a dispatch group for handling async tasks

            // Iterate over each post reference
            for postRefPath in savedPostRefs {
                dispatchGroup.enter() // Enter the dispatch group

                // Convert the string reference to a DocumentReference
                if let postRef = convertStringToDocumentReference(postRefPath) {
                    // Fetch the post from Firestore using the reference
                    TripController().getPost(byReference: postRef) { post, error in
                        if let error = error {
                            print("Error fetching post: \(error.localizedDescription)")
                        } else if let post = post {
                            posts.append(post) // Append the fetched post to the array
                        }
                        dispatchGroup.leave() // Leave the dispatch group
                    }
                } else {
                    dispatchGroup.leave() // Leave the dispatch group if the reference is invalid
                }
            }

            // Notify when all async tasks are completed
            dispatchGroup.notify(queue: .main) {
                self.posts = posts // Assign the fetched posts to self.posts
                self.postTableView.reloadData() // Reload the table view to display the posts
            }
        }
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

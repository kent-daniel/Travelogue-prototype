//
//  TripDetailsViewController.swift
//  Travelogue
//
//  Created by kent daniel on 3/5/2023.
//

import UIKit
import CoreLocation
import Firebase

class TripDetailsViewController: UIViewController, didFinishEditingTrip {
    
    func didEditTrip(_ trip: Trip) {
        self.trip = trip
        self.title = trip.name
        print(trip)
    }
    
    

    
    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    var trip:Trip?
    var currentUser:User?
    var currentUserRef:DocumentReference?
    
    var posts: [Post]?
    var isAdmin: Bool = false
    var tripMembers:[User]? = [User]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.currentUser = appDelegate?.currentUser
        // set the title of the view controller to the trip name
        self.title = trip?.name
        
        // Sort posts based on date in descending order
        self.posts = trip!.posts!.sorted(by: { $0.dateTime! > $1.dateTime! })
        
        postTableView.dataSource = self
        postTableView.delegate = self
        
        postTableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        postTableView.rowHeight = 450
        
        print(self.posts?.count)
        for memberRef in (self.trip?.members) ?? [] {
            UserController().getUser(from: memberRef) { user in
                if let user = user {
                    self.tripMembers!.append(user)
                }
                
            }
        }
        
        UserController().getDocumentReference(for: currentUser!) { currentUserRef,error  in
            guard let currentUserRef = currentUserRef else {
                // handle the case where currentUserRef is nil
                return
            }
            self.currentUserRef = currentUserRef
            // check admin priviledge
            if currentUserRef == self.trip?.admin {
                self.isAdmin = true
                
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        TripController().getAllTripPosts(for: self.trip!){ posts,error in
            self.posts = posts
            
            // Sort posts based on date in descending order
            self.posts = self.posts!.sorted(by: { $0.dateTime! > $1.dateTime! })
            
            DispatchQueue.main.async {
                self.postTableView.reloadData()
            }
        }
        
    }
    
    @IBAction func editButtonClicked(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Common actions for both members and admins
        let createPostAction = UIAlertAction(title: "Create a New Post", style: .default) { _ in
            // Handle create post action
            self.performSegue(withIdentifier: "tripCreatePostSegue", sender: nil)
        }
        
        let seeMembersAction = UIAlertAction(title: "See Trip Members", style: .default) { _ in
            // Handle see members action
            self.performSegue(withIdentifier: "viewTripMembers", sender: nil)
        }
        
        actionSheet.addAction(createPostAction)
        actionSheet.addAction(seeMembersAction)
        
        if isAdmin {
            // Actions only for admin
            let editTripAction = UIAlertAction(title: "Edit Trip", style: .default) { _ in
                // Handle edit trip action
                self.performSegue(withIdentifier: "editTripSegue", sender: nil)
            }
            
            actionSheet.addAction(editTripAction)
        } else {
            // Actions only for members
            let leaveGroupAction = UIAlertAction(title: "Leave Group", style: .destructive) { _ in
                let confirmationAlert = UIAlertController(title: "Confirmation", message: "Are you sure you want to leave the group?", preferredStyle: .alert)
                
                let confirmAction = UIAlertAction(title: "Leave", style: .destructive) { _ in
                    // Handle leave group action
                    
                    TripController().removeMemberFromTrip(member: self.currentUserRef!, trip: self.trip!)
                    let tripRef = TripController().getDocumentReference(for: self.trip!)
                    UserController().removeTripFromUser(user: self.currentUser!, tripRefToRemove: tripRef!)
                    
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                confirmationAlert.addAction(confirmAction)
                confirmationAlert.addAction(cancelAction)
                
                self.present(confirmationAlert, animated: true, completion: nil)
            }
            
            actionSheet.addAction(leaveGroupAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        // Present the action sheet
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.barButtonItem = editButton
        }
        present(actionSheet, animated: true, completion: nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showMapSegue"){
            let mapVC = segue.destination as! TripMapViewController
            // get all name , coordinate & address from the itinerary & pass to mapVC
            // Extract the necessary data from itineraries
            var locations: [(name: String, coordinate: CLLocationCoordinate2D, address: String, imageURL: String?)] = []
            for itinerary in trip?.itineraries ?? [] {
                if let name = itinerary.title,
                   let coordinateArray = itinerary.coordinate,
                   coordinateArray.count >= 2,
                   let latitude = coordinateArray.first,
                   let longitude = coordinateArray.last,
                   let address = itinerary.address{
                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    locations.append((name: name, coordinate: coordinate, address: address, imageURL: itinerary.imgURL ?? ""))
                }
            }
            mapVC.locations = locations
        }else if (segue.identifier == "tripCreatePostSegue"){
            let createPostVC = segue.destination as! CreatePostViewController
            createPostVC.selectedTrip = trip
        }else if (segue.identifier == "editTripSegue"){
            let editTripVC = segue.destination as! UpdateTripTableViewController
            editTripVC.selectedTrip = trip
            editTripVC.tripMembers = self.tripMembers ?? []
            if isAdmin{
                editTripVC.mode = .edit
            }
            
            editTripVC.delegate = self
            
        }else if (segue.identifier == "viewTripMembers"){
            let viewMembersVC = segue.destination as! ViewMembersTableViewController
            viewMembersVC.members = self.tripMembers


        }else if (segue.identifier == "tripInfoSegue"){
            let tripInfoVC = segue.destination as! TripInfoViewController
            tripInfoVC.trip = self.trip
        }
    }
}


extension TripDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the table view
        return self.posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        tapGesture.numberOfTapsRequired = 2
        cell.addGestureRecognizer(tapGesture)
        cell.isUserInteractionEnabled = true
        cell.tag = indexPath.row

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle row selection
        if let itinerary = trip?.posts![indexPath.row] {
            // Do something with the selected itinerary
            print("Selected itinerary: \(itinerary)")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        guard let cell = gesture.view as? PostTableViewCell else { return }
        let index = cell.tag
        guard let post = posts?[index] else { return }
        
        let alertController = UIAlertController(title: "Save Post", message: "Do you want to save this post?", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            
            
            // Add the new post ID to the array
            let tripRef = TripController().getDocumentReference(for: self.trip!)
            let postRef = tripRef?.collection("posts").document(post.id!)
            // Convert postRef to a string
            let postRefString = postRef?.path

            // Retrieve existing saved post references from UserDefaults
            var savedPostRefs = UserDefaults.standard.array(forKey: "SavedPostRefs") as? [String] ?? []

            // Add the new post reference string to the array
            savedPostRefs.append(postRefString!)

            // Save the updated array to UserDefaults
            UserDefaults.standard.set(savedPostRefs, forKey: "SavedPostRefs")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

}





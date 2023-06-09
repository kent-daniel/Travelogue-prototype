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
    
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    var trip:Trip?
    var currentUser:User?
    var currentUserRef:DocumentReference?
    var collectionView: UICollectionView!
    var posts: [Post]?
    var isAdmin: Bool = false
    var tripMembers:[User]? = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.currentUser = appDelegate?.currentUser
        // set the title of the view controller to the trip name
        self.title = trip?.name
        self.posts = trip?.posts
        print(self.trip?.members)
        print("\(trip?.id) id")
        
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
        
        
        
        
        
        // Initialize collection view layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        layout.itemSize = CGSize(width: 300, height: 300)
        
        // Initialize collection view
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: "PostCell")
        collectionView.backgroundColor = .white
        
        // Add collection view to view hierarchy
        view.addSubview(collectionView)
        
        // Add constraints to position and size collection view
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        TripController().getAllTripPosts(for: self.trip!){ posts,error in
            self.posts = posts
            self.collectionView.reloadData()
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


        }
    }
}



// Implement collection view data source and delegate methods
extension TripDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts?.count ?? 0 // Replace with your actual number of items
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
        
        let post = posts![indexPath.item]
        cell.configure(with: post)
        
        return cell
    }

}



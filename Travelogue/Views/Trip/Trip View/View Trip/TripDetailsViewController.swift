//
//  TripDetailsViewController.swift
//  Travelogue
//
//  Created by kent daniel on 3/5/2023.
//

import UIKit

class TripDetailsViewController: UIViewController {
    @IBOutlet weak var editButton: UIBarButtonItem!
    var trip:Trip?
    var currentUser:User?
    var collectionView: UICollectionView!
    var posts: [Post]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.currentUser = appDelegate?.currentUser
        // set the title of the view controller to the trip name
        self.title = trip?.name
        self.posts = trip?.posts
        
        UserController().getDocumentReference(for: currentUser!) { currentUserRef in
            guard let currentUserRef = currentUserRef else {
                // handle the case where currentUserRef is nil
                return
            }
            
            print(currentUserRef , self.trip?.admin)
            if currentUserRef == self.trip?.admin {
                
                self.editButton.isEnabled = true
            } else {
                self.editButton.isEnabled = false
            }
        }
        
        
        let add = UIAction(title: "Create A Post" , image: UIImage(systemName: "plus.app")) { _ in
            // go to create post VC
            print("add is tapped")
            self.navigateToPostController(from: self)
        }
        
        let edit = UIAction(title: "Edit Trip", image: UIImage(systemName: "pencil")) { _ in
            // go to edit trip VC
            
        }
        
        let delete = UIAction(title: "Delete Trip", image: UIImage(systemName: "trash")) { _ in
            
        }
        
        let menu = UIMenu(title: "Menu", children: [add, edit, delete])
        editButton.menu = menu
        
        
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
    
    
    func navigateToPostController(from viewController: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let postVC = storyboard.instantiateViewController(withIdentifier: "CreatePostViewController") as? CreatePostViewController else {
            return
        }
        postVC.navigationItem.hidesBackButton=true
        postVC.selectedTrip = self.trip
        let navController = UINavigationController(rootViewController: postVC)
        navController.title = "Create a new post"
        postVC.navigationItem.hidesBackButton=true
        viewController.present(navController, animated: true, completion: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
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



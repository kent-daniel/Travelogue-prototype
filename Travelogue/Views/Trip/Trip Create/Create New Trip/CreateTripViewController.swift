//
//  TripEditViewController.swift
//  Travelogue
//
//  Created by kent daniel on 3/5/2023.
//

import UIKit

class CreateTripViewController: UIViewController ,passMembersDelegate , SearchLocationViewControllerDelegate, ItineraryListEditDelegate{
    func didFinishEditingItineraryList(itineraries: [Itinerary]) {
        print(itineraries)
        itineraryList = itineraries
    }
    
    
    func didSelectLocation(_ location: Location) {
        print(location.name)
        print(location.address)
        print(location.coordinate)
    }
    
    
    var currentUser : User?
    var members : [User]?
    var itineraryList : [Itinerary]?
   
    @IBOutlet weak var membersTable: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var descTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get current user
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.currentUser = appDelegate?.currentUser
        
        
        tableViewSetup()
        
        
        
    }
    // ISSUE : rename
    @IBAction func addTrip(_ sender: Any) {
        // add admin
        let currentTrip = TripController().createNewTrip(name: nameTextField.text!, admin: self.currentUser!)
        
        TripController().updateTripMembers(members: members!, trip: currentTrip!)
        TripController().updateItinerariesInTrip(itineraries: itineraryList!, trip: currentTrip!)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
    // MARK: - segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "tripEditAddMembers"){
            let membersVC = segue.destination as! MembersSearchTableViewController
            membersVC.delegate = self
        }else if (segue.identifier == "itineraryListSegue"){
            let itineraryListVC = segue.destination as! ItineraryListTableViewController
            itineraryListVC.delegate = self
        
            
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
        
        self.backgroundColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.0)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 2
    }
    
}












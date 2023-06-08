//
//  CreateNewTripTableViewController.swift
//  Travelogue
//
//  Created by kent daniel on 1/6/2023.
//

import UIKit
import Firebase
import ProgressHUD
class UpdateTripTableViewController: UITableViewController , SearchLocationViewControllerDelegate , memberListDelegate , ItineraryListEditDelegate{
    func passMemberList(_ members: [User]?) {
        self.tripMembers = members!
        membersCount.text = "\(self.tripMembers.count) members"
    }
    
    func didSelectLocation(_ location: Location) {
        locationName.text = location.name
        locationCode = location.countryCode
    }
    
    func didFinishEditingItineraryList(itineraries: [Itinerary]) {
        self.tripItineraries = itineraries
    }
    
    @IBAction func saveTripChanges(_ sender: Any) {
        
        // Form data validation
        guard let tripName = tripNameText.text, !tripName.isEmpty else {
            AlertHelper.showAlert(title: "Validation Error", message: "Trip name cannot be empty.", viewController: self)
            return
        }
        
        // Check if location name is empty
        guard let location = locationName.text, !location.isEmpty else {
            AlertHelper.showAlert(title: "Validation Error", message: "Location name cannot be empty.", viewController: self)
            return
        }
       
        var newMemberRefs :[DocumentReference] = []
        for newMember in self.tripMembers{
            UserController().getDocumentReference(for: newMember){userRef,error  in
                newMemberRefs.append(userRef!)
            }
        }
        // FIXME: seperate create & edit trip
        
        // create trip
        
        // edit trip
        
        
        // create / update trip
        if self.mode == .create{
            ProgressHUD.animationType = .singleCirclePulse
            ProgressHUD.show("Creating New Trip")
            TripController().createOrUpdateTrip(name: tripNameText.text!, desc: tripDescText.text!, date: tripDate.date, locationName: locationName.text!, countryCode: (locationCode ?? selectedTrip?.countryCode) ?? "AU", admin: self.currentUserRef!,members: newMemberRefs ,mode:.create){ [self]
                trip in
                // add trip to current user
                let tripRef = TripController().getDocumentReference(for: trip!)
                UserController().addTripToUser(user: self.currentUser!, newTripRef: tripRef!)
                
                
                
                
                
                    // Add trip to all the invited members
                for member in self.tripMembers {
                    if member != self.currentUser {
                        UserController().addTripToUser(user: member, newTripRef: tripRef!)
                    }
                }
                
                
                
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                    self.navigationController?.popViewController(animated: true)
                }
                
                
            }
        }else if self.mode == .edit{
            ProgressHUD.animationType = .singleCirclePulse
            ProgressHUD.show("Updating Trip")
            TripController().createOrUpdateTrip(name: tripNameText.text!, desc: tripDescText.text!, date: tripDate.date, locationName: locationName.text!, countryCode: (locationCode ?? selectedTrip?.countryCode) ?? "AU", admin: self.currentUserRef!, mode:.edit){ [self] trip in
                
                
                
                let tripRef = TripController().getDocumentReference(for: self.selectedTrip!)
                for memberRef in selectedTrip!.members!{
                    // remove all members from the original trip
                    TripController().removeMemberFromTrip(member: memberRef, trip: self.selectedTrip!)
                    // remove the trip from all the original members
                    UserController().getUser(from: memberRef) {user in
                        UserController().removeTripFromUser(user: user!, tripRefToRemove: tripRef!)
                    }
                }
               
                // add trip to all users
                for member in tripMembers{
                    UserController().addTripToUser(user: member,newTripRef: tripRef!)
                }
                TripController().updateTripMembers(members: newMemberRefs, trip: trip!)
                
                
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                    self.navigationController?.popViewController(animated: true)
                }
                
                
            }
            
        }
        
       
        
    }
    @IBOutlet weak var tripNameText: UITextView!
    @IBOutlet weak var tripDescText: UITextView!
    @IBOutlet weak var tripDate: UIDatePicker!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var membersCount: UILabel!
    
    var selectedTrip:Trip?
    var locationCode:String?
    var tripMembers = [User]()
    var tripItineraries = [Itinerary]()
    var mode: TripController.Mode = .create
    var currentUser:User?
    var currentUserRef:DocumentReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedTrip?.name ?? "Create a new trip"
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let currentUser = (appDelegate?.currentUser)!
        self.currentUser = currentUser
        
        membersCount.text = "\(self.selectedTrip?.members?.count ?? 0) members"
        
        UserController().getDocumentReference(for: currentUser) { [weak self] userRef, error in
            guard let self = self else { return }
            self.currentUserRef = userRef
            
            if self.mode == .edit{
                setUpTripEditingData()
            }
            
        }
        if let selectedTrip = selectedTrip {
            if self.currentUserRef != selectedTrip.admin {
                    AlertHelper.showAlert(title: "Unauthorized Access", message: "You are not the admin of this trip.", viewController: self)
                    self.navigationController?.popViewController(animated: true)
                    }
                 else {
                    self.title = "Edit \(selectedTrip.name ?? "")"
                    self.mode = .edit
                }
            
        } else {
            mode = .create
        }

        
    }
    
    
    func setUpTripEditingData(){
        tripNameText.text = self.selectedTrip?.name
        tripDescText.text = self.selectedTrip?.tripDesc
        tripDate.date = (self.selectedTrip?.date) ?? Date()
        locationName.text = self.selectedTrip?.locationName ?? nil
        tripItineraries = self.selectedTrip?.itineraries ?? []
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
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
     
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "tripSearchLocationSegue"){
            let searchLocationVC = segue.destination as! SearchLocationViewController
            searchLocationVC.delegate = self
        }else if (segue.identifier == "tripCreateItinerarySegue"){
            let itineraryListVC = segue.destination as! ItineraryListTableViewController
            itineraryListVC.delegate = self
        }else if (segue.identifier == "tripAddMembersSegue"){
            let addMembersVC = segue.destination as! MemberListViewController
            addMembersVC.delegate = self
            addMembersVC.members = self.tripMembers
        }
    }
    
}

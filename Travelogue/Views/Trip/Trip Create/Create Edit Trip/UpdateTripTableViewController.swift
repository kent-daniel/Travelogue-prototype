//
//  CreateNewTripTableViewController.swift
//  Travelogue
//
//  Created by kent daniel on 1/6/2023.
//

import UIKit
import Firebase
import ProgressHUD
protocol didFinishEditingTrip: NSObjectProtocol {
    func didEditTrip(_ trip: Trip)
}

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
        print(self.tripItineraries)
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
        
        
        // create trip
        if self.mode == .create{
            ProgressHUD.animationType = .singleCirclePulse
            ProgressHUD.show("Creating New Trip")
            TripController().createTrip(name: tripNameText.text!, desc: tripDescText.text!, date: tripDate.date, locationName: locationName.text!, countryCode: (locationCode ?? selectedTrip?.countryCode) ?? "AU", admin: self.currentUserRef!,members: newMemberRefs,itineraries: self.tripItineraries){
                newTrip in
                // add trip to current user
                let tripRef = TripController().getDocumentReference(for: newTrip!)
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

            let updatedTrip = Trip()
            updatedTrip.admin = currentUserRef
            updatedTrip.id = selectedTrip?.id
            updatedTrip.name = tripNameText.text
            updatedTrip.tripDesc = tripDescText.text
            updatedTrip.locationName = locationName.text
            updatedTrip.countryCode = locationCode
            updatedTrip.date = tripDate.date

            var memberRefs: [DocumentReference] = []

            // Use a DispatchGroup to wait for all member references to be retrieved
            let group = DispatchGroup()


            for mem in self.tripMembers {
                    group.enter()
                    UserController().getDocumentReference(for: mem) { mref, err in
                        if let mref = mref {
                            memberRefs.append(mref)
                        }
                        group.leave()
                    }
                }

            group.notify(queue: .main) {
                    updatedTrip.members = memberRefs
                    
                    let tripRef = TripController().getDocumentReference(for: self.selectedTrip!)
                    
                    // Remove trip from original members
                    for membRef in self.selectedTrip!.members ?? [] {
                        UserController().getUser(from: membRef) { user in
                            if let user = user {
                                UserController().removeTripFromUser(user: user, tripRefToRemove: tripRef!)
                            }
                        }
                    }
                    
                    // Add trip to updated members
                    for memberRef in updatedTrip.members ?? [] {
                        UserController().getUser(from: memberRef) { member in
                            if let member = member {
                                UserController().addTripToUser(user: member, newTripRef: tripRef!)
                            }
                        }
                    }
                    
                    // Call the updateTrip function
                TripController().updateTrip(id: updatedTrip.id!, updatedTrip: updatedTrip) { trip in
                        if let trip = trip {
                            
                            TripController().updateItinerariesInTrip(itineraries: self.tripItineraries , trip: updatedTrip){ itineraries,err in
                                trip.itineraries = itineraries
                                ProgressHUD.dismiss()
                                self.delegate?.didEditTrip(trip)
                                DispatchQueue.main.async {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        } else {
                            ProgressHUD.dismiss()
                            // Handle failure
                        }
                    }
                }


            print(selectedTrip?.id)

            
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
    weak var delegate: didFinishEditingTrip?
    
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "tripSearchLocationSegue"){
            let searchLocationVC = segue.destination as! SearchLocationViewController
            searchLocationVC.delegate = self
        }else if (segue.identifier == "tripCreateItinerarySegue"){
            let itineraryListVC = segue.destination as! ItineraryListTableViewController
            itineraryListVC.itineraryList = self.tripItineraries
            itineraryListVC.delegate = self
        }else if (segue.identifier == "tripAddMembersSegue"){
            let addMembersVC = segue.destination as! MemberListViewController
            addMembersVC.delegate = self
            addMembersVC.members = self.tripMembers
        }
    }
    
}

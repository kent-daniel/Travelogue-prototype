//
//  CreateNewTripTableViewController.swift
//  Travelogue
//
//  Created by kent daniel on 1/6/2023.
//

import UIKit

class CreateNewTripTableViewController: UITableViewController , SearchLocationViewControllerDelegate , memberListDelegate , ItineraryListEditDelegate{
    func passMemberList(_ members: [User]?) {
        self.tripMembers = members
    }
    
    
    
    enum Mode {
            case edit
            case create
        }
    
    func didSelectLocation(_ location: Location) {
        locationName.text = location.name
        locationCode = location.countryCode
    }
    
    func didFinishEditingItineraryList(itineraries: [Itinerary]) {
        self.tripItineraries = itineraries
    }
    
    @IBAction func saveTripChanges(_ sender: Any) {
        if mode == .create{
            
        }
        
    }
    @IBOutlet weak var tripNameText: UITextView!
    @IBOutlet weak var tripDescText: UITextView!
    @IBOutlet weak var tripDate: UIDatePicker!
    @IBOutlet weak var locationName: UILabel!
    
    var selectedTrip:Trip?
    var locationCode:String?
    var tripMembers:[User]?
    var tripItineraries:[Itinerary]?
    var mode: Mode = .create
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedTrip?.name ?? "Create a new trip"
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let currentUser = (appDelegate?.currentUser)!
        
        if selectedTrip!==nil{ // edit mode
            UserController().getDocumentReference(for: currentUser){ userRef,error in
                if userRef != self.selectedTrip?.admin {
                    let alert = UIAlertController(title: "Unauthorized Access", message: "You are not the admin of this trip.", preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "Okay", style: .default) { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(okayAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.title = "Edit \(self.selectedTrip?.name ?? "")"
                    self.mode = .edit
                }
            }
        }else{
            mode = .create
        }
        
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
            addMembersVC.members = self.tripMembers ?? []
        }
    }
    
}

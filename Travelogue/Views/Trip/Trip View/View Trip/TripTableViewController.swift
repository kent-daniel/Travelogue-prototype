//
//  HomeTableViewController.swift
//  Travelogue
//
//  Created by kent daniel on 27/4/2023.
//

import UIKit

class TripTableViewController: UITableViewController {
    
    var userTrips:[Trip] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // start a timer to periodically check if the user has been loaded
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [self] timer in
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
            if appDelegate!.userLoggedIn != true {
                // user has not been loaded, navigate to login controller
                NavigationHelper.navigateToLogin(from: self)
                timer.invalidate()
            } else {
                // user has been loaded, fetch trips
                setTitle()
                fetchTrips()
                
                tableView.register(TripCellTableViewCell.self, forCellReuseIdentifier: "TripCell")
                timer.invalidate()
            }
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchTrips()
        self.tabBarController?.tabBar.isHidden = false
        setTitle()
    }
    
    
    func setTitle() {
        var id = AuthController().getCurrentUser()?.uid
        UserController().getUserByID(id: id!) { user, err in
            if let user = user {
                let username = user.name!
                self.title = "Hi " + username
            } else {
                print(err?.localizedDescription)
            }
        }
    }
    
    func fetchTrips() {
        TripController().getCurrentUserTrips { trips in
            if let trips = trips {
                self.userTrips=trips
                self.tableView.reloadData()
            } else {
                // Handle the error case
                print("Error retrieving trips")
            }
        }
    }
    //    This will ensure that the title is set before the trips are loaded.
    
    
    
    
    
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // You only need one section to display the trips
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userTrips.count // Return the number of trips in the userTrips array
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as! TripCellTableViewCell
        
        let trip = userTrips[indexPath.row]
        cell.textLabel?.text = trip.name // Display the trip name in the cell
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trip = userTrips[indexPath.row]
        performSegue(withIdentifier: "ShowTripDetailsSegue", sender: trip)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTripDetailsSegue",
           let indexPath = tableView.indexPathForSelectedRow{
            let selectedRow = indexPath.row
            let detailVC = segue.destination as! TripDetailsViewController
            detailVC.trip = self.userTrips[selectedRow]
        }
    }
    
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
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */



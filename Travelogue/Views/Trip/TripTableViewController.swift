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
        setTitle()
        fetchTrips()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchTrips()
    }
    
    
    func setTitle() {
        var id = AuthController().getCurrentUser()?.uid
        UserController().getUserByID(id: id!) { user, err in
            if let user = user {
                let username = user.name!
                self.title = username + "'s  Trips"
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
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // You only need one section to display the trips
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userTrips.count // Return the number of trips in the userTrips array
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath)
        
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
           let tripDetailVC = segue.destination as? TripDetailsViewController,
           let trip = sender as? Trip {
            tripDetailVC.trip = trip
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
    
}

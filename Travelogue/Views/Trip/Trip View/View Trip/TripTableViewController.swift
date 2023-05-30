//
//  HomeTableViewController.swift
//  Travelogue
//
//  Created by kent daniel on 27/4/2023.
//

import UIKit
import ProgressHUD

class TripTableViewController: UITableViewController {
    
    var userTrips:[Trip] = []
    var currentUser: User?
    var pullRefreshControl: UIRefreshControl!

    
    // MARK: view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.currentUser = appDelegate?.currentUser
        
        fetchTrips()
        tableView.register(TripCellTableViewCell.self, forCellReuseIdentifier: "TripCell")
        // Create the refresh control
        pullRefreshControl = UIRefreshControl()
        pullRefreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        // Add the refresh control to the table view
        tableView.refreshControl = pullRefreshControl
    }
    @objc private func refresh(_ sender: Any) {
        // Perform the data fetching operation again
        fetchTrips()
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    
    // MARK: fetchTrips
    func fetchTrips() {
        ProgressHUD.animationType = .multipleCircleScaleRipple
        ProgressHUD.show("fetching trips ...")
        TripController().getUserTrips(user:self.currentUser!) { trips in
            if let trips = trips {
                let sortedTrips = trips.sorted { $0.name! < $1.name! } // Sort by name
                self.userTrips = sortedTrips
                self.tableView.reloadData()
            } else {
                // Handle the error case
                print("Error retrieving trips")
            }
            self.pullRefreshControl.endRefreshing()
            ProgressHUD.dismiss()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as! TripCellTableViewCell
        
        let trip = userTrips[indexPath.row]
        cell.textLabel?.text = trip.name // Display the trip name in the cell
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trip = userTrips[indexPath.row]
        performSegue(withIdentifier: "ShowTripDetailsSegue", sender: trip)
    }
    
    // MARK: segue prepare
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



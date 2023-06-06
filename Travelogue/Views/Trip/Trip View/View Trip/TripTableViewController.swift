//
//  TripTableViewController.swift
//  Travelogue
//
//  Created by kent daniel on 27/4/2023.
//

import UIKit
import ProgressHUD

class TripTableViewController: UITableViewController {
    
    var userTrips: [[Trip]] = []
    var currentUser: User?
    var pullRefreshControl: UIRefreshControl!
    
    // MARK: view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.currentUser = appDelegate?.currentUser
        
        fetchTrips()
        let nib = UINib(nibName: "TripCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TripCell")
        tableView.rowHeight = 230
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
        fetchTrips()
    }
    
    // MARK: fetchTrips
    func fetchTrips() {
        UserController().getUserByID(id: self.currentUser!.id!) { user, error in
            TripController().getUserTrips(user: user!) { trips in
                if let trips = trips {
                    let sortedTrips = trips.sorted { $0.date ?? Date() > $1.date ?? Date()} // Sort by date in descending order
                    self.userTrips = Dictionary(grouping: sortedTrips, by: { DateParser.stringFromDate($0.date ?? Date(), format: "MMM yyyy") })
                        .sorted { $0.key < $1.key } // Sort sections by date in descending order
                        .map { $0.value } // Extract the grouped trips
                    
                    self.tableView.reloadData()
                } else {
                    // Handle the error case
                    print("Error retrieving trips")
                }
                self.pullRefreshControl.endRefreshing()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return userTrips.count // Number of sections is the count of grouped trips
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userTrips[section].count // Number of rows in each section is the count of trips in that section
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as! TripCell
        
        let trip = userTrips[indexPath.section][indexPath.row] // Get the trip for the indexPath
        
        cell.tripName.text = trip.name // Display the trip name in the cell
        cell.tripDesc.text = trip.tripDesc
        cell.tripDate.text = DateParser.stringFromDate(trip.date ?? Date())
        cell.tripMembersCount.text = "\(trip.members?.count ?? 0) members"
        cell.locationName.text = "📍\(trip.locationName ?? "nowhere")"
        // get user
        UserController().getUser(from: trip.admin!){
            user in
            cell.adminName.text = user?.name
            cell.adminProfile.image = UIImage(systemName: "person.circle.fill")
            cell.adminProfile.showLoadingAnimation() // Show loading
            
            ImageManager.downloadImage(from: (user?.profileImgUrl) ?? "") { profileImage, error in
                cell.adminProfile.hideLoadingAnimation() // Hide spinner
                
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                } else if let profileImage = profileImage {
                    cell.adminProfile.image = profileImage
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let trip = userTrips[section].first // Get the first trip in the section
        return DateParser.stringFromDate(trip!.date ?? Date(), format: "MMM yyyy") // Use the date as the section title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trip = userTrips[indexPath.section][indexPath.row] // Get the trip for the indexPath
        performSegue(withIdentifier: "ShowTripDetailsSegue", sender: trip)
    }
    
    // MARK: segue prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTripDetailsSegue",
           let indexPath = tableView.indexPathForSelectedRow {
            let selectedRow = indexPath.row
            let selectedSection = indexPath.section
            let detailVC = segue.destination as! TripDetailsViewController
            detailVC.trip = userTrips[selectedSection][selectedRow]
        } else if segue.identifier == "createTripSegue" {
            let createTripVC = segue.destination as! UpdateTripTableViewController
            createTripVC.selectedTrip = nil
        }
    }
    
}

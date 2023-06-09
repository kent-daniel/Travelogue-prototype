//
//  CreateItineraryTableViewController.swift
//  Travelogue
//
//  Created by kent daniel on 8/6/2023.
//

import UIKit
protocol CreateItineraryDelegate: NSObjectProtocol{
    func didCreateItinerary(itinerary: Itinerary)
}
class CreateItineraryTableViewController: UITableViewController, SearchLocationViewControllerDelegate {
    func didSelectLocation(_ location: Location) {
        locationName.text = location.name
        coor = location.coordinate
        address = location.address
    }
    var itinerary = Itinerary()
    var address:String?
    var coor:[Double]?
    weak var delegate: CreateItineraryDelegate?
    
    
    @IBOutlet weak var itTitle: UITextView!
    
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var itDate: UIDatePicker!
    @IBOutlet weak var itineraryDesc: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func addItinerary(_ sender: Any) {
        if let title = itTitle.text, !title.isEmpty, let dateTime = itDate?.date {
            itinerary.title = title
            itinerary.dateTime = dateTime
            itinerary.address = address ?? ""
            itinerary.coordinate = coor ?? []
            itinerary.desc = itineraryDesc.text ?? ""
            
                        
            self.delegate?.didCreateItinerary(itinerary: itinerary)
            self.navigationController?.popViewController(animated: true)
        } else {
            // Show an alert indicating that the itinerary must have a name and datetime
            let alertController = UIAlertController(title: "Error", message: "Itinerary must have a name and datetime.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 4
        } else if section == 1 {
            return 1
        }
        return 0
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "createItineraryLocation"){
            let searchLocationVC = segue.destination as! SearchLocationViewController
            searchLocationVC.delegate = self
        }
    }
    
}

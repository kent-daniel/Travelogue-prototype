//
//  CreateItineraryViewController.swift
//  Travelogue
//
//  Created by kent daniel on 23/5/2023.
//

import UIKit
protocol CreateItineraryDelegate: NSObjectProtocol{
    func didCreateItinerary(itinerary: Itinerary)
}
class CreateItineraryViewController: UIViewController , SearchLocationViewControllerDelegate{
    var itinerary = Itinerary()
    var address:String?
    var coor:[Double]?
    weak var delegate: CreateItineraryDelegate?

    @IBOutlet weak var desc: UITextField!
    
    @IBOutlet weak var itineraryDate: UIDatePicker!
    @IBOutlet weak var itineraryName: UITextField!
    @IBOutlet weak var locationName: UILabel!
    
    @IBAction func addItinerary(_ sender: Any) {
        if let title = itineraryName.text, !title.isEmpty, let dateTime = itineraryDate?.date {
            itinerary.title = title
            itinerary.dateTime = dateTime
            itinerary.address = address ?? ""
            itinerary.coordinate = coor ?? []
            itinerary.desc = desc.text ?? ""
            
            print(itinerary)
            
            self.delegate?.didCreateItinerary(itinerary: itinerary)
            self.navigationController?.popViewController(animated: true)
        } else {
            // Show an alert indicating that the itinerary must have a name and datetime
            let alertController = UIAlertController(title: "Error", message: "Itinerary must have a name and datetime.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func didSelectLocation(_ location: Location) {
        address = location.address
        coor = location.coordinate
        locationName.text = location.name
    }
    /*
     MARK: - Navigation

     In a storyboard-based application, you will often want to do a little preparation before navigation
    
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "createItineraryLocation"){
            let searchLocationVC = segue.destination as! SearchLocationViewController
            searchLocationVC.delegate = self
        }
    }

}

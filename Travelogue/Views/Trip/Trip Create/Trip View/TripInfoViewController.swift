//
//  TripInfoViewController.swift
//  Travelogue
//
//  Created by kent daniel on 15/5/2023.
//

import UIKit

class TripInfoViewController: UIViewController {
    var trip:Trip?
    @IBOutlet weak var tripName: UILabel!
    
    @IBOutlet weak var tripLoc: UILabel!
    @IBOutlet weak var tripDate: UILabel!
    @IBOutlet weak var tripDesc: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tripName.text = trip?.name
        tripLoc.text = trip?.locationName
        tripDate.text = DateParser.stringFromDate((trip?.date)!)
        tripDesc.text = trip?.tripDesc
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
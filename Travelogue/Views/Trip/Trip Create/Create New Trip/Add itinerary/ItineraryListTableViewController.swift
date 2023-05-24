import UIKit

protocol ItineraryListEditDelegate : NSObjectProtocol{
    func didFinishEditingItineraryList(itineraries: [Itinerary])
}

class ItineraryListTableViewController: UITableViewController, CreateItineraryDelegate {
    weak var delegate : ItineraryListEditDelegate?
    var itineraryList: [Itinerary] = []
    var sections: [String] = []   // Array to store section titles
    var itineraryDict: [String: [Itinerary]] = [:]   // Dictionary to store itineraries grouped by date
    var longPressGesture: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable editing mode
        tableView.isEditing = true
        
        // Add long press gesture recognizer
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        prepareData()
        tableView.reloadData()
    }
    
    // MARK: - Data Preparation
    
    private func prepareData() {
        itineraryDict.removeAll()
        sections.removeAll()
        
        // Group itineraries by date
        for itinerary in itineraryList {
            if let date = itinerary.dateTime {
                let dateString = DateParser.stringFromDate(date)
                if itineraryDict[dateString] == nil {
                    itineraryDict[dateString] = [itinerary]
                    sections.append(dateString)
                } else {
                    itineraryDict[dateString]?.append(itinerary)
                }
            }
        }
        
        // Sort sections by date in ascending order
        sections.sort { (dateString1, dateString2) -> Bool in
            if let date1 = DateParser.dateFromString(dateString1), let date2 = DateParser.dateFromString(dateString2) {
                return date1 < date2
            }
            return false
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = sections[section]
        return itineraryDict[sectionTitle]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItineraryCell", for: indexPath)
        
        let sectionTitle = sections[indexPath.section]
        if let itineraries = itineraryDict[sectionTitle] {
            let itinerary = itineraries[indexPath.row]
            cell.textLabel?.text = itinerary.title // Display the trip address in the cell
            cell.detailTextLabel?.text = itinerary.address
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    // MARK: - Editing Cells
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // Enable editing for all cells
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let sectionTitle = sections[indexPath.section]
            itineraryDict[sectionTitle]?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Drag and Drop Reordering
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true // Allow moving rows
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceSectionTitle = sections[sourceIndexPath.section]
        let destinationSectionTitle = sections[destinationIndexPath.section]
        
        if var sourceItineraries = itineraryDict[sourceSectionTitle],
            var destinationItineraries = itineraryDict[destinationSectionTitle]
           {
            
            // Remove itinerary from source section
            let itineraryToMove = sourceItineraries[sourceIndexPath.row]
            sourceItineraries.remove(at: sourceIndexPath.row)
            
            // Update itinerary date to match the destination section
            if let destinationDate = DateParser.dateFromString(destinationSectionTitle) {
                itineraryToMove.dateTime = destinationDate
            }
            // only insert if section is different , just show reordering if section is the same
            if sourceSectionTitle != destinationSectionTitle{
                // Insert itinerary into destination section
                destinationItineraries.insert(itineraryToMove, at: destinationIndexPath.row)
            }
            
            
            // Update itineraryDict and sections arrays
            itineraryDict[sourceSectionTitle] = sourceItineraries
            itineraryDict[destinationSectionTitle] = destinationItineraries
            sections = itineraryDict.keys.sorted()
            
            
        }
    }
    
    // MARK: - Long Press Gesture
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let location = gestureRecognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: location) {
                tableView.beginUpdates()
                tableView.setEditing(true, animated: true)
                tableView.moveRow(at: indexPath, to: indexPath)
                tableView.endUpdates()
            }
        }
    }
    
    // MARK: - CreateItineraryDelegate
    
    func didCreateItinerary(itinerary: Itinerary) {
        itineraryList.append(itinerary)
        prepareData()
        print(itineraryList)
        tableView.reloadData()
    }
    // MARK: - Saving itinerary list
    
    @IBAction func confirmItinerary(_ sender: Any) {
        self.delegate?.didFinishEditingItineraryList(itineraries: itineraryList)
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createItinerarySegue" {
            let createItineraryVC = segue.destination as! CreateItineraryViewController
            createItineraryVC.delegate = self
        }
    }
}

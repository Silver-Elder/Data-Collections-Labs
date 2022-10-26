import UIKit

//---- Answers to Book Questions (p.64, first bullet prompt) ----
//“What model object(s) will you need for this app?
    // An Athlete Object

//What properties will the model object(s) need?
    // Name, Age, Height, Sport, Team

//In addition to the view controller provided in the starter project, what other controllers will you need?
    // An AthleteDetailedProfileViewController
//What properties and functions will the controllers need?”
    // At bare minimun, the AthleteTableViewController will need: button actions to select a created Athete profile listed on the TableView, and and tell the AthleteDetailedProfileViewController's delegate which Athlete button had been pressed; and another button action that will segue to the AthleteDetailedProfileViewController, and tell the AthleteDetailedProfileViewController's delegate that the user selected the "Create New Althete Profile" button.
    //  As for the AthleteDetailedProfileViewController, it will need: a button and segue back to the AthleteTableViewController for when the user wants to exit the AthleteDetailedProfileView; some code to decide (based on the delegate info), whether to populate the AthleteDetailedProfileView with a specific athlete's photo and description text — both pulled from the Athlete's instance found in the AthleteModelController (which we will have created to hold our Athlete Struct, and contain each athlete instance that has/will be created in an "Athetes" array) — and provide an edit button on the AthleteDetailedProfileView (which will allow the user to edit the athlete's profile, and click a "save" button, and push their data back to the AthleteDetailedProfileViewController, which will in turn give the data to the AthleteModelController to udate the information for that Athlete's instance (found in the "Athletes" array)); or to have the AthleteDetailedProfileView display a setup where the user can upload the athlete photo and enter a description into blank text fields (that will be set to appear next to the Name, Age, Height, Sport, and Team labels on the AthleteDetailedProfileView), and a button action that will ask the AthleteDetailedProfileView for the the user's photo and description inputs, and then pass the returned inputs to the AthleteModelController to be turned into a new Athlete instance, and saved by the AthleteModelController in its "Athletes" array.

class AthleteTableViewController: UITableViewController {
    
    struct PropertyKeys {
        static let athleteCell = "AthleteCell"
    }

    var athletes: [Athlete] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return athletes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.athleteCell, for: indexPath)
        
        let athlete = athletes[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = athlete.name
        content.secondaryText = athlete.description
        cell.contentConfiguration = content
        
        return cell
    }
    
    @IBSegueAction func addAthlete(_ coder: NSCoder) -> AthleteFormViewController? {
        return AthleteFormViewController(coder: coder, athlete: nil)
    }
    
    @IBSegueAction func editAthlete(_ coder: NSCoder, sender: Any?) -> AthleteFormViewController? {
        let athleteToEdit: Athlete?
        
        if let athleteCell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: athleteCell) {
            athleteToEdit = athletes[indexPath.row]
        } else {
            athleteToEdit = nil
        }
        
        return AthleteFormViewController(coder: coder, athlete: athleteToEdit)
        ////// pg.67 *************
    }
    
    @IBAction func unwindSegue( segue: UIStoryboardSegue) {
        guard let athleteFormViewController = segue.source as? AthleteFormViewController, let athlete = athleteFormViewController.athlete else { return }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            athletes[selectedIndexPath.row] = athlete
            
        } else {
            athletes.append(athlete)
        }
    }
    
}

//
//  AthleteFormViewController.swift
//  FavoriteAthlete
//
//  Created by Sterling Jenkins on 10/12/22.
//

import UIKit

class AthleteFormViewController: UIViewController {

    var athlete: Athlete?
    
    init?(coder: NSCoder, athlete: Athlete?) {
        self.athlete = athlete
        super.init(coder: coder)
            // This (^^^) is what's referred to as the "super implementation"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView() {
        if let athlete = athlete {
            ageTextField.text = "\(athlete.age)"
            nameTextField.text = athlete.name
            leaugeTextField.text = athlete.league
            teamTextField.text = athlete.team
            title = "Edit atlete"
        } else {
            title = "Add Athlete"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var leaugeTextField: UITextField!
    @IBOutlet weak var teamTextField: UITextField!
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let name = nameTextField.text,
              let ageString = ageTextField.text,
              let age = Int(ageString),
              let leauge = leaugeTextField.text,
              let team = teamTextField.text else { return }
        
        athlete = Athlete(name: name, age: age, league: leauge, team: team)
        
        performSegue(withIdentifier: "unwindToMyFavoriteAthletesTableViewController", sender: self)
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

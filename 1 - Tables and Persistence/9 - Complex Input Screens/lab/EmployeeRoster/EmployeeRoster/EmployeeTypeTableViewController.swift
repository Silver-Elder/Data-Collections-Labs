//
//  EmployeeTypeTableViewController.swift
//  EmployeeRoster
//
//  Created by Sterling Jenkins on 11/9/22.
//

import UIKit

protocol EpmloyeeTypeTableViewControllerDelegate {
    func employeeTypeTableViewController(_: EmployeeTypeTableViewController, didSelect: EmployeeType)
}

class EmployeeTypeTableViewController: UITableViewController {
   
//    init?(coder: NSCoder, employeeType: EmployeeType?) {
//        self.selectedEmployeeType = employeeType
//        super.init(coder: coder)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    var delegate: EpmloyeeTypeTableViewControllerDelegate?
    
    var selectedEmployeeType: EmployeeType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return EmployeeType.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Employee Type", for: indexPath)

        var cellContent = cell.defaultContentConfiguration()
        let employeeType = EmployeeType.allCases[indexPath.row]
        
        cellContent.text = employeeType.description
        cell.contentConfiguration = cellContent
        
        if selectedEmployeeType == employeeType {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employeeType = EmployeeType.allCases[indexPath.row]
        selectedEmployeeType = employeeType
        
        delegate?.employeeTypeTableViewController(self, didSelect: employeeType)
        
        tableView.reloadData()
    }
}

// Pick up on p.253

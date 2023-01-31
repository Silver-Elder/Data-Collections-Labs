//
//  StoreItemTableViewDiffableDataSource.swift
//  iTunesSearch
//
//  Created by Sterling Jenkins on 1/30/23.
//

import Foundation
import UIKit

@MainActor
class StoreItemTableViewDiffableDataSource: UITableViewDiffableDataSource<String, StoreItem> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return snapshot().sectionIdentifiers[section]
    }
}

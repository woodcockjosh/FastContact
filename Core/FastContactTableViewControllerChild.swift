//
//  FastContactTableViewControllerChild.swift
//  FastContact
//
//  Created by Josh Woodcock on 8/23/15.
//  Copyright (c) 2015 Connecting Open Time, LLC. All rights reserved.
//

import UIKit

public protocol FastContactTableViewControllerChild {
    func getEmptyTableViewCell(tableView: UITableView, state: FastContactViewState) -> UITableViewCell;
}

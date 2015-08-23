//
//  UITableViewController.swift
//  FastContact
//
//  Created by Josh Woodcock on 8/23/15.
//  Copyright (c) 2015 Connecting Open Time, LLC. All rights reserved.
//

import UIKit

class SomeTableViewController: FastContactTableViewController, FastContactTableViewControllerChild {

    internal override func getEmptyTableViewCell(tableView: UITableView, state: FastContactViewState) -> UITableViewCell {
        
        // Get cell
        var stateIdentifierMap: [FastContactViewState: String] = [
            FastContactViewState.EmptyNoAccess: "no_access_empty_cell",
            FastContactViewState.EmptyBlockedAccess: "blocked_access_empty_cell",
            FastContactViewState.EmptyWithAccess: "has_access_empty_cell"
        ];
        var identifier:String = stateIdentifierMap[state]!
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier) as! UITableViewCell;
        
        // Set empty message
        var emptyMessageContainer: UIView! = cell.viewWithTag(1);
        var emptyMessageLabel: UITextView = emptyMessageContainer.viewWithTag(11) as! UITextView;
        var stateMessageMap: [FastContactViewState: String] = [
            FastContactViewState.EmptyNoAccess: "Great job at opening the app! I hope it wasn't too difficult. This app works best when it has access to your contacts",
            FastContactViewState.EmptyBlockedAccess: "Looks like the permissions on your phone are currently blocking access to your phone contacts. This app works best when it has access to your contacts",
            FastContactViewState.EmptyWithAccess: "Looks kind of lonely in here. Time to get out there and meet some people!"
        ];
        var message:String = stateMessageMap[state]!;
        emptyMessageLabel.text = message;
        
        // Set provide access button
        var button: UIButton! = cell.viewWithTag(21) as! UIButton;
        setProvideAccessButton(button);
        
        return cell;
    }
    

    

    
}

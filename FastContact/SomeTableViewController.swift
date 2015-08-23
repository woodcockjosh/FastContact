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
            FastContactViewState.EmptyNoAccess: "empty_message_with_button_cell",
            FastContactViewState.EmptyBlockedAccessAtLeastIOS8: "empty_message_with_button_cell",
            FastContactViewState.EmptyBlockedAccessLessThanIOS8: "empty_message_cell",
            FastContactViewState.EmptyWithAccess: "empty_message_cell"
        ];
        var identifier:String = stateIdentifierMap[state]!
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier) as! UITableViewCell;
        
        // Set empty message
        var emptyMessageLabel: UILabel = cell.viewWithTag(11) as! UILabel;
        var stateMessageMap: [FastContactViewState: String] = [
            FastContactViewState.EmptyNoAccess: "Great job at opening the app! We hope it wasn't too difficult. This app works best when it has access to your contacts",
            FastContactViewState.EmptyBlockedAccessAtLeastIOS8: "Looks like the permissions on your phone are currently blocking access to your phone contacts. This app works best when it has access to your contacts",
            FastContactViewState.EmptyBlockedAccessLessThanIOS8: "Looks like the permissions on your phone are currently blocking access to your phone contacts. This app works best when it has access to your contacts. To provide access go to "+FastContactHelper.getSettingsNavigationString()+"Then toggle access to on",
            FastContactViewState.EmptyWithAccess: "Looks kind of lonely in here. Time to get out there and meet some people!"
        ];
        var message:String = stateMessageMap[state]!;
        emptyMessageLabel.text = message;
        
        // Set button for valid states. Blocked state for iOS < 8 should not have a button.
        if(state == .EmptyNoAccess || state == .EmptyBlockedAccessAtLeastIOS8) {
            // Set provide access button
            var buttonContainer: UIView! = cell.viewWithTag(2);
            var button: UIButton! = buttonContainer.viewWithTag(21) as! UIButton;
            button.titleLabel?.textAlignment = NSTextAlignment.Center;
            setProvideAccessButton(button);
        }
        
        return cell;
    }
}

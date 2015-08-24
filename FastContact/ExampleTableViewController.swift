//
//  UITableViewController.swift
//  FastContact
//
//  Created by Josh Woodcock on 8/23/15.
//  Copyright (c) 2015 Connecting Open Time, LLC. All rights reserved.
//

import UIKit

class ExampleTableViewController: FastContactTableViewController, FastContactTableViewControllerChild {
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Example data
        self._setupExampleData();
    }

    internal override func getEmptyTableViewCell(tableView: UITableView, state: FastContactViewState) -> UITableViewCell {
        
        // Get cell
        var stateIdentifierMap: [FastContactViewState: String] = [
            FastContactViewState.EmptyNoAccess: "empty_message_with_button_cell",
            FastContactViewState.ManyNoAccess: "empty_message_with_button_cell",
            FastContactViewState.EmptyBlockedAccessAtLeastIOS8: "empty_message_with_button_cell",
            FastContactViewState.EmptyBlockedAccessLessThanIOS8: "empty_message_cell",
            FastContactViewState.EmptyWithAccess: "empty_message_cell",
            FastContactViewState.ManyWithAccessAndFiller: "empty_message_cell",
            FastContactViewState.ManyBlockedAccessAtLeastIOS8: "empty_message_with_button_cell",
            FastContactViewState.ManyBlockedAccessLessThanIOS8: "empty_message_cell"
        ];
        
        var identifier:String = stateIdentifierMap[state]!
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier) as! UITableViewCell;
        
        // Set empty message
        var emptyMessageLabel: UILabel = cell.viewWithTag(11) as! UILabel;
        var stateMessageMap: [FastContactViewState: String] = [
            FastContactViewState.EmptyNoAccess: self._getNoAccessMessage(),
            FastContactViewState.ManyNoAccess: self._getNoAccessMessage(),
            FastContactViewState.EmptyBlockedAccessAtLeastIOS8: self._getBlockedAccessAtLeastIOS8Message(),
            FastContactViewState.EmptyBlockedAccessLessThanIOS8: self._getBlockedAccessLessThanIOS8Message(),
            FastContactViewState.EmptyWithAccess: "Looks kind of lonely in here. Time to get out there and meet some people!",
            FastContactViewState.ManyWithAccessAndFiller: "Looks like you have some contacts. Good Job! Now lets try some of the other app features",
            FastContactViewState.ManyBlockedAccessLessThanIOS8: self._getBlockedAccessLessThanIOS8Message(),
            FastContactViewState.ManyBlockedAccessAtLeastIOS8: self._getBlockedAccessAtLeastIOS8Message()
        ];
        var message:String = stateMessageMap[state]!;
        emptyMessageLabel.text = message;
        
        // Set button for valid states. Blocked state for iOS < 8 should not have a button.
        if(!FastContactHelper.stateHasAccess(state) && FastContactHelper.stateIsAtLeastIOS8(state)) {
            // Set provide access button
            var buttonContainer: UIView! = cell.viewWithTag(2);
            var button: UIButton! = buttonContainer.viewWithTag(21) as! UIButton;
            button.titleLabel?.textAlignment = NSTextAlignment.Center;
            setProvideAccessButton(button);
        }
        
        return cell;
    }
    
    internal override func getNonEmptyTableViewCell(tableView: UITableView, state: FastContactViewState) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("contact_cell") as! UITableViewCell;
        
        return cell;
    }

    internal override func shouldShowFillerInNonEmptyList() ->Bool {
        return true;
    }
    
    private func _setupExampleData() {
        var exampleOfItemLoadedFromCoreData = PhoneContact(name: "Josh Woodcock", phoneNumber: "407-235-4361", image: UIImage());
        var list = Array<Array<IListItem>>();
        var defaultSection = Array<IListItem>();
        defaultSection.append(exampleOfItemLoadedFromCoreData);
        defaultSection.append(exampleOfItemLoadedFromCoreData);
        defaultSection.append(exampleOfItemLoadedFromCoreData);
        //defaultSection.append(exampleOfItemLoadedFromCoreData);

        list.append(defaultSection);
        var state = FastContactHelper.getViewStateWithListCountAndAccess(list, useFiller: shouldShowFillerInNonEmptyList());

        self._fastContactListManager.setItemsInListForState(self._currentListIndex, list: list, state: state);
    }
    
    private func _getNoAccessMessage()->String{
        return "Great job at opening the app! We hope it wasn't too difficult. This app works best when it has access to your contacts";
    }
    
    private func _getBlockedAccessAtLeastIOS8Message() -> String {
        return "Looks like the permissions on your phone are currently blocking access to your phone contacts. This app works best when it has access to your contacts";
    }
    
    private func _getBlockedAccessLessThanIOS8Message() ->String {
        return "Looks like the permissions on your phone are currently blocking access to your phone contacts. This app works best when it has access to your contacts. To provide access go to "+FastContactHelper.getSettingsNavigationString()+"Then toggle access to on";
    }
}

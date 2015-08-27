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
            FastContactViewState.EmptyBlockedAccess: self._getBlockedAccessCellID(),
            FastContactViewState.ManyNoAccess: "empty_message_with_button_cell",
            FastContactViewState.EmptyWithAccess: "empty_message_cell",
            FastContactViewState.ManyWithAccessAndFiller: "empty_message_cell",
            FastContactViewState.ManyBlockedAccess: self._getBlockedAccessCellID(),
        ];
        
        var identifier:String = stateIdentifierMap[state]!
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier) as! UITableViewCell;
        
        // Set empty message
        var emptyMessageLabel: UILabel = cell.viewWithTag(11) as! UILabel;
        var stateMessageMap: [FastContactViewState: String] = [
            FastContactViewState.EmptyNoAccess: self._getNoAccessMessage(),
            FastContactViewState.ManyNoAccess: self._getNoAccessMessage(),
            FastContactViewState.EmptyBlockedAccess: self._getBlockedAccessMessage(),
            FastContactViewState.EmptyWithAccess: "Looks kind of lonely in here. Time to get out there and meet some people!",
            FastContactViewState.ManyWithAccessAndFiller: "Looks like you have some contacts. Good Job! Now lets try some of the other app features",
            FastContactViewState.ManyBlockedAccess: self._getBlockedAccessMessage()
        ];
        
        var message:String = stateMessageMap[state]!;
        emptyMessageLabel.text = message;
        
        // Set button for valid states. Blocked state for iOS < 8 should not have a button.
        if(FastContactHelper.shouldAskForPermission(state)) {
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
    
    private func _getBlockedAccessMessage() -> String {
        if(FastContactConstant.IOS_MAIN_VERSION >= 8.0){
            return "Looks like the permissions on your phone are currently blocking access to your phone contacts. This app works best when it has access to your contacts";
        }else{
            return "Looks like the permissions on your phone are currently blocking access to your phone contacts. This app works best when it has access to your contacts. To provide access go to "+FastContactHelper.getSettingsNavigationString()+"Then toggle access to on";
        }
    }
    
    private func _getBlockedAccessCellID() -> String {
        if(FastContactConstant.IOS_MAIN_VERSION >= 8.0) {
            return "empty_message_with_button_cell";
        }else{
            return "empty_message_cell"
        }
    }
}

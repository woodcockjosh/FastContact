//
//  FastContactTableViewController.swift
//  FastContact
//
//  Created by Josh Woodcock on 8/22/15.
//  Copyright (c) 2015 Connecting Open Time, LLC. All rights reserved.
//

import UIKit

class FastContactTableViewController: UITableViewController {
    
    private var _currentViewState: FastContactViewState!;
    internal var _fastContactListManager: FastContactListManager!;
    internal var _currentListItem: Int!;
    internal var _lists: Array<Array<Array<IListItem>>>!;

    override func viewDidLoad() {
        super.viewDidLoad()
        self._currentViewState       = FastContactViewStateHelper.getDefaultViewStateBasedOnPhoneContactAccess();
        self._fastContactListManager = FastContactListManager(listCount: self.getListCount());
        self._currentListItem        = self.getDefaultListItem();
        self._lists                  = self._fastContactListManager.getLists();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return _lists[_currentListItem].count;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _lists[_currentListItem][section].count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = _getTableViewCellForState(tableView, cellForRowAtIndexPath: indexPath, state: _currentViewState);
        return cell;
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var list = _lists[_currentListItem];
        var section = list[indexPath.section];
        var row = section[indexPath.row];
        
        if(!(row is EmptyListItem)) {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath);
        }else{
            return self._getEmptyTableViewCellHeight();
        }
    }
    
    /// MARK FastContactTableViewController
    
    internal func getListCount() -> Int {
        return 1;
    }
    
    internal func getDefaultListItem() -> Int {
        return 0;
    }
    
    /**
        You will probably want to override this one and put your own empty states.
    */
    internal func getEmptyTableViewCell(tableView: UITableView, state: FastContactViewState) -> UITableViewCell {
        // Get cell
        var stateIdentifierMap: [FastContactViewState: String] = [
            FastContactViewState.EmptyNoAccess: "no_access_empty_cell",
            FastContactViewState.EmptyBlockedAccess: "blocked_access_empty_cell",
            FastContactViewState.EmptyWithAccess: "has_access_empty_cell"
        ];
        var identifier:String = stateIdentifierMap[state]!
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier) as! UITableViewCell;
        
        // Set empty message
        var emptyMessageLabel: UILabel = cell.viewWithTag(1) as! UILabel;
        var stateMessageMap: [FastContactViewState: String] = [
            FastContactViewState.EmptyNoAccess: "Great job at opening the app! I hope it wasn't too difficult. This app works best when it has access to your contacts",
            FastContactViewState.EmptyBlockedAccess: "Looks like the permissions on your phone are currently blocking access to your phone contacts. This app works best when it has access to your contacts",
            FastContactViewState.EmptyWithAccess: "Looks kind of lonely in here. Time to get out there and meet some people!"
        ];
        var message:String = stateMessageMap[state]!;
        emptyMessageLabel.text = message;
        
        return cell;
    }
    
    internal func getNonEmptyTableViewCell(tableView: UITableView, state: FastContactViewState) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("contact_cell") as! UITableViewCell;
        
        return cell;
    }
    
    internal func setViewState(state: FastContactViewState) {
        self._currentViewState = state;
    }
    
    /// MARK Private methods
    
    private func _getTableViewCellForState(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, state: FastContactViewState) -> UITableViewCell {
        var cell: UITableViewCell!;
        
        switch(state) {
        case .EmptyWithAccess:
            cell = getEmptyTableViewCell(tableView, state: state);
            break;
        case .EmptyNoAccess:
            cell = getEmptyTableViewCell(tableView, state: state);
            break;
        case .EmptyBlockedAccess:
            cell = getEmptyTableViewCell(tableView, state: state);
            break;
        case .ManyWithAccessNoFiller:
            cell = getNonEmptyTableViewCell(tableView, state: state);
            break;
        case .ManyWithAccessAndFiller:
            cell = getNonEmptyTableViewCell(tableView, state: state);
            break;
        default:
            cell = UITableViewCell();
            break;
        }
        
        return cell;
    }
    
    private func _getEmptyTableViewCellHeight() -> CGFloat {
        return tableView.frame.height;
    }
    
}

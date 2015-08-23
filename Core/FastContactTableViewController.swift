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
    
    @IBAction func provideAccessWithNoAccessClicked(sender: UIButton) {
        APAddressBook.requestAccess { (didProvideAccess: Bool, error: NSError!) -> Void in
            var state: FastContactViewState!;
            if(didProvideAccess) {
                state = .ManyWithAccessAndFiller;
            }else{
                state = FastContactHelper.getViewStateWithListCountAndAccess(self._lists[self._currentListItem]);
            }
            self._fastContactListManager.updateListsForState(state);
        }
    }
    
    @IBAction func provideAccessWithBlockedAccessClicked(sender: UIButton) {
        if(Constant.IOS_MAIN_VERSION >= 8.0) {
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!);
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self._currentViewState       = FastContactHelper.getDefaultViewStateBasedOnPhoneContactAccess();
        self._fastContactListManager = FastContactListManager(listCount: self.getListCount(), updateBlock: {()->Void in
            self._lists = self._fastContactListManager.getLists();
            self._currentViewState = FastContactHelper.getViewStateWithListCountAndAccess(self._lists[self._currentListItem]);
            self.tableView.reloadData();
        });
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
    
    internal func getEmptyTableViewCell(tableView: UITableView, state: FastContactViewState) -> UITableViewCell {
        return UITableViewCell();
    }
    
    internal func getNonEmptyTableViewCell(tableView: UITableView, state: FastContactViewState) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("contact_cell") as! UITableViewCell;
        
        return cell;
    }
    
    internal func setViewState(state: FastContactViewState) {
        self._currentViewState = state;
    }
    
    internal func setProvideAccessButton(button: UIButton) {
        
        switch(_currentViewState!) {
        case .EmptyNoAccess:
            self._setProvideNoAccessButton(button);
            break;
        case .EmptyBlockedAccessAtLeastIOS8:
            self._setProvideBlockedAccessButton(button);
            break;
        default:
            break;
        }
    }
    
    /// MARK Private methods
    
    private func _getTableViewCellForState(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, state: FastContactViewState) -> UITableViewCell {
        var cell: UITableViewCell!;
        
        switch(state) {
        case .EmptyWithAccess:
            cell = getEmptyTableViewCell(tableView, state: state);
            cell = _getEmptyCellWithAttributes(cell);
            break;
        case .EmptyNoAccess:
            cell = getEmptyTableViewCell(tableView, state: state);
            cell = _getEmptyCellWithAttributes(cell);
            break;
        case .EmptyBlockedAccessAtLeastIOS8:
            cell = getEmptyTableViewCell(tableView, state: state);
            cell = _getEmptyCellWithAttributes(cell);
            break;
        case .EmptyBlockedAccessLessThanIOS8:
            cell = getEmptyTableViewCell(tableView, state: state);
            cell = _getEmptyCellWithAttributes(cell);
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
 
    private func _getEmptyCellWithAttributes(cell: UITableViewCell) -> UITableViewCell {
        cell.selectionStyle = .None;
        
        return cell;
    }
    
    private func _getEmptyTableViewCellHeight() -> CGFloat {
        var height: CGFloat = tableView.frame.height;
        
        if(navigationController != nil) {
            height -= navigationController!.navigationBar.frame.height;
        }
        
        height -= 20;
        
        return  height;
    }
    
    private func _setProvideNoAccessButton(button: UIButton) {
        button.addTarget(self, action: "provideAccessWithNoAccessClicked:", forControlEvents: UIControlEvents.TouchUpInside);
    }
    
    private func _setProvideBlockedAccessButton(button: UIButton) {
        button.addTarget(self, action: "provideAccessWithBlockedAccessClicked:", forControlEvents: UIControlEvents.TouchUpInside);
    }
}

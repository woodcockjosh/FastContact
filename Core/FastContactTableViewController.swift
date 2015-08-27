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
    internal var _currentListIndex: Int!;
    internal var _lists: Array<Array<Array<IListItem>>>!;
    
    @IBAction func provideAccessWithNoAccessClicked(sender: UIButton) {
        APAddressBook.requestAccess { (didProvideAccess: Bool, error: NSError!) -> Void in
            var state: FastContactViewState!;
            if(didProvideAccess) {
                state = .ManyWithAccessAndFiller;
            }else{
                state = FastContactHelper.getViewStateWithListCountAndAccess(self._lists[self._currentListIndex], useFiller: self.shouldShowFillerInNonEmptyList());
            }
            self._fastContactListManager.updateListsForState(state);
        }
    }
    
    @IBAction func provideAccessWithBlockedAccessClicked(sender: UIButton) {
        if(FastContactConstant.IOS_MAIN_VERSION >= 8.0) {
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!);
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self._currentViewState       = FastContactHelper.getDefaultViewStateBasedOnPhoneContactAccess();
        
        self._fastContactListManager = FastContactListManager(
            listCount: self.getListCount(),
            itemsBeforeEmptyListMax: self.getItemsBeforeEmptyListMax(),
            
            updateBlock: {()->Void in
                self._lists = self._fastContactListManager.getLists();
                self._updateViewStateAndData();
            }
        );
        
        self._currentListIndex = self.getDefaultListItem();
        self._lists            = self._fastContactListManager.getLists();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return _lists[_currentListIndex].count;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _lists[_currentListIndex][section].count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = _getTableViewCellForState(tableView, cellForRowAtIndexPath: indexPath, state: _currentViewState);
        return cell;
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var list = _lists[_currentListIndex];
        var section = list[indexPath.section];
        var row = section[indexPath.row];
        
        if(!(row is EmptyListItem)) {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath);
        }else{
            return self._getEmptyTableViewCellHeight(indexPath);
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
        return UITableViewCell();
    }
    
    internal func setViewState(state: FastContactViewState) {
        self._currentViewState = state;
    }
    
    internal func getViewState()->FastContactViewState {
        return self._currentViewState;
    }
    
    internal func getItemsBeforeEmptyListMax()->Int {
        if(FastContactConstant.IOS_MAIN_VERSION >= 8) {
            return 3;
        }else{
            return 2;
        }
    }
    
    internal func shouldShowFillerInNonEmptyList() -> Bool {
        return true;
    }
    
    internal func setProvideAccessButton(button: UIButton) {
        
        switch(_currentViewState!) {
        case .EmptyNoAccess:
            self._setProvideNoAccessButton(button);
            break;
        case .ManyNoAccess:
            self._setProvideNoAccessButton(button);
            break;
        case .EmptyBlockedAccess:
            self._setProvideBlockedAccessButton(button);
            break;
        case .ManyBlockedAccess:
            self._setProvideBlockedAccessButton(button);
            break;
        default:
            break;
        }
    }
    
    private func _updateViewStateAndData() {
        self._currentViewState = FastContactHelper.getViewStateWithListCountAndAccess(self._lists[self._currentListIndex], useFiller: shouldShowFillerInNonEmptyList());
        self.tableView.reloadData();
    }
    
    /// MARK Private methods
    
    private func _getTableViewCellForState(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, state: FastContactViewState) -> UITableViewCell {
        var cell: UITableViewCell!;
        
        var listItem: IListItem = _lists[_currentListIndex][indexPath.section][indexPath.row];
        
        if(listItem is EmptyListItem) {
            cell = getEmptyTableViewCell(tableView, state: state);
            cell = _getEmptyCellWithAttributes(cell);
        }else{
            cell = getNonEmptyTableViewCell(tableView, state: state);
        }
        
        return cell;
    }
 
    private func _getEmptyCellWithAttributes(cell: UITableViewCell) -> UITableViewCell {
        cell.selectionStyle = .None;
        
        return cell;
    }
    
    private func _getEmptyTableViewCellHeight(indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat = tableView.frame.height;
        var list = _lists[_currentListIndex];
        
        if(navigationController != nil) {
            height -= navigationController!.navigationBar.frame.height;
        }
        
        height -= 20;
        
        // Subtract the height of the rows and sections

        var itemCount = 0;
        for section in list {
            var sectionHeight = self.tableView(self.tableView, heightForHeaderInSection: indexPath.section);
            height -= sectionHeight;
            for item in section {
                if(!(item is EmptyListItem)) {
                    var cellHeight = super.tableView(self.tableView, heightForRowAtIndexPath: indexPath);
                    height -= cellHeight;
                    itemCount++;
                    if(itemCount >= getItemsBeforeEmptyListMax()) {
                        return height;
                    }
                }
            }
        }

        return  height;
    }
    
    private func _setProvideNoAccessButton(button: UIButton) {
        button.addTarget(self, action: "provideAccessWithNoAccessClicked:", forControlEvents: UIControlEvents.TouchUpInside);
    }
    
    private func _setProvideBlockedAccessButton(button: UIButton) {
        button.addTarget(self, action: "provideAccessWithBlockedAccessClicked:", forControlEvents: UIControlEvents.TouchUpInside);
    }
    

}

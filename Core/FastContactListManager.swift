//
//  FastContactDelegate.swift
//  FastContact
//
//  Created by Josh Woodcock on 8/22/15.
//  Copyright (c) 2015 Connecting Open Time, LLC. All rights reserved.
//

import UIKit

public class FastContactListManager {
    
    private var _filterBlocks: Array<()->Void> = Array();
    
    public func getListsForState(state: FastContactViewState, listCount: Int)->Array<Array<IListItem>> {
        var lists = Array<Array<IListItem>>();
        for (var i = 0; i < listCount; i++) {
            lists.append(getListForState(state));
        }
        return lists;
    }
    
    public func getListForState(state: FastContactViewState)->Array<IListItem>{
        var list: Array<IListItem>!;
        
        switch(state){
        case .EmptyNoAccess:
            list = _getEmptyNoAccessList();
            break;
        default:
            list = Array<IListItem>();
            break;
        }
        
        return list;
    }
    
    private func _getEmptyNoAccessList() -> Array<IListItem> {
        var list = Array<IListItem>();
        
        var item = RequestPermissionListItem();
        
        return list;
    }
    
    private func _getOneItemNoAccessList() -> Array<IListItem> {
        // TODO
        return Array<IListItem>();
    }
    
    private func _getEmptyWithAccess() -> Array<IListItem> {
        return Array<IListItem>();
    }
    
    private func _getManyItemsWithAccessAndHelp() -> Array<IListItem> {
        return Array<IListItem>();
    }
    
    private func _getManyItemsWithAccess() -> Array<IListItem> {
        return Array<IListItem>();
    }
    
}

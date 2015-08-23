//
//  FastContactDelegate.swift
//  FastContact
//
//  Created by Josh Woodcock on 8/22/15.
//  Copyright (c) 2015 Connecting Open Time, LLC. All rights reserved.
//

import UIKit

public class FastContactListManager {
    
    private var _onBuildListFilterBlocks: Array<()->Void> = Array();
    private var _updateBlock: ()->Void;
    private var _onBuildListGroupingBlocks: Array<()->Void> = Array();
    private var _lists: Array<Array<Array<IListItem>>> = Array<Array<Array<IListItem>>>();
    
    public init(listCount: Int, updateBlock: ()->Void) {
        self._updateBlock = updateBlock;
        self._lists = self._getDefaultLists(listCount);
    }
    
    public func updateListsForState(state: FastContactViewState) {
        self._updateBlock();
    }
    
    public func getLists() -> Array<Array<Array<IListItem>>> {
        return _lists;
    }
    
    private func _getDefaultLists(listCount: Int)->Array<Array<Array<IListItem>>> {
        var lists = Array<Array<Array<IListItem>>>();
        for (var i = 0; i < listCount; i++) {
            var list = Array<Array<IListItem>>();
            var oneEmptyListSection = Array<IListItem>();
            var oneEmptyListItem = EmptyListItem();
            
            oneEmptyListSection.append(oneEmptyListItem);
            list.append(oneEmptyListSection);
            lists.append(list);
        }
        return lists;
    }
}
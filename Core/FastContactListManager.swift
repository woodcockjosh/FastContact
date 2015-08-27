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
    private var _itemsBeforeEmptyListMax: Int;
    
    public init(listCount: Int, itemsBeforeEmptyListMax: Int, updateBlock: ()->Void) {
        self._updateBlock = updateBlock;
        self._itemsBeforeEmptyListMax = itemsBeforeEmptyListMax;
        self._lists = self._getDefaultLists(listCount);
    }
    
    public func setItemsInListForState(listIndex: Int, list: Array<Array<IListItem>>, state: FastContactViewState) {
        var listToSet = list;
        
        // Add a fillter empty cell
        if(state == .ManyWithAccessAndFiller || state == .ManyNoAccess || state == .ManyBlockedAccess){
            if(listToSet.count == 0){
                listToSet.append(Array<IListItem>());
            }
            
            if(list[0].count <= _itemsBeforeEmptyListMax) {
                listToSet[0].append(EmptyListItem());
            }else{
                listToSet[0].insert(EmptyListItem(), atIndex: 0);
            }
        }
        
        _lists[listIndex] = listToSet;
        
        self.updateListsForState(state);
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
    
    private func _listIsEmpty(list: Array<Array<IListItem>>)->Bool{
        if((list.count == 0 && list[0].count == 0 && list[0][0] is EmptyListItem) || list.count == 0) {
            return true;
        }else{
            return false;
        }
    }
}
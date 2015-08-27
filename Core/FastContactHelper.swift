//
//  FastContactViewStateHelper.swift
//  FastContact
//
//  Created by Josh Woodcock on 8/22/15.
//  Copyright (c) 2015 Connecting Open Time, LLC. All rights reserved.
//

import UIKit

public class FastContactHelper {
    
    public static func getDefaultViewStateBasedOnPhoneContactAccess() -> FastContactViewState {
        
        var state: FastContactViewState!;
        
        switch(APAddressBook.access()) {
        case APAddressBookAccess.Granted:
            state = FastContactViewState.EmptyWithAccess;
            break;
        case APAddressBookAccess.Denied:
            state = FastContactViewState.EmptyBlockedAccess;
            break;
        default:
            state = FastContactViewState.EmptyNoAccess;
            break;
        }
        
        return state;
    }
    
    public static func getSettingsNavigationString() -> String {
        var appName: String = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String;
        var navString = "Settings\n\t->Privacy\n\t\t->Contacts\n\t\t\t->"+appName+"\n";
        return navString;
    }
    
    public static func getViewStateWithListCountAndAccess(list: Array<Array<IListItem>>, useFiller: Bool)->FastContactViewState {
        
        if(APAddressBook.access() == .Granted) {
            if(!isEmptyItemList(list)){
                if(useFiller) {
                    return FastContactViewState.ManyWithAccessAndFiller;
                }else{
                    return FastContactViewState.ManyWithAccessNoFiller;
                }
            }else{
                if(list.count > 0 && list[0].count > 1) {
                    return FastContactViewState.ManyWithAccessAndFiller;
                }else{
                    return FastContactViewState.EmptyWithAccess;
                }
            }
        }else{
            if(!isEmptyItemList(list)) {
                if(APAddressBook.access() != APAddressBookAccess.Denied){
                    return FastContactViewState.ManyNoAccess;
                }else{
                    return FastContactViewState.ManyBlockedAccess
                }
            }else{
                return getDefaultViewStateBasedOnPhoneContactAccess();
            }
        }
    }
    
    public static func stateIsEmpty(state: FastContactViewState) -> Bool {
        
        if(state == .EmptyNoAccess || state == .EmptyBlockedAccess || state == .EmptyWithAccess) {
            return true;
        }else{
            return false;
        }
    }
    
    public static func stateHasNoAccess(state: FastContactViewState) -> Bool {
        if(state == FastContactViewState.EmptyNoAccess || state == FastContactViewState.ManyNoAccess){
            return true;
        }else{
            return false;
        }
    }
    
    public static func shouldAskForPermission(state: FastContactViewState) -> Bool {
        if((stateIsBlocked(state) && FastContactConstant.IOS_MAIN_VERSION >= 8.0) || stateHasNoAccess(state)){
            return true;
        }else{
            return false;
        }
    }
    
    public static func stateHasAccess(state: FastContactViewState) -> Bool {
        if(state == .EmptyWithAccess || state == .ManyWithAccessNoFiller || state == .ManyWithAccessAndFiller) {
            return true;
        }else{
            return false;
        }
    }
    
    public static func stateIsBlocked(state: FastContactViewState) -> Bool {
        if(state == FastContactViewState.EmptyBlockedAccess || state == FastContactViewState.ManyBlockedAccess){
            return true;
        }else{
            return false;
        }
    }
    
    public static func isEmptyItemList(list: Array<Array<IListItem>>) -> Bool {
        if((list.count > 0) && (list[0].count > 0) && (list[0][0] is EmptyListItem || list[0][list.count - 1] is EmptyListItem)){
            return true;
        }else{
            return false;
        }
    }
}


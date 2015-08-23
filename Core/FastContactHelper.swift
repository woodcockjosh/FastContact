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
            if(Constant.IOS_MAIN_VERSION >= 8.0) {
                state = FastContactViewState.EmptyBlockedAccessAtLeastIOS8;
            }else{
                state = FastContactViewState.EmptyBlockedAccessLessThanIOS8;
            }
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
    
    public static func getViewStateWithListCountAndAccess(list: Array<Array<IListItem>>)->FastContactViewState {
        if((list.count > 0) && (list[0].count > 0) && !(list[0][0] is EmptyListItem) &&  (APAddressBook.access() == .Granted)) {
            return FastContactViewState.ManyWithAccessAndFiller;
        }else{
            return getDefaultViewStateBasedOnPhoneContactAccess();
        }
    }
    
}

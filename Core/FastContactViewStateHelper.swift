//
//  FastContactViewStateHelper.swift
//  FastContact
//
//  Created by Josh Woodcock on 8/22/15.
//  Copyright (c) 2015 Connecting Open Time, LLC. All rights reserved.
//

import UIKit

public class FastContactViewStateHelper {
    
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
    
}

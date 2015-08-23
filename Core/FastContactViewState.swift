//
//  FastContactViewState.swift
//  FastContact
//
//  Created by Josh Woodcock on 8/22/15.
//  Copyright (c) 2015 Connecting Open Time, LLC. All rights reserved.
//

import UIKit

public enum FastContactViewState {
    case EmptyNoAccess;
    case EmptyBlockedAccessLessThanIOS8;
    case EmptyBlockedAccessAtLeastIOS8;
    case EmptyWithAccess;
    case ManyWithAccessAndFiller;
    case ManyWithAccessNoFiller;
}

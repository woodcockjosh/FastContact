//
//  Constant.swift
//  FastContact
//
//  Created by Josh Woodcock on 8/23/15.
//  Copyright (c) 2015 Connecting Open Time, LLC. All rights reserved.
//

import UIKit

public struct FastContactConstant {
    public static let IOS_MAIN_VERSION: Double = {
        var systemVersion = UIDevice.currentDevice().systemVersion;
        var numbers = split(systemVersion) {$0 == "."}
        var numStrings = Array<String>();
        var i = 0;
        for num in numbers {
            i++;
            if(i <= 2) {
                numStrings.append(num);
            }else{
                break;
            }
        }
        var numString = ".".join(numStrings);
        var numNum = (numString as NSString).doubleValue;
        
        return numNum;
    }();
}

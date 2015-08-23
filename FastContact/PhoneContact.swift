//
//  PhoneContact.swift
//  FastContact
//
//  Created by Josh Woodcock on 8/22/15.
//  Copyright (c) 2015 Connecting Open Time, LLC. All rights reserved.
//

import UIKit

public class PhoneContact: IListItem {
    
    private var _name: String;
    private var _phoneNumber: String
    private var _image: UIImage!;
    
    public init() {
        _name = "";
        _phoneNumber = "";
        _image = nil;
    }
    
    public func getName()->String{
        return self._name;
    }
    
    public func getPhoneNumber()->String{
        return self._phoneNumber;
    }
    
    public func getImage()->UIImage{
        return self._image;
    }
}

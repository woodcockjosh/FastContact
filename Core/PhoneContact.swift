//
//  PhoneContact.swift
//  FastContact
//
//  Created by Josh Woodcock on 8/22/15.
//  Copyright (c) 2015 Connecting Open Time, LLC. All rights reserved.
//

import UIKit

public struct PhoneContact: IListItem {
    private var _name: String;
    private var _phoneNumber: String
    private var _image: UIImage;
    
    public init(name: String, phoneNumber: String, image: UIImage) {
        _name = name;
        _phoneNumber = phoneNumber;
        _image = image;
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

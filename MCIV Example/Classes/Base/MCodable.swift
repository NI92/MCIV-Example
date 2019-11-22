//
//  MCodable.swift
//  MCIV Example
//
//  Created by Nick Ignatenko on 2019-11-22.
//  Copyright © 2019 Nick Ignatenko. All rights reserved.
//
//  A class conforming to the 'NSCoding' protocol to allow easy parsing of data to property key names.

import UIKit

class MCodable: NSObject, NSCoding {
    var properties: [String] {
        return Mirror(reflecting: self).children.compactMap { $0.label }
    }
    
    // MARK: Init
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        for property in self.properties {
            self.setValue(aDecoder.decodeObject(forKey: property), forKeyPath: property)
        }
    }
    
    // MARK: Actions
    func encode(with aCoder: NSCoder) {
        for property in self.properties {
            aCoder.encode(self.value(forKeyPath: property), forKey: property)
        }
    }
}

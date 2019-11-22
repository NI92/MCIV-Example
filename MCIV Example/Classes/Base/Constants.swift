//
//  Constants.swift
//  MCIV Example
//
//  Created by Nick Ignatenko on 2019-11-22.
//  Copyright © 2019 Nick Ignatenko. All rights reserved.
//
//  App constants.

import UIKit

#if DEV
let dev = "api.harvardartmuseums.org"
#else
let prod = "api.harvardartmuseums.org"
#endif

// API keys
let hostURL = "https://\(prod)/"
let apiVersion = "" //"rest/v1/"
let baseURL = hostURL + apiVersion

// Status codes
let InvalidTokenStatusCode = 401

var appVersion: String {
    return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
}

var appName: String {
    return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
}

private let kDeviceIdUD = "com.mciv-example.deviceId"
var deviceId: String? {
    if let id = UserDefaults.standard.string(forKey: kDeviceIdUD) {
        return id
    }
    if let id = UIDevice.current.identifierForVendor?.uuidString {
        UserDefaults.standard.set(id, forKey: kDeviceIdUD)
        UserDefaults.standard.synchronize()
        return id
    }
    return nil
}

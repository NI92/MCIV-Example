//
//  CommonRequest.swift
//  MCIV Example
//
//  Created by Nick Ignatenko on 2019-11-22.
//  Copyright © 2019 Nick Ignatenko. All rights reserved.
//
//  Networking-related classes. Specifically, making a single "common" request. Or, a "mutlipart" request.

import UIKit
import Alamofire

class CommonRequest {
    var url: String!
    var headers: [String: String]!
    var parameters: [String: Any]!
    var method: Alamofire.HTTPMethod!
    var encoding: ParameterEncoding = URLEncoding.default
    var timeout: TimeInterval = 30.0
    
    // MARK: Init
    required init(url: String, method: Alamofire.HTTPMethod) {
        self.url = url
        self.headers = [String: String]()
        self.parameters = [String: Any]()
        self.method = method
    }
    
    // MARK: Actions
    class func create(url: String, method: Alamofire.HTTPMethod) -> Self {
        let request = self.init(url: url, method: method)
        request.withBaseHeaders()
        return request
    }
    
    func withParameter(key: String, value: Any) -> Self {
        self.parameters[key] = value
        return self
    }
    
    func withHeader(key: String, value: String) -> Self {
        self.headers[key] = value
        return self
    }
}

struct FileRepresentation {
    let fileName: String
    let mimeType: String
}

class MultipartRequest: CommonRequest {
    var fileRepresentations = [String: FileRepresentation]()
    
    func withTextParameter(key: String, value: String, encoding: String.Encoding = .utf8) -> Self {
        return self.withParameter(key: key, value: value.data(using: encoding)!)
    }
    
    func withFileParameter(key: String, value: Data, representation: FileRepresentation) -> Self {
        self.fileRepresentations[key] = representation
        return self.withParameter(key: key, value: value)
    }
    
    override func withParameter(key: String, value: Any) -> Self {
        guard let value = value as? Data else { fatalError("Only parameters of type 'Data' are supported") }
        self.parameters[key] = value
        return self
    }
}

// MARK: - Actions (base parameters)
extension CommonRequest {
    @discardableResult
    fileprivate func withBaseHeaders() -> Self {
        if let deviceId = deviceId {
            let _ = self.withHeader(key: "deviceId", value: deviceId)
        }
        let _ = self.withHeader(key: "osType", value: "iOS")
        let _ = self.withHeader(key: "appName", value: "MCIV-Example")
        let _ = self.withHeader(key: "appVersion", value: appVersion)
        return self
    }
}

// MARK: Actions (pagination)
extension CommonRequest {
    func withCurrentPage(_ page: Int) -> Self {
        let _ = self.withParameter(key: "currentPage", value: page)
        return self
    }
    
    func withPageSize(_ pageSize: Int) -> Self {
        let _ = self.withParameter(key: "pageSize", value: pageSize)
        return self
    }
}

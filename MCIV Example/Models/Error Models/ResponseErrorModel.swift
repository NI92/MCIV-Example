//
//  ResponseErrorModel.swift
//  MCIV Example
//
//  Created by Nick Ignatenko on 2019-11-22.
//  Copyright © 2019 Nick Ignatenko. All rights reserved.
//
//  Error handling model.

import Foundation

struct ResponseErrorModel: Model {
    let type: String
    let message: String?
    let reason: String?
    let subject: String?
    let subjectType: String?
    
    /// Parse an inputted JSON file
    static func create(json: Any?) throws -> ResponseErrorModel {
        guard let json = json as? JSON else { throw NetError.incorrectData }
        return self.init(type: (json["type"] as? String ?? ""),
                         message: json["message"] as? String,
                         reason: json["reason"] as? String,
                         subject: json["subject"] as? String,
                         subjectType: json["subjectType"] as? String)
    }
    
    /// Turn current data into JSON-format to send over network
    func toJSON() throws -> JSON {
        return ["type": self.type,
                "message": self.message ?? "",
                "reason": self.reason ?? "",
                "subject": self.subject ?? "",
                "subjectType": self.subjectType ?? ""]
    }
}

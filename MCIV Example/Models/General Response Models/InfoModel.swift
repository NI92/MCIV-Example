//
//  InfoModel.swift
//  MCIV Example
//
//  Created by Nick Ignatenko on 2019-11-22.
//  Copyright © 2019 Nick Ignatenko. All rights reserved.
//
//  An 'info' model that comes with every get response.

import UIKit

struct InfoModel: Model, CustomStringConvertible {
    let totalRecordsPerQuery: Int
    let totalRecords: Int
    let totalPages: Int
    let currentPage: Int
    let nextPageURL: String
    var description: String {
        return "Page \(self.currentPage) out of \(self.totalPages) pages. \(self.totalRecords) total records."
    }
    
    static func create(json: Any?) throws -> InfoModel {
        guard let json = json as? JSON else { throw NetError.incorrectData }
        
        guard let totalRecordsPerQuery = json["totalrecordsperquery"] as? Int,
            let totalRecords = json["totalrecords"] as? Int,
            let totalPages = json["pages"] as? Int,
            let currentPage = json["page"] as? Int,
            let nextPageURL = json["next"] as? String
            else { throw NetError.incorrectData }
        
        return self.init(totalRecordsPerQuery: totalRecordsPerQuery,
                         totalRecords: totalRecords,
                         totalPages: totalPages,
                         currentPage: currentPage,
                         nextPageURL: nextPageURL)
    }
}

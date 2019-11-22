//
//  ArtList.swift
//  MCIV Example
//
//  Created by Nick Ignatenko on 2019-11-22.
//  Copyright © 2019 Nick Ignatenko. All rights reserved.
//
//  Primary model for parsing retrieved JSON data from the Harvard Museum API.

import UIKit

struct ArtListModel: Model, CustomStringConvertible {
    let info: InfoModel
    let records: [ArtModel]
    var description: String {
        return "\(self.records.count) records"
    }
    
    static func create(json: Any?) throws -> ArtListModel {
        guard let json = json as? JSON else { throw NetError.incorrectData }
        
        guard let info = try? InfoModel.create(json: json["info"]),
            let records = try (json["records"] as? [JSON])?.createModels(ArtModel.self)
            else { throw NetError.incorrectData }
        
        return self.init(info: info,
                         records: records)
    }
}

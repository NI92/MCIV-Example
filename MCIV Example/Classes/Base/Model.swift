//
//  Model.swift
//  MCIV Example
//
//  Created by Nick Ignatenko on 2019-11-22.
//  Copyright © 2019 Nick Ignatenko. All rights reserved.
//
//  Foundation class for all models (data & logic handlers).

import UIKit

typealias JSON = [String: Any]

protocol Model {
    static func create(json: Any?) throws -> Self
}

extension Array where Element == JSON {
    func createModels<M: Model>(_ type: M.Type) throws -> [M] {
        return try self.map({ (element) -> M in
            return try M.create(json: element)
        })
    }
}

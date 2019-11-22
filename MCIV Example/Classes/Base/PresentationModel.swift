//
//  PresentationModel.swift
//  MCIV Example
//
//  Created by Nick Ignatenko on 2019-11-22.
//  Copyright © 2019 Nick Ignatenko. All rights reserved.
//
//  Foundation class for all children to act as a layer between data retrieval & separation.

import UIKit

class PresentationModel: NSObject {
    typealias ErrorHandler = (NSError) -> ()
    typealias LoadingHandler = (Bool) -> ()
    
    var errorHandler: ErrorHandler?
    var loadingHandler: LoadingHandler?
    
    required init(errorHandler: ErrorHandler?) {
        super.init()
        self.errorHandler = errorHandler
    }
}

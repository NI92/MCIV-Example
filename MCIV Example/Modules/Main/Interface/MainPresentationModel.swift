//
//  MainPresentationModel.swift
//  MCIV Example
//
//  Created by Nick Ignatenko on 2019-11-22.
//  Copyright © 2019 Nick Ignatenko. All rights reserved.
//

import UIKit
import PromiseKit

class MainPresentationModel: PresentationModel {
    /// In charge of making a network request to retrieve data.
    let harvardMuseumManager = HarvardMuseumNetworkManager()
    /// When data is successfully retrieved, this block is called to pass data back & present in some kind of UI, such as a table view.
    var refreshHandler: ((_ model: ArtListModel) -> ())?
    
    required init(errorHandler: ErrorHandler?) {
        super.init(errorHandler: errorHandler)
    }
    
    func getMuseumData() {
        self.loadingHandler?(true)
        self.harvardMuseumManager.getArtList()
            .then { [weak self] model -> Promise<()> in
                guard let self = self else { return Promise() }
                self.loadingHandler?(false)
                self.refreshHandler?(model)
                return Promise() // *NOTE: Need this bloody hack of returning a 'Promise' to make '.then' work!
            }.catch { [weak self] error in
                guard let self = self else { return }
                self.loadingHandler?(false)
                self.errorHandler?(error as NSError)
        }
    }
}

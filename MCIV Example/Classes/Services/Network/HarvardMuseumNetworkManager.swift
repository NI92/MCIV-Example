//
//  HarvardMuseumNetworkManager.swift
//  MCIV Example
//
//  Created by Nick Ignatenko on 2019-11-22.
//  Copyright © 2019 Nick Ignatenko. All rights reserved.
//
//  In charge of requesting JSON data from the server for the 'main' controllers.

import UIKit
import PromiseKit

class HarvardMuseumNetworkManager: NetworkManager {
    enum Endpoint {
        // API Docs https://github.com/harvardartmuseums/api-docs
        //static let Main = "promotions/main"
        static let Object           = "object"
        static let Person           = "person"
        static let Exhibition       = "exhibitions"
        static let Publication      = "publication"
        static let Gallery          = "gallery"
        static let Spectrum         = "spectrum"
        static let Classification   = "classification"
        static let Century          = "century"
        static let Color            = "color"
        static let Culture          = "culture"
        static let Group            = "group"
        static let Medium           = "medium"
        static let Period           = "period"
        static let Place            = "place"
        static let Technique        = "technique"
        static let Worktype         = "worktype"
        static let Activity         = "activity"
        static let Site             = "site"
        static let Video            = "video"
        static let Image            = "image"
        static let Audio            = "audio"
        static let Annotation       = "annotation"
        // Experimental data
        static let Experimental     = "experimental"
    }
    
    func getArtList() -> Promise<ArtListModel> {
        return Promise<ArtListModel> { [unowned self] seal in
            let accessToken = User.current.accessToken ?? ""
            let request = CommonRequest.create(url: baseURL+Endpoint.Object, method: .get).withParameter(key: "apikey", value: accessToken)
            self.performRequestJSON(request)
                .then { response -> Promise<()> in
                    guard let json = response as? JSON else { throw NetError.incorrectData }
                    let model = try ArtListModel.create(json: json)
                    seal.fulfill(model)
                    return Promise() // *NOTE: Need this bloody hack of returning a 'Promise' to make '.then' work!
                }.catch { error in
                    seal.reject(error)
            }
        }
    }
}

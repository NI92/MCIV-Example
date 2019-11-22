//
//  ArtImageModel.swift
//  MCIV Example
//
//  Created by Nick Ignatenko on 2019-11-22.
//  Copyright © 2019 Nick Ignatenko. All rights reserved.
//

import UIKit

struct ArtImageModel: Model {
    let width: Int
    let height: Int
    let iiifBaseURI: String
    let baseImageURL: String
    let publicCaption: String?
    let imageID: Int
    let idsID: Int
    let displayOrder: Int
    let format: String
    let copyright: String
    let renditionNumber: String
    
    static func create(json: Any?) throws -> ArtImageModel {
        guard let json = json as? JSON else {throw NetError.incorrectData }
        
        guard let width = json["width"] as? Int,
            let height = json["height"] as? Int,
            let iiifBaseURI = json["iiifbaseuri"] as? String,
            let baseImageURL = json["baseimageurl"] as? String,
            let imageID = json["imageid"] as? Int,
            let idsID = json["idsid"] as? Int,
            let displayOrder = json["displayorder"] as? Int,
            let format = json["format"] as? String,
            let copyright = json["copyright"] as? String,
            let renditionNumber = json["renditionnumber"] as? String
            else { throw NetError.incorrectData }

        let publicCaption = json["publiccaption"] as? String
        
        return self.init(width: width,
                         height: height,
                         iiifBaseURI: iiifBaseURI,
                         baseImageURL: baseImageURL,
                         publicCaption: publicCaption,
                         imageID: imageID,
                         idsID: idsID,
                         displayOrder: displayOrder,
                         format: format,
                         copyright: copyright,
                         renditionNumber: renditionNumber)
    }
}

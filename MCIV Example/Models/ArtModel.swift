//
//  ArtModel.swift
//  MCIV Example
//
//  Created by Nick Ignatenko on 2019-11-22.
//  Copyright © 2019 Nick Ignatenko. All rights reserved.
//
//  Primary model for parsing retrieved JSON data from the Harvard Museum API.

import UIKit

struct ArtModel: Model {
    let accessionYear: Int
    let technique: String?
    let mediaCount: Int
    let edition: Int?
    let totalPageViews: Int
    let groupCount: Int
    let objectNumberString: String
    let colorCount: Int
    let lastUpdateTimestamp: String
    let rank: Int
    let imageCount: Int
    let description: String?
    let dateOfLastpageViewTimestamp: String?
    let dateofFirstPageViewTimestamp: String?
    let primaryImageURL: String?
    //let colors: [ColorModel]
    let dated: String
    let contextualTextCount: Int
    let copyright: String?
    let period: String?
    let accessionMethod: String
    let url: String
    let provenance: String?
    let images: [ArtImageModel]
    let publicationCount: Int
    let objectID: Int
    let culture: String?
    let verificationLevelDescription: String
    let standardReferenceNumber: String?
    let department: String
    let state: String?
    let marksCount: Int
    let contact: String
    let titlesCount: Int
    let id: Int
    let title: String
    let verificationLevel: Int
    let division: String
    let style: String?
    let commentary: String?
    let relatedCount: Int
    let dateBegin: Int
    let labelText: String?
    let totalUniquePageViews: Int
    let dimensions: String
    let exhibitionCount: Int
    let techniqueID: String?
    let dateEnd: Int
    let creditLine: String
    let imagePermissionLevel: Int
    let signed: String?
    let periodID: String?
    let century: String?
    let classificationID: Int
    let medium: String?
    let peopleCount: Int
    let accessLevel: Int
    let classification: String
    
//    key : "people"
//    ▿ value : 1 element
//      ▿ 0 : 12 elements
//        ▿ 0 : 2 elements
//          - key : gender
//          - value : unknown
//        ▿ 1 : 2 elements
//          - key : displayorder
//          - value : 1
//        ▿ 2 : 2 elements
//          - key : displayname
//          - value : Unidentified Artist
//        ▿ 3 : 2 elements
//          - key : prefix
//          - value : <null>
//            - super : NSObject
//        ▿ 4 : 2 elements
//          - key : alphasort
//          - value : Unidentified Artist
//        ▿ 5 : 2 elements
//          - key : personid
//          - value : 34147
//        ▿ 6 : 2 elements
//          - key : culture
//          - value : <null> { ... }
//        ▿ 7 : 2 elements
//          - key : role
//          - value : Artist
//        ▿ 8 : 2 elements
//          - key : displaydate
//          - value : <null> { ... }
//        ▿ 9 : 2 elements
//          - key : deathplace
//          - value : <null> { ... }
//        ▿ 10 : 2 elements
//          - key : name
//          - value : Unidentified Artist
//        ▿ 11 : 2 elements
//          - key : birthplace
//          - value : <null> { ... }
    
//    "seeAlso": [
//      {
//        "id": String
//        "type": String
//        "format": String
//        "profile": String
//      }
//    ]
    
    static func create(json: Any?) throws -> ArtModel {
        guard let json = json as? JSON else {throw NetError.incorrectData }
        
        guard let accessionYear = json["accessionyear"] as? Int,
            let mediaCount = json["mediacount"] as? Int,
            let totalPageViews = json["totalpageviews"] as? Int,
            let groupCount = json["groupcount"] as? Int,
            let objectNumberString = json["objectnumber"] as? String,
            let colorCount = json["colorcount"] as? Int,
            let lastUpdateTimestamp = json["lastupdate"] as? String,
            let rank = json["rank"] as? Int,
            let imageCount = json["imagecount"] as? Int,
            //let colors = try ColorModel json["colors"],
            let dated = json["dated"] as? String,
            let contextualTextCount = json["contextualtextcount"] as? Int,
            let accessionMethod = json["accessionmethod"] as? String,
            let url = json["url"] as? String,
            let images = try (json["images"] as? [JSON])?.createModels(ArtImageModel.self),
            let publicationCount = json["publicationcount"] as? Int,
            let objectID = json["objectid"] as? Int,
            let verificationLevelDescription = json["verificationleveldescription"] as? String,
            let department = json["department"] as? String,
            let marksCount = json["markscount"] as? Int,
            let contact = json["contact"] as? String,
            let titlesCount = json["titlescount"] as? Int,
            let id = json["id"] as? Int,
            let title = json["title"] as? String,
            let verificationLevel = json["verificationlevel"] as? Int,
            let division = json["division"] as? String,
            let relatedCount = json["relatedcount"] as? Int,
            let dateBegin = json["datebegin"] as? Int,
            let totalUniquePageViews = json["totaluniquepageviews"] as? Int,
            let dimensions = json["dimensions"] as? String,
            let exhibitionCount = json["exhibitioncount"] as? Int,
            let dateEnd = json["dateend"] as? Int,
            let creditLine = json["creditline"] as? String,
            let imagePermissionLevel = json["imagepermissionlevel"] as? Int,
            let classificationID = json["classificationid"] as? Int,
            let peopleCount = json["peoplecount"] as? Int,
            let accessLevel = json["accesslevel"] as? Int,
            let classification = json["classification"] as? String
            else { throw NetError.incorrectData }
        
        let technique = json["technique"] as? String
        let edition = json["edition"] as? Int
        let copyright = json["copyright"] as? String
        let period = json["period"] as? String
        let standardReferenceNumber = json["standardreferencenumber"] as? String
        let state = json["state"] as? String
        let style = json["style"] as? String
        let commentary = json["commentary"] as? String
        let labelText = json["labeltext"] as? String
        let techniqueID = json["techniqueid"] as? String
        let signed = json["signed"] as? String
        let periodID = json["periodid"] as? String
        let century = json["century"] as? String
        let culture = json["culture"] as? String
        let medium = json["medium"] as? String
        let primaryImageURL = json["primaryimageurl"] as? String
        let provenance = json["provenance"] as? String
        let description = json["description"] as? String
        let dateOfLastpageViewTimestamp = json["dateoflastpageview"] as? String
        let dateofFirstPageViewTimestamp = json["dateoffirstpageview"] as? String
        
        return self.init(accessionYear: accessionYear,
                         technique: technique,
                         mediaCount: mediaCount,
                         edition: edition,
                         totalPageViews: totalPageViews,
                         groupCount: groupCount,
                         objectNumberString: objectNumberString,
                         colorCount: colorCount,
                         lastUpdateTimestamp: lastUpdateTimestamp,
                         rank: rank,
                         imageCount: imageCount,
                         description: description,
                         dateOfLastpageViewTimestamp: dateOfLastpageViewTimestamp,
                         dateofFirstPageViewTimestamp: dateofFirstPageViewTimestamp,
                         primaryImageURL: primaryImageURL,
                         //colors: colors,
                         dated: dated,
                         contextualTextCount: contextualTextCount,
                         copyright: copyright,
                         period: period,
                         accessionMethod: accessionMethod,
                         url: url,
                         provenance: provenance,
                         images: images,
                         publicationCount: publicationCount,
                         objectID: objectID,
                         culture: culture,
                         verificationLevelDescription: verificationLevelDescription,
                         standardReferenceNumber: standardReferenceNumber,
                         department: department,
                         state: state,
                         marksCount: marksCount,
                         contact: contact,
                         titlesCount: titlesCount,
                         id: id,
                         title: title,
                         verificationLevel: verificationLevel,
                         division: division,
                         style: style,
                         commentary: commentary,
                         relatedCount: relatedCount,
                         dateBegin: dateBegin,
                         labelText: labelText,
                         totalUniquePageViews: totalUniquePageViews,
                         dimensions: dimensions,
                         exhibitionCount: exhibitionCount,
                         techniqueID: techniqueID,
                         dateEnd: dateEnd,
                         creditLine: creditLine,
                         imagePermissionLevel: imagePermissionLevel,
                         signed: signed,
                         periodID: periodID,
                         century: century,
                         classificationID: classificationID,
                         medium: medium,
                         peopleCount: peopleCount,
                         accessLevel: accessLevel,
                         classification: classification)
    }
}

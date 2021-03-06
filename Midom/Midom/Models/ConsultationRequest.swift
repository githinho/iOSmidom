//
//  ConsultationRequest.swift
//  Midom
//
//  Created by Eugen Druzin on 08/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import Foundation
import Gloss

class ConsultationRequest: Decodable {
    
    var id: Int?
    var creationTime: UInt64?
    var acceptanceTime: String?
    var studyOwner: Int?
    var status: String?
    var study: Int?
    var studyObj: Study?
    
    required init?(json: JSON) {
        self.id = "id" <~~ json
        self.creationTime = "creationTime" <~~ json
        self.acceptanceTime = "acceptanceTime" <~~ json
        self.studyOwner = "studyOwner" <~~ json
        self.status = "status" <~~ json
        self.study = "study" <~~ json
        self.studyObj = "studyObj" <~~ json
    }
}

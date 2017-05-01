//
//  ConsultationRequestMessage.swift
//  Midom
//
//  Created by Eugen Druzin on 08/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import Foundation
import Gloss

class ConsultationRequestMessage: Decodable {
    
    var id: Int?
    var comment: String?
    var creationTime: UInt64?
    var msSender: String?
    var spSender: String?
    
    required init?(json: JSON) {
        self.id = "id" <~~ json
        self.comment = "comment" <~~ json
        self.creationTime = "creationTime" <~~ json
        self.msSender = "msSender" <~~ json
        self.spSender = "spSender" <~~ json
    }
}

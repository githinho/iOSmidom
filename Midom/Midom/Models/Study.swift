//
//  Study.swift
//  Midom
//
//  Created by Eugen Druzin on 08/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import Foundation
import Gloss

class Study: Decodable {
    
    var id: Int?
    var name: String?
    var creationDate: Double?
    var ownerId: Int?
    var open: Bool?
    var ownerObj: AccountDetails?
    
    required init?(json: JSON) {
        self.id = "id" <~~ json
        self.name = "name" <~~ json
        self.creationDate = "creationDate" <~~ json
        self.ownerId = "ownerId" <~~ json
        self.open = "open" <~~ json
        // TODO: add ownerObj
    }
}

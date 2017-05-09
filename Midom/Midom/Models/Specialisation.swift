//
//  Specialisation.swift
//  Midom
//
//  Created by Eugen Druzin on 08/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import Foundation
import Gloss

struct Specialisation: Decodable {
    
    var id: Int?
    var name: String?
    var parentStudy: String?
    var subStudies: [Int]?
    var selected: Bool?
    
    init(json: JSON) {
        self.id = "id" <~~ json
        self.name = "name" <~~ json
        self.parentStudy = "parentStudy" <~~ json
        self.subStudies = "subStudies" <~~ json
        self.selected = "selected" <~~ json
    }
}

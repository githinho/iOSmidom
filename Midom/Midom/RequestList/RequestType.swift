//
//  RequestType.swift
//  Midom
//
//  Created by Eugen Druzin on 17/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import Foundation

enum RequestType: String {
    
    case pending = "Pending"
    case accepted = "Accepted"
    case consulted = "Consulted"
    case closed = "Closed"
    case rejected = "Rejected"
    case revoked = "Revoked"
}

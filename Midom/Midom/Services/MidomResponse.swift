//
//  MidomResponse.swift
//  Midom
//
//  Created by Eugen Druzin on 08/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import Foundation

struct MidomResponse {
    let message: Any
    let code: Int
}

extension MidomResponse {
    init?(json: [String: Any]) {
        guard let message = json["message"] as? Any,
            let code = json["code"] as? Int
            else {
            return nil
        }
        self.message = message
        self.code = code
    }
}

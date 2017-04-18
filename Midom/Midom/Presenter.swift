//
//  Presenter.swift
//  Midom
//
//  Created by Eugen Druzin on 18/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import Foundation

protocol PresenterContext {
    var midomService: MidomService {get}
}

struct Presenter {
    static func present(context: PresenterContext) -> String {
        return context.midomService.error!
    }
}

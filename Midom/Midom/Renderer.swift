//
//  Renderer.swift
//  Midom
//
//  Created by Eugen Druzin on 18/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import Foundation
import UIKit

class Renderer {
    
    private let window: UIWindow
    private let presenterContext: PresenterContext
    
    init(window:UIWindow, context: PresenterContext) {
        self.window = window
        self.presenterContext = context
    }
    
    func render() {
        DispatchQueue.main.async {
            if let nc = self.window.rootViewController as? UINavigationController {
                if let topvc = nc.topViewController as? LoginViewController {
                    topvc.update(errorMessage: Presenter.present(context: self.presenterContext))
                } else if let topvc = nc.topViewController as? RequestListViewController {
                    topvc.update(model: Presenter.present(context: self.presenterContext))
                } else if let topvc = nc.topViewController as? PendingRequestViewController {
                    topvc.update(viewModel: Presenter.present(context: self.presenterContext))
                } else if let topvc = nc.topViewController as? AcceptedRequestViewController {
                    topvc.update(viewModel: Presenter.present(context: self.presenterContext))
                }
            }
        }
    }
}

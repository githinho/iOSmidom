//
//  RequestListViewController.swift
//  Midom
//
//  Created by Eugen Druzin on 17/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import UIKit

class RequestListViewController: UIViewController {
    
    @IBOutlet weak var requeststableView: UITableView!
    
    private var requestType: RequestType?

    convenience init(requestType: RequestType) {
        self.init()
        self.requestType = requestType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = requestType?.rawValue
    }
}

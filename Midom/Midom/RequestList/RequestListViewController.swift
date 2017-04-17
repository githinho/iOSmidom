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
    internal var requestsList = [ConsultationRequest]()
    internal let identifier = String(describing: RequestTableViewCell.self)

    
    convenience init(requestType: RequestType) {
        self.init()
        self.requestType = requestType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = requestType?.rawValue
        
        self.requeststableView.delegate = self
        self.requeststableView.dataSource = self
        self.requeststableView.register(
            UINib(nibName: identifier, bundle: nil),
            forCellReuseIdentifier: identifier)
        
        let rowHeight: CGFloat = 80
        self.requeststableView.estimatedRowHeight = rowHeight
        self.requeststableView.rowHeight = rowHeight
    }
}

extension RequestListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = requeststableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! RequestTableViewCell
        
        // TODO: use cell.configure()
        cell.configure(request: requestsList[indexPath.item])
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestsList.count
    }
}

extension RequestListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: open request details
        print("clicked item \(indexPath.item)")
    }
}

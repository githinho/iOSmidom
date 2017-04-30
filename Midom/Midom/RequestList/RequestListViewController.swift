//
//  RequestListViewController.swift
//  Midom
//
//  Created by Eugen Druzin on 17/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import UIKit
import Toast_Swift

class RequestListViewController: UIViewController {
    
    @IBOutlet weak var requeststableView: UITableView!
    
    private var requestType: RequestType
    internal var service: MidomService
    
    internal var requestsList = [ConsultationRequest]()
    internal let identifier = String(describing: RequestTableViewCell.self)
    
    init(requestType: RequestType, service: MidomService) {
        self.requestType = requestType
        self.service = service
        super.init(nibName: "RequestListViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = requestType.rawValue
        
        self.requeststableView.delegate = self
        self.requeststableView.dataSource = self
        self.requeststableView.register(
            UINib(nibName: identifier, bundle: nil),
            forCellReuseIdentifier: identifier)
        
        let rowHeight: CGFloat = 80
        self.requeststableView.estimatedRowHeight = rowHeight
        self.requeststableView.rowHeight = rowHeight
        
        self.service.getConsultationRequestsForStatus(status: requestType)
    }
    
    func update(model: ConsultationRequestsViewModel) {
        if let error = model.error {
            view.makeToast(error)
        }
        if let list = model.consultaionRequests {
            requestsList = list
            requeststableView.reloadData()
        }
    }
}

extension RequestListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = requeststableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! RequestTableViewCell
        
        // TODO: use cell.configure()
        cell.configure(cellData: createCell(cr: requestsList[indexPath.item]))
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestsList.count
    }
    
    private func createCell(cr: ConsultationRequest) -> RequstCell {
        let studyName = cr.studyObj?.name ?? ""
        let date = cr.creationTime ?? 1
        
        var personName = ""
        var avatar: UIImage?
        if let account = service.accounts.first(where: {$0.id == cr.studyOwner!}) {
            personName = account.getFullName()
            if let data = account.avatar {
                avatar = UIImage(data: data)
            }
        }
        
        return RequstCell(studyName: studyName, specialistName: personName, date: date, avatar: avatar)
    }
    
}

extension RequestListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: open request details
        print("clicked item \(indexPath.item)")
    }
}

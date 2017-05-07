//
//  PendingRequestViewController.swift
//  Midom
//
//  Created by Eugen Druzin on 30/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import UIKit

class PendingRequestViewController: UIViewController {

    @IBOutlet weak var nameStudyLabel: UILabel!
    @IBOutlet weak var specialistLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    private let service: MidomService
    private let crId: Int

    init(midomService: MidomService, crId: Int) {
        self.service = midomService
        self.crId = crId
        super.init(nibName: "PendingRequestViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Request data"
    }
    
    func update(viewModel: PendingCrViewModel) {
        if let error = viewModel.error {
            self.view.makeToast(error)
        } else {
            self.presentDatat(viewModel: viewModel)
        }
    }
    
    // TODO: refactor this! send only needed data
    private func presentDatat(viewModel: PendingCrViewModel) {
        if let consultationRequest = viewModel.consultationRequests?
            .first(where: { $0.id == crId }) {
            nameStudyLabel.text = Utils.getStudyNameLabel(name: consultationRequest.studyObj?.name)
            dateLabel.text = Utils.getCreationDateLabel(date: consultationRequest.creationTime)
            
            if let account = viewModel.accounts?
                .first(where: { $0.id == consultationRequest.studyOwner} ) {
                specialistLabel.text = Utils.getSpecialistNameLabel(account: account)
            }
        }
        if let messages = viewModel.crMessages {
            for message in messages {
                let comment = message.comment ?? ""
                commentLabel.text = "\(comment) \n"
            }
        }
    }
    
    @IBAction func acceptButtonClicked(_ sender: UIButton) {
        service.acceptPendingCr(vc: self, crId: crId)
    }

    @IBAction func rejectButtonClicked(_ sender: UIButton) {
        service.rejectPendingCr(crId: crId)
    }
}

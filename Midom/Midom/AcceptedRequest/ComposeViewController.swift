//
//  ComposeViewController.swift
//  Midom
//
//  Created by Eugen Druzin on 02/05/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var commentTextView: UITextView!
    
    private let service: MidomService
    private let crId: Int
    
    init(midomService: MidomService, crId: Int) {
        self.service = midomService
        self.crId = crId
        super.init(nibName: "ComposeViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Comment"
        
        commentTextView.becomeFirstResponder()
    }
    
    func update(errorMessage: String) {
        self.view.makeToast(errorMessage)
    }
    
    @IBAction func sendCommentButtonClicked(_ sender: UIButton) {
        if let comment = commentTextView.text {
            service.sendConsultationComment(id: crId, comment: comment)
        } else {
            self.view.makeToast("Cannot send empty comment")
        }
    }
}

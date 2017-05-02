//
//  AcceptedRequestViewController.swift
//  Midom
//
//  Created by Eugen Druzin on 02/05/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import UIKit

class AcceptedRequestViewController: UIViewController {

    @IBOutlet weak var studyProviderLabel: UILabel!
    @IBOutlet weak var studyNameLabel: UILabel!
    @IBOutlet weak var commentLable: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!

    private let service: MidomService
    private let crId: Int
    
    private var consulationRequest: ConsultationRequest?
    private var study: Study?
    private var account: AccountDetails?
    
    internal let identifier = String(describing: AcceptedRequestCollectionViewCell.self)
    
    init(midomService: MidomService, crId: Int) {
        self.service = midomService
        self.crId = crId
        super.init(nibName: "AcceptedRequestViewController", bundle: nil)
        setInitialVariables()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        configureCollectionView()
    }
    
    private func setInitialVariables() {
        consulationRequest = service.consultationRequests?.first(where: { $0.id == crId })
        study = consulationRequest?.studyObj
        account = service.accounts.first(where: { $0.id == study?.ownerId })
    }
    
    private func setupNavigationBar() {
        self.title = "Consultation Request Data"
        let rightButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                              target: self, action: #selector(composeBarButtonClicked))
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    private func configureCollectionView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(
            UINib(nibName: identifier, bundle: nil),
            forCellWithReuseIdentifier: identifier)
    }
    
    @objc private func composeBarButtonClicked() {
        
    }
}

extension AcceptedRequestViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: open full screen image
    }
}

extension AcceptedRequestViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
            as! AcceptedRequestCollectionViewCell
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // TODO: calculate number of photos
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: calculate number of photos
        return 3
    }
}

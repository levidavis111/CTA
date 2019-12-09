//
//  EventFavoriteViewController.swift
//  6.1-cta
//
//  Created by Levi Davis on 12/2/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import UIKit

class EventFavoriteViewController: UIViewController {
    
    //    MARK: - Local Variables
    
    var favoriteEvents = [FavoriteEvent]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    //    MARK: - UI Elements
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FavoriteEventTableViewCell.self, forCellReuseIdentifier: ReuseIdentifier.favoriteEventCell.rawValue)
        return tableView
    }()
    
    //    MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        addSubviews()
        constrainSubviews()
        setupNavItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFavoritesFromFireBase()
    }
    
    //    MARK: Private Functions
    
    private func setDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupNavItems() {
        navigationItem.title = "Fave Events"
    }
    
    private func getFavoritesFromFireBase() {
        guard let user = FirebaseAuthService.manager.currentUser else {return}
        FirestoreService.manager.getEvents(forUserID: user.uid) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let events):
                self.favoriteEvents = events
            }
        }
    }
    
    //    MARK: - Setup UI
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func constrainSubviews() {
        constrainTableView()
    }
    
    private func constrainTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        [tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
         tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
         tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)].forEach{$0.isActive = true}
    }
    
}

extension EventFavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.favoriteEventCell.rawValue, for: indexPath) as? FavoriteEventTableViewCell else {return UITableViewCell()}
        let oneEvent = favoriteEvents[indexPath.row]
        
        ImageManager.manager.getImage(urlStr: oneEvent.photoURL) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let image):
                    cell.eventImageView.image = image
                }
            }
        }
        cell.delegate = self
        cell.nameLabel.text = oneEvent.name
        cell.timeLabel.text = "Event saved \(oneEvent.dateCreated!)"
        cell.faveButton.tag = indexPath.row
        return cell
    }
    
    
}

extension EventFavoriteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension EventFavoriteViewController: EventCellDelegate {
    func faveEvent(tag: Int) {
        guard let user = FirebaseAuthService.manager.currentUser else {return}
        let eventToDelete = favoriteEvents[tag]
        
        FirestoreService.manager.deleteFavoriteEvent(forUserID: user.uid, eventID: eventToDelete.id) { (result) in
            switch result {
            case .failure(let error):
                print("Error deleting event: \(error)")
            case .success():
                print("We deleted that sucka")
                //                self.favoriteEvents.remove(at: tag)
                self.getFavoritesFromFireBase()
                self.tableView.reloadData()
            }
        }
    }
    
}

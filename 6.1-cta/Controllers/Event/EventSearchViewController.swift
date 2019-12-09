//
//  EventSearchViewController.swift
//  6.1-cta
//
//  Created by Levi Davis on 12/2/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import UIKit

class EventSearchViewController: UIViewController {
    
    //    MARK: - Local Variables
    
    var events = [EventElement]() {
        didSet {
            eventTableView.reloadData()
        }
    }
    
    var search = "Chicago"
    
    //    MARK: UI Elements
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    lazy var eventTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EventsTableViewCell.self, forCellReuseIdentifier: ReuseIdentifier.eventCell.rawValue)
        return tableView
    }()
    
    //    MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setDelegates()
        setupNavItems()
        addSubviews()
        constrainSubviews()
        loadEventData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    //    MARK: - Objc Functions
    
    @objc private func logout() {
        FirebaseAuthService.manager.logoutUser()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
            else {return}
        window.rootViewController = LoginViewController()
    }
    
    @objc private func showFaveButtonPressed() {
        let faveEventVC = EventFavoriteViewController()
        navigationController?.pushViewController(faveEventVC, animated: true)
    }
    
    //    MARK: - Private Functions
    
    private func setupNavItems() {
        let rightButton = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(logout))
        let leftButton = UIBarButtonItem(title: "faves", style: .plain, target: self, action: #selector(showFaveButtonPressed))
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.title = "Events"
    }
    
    private func loadEventData() {
        TicketMasterAPIClient.manager.getEventElements(city: search) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let events):
                self.events = events
            }
        }
    }
    
    //    MARK: - Setup UI
    
    private func setDelegates() {
        self.eventTableView.dataSource = self
        self.eventTableView.delegate = self
        self.searchBar.delegate = self
    }
    
    private func addSubviews() {
        view.addSubview(searchBar)
        view.addSubview(eventTableView)
    }
    
    private func constrainSubviews() {
        constrainSearchBar()
        constrainTableView()
    }
    
    private func constrainSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        [searchBar.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
         searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)].forEach{$0.isActive = true}
    }
    
    private func constrainTableView() {
        eventTableView.translatesAutoresizingMaskIntoConstraints = false
        [eventTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
         eventTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
         eventTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         eventTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)].forEach{$0.isActive = true}
    }
}

extension EventSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.eventCell.rawValue, for: indexPath) as? EventsTableViewCell else {return UITableViewCell()}
        let oneEvent = events[indexPath.row]
        
        ImageManager.manager.getImage(urlStr: oneEvent.images[0].url) { (result) in
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
        cell.timeLabel.text = "Starts: \(oneEvent.dates.start.localTime)"
        cell.faveButton.tag = indexPath.row
        
        let existsInFaves = oneEvent.existsInFavorites { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let bool):
                switch bool {
                case true:
                    cell.faveButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                case false:
                    cell.faveButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    
                }
            }
        }
        
        return cell
    }
    
    
}

extension EventSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let oneEvent = events[indexPath.row]
        let eventDetailVC = EventDetailViewController()
        eventDetailVC.event = oneEvent
        self.navigationController?.pushViewController(eventDetailVC, animated: true)
    }
}

extension EventSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            self.search = searchText
            loadEventData()
        } else {
            return
        }
        
        
    }
}

extension EventSearchViewController: EventCellDelegate {
    func faveEvent(tag: Int) {
        
        let oneEvent = events[tag]
        
        guard let user = FirebaseAuthService.manager.currentUser else {return}
        
        let existsInFaves = oneEvent.existsInFavorites { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let bool):
                switch bool {
                case true:
                    FirestoreService.manager.deleteFavoriteEvent(forUserID: user.uid, eventID: oneEvent.id) { (result) in
                        switch result {
                        case .failure(let error):
                            print(error)
                        case .success(()):
                            print("Deleted from Search Cell")
                        }
                    }
                case false:
                    
                    let favedEvent = FavoriteEvent(name: oneEvent.name, photoURL: oneEvent.images[0].url, id: oneEvent.id, creatorID: user.uid)
                    FirestoreService.manager.saveEvent(event: favedEvent) { (result) in
                        switch result {
                        case .failure(let error):
                            print(error)
                        case .success():
                            print("You saved it from the Search Cell")
                        }
                    }
                    
                }
            }
        }
        
    }
    
    
}

//
//  ArtFavoriteViewController.swift
//  6.1-cta
//
//  Created by Levi Davis on 12/2/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import UIKit

class ArtFavoriteViewController: UIViewController {
    
    //    MARK: - Local Variables
    
    var favoriteArts = [FavoriteArt]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    //    MARK: - UI Elements
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FavoriteArtTableViewCell.self, forCellReuseIdentifier: ReuseIdentifier.favoriteArtCell.rawValue)
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
    
    //    MARK: - Private Fucntions
    
    private func setDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupNavItems() {
        navigationItem.title = "Fave Arts"
    }
    
    private func getFavoritesFromFireBase() {
        guard let user = FirebaseAuthService.manager.currentUser else {return}
        FirestoreService.manager.getArts(forUserID: user.uid) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let arts):
                self.favoriteArts = arts
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

extension ArtFavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteArts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.favoriteArtCell.rawValue, for: indexPath) as? FavoriteArtTableViewCell else {return UITableViewCell()}
        let oneArt = favoriteArts[indexPath.row]
        
        ImageManager.manager.getImage(urlStr: oneArt.photoURL) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let image):
                    cell.artImageView.image = image
                }
            }
        }
        cell.delegate = self
        cell.nameLabel.text = oneArt.principalOrFirstMaker
        cell.timeLabel.text = oneArt.longTitle
        cell.faveButton.tag = indexPath.row
        return cell
    }
    
}

extension ArtFavoriteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension ArtFavoriteViewController: EventCellDelegate {
    func faveEvent(tag: Int) {
        guard let user = FirebaseAuthService.manager.currentUser else {return}
        let artToDelete = favoriteArts[tag]
        
        FirestoreService.manager.deleteFavoriteArt(forUserID: user.uid, artID: artToDelete.id) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(()):
                print("You deleted that sucka from the favorite cell")
                self.getFavoritesFromFireBase()
                self.tableView.reloadData()
            }
        }
        
    }
    
}

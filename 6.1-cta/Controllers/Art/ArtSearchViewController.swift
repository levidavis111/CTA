//
//  ArtSearchViewController.swift
//  6.1-cta
//
//  Created by Levi Davis on 12/2/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import UIKit

class ArtSearchViewController: UIViewController {
    
    //    MARK: - Local Variable
    
    var arts = [ArtObject]() {
        didSet {
            artTableView.reloadData()
        }
    }
    
    var search = "Rembrandt"
    
    //    MARK: - UI Elements
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        
        return searchBar
    }()
    
    lazy var artTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ArtTableViewCell.self, forCellReuseIdentifier: ReuseIdentifier.artCell.rawValue)
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
        loadArtData()
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
        let artFaveVC = ArtFavoriteViewController()
        navigationController?.pushViewController(artFaveVC, animated: true)
    }
    
    //    MARK: - Private Functions
    
    private func setupNavItems() {
        let rightButton = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(logout))
        let leftButton = UIBarButtonItem(title: "faves", style: .plain, target: self, action: #selector(showFaveButtonPressed))
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.title = "Art Stuff"
    }
    
    private func loadArtData() {
        MuseumAPIClient.manager.getArtObjects(keyWord: search) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let arts):
                self.arts = arts
            }
        }
    }
    
    private func setDelegates() {
        self.artTableView.dataSource = self
        self.artTableView.delegate = self
        self.searchBar.delegate = self
    }
    
    //    MARK: - Setup UI
    
    private func addSubviews() {
        view.addSubview(searchBar)
        view.addSubview(artTableView)
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
        artTableView.translatesAutoresizingMaskIntoConstraints = false
        [artTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
         artTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
         artTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         artTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)].forEach{$0.isActive = true}
    }
}

extension ArtSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.artCell.rawValue, for: indexPath) as? ArtTableViewCell else {return UITableViewCell()}
        let oneArt = arts[indexPath.row]
        
        let existsInFaves = oneArt.existsInFavorites { (result) in
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
        
        if let artImageURL = oneArt.webImage?.url {
            ImageManager.manager.getImage(urlStr: artImageURL) { (result) in
                
                DispatchQueue.main.async {
                    
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let image):
                        cell.artImageView.image = image
                        
                    }
                }
            }
        }
        cell.delegate = self
        
        return cell
    }
    
    
}

extension ArtSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let oneArt = arts[indexPath.row]
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let artDetailVC = storyBoard.instantiateViewController(withIdentifier: "ArtDetailViewController") as! ArtDetailViewController
        artDetailVC.art = oneArt
        self.navigationController?.pushViewController(artDetailVC, animated: true)
        
    }
}

extension ArtSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            self.search = searchText
            loadArtData()
        } else {
            return
        }
        
        
    }
}

extension ArtSearchViewController: EventCellDelegate {
    func faveEvent(tag: Int) {
        let oneArt = arts[tag]
        guard let user = FirebaseAuthService.manager.currentUser else {return}
        print("oneArt")
        let existsInFaves = oneArt.existsInFavorites { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let bool):
                switch bool {
                case true:
                    FirestoreService.manager.deleteFavoriteArt(forUserID: user.uid, artID: oneArt.id) { (result) in
                        switch result {
                        case .failure(let error):
                            print(error)
                        case .success(()):
                            
                            print("You deleted that art from the search cell")
                        }
                    }
                case false:
                    
                    let favedArt = FavoriteArt(title: oneArt.title, longTitle: oneArt.longTitle, principalOrFirstMaker: oneArt.principalOrFirstMaker, photoURL: oneArt.webImage?.url ?? "", id: oneArt.id, creatorID: user.uid)
                    
                    FirestoreService.manager.saveArt(art: favedArt) { (result) in
                        switch result {
                        case .failure(let error):
                            print(error)
                        case .success(()):
                            print("You saved that art from the search vc cell")
                        }
                    }
                }
            }
        }
        
    }
    
}

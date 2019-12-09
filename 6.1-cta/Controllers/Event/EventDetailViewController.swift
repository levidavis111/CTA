//
//  EventDetailViewController.swift
//  6.1-cta
//
//  Created by Levi Davis on 12/2/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    //    MARK: - Local Variables
    
    var event: EventElement!
    
    //    MARK: - UI Elements
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var introLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Main Info"
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "\(event.name)\n Starts: \(event.dates.start.localTime) local time"
        return label
    }()
    
    lazy var faveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.addTarget(self, action: #selector(faveButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var segueButton: UIButton = {
        let button = UIButton()
        button.setTitle("See Favorites", for: .normal)
        button.addTarget(self, action: #selector(seeFavoritesButtonPressed), for: .touchUpInside)
        return button
    }()
    
    //    MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        addSubviews()
        constrainSubviews()
        setImageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setButtonImage()
    }
    
    //    MARK: - Objc Functions
    
    @objc private func faveButtonPressed() {
        
        let existsInFaves = event.existsInFavorites { (result) in
            switch result {
            case .success(let bool):
                switch bool {
                case true:
                    print("Exists in faves")
                    self.deleteFavoriteEvent()
                    self.setButtonImage()
                case false:
                    print("Does not exist in faves")
                    self.addFavoriteEvent()
                    self.setButtonImage()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc private func seeFavoritesButtonPressed() {
        let faveEventVC = EventFavoriteViewController()
        navigationController?.pushViewController(faveEventVC, animated: true)
    }
    
    //    MARK: - Private Functions
    
    private func setButtonImage() {
        let existsInFaves = event.existsInFavorites { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let bool):
                switch bool {
                case true:
                    self.faveButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                case false:
                    self.faveButton.setImage(UIImage(systemName: "heart"), for: .normal)
                }
            }
        }
        
    }
    
    private func addFavoriteEvent() {
        guard let user = FirebaseAuthService.manager.currentUser else {return}
        let favedEvent = FavoriteEvent(name: event.name, photoURL: event.images[0].url, id: event.id, creatorID: user.uid)
        FirestoreService.manager.saveEvent(event: favedEvent) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success():
                self.showAlert(with: "Posted!", and: "Yay!")
            }
        }
    }
    
    private func deleteFavoriteEvent() {
        guard let user = FirebaseAuthService.manager.currentUser else {return}
        
        FirestoreService.manager.deleteFavoriteEvent(forUserID: user.uid, eventID: event.id) { (result) in
            switch result {
            case .failure(let error):
                print("Error deleting event: \(error)")
            case .success():
                print("We deleted that sucka")
            }
        }
    }
    
    private func showAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func setImageView() {
        let imageURL = event.images[0].url
        ImageManager.manager.getImage(urlStr: imageURL) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let image):
                    self.imageView.image = image
                }
            }
        }
    }
    
    //    MARK: Setup UI
    
    private func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(infoLabel)
        view.addSubview(introLabel)
        view.addSubview(faveButton)
        view.addSubview(segueButton)
    }
    
    private func constrainSubviews() {
        constrainImageView()
        constrainInfoLabel()
        constrainIntroLabel()
        constrainFaveButton()
        constrainSegueButton()
    }
    
    private func constrainImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        [imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
         imageView.heightAnchor.constraint(equalToConstant: 200),
         imageView.widthAnchor.constraint(equalToConstant: 250)].forEach{$0.isActive = true}
    }
    
    private func constrainIntroLabel() {
        introLabel.translatesAutoresizingMaskIntoConstraints = false
        [introLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         introLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)].forEach{$0.isActive = true}
    }
    
    private func constrainInfoLabel() {
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        [infoLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         infoLabel.topAnchor.constraint(equalTo: introLabel.bottomAnchor, constant: 20)].forEach{$0.isActive = true}
    }
    
    private func constrainFaveButton() {
        faveButton.translatesAutoresizingMaskIntoConstraints = false
        [faveButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2),
         faveButton.bottomAnchor.constraint(equalTo: infoLabel.topAnchor, constant: 2),
         faveButton.leadingAnchor.constraint(equalTo: introLabel.trailingAnchor, constant: 2)].forEach{$0.isActive = true}
    }
    
    private func constrainSegueButton() {
        segueButton.translatesAutoresizingMaskIntoConstraints = false
        [segueButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 30),
         segueButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)].forEach{$0.isActive = true}
    }
    
}

//
//  ArtDetailViewController.swift
//  6.1-cta
//
//  Created by Levi Davis on 12/2/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import UIKit

class ArtDetailViewController: UIViewController {
    
    //    MARK: - Local Variables
    
    var art: ArtObject!
    
    //    MARK: - IB Outlets
    
    @IBOutlet weak var artDetailImageView: UIImageView!
    @IBOutlet weak var mainInfoLabel: UILabel!
    @IBOutlet weak var moreInfoLabel: UILabel!
    @IBOutlet weak var faveButtonOutlet: UIButton!
    
    //    MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        setImageView()
        setMoreInfoLabelText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setButtonImage()
    }
    
    //    MARK: - IB Actions
    
    @IBAction func faveButtonPressed(_ sender: UIButton) {
        let existsInFaves = art.existsInFavorites { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let bool):
                switch bool {
                case true:
                    self.deleteFavoriteArt()
                    self.setButtonImage()
                case false:
                    self.addFavoriteArt()
                    self.setButtonImage()
                }
            }
        }
        
    }
    
    
    @IBAction func seeFavoritesButtonPressed(_ sender: UIButton) {
        let artEventVC = ArtFavoriteViewController()
        navigationController?.pushViewController(artEventVC, animated: true)
    }
    
    
    //    MARK: - Private Functions
    
    private func setButtonImage() {
        let existsInFaves = art.existsInFavorites { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let bool):
                switch bool {
                case true:
                    self.faveButtonOutlet.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                case false:
                    self.faveButtonOutlet.setImage(UIImage(systemName: "heart"), for: .normal)
                }
            }
        }
    }
    
    private func setMoreInfoLabelText() {
        moreInfoLabel.text = "\(art.principalOrFirstMaker)\n\(art.longTitle)"
    }
    
    private func addFavoriteArt() {
        guard let user = FirebaseAuthService.manager.currentUser else {return}
        let favedArt = FavoriteArt(title: art.title, longTitle: art.longTitle, principalOrFirstMaker: art.principalOrFirstMaker, photoURL: art.webImage?.url ?? "", id: art.id, creatorID: user.uid)
        
        FirestoreService.manager.saveArt(art: favedArt) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(()):
                self.showAlert(with: "Posted!", and: "Yay!")
            }
        }
        
    }
    
    private func deleteFavoriteArt() {
        guard let user = FirebaseAuthService.manager.currentUser else {return}
        
        FirestoreService.manager.deleteFavoriteArt(forUserID: user.uid, artID: art.id) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(()):
                print("You deleted that sucka from the cell")
            }
        }
        
    }
    
    private func showAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func setImageView() {
        
        if let imageURL = art.webImage?.url {
            ImageManager.manager.getImage(urlStr: imageURL) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let image):
                        print("hi")
                        self.artDetailImageView.image = image
                    }
                }
            }
        } else {
            self.artDetailImageView.image = UIImage(named: "default")
        }
    }
    
    
}

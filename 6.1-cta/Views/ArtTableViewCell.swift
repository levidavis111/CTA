//
//  ArtTableViewCell.swift
//  6.1-cta
//
//  Created by Levi Davis on 12/3/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import UIKit

class ArtTableViewCell: UITableViewCell {
    
    //  MARK: - Local Variables
    
    weak var delegate: EventCellDelegate?
    
//    MARK: - UI Elements
    
    lazy var artistLabel: UILabel = {
        let nameLabel = UILabel()
        return nameLabel
    }()
    
    lazy var detailLabel: UILabel = {
        let timeLabel = UILabel()
        return timeLabel
    }()
    
    lazy var artImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var faveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.addTarget(self, action: #selector(faveButtonPressed), for: .touchUpInside)
        return button
    }()
    
//    MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setConstrains()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Objc Functions
    
    @objc private func faveButtonPressed(sender: UIButton!) {
        delegate?.faveEvent(tag: sender.tag)
        if faveButton.image(for: .normal) == UIImage(systemName: "heart") {
            faveButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            faveButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
//    MARK: - Setup UI
    
    private func addSubviews() {
        addSubview(artistLabel)
        addSubview(detailLabel)
        addSubview(artImageView)
        addSubview(faveButton)
    }
    
    private func setConstrains() {
        constrainNameLabel()
        constrainTimeLabel()
        constrainImageView()
        constrainFaveButton()
    }
    
    private func constrainNameLabel() {
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        [artistLabel.leadingAnchor.constraint(equalTo: artImageView.trailingAnchor, constant: 5),
         artistLabel.trailingAnchor.constraint(equalTo: faveButton.leadingAnchor, constant: -5),
         artistLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -20)].forEach{$0.isActive = true}
    }
    
    private func constrainTimeLabel() {
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        [detailLabel.leadingAnchor.constraint(equalTo: artImageView.trailingAnchor, constant: 5),
         detailLabel.trailingAnchor.constraint(equalTo: faveButton.leadingAnchor, constant: -5),
         detailLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 20)].forEach{$0.isActive = true}
    }
    
    private func constrainImageView() {
        artImageView.translatesAutoresizingMaskIntoConstraints = false
        [artImageView.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
         artImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
         artImageView.heightAnchor.constraint(equalToConstant: 125),
         artImageView.widthAnchor.constraint(equalToConstant: 175)].forEach{$0.isActive = true}
    }
    
    private func constrainFaveButton() {
        faveButton.translatesAutoresizingMaskIntoConstraints = false
        [faveButton.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
         faveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
         faveButton.heightAnchor.constraint(equalToConstant: 20),
         faveButton.widthAnchor.constraint(equalToConstant: 20)].forEach{$0.isActive = true}
    }
    
    
}

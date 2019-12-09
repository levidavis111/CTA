//
//  EventsTableViewCell.swift
//  6.1-cta
//
//  Created by Levi Davis on 12/2/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    
//    MARK: - Local Variable
    
    weak var delegate: EventCellDelegate?
    
//    MARK: - UI Elements
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        return nameLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        return timeLabel
    }()
    
    lazy var eventImageView: UIImageView = {
        let imageView = UIImageView()
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
    
//    MARK: - UI Setup
    
    private func addSubviews() {
        addSubview(nameLabel)
        addSubview(timeLabel)
        addSubview(eventImageView)
        addSubview(faveButton)
    }
    
    private func setConstrains() {
        constrainNameLabel()
        constrainTimeLabel()
        constrainImageView()
        constrainFaveButton()
    }
    
    private func constrainNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        [nameLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 5),
         nameLabel.trailingAnchor.constraint(equalTo: faveButton.leadingAnchor, constant: -5),
         nameLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -20)].forEach{$0.isActive = true}
    }
    
    private func constrainTimeLabel() {
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        [timeLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 5),
         timeLabel.trailingAnchor.constraint(equalTo: faveButton.leadingAnchor, constant: -5),
         timeLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 20)].forEach{$0.isActive = true}
    }
    
    private func constrainImageView() {
        eventImageView.translatesAutoresizingMaskIntoConstraints = false
        [eventImageView.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
         eventImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
         eventImageView.heightAnchor.constraint(equalToConstant: 125),
         eventImageView.widthAnchor.constraint(equalToConstant: 175)].forEach{$0.isActive = true}
    }
    
    private func constrainFaveButton() {
        faveButton.translatesAutoresizingMaskIntoConstraints = false
        [faveButton.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
         faveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
         faveButton.heightAnchor.constraint(equalToConstant: 20),
         faveButton.widthAnchor.constraint(equalToConstant: 20)].forEach{$0.isActive = true}
    }
    
}

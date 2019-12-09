//
//  Protocol.swift
//  6.1-cta
//
//  Created by Levi Davis on 12/3/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import Foundation

protocol EventCellDelegate: AnyObject {
    func faveEvent(tag: Int)
}

protocol EventDelegate: AnyObject {
    func callActionSheet(tag: Int)
}

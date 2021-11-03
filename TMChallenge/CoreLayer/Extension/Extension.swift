//
//  Extension.swift
//  TMChallenge
//
//  Created by Jose Galindo Martinez on 03/11/21.
//

import Foundation
import UIKit

protocol ReuseIdentifiable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String { .init(describing: self) }
}

extension UITableViewCell: ReuseIdentifiable {}

//
//  BookListCell.swift
//  drewslist
//
//  Created by Andrew Aquino on 8/27/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
  func registerBookListCell() {
    register(BookListCell.self, forCellReuseIdentifier: BookListCell.identifier)
  }
}

class BookListCell: BasicTableViewCell {
  static let identifier = "BookListCell"
  var book: Book?
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  override func setup() {
    addSubview(titleLabel)
    titleLabel.fillSuperview()
  }
  func update(with book: Book?) {
    self.book = book
    titleLabel.text = book?.title
  }
}

extension UITableViewCell {
  static func bookListCell(at indexPath: IndexPath, using tableView: UITableView) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: BookListCell.identifier, for: indexPath) as? BookListCell {
      return cell
    }
    return .empty
  }
}

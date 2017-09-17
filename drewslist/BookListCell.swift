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
  static var width: CGFloat {
    return screen.width
  }
  static var height: CGFloat {
    return screen.width
  }
  static let identifier = "BookListCell"
  let bookImageView = UIImageView()
  let gradientView = UIView()
  let gradient = CAGradientLayer()
  let titleLabel = DLLabel().set(style: .title)
  let authorLabel = DLLabel().set(style: .body)
  let isbnLabel = DLLabel().set(style: .subtitle)
  let distanceLabel = DLLabel().set(style: .subtitle)
  let callButton = BasicButton()
  override func setup() {
    super.setup()
    backgroundColor = .clear
    // book image view
    addSubview(bookImageView)
    bookImageView.fillSuperview()
    // gradient
    gradient.colors = [
      UIColor.black.withAlphaComponent(0.9).cgColor,
      UIColor.clear.cgColor
    ]
    gradient.locations = [0.0, 1.0]
    gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
    gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
    gradientView.layer.insertSublayer(gradient, at: 0)
    addSubview(gradientView)
    gradientView.fillSuperview()
    gradient.frame = CGRect(x: 0, y: 0, width: screen.width, height: screen.width)
    // phone number
    callButton.setImage(#imageLiteral(resourceName: "call-light"), for: .normal)
    callButton.didTapHandler = {
      
    }
    addSubview(callButton)
    callButton
    .anchor(.bottom, padding: 12)
    .anchor(.right, padding: 10)
    .width(48)
    .height(48)
    // isbn
    addSubview(isbnLabel)
    isbnLabel
    .anchor(.bottom, .left, padding: 10)
    .anchor(.left, of: callButton, padding: 10)
    .height(20)
    // title
    addSubview(titleLabel)
    titleLabel
    .anchor(.top, of: isbnLabel, padding: 0, matching: .width)
    .height(44) { [weak self] (constraint) in
      self?.titleLabel.heightConstraint = constraint
    }
    // author
    addSubview(authorLabel)
    authorLabel
    .anchor(.top, of: titleLabel, padding: 0, matching: .width)
    .height(44) { [weak self] (constraint) in
      self?.authorLabel.heightConstraint = constraint
    }
    // distance
    addSubview(distanceLabel)
    distanceLabel
    .anchor(.top, of: authorLabel, padding: 0, matching: .width)
    .height(20)
  }
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  func update(with listing: Listing?) {
    guard let listing = listing, let book = listing.book else { return }
    if let imageURL = listing.media.first?.imageURL?.urlValue {
      bookImageView.sd_setImage(with: imageURL, completed: nil)
    }
    titleLabel.text = book.title
    authorLabel.text = book.author
    if let isbn = book.isbn {
      isbnLabel.text = "ISBN: \(isbn)"
    }
    if let distance = listing.distance {
      distanceLabel.text = distance.description + (distance > 1 ? " miles" : " mile")
    }
  }
}

extension UITableViewCell {
  static func bookListCell(_ listings: [Listing], at indexPath: IndexPath, using tableView: UITableView) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: BookListCell.identifier, for: indexPath) as? BookListCell {
      cell.update(with: listings[indexPath.row])
      return cell
    }
    return .empty
  }
}

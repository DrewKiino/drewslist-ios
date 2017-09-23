//
//  BookListCell.swift
//  drewslist
//
//  Created by Andrew Aquino on 8/27/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import UIKit
import ImageViewer
import Pantry

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
    return 300
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
  var listing: Listing?
  override func setup() {
    super.setup()
    backgroundColor = .clear
    // book image view
    bookImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTapped)))
    bookImageView.isUserInteractionEnabled = true
    addSubview(bookImageView)
    bookImageView.fillSuperview()
    // gradient
    gradient.colors = [
      UIColor.black.withAlphaComponent(0.95).cgColor,
      UIColor.clear.cgColor
    ]
    gradient.locations = [-0.5, 0.9]
    gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
    gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
    gradientView.isUserInteractionEnabled = false
    gradientView.layer.insertSublayer(gradient, at: 0)
    gradientView.isHidden = true
    addSubview(gradientView)
    gradientView.fillSuperview()
    gradient.frame = CGRect(x: 0, y: 0, width: BookListCell.width, height: BookListCell.height)
    // phone number
    callButton.setImage(#imageLiteral(resourceName: "call-light").withRenderingMode(.alwaysTemplate), for: .normal)
    callButton.imageView?.tintColor = didWatchAd ? .dlBlue : .white
    callButton.didTapHandler = { [weak self] in
      self?.showContactNumber()
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
    titleLabel.numberOfLines = 3
    addSubview(titleLabel)
    titleLabel
    .anchor(.top, of: isbnLabel, padding: 0, matching: .width)
    .autoresize(height: 44, max: BookListCell.height * 0.6)
    // author
    authorLabel.numberOfLines = 2
    addSubview(authorLabel)
    authorLabel
    .anchor(.top, of: titleLabel, padding: 0, matching: .width)
    .autoresize(height: 44, max: BookListCell.height * 0.2)
    // distance
    addSubview(distanceLabel)
    distanceLabel
    .anchor(.top, of: authorLabel, padding: 0, matching: .width)
    .height(20)
  }
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  override func prepareForReuse() {
    super.prepareForReuse()
    bookImageView.image = nil
  }
  func update(with listing: Listing?) {
    guard let listing = listing, let book = listing.book else { return }
    self.listing = listing
    if let imageURL = listing.media.first?.imageURL?.urlValue {
      bookImageView.set(imageFromURL: imageURL) { [weak self] image in
        self?.gradientView.isHidden = false
      }
    }
    titleLabel.text = book.title
    authorLabel.text = "Harry Boylan, Devy Manos, and Divvy Guatamalan"
    authorLabel.text = book.author
    if let isbn = book.isbn {
      isbnLabel.text = "ISBN: \(isbn)"
    }
    if let distance = listing.distance {
      distanceLabel.text = distance.description + (distance > 1 ? " miles" : " mile")
    }
    callButton.imageView?.tintColor = didWatchAd ? .dlBlue : .white
  }
  func imageTapped() {
    let vc = BookListViewController.shared
    let configuration: GalleryConfiguration = [
      GalleryConfigurationItem.closeButtonMode(.builtIn),
      GalleryConfigurationItem.pagingMode(.carousel),
      GalleryConfigurationItem.presentationStyle(.fade),
      GalleryConfigurationItem.hideDecorationViewsOnLaunch(true),
      GalleryConfigurationItem.swipeToDismissMode(.vertical),
      GalleryConfigurationItem.toggleDecorationViewsBySingleTap(false),
      GalleryConfigurationItem.overlayColor(UIColor.black),
      GalleryConfigurationItem.overlayColorOpacity(1),
      GalleryConfigurationItem.overlayBlurOpacity(1),
      GalleryConfigurationItem.overlayBlurStyle(.light),
      GalleryConfigurationItem.videoControlsColor(.white),
      GalleryConfigurationItem.maximumZoomScale(8),
      GalleryConfigurationItem.swipeToDismissThresholdVelocity(500),
      GalleryConfigurationItem.doubleTapToZoomDuration(0.15),
      GalleryConfigurationItem.blurPresentDuration(0.5),
      GalleryConfigurationItem.blurPresentDelay(0),
      GalleryConfigurationItem.colorPresentDuration(0.25),
      GalleryConfigurationItem.colorPresentDelay(0),
      GalleryConfigurationItem.blurDismissDuration(0.1),
      GalleryConfigurationItem.blurDismissDelay(0.4),
      GalleryConfigurationItem.colorDismissDuration(0.45),
      GalleryConfigurationItem.colorDismissDelay(0),
      GalleryConfigurationItem.itemFadeDuration(0.3),
      GalleryConfigurationItem.decorationViewsFadeDuration(0.15),
      GalleryConfigurationItem.rotationDuration(0.15),
      GalleryConfigurationItem.displacementDuration(0.55),
      GalleryConfigurationItem.reverseDisplacementDuration(0.25),
      GalleryConfigurationItem.displacementTransitionStyle(.springBounce(0.7)),
      GalleryConfigurationItem.displacementTimingCurve(.linear),
      GalleryConfigurationItem.statusBarHidden(true),
      GalleryConfigurationItem.displacementKeepOriginalInPlace(false),
      GalleryConfigurationItem.displacementInsetMargin(50)
    ]
    let galleryVC = GalleryViewController(startIndex: 0, itemsDataSource: self, configuration: configuration)
    galleryVC.swipedToDismissCompletion = {
      HeaderView.shared.show()
    }
    HeaderView.shared.hide()
    vc.presentImageGallery(galleryVC)
  }
  // ad stuff
  func showContactNumber() {
    guard let number = listing?.user?.contactNumber else { return }
    let vc = BookListViewController.shared
    if didWatchAd {
      if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
        })
      }
    } else if AdManager.shared.isReadyToShowAds {
      let alertVC = UIAlertController(title: "Lite Version", message: "To view this seller's contact number you must watch an Ad.\n\n* Expires in 24 hours.", preferredStyle: .alert)
      alertVC.addAction(UIAlertAction(title: "Watch Ad", style: .default, handler: { [weak self] (_) in
        self?.watchAd()
      }))
      alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
      }))
      vc.present(alertVC, animated: true, completion: nil)
    } else {
      let alertVC = UIAlertController(title: "Lite Version", message: "Please wait, our ads are currently downloading...", preferredStyle: .alert)
      vc.present(alertVC, animated: true, completion: nil)
      Timer.after(2.0) { [weak alertVC] in
        alertVC?.dismiss(animated: true, completion: nil)
      }
    }
  }
  var didWatchAd: Bool {
    get {
      if let listingID = listing?.id {
        return Pantry.unpack(listingID) ?? false
      }
      return false
    }
    set(new) {
      if let listingID = listing?.id {
        Pantry.pack(new, key: listingID, expires: .seconds(86400))
      }
    }
  }
  func watchAd() {
    HeaderView.shared.hide()
    let vc = BookListViewController.shared
    AdManager.shared.show(withPresenting: vc) { [weak self] (success) in
      HeaderView.shared.show()
      if success {
        self?.didWatchAd = true
        self?.callButton.imageView?.tintColor = .dlBlue
      }
    }
  }
}

extension BookListCell: GalleryItemsDataSource {
  func itemCount() -> Int {
    return listing?.media.count ?? 0
  }
  func provideGalleryItem(_ index: Int) -> GalleryItem {
    return GalleryItem.image(fetchImageBlock: { [weak self] (callback) in
      ImageManager.fetch(imageURL: self?.listing?.media[safe: index]?.imageURL?.urlValue, completionHandler: callback)
    })
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

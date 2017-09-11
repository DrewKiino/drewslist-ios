//
//  ListingViewController.swift
//  drewslist
//
//  Created by Andrew Aquino on 8/31/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

class ListingViewController: BasicViewController {
  
  static let shared = ListingViewController()
  
  let tableView = UITableView(frame: .zero, style: .plain)
  
  var listing: Listing? = Listing()
  
  deinit {
    log.debug("deinit")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    headerView.setLeftButtonText("Cancel")
    headerView.setRightButtonText("Clear")
    headerView.leftButtonTappedHandler = {
    }
    headerView.rightButtonTappedHandler = {
    }
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorColor = .clear
    tableView.allowsSelection = false
    tableView.register(ListImagesCell.self, forCellReuseIdentifier: "ListImagesCell")
    tableView.register(ListTextFieldCell.self, forCellReuseIdentifier: "ListTextFieldCell")
    tableView.register(ListButtonCell.self, forCellReuseIdentifier: "ListButtonCell")
    view.addSubview(tableView)
    tableView.fillSuperview(left: 0, right: 0, top: 44, bottom: 0)
    
    Listing.fetch()
    .then { listings in
      log.debug(listings)
    }
    .catch { log.error($0) }
    
    log.debug(screen.width)
  }
}

extension ListingViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.row {
    case 0:
      return (screen.width / 4) + 20
    case 6:
      return 84
    default:
      return 44
    }
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 7
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      if let cell = tableView.dequeueReusableCell(withIdentifier: "ListImagesCell", for: indexPath) as? ListImagesCell {
        cell.imagePickerButton1.didFinishWithImageHandler = { [weak self, weak cell] image in
          guard let image = image else { return }
          cell?.imagePickerButton1.spinner.startAnimating()
           Media(image: image, index: 0).upload()
          .then { [weak self] media -> () in
            cell?.imagePickerButton1.spinner.stopAnimating()
            if let media = media {
              if let index = self?.listing?.media.index(where: { $0.index == media.index }) {
                self?.listing?.media.remove(at: index)
              }
              self?.listing?.media.append(media)
            }
          }
          .catch { log.error($0) }
        }
        cell.imagePickerButton2.didFinishWithImageHandler = { [weak self, weak cell] image in
          guard let image = image else { return }
          cell?.imagePickerButton2.spinner.startAnimating()
          Media(image: image, index: 1).upload()
          .then { [weak self] media -> () in
            cell?.imagePickerButton2.spinner.stopAnimating()
            if let media = media {
              if let index = self?.listing?.media.index(where: { $0.index == media.index }) {
                self?.listing?.media.remove(at: index)
              }
              self?.listing?.media.append(media)
            }
          }
          .catch { log.error($0) }
        }
        cell.imagePickerButton3.didFinishWithImageHandler = { [weak self, weak cell] image in
          guard let image = image else { return }
          cell?.imagePickerButton3.spinner.startAnimating()
          Media(image: image, index: 2).upload()
          .then { [weak self] media -> () in
            cell?.imagePickerButton3.spinner.stopAnimating()
            if let media = media {
              if let index = self?.listing?.media.index(where: { $0.index == media.index }) {
                self?.listing?.media.remove(at: index)
              }
              self?.listing?.media.append(media)
            }
          }
          .catch { log.error($0) }
        }
        return cell
      }
      break
    case 1:
      if let cell = tableView.dequeueReusableCell(withIdentifier: "ListTextFieldCell", for: indexPath) as? ListTextFieldCell {
        cell.iconImageView.image = #imageLiteral(resourceName: "author")
        cell.textField.placeholder = "Author"
        cell.textField.didChangeTextHandler = { [weak self] text in
          self?.listing?.book?.author = text
        }
        return cell
      }
      break
    case 2:
      if let cell = tableView.dequeueReusableCell(withIdentifier: "ListTextFieldCell", for: indexPath) as? ListTextFieldCell {
        cell.iconImageView.image = #imageLiteral(resourceName: "title")
        cell.textField.placeholder = "Title"
        cell.textField.didChangeTextHandler = { [weak self] text in
          self?.listing?.book?.title = text
        }
        return cell
      }
      break
    case 3:
      if let cell = tableView.dequeueReusableCell(withIdentifier: "ListTextFieldCell", for: indexPath) as? ListTextFieldCell {
        cell.iconImageView.image = #imageLiteral(resourceName: "isbn")
        cell.textField.placeholder = "ISBN"
        cell.textField.shouldBeginEditing = { callback in
          let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
          alert.addAction(UIAlertAction(title: "Scan ISBN", style: .default) { _ in
            cell.textField.alternateTextSelectionHandler = { [weak self] callback in
              HeaderView.shared.hide()
              ISBNManager.presented(with: self) { isbn in
                HeaderView.shared.show()
                callback?(isbn)
              }
            }
            callback?(false)
          })
          alert.addAction(UIAlertAction(title: "Input ISBN", style: .default) { _ in
            callback?(true)
          })
          alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
          })
          self.present(alert, animated: true, completion: nil)
        }
        cell.textField.didChangeTextHandler = { [weak self] text in
          self?.listing?.book?.isbn = text
        }
        return cell
      }
      break
    case 4:
      if let cell = tableView.dequeueReusableCell(withIdentifier: "ListTextFieldCell", for: indexPath) as? ListTextFieldCell {
        cell.iconImageView.image = #imageLiteral(resourceName: "zipcode")
        cell.textField.placeholder = "Zip Code"
        cell.textField.shouldBeginEditing = { callback in
          let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
          alert.addAction(UIAlertAction(title: "User Current Location", style: .default) { _ in
            cell.textField.alternateTextSelectionHandler = { callback in
              LocationManager.shared.zipcode()
              .then { zipcode -> () in
                callback?(zipcode)
              }
              .catch { log.error($0) }
            }
            callback?(false)
          })
          alert.addAction(UIAlertAction(title: "Input Zip Code", style: .default) { _ in
            callback?(true)
          })
          alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
          })
          self.present(alert, animated: true, completion: nil)
        }
        cell.textField.didChangeTextHandler = { [weak self] text in
          LocationManager.shared.location(from: text)
          .then { [weak self] location -> ()in
            self?.listing?.longitude = location?.coordinate.longitude.description.doubleValue
            self?.listing?.latitude = location?.coordinate.latitude.description.doubleValue
            self?.listing?.zipcode = text
          }
          .catch { log.error($0) }
        }
        return cell
      }
      break
    case 5:
      if let cell = tableView.dequeueReusableCell(withIdentifier: "ListTextFieldCell", for: indexPath) as? ListTextFieldCell {
        cell.iconImageView.image = #imageLiteral(resourceName: "call")
        cell.textField.placeholder = "Contact Number"
        cell.textField.didChangeTextHandler = { [weak self] text in
          self?.listing?.contactNumber = text
        }
        return cell
      }
      break
    case 6:
      if let cell = tableView.dequeueReusableCell(withIdentifier: "ListButtonCell", for: indexPath) as? ListButtonCell {
        cell.listButton.setTitle("List Book!", for: .normal)
        cell.listButton.didTapHandler = { [weak self, weak cell] in
          cell?.set(state: .listing)
          log.debug(self?.listing?.toJSON())
          self?.listing?.list() { success in
            cell?.set(state: success ? .success : .failed)
          }
        }
        return cell
      }
      break
    default:
      break
    }
    return .empty
  }
}

class ListImagesCell: BasicTableViewCell {
  
  let imagePickerButton1 = ImagePickerButton()
  let imagePickerButton2 = ImagePickerButton()
  let imagePickerButton3 = ImagePickerButton()
  
  override func setup() {
    addSubview(imagePickerButton1)
    imagePickerButton1.center().size(width: screen.width / 4, height: screen.width / 4)
    addSubview(imagePickerButton2)
    imagePickerButton2.anchor(.left, of: imagePickerButton1, padding: 10, matching: .width, .height)
    addSubview(imagePickerButton3)
    imagePickerButton3.anchor(.right, of: imagePickerButton1, padding: 10, matching: .width, .height)
  }
}

class ListTextFieldCell: BasicTableViewCell {
  let textField = BasicTextField()
  let iconImageView = BasicImageView()
  override func setup() {
    addSubview(iconImageView)
    iconImageView.anchor(.top, .left, padding: 10).size(width: 36, height: 36)
    addSubview(textField)
    textField.anchor(.right, of: iconImageView, padding: 10, matching: .height)
  }
}

class ListButtonCell: BasicTableViewCell {
  let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
  let listButton = BasicButton()
  let topBorder = UIView()
  let bottomBorder = UIView()
  enum State {
    case listing
    case failed
    case success
    case normal
  }
  override func setup() {
    // top border
    topBorder.backgroundColor = .black
    addSubview(topBorder)
    topBorder.anchor(.top, .left, .right, padding: 10).height(0.5)
    // bottom border
    bottomBorder.backgroundColor = .black
    addSubview(bottomBorder)
    bottomBorder.anchor(.bottom, .left, .right, padding: 10).height(0.5)
    // activity indicator
    addSubview(spinner)
    spinner.center(.x, offsetBy: -88).center(.y)
    // list button
    listButton.setTitleColor(.black, for: .normal)
    listButton.titleLabel?.font = .boldSystemFont(ofSize: 30)
    listButton.contentHorizontalAlignment = .center
    addSubview(listButton)
    listButton.fillSuperview(left: 10, right: 10, top: 10, bottom: 10)
  }
  func set(state: State) {
    switch state {
    case .listing:
      spinner.startAnimating()
      listButton.setTitle("Listing...", for: .normal)
      break
    case .failed:
      listButton.setTitle("Failed.", for: .normal)
      Timer.after(3.0) { [weak self] in
        self?.set(state: .normal)
      }
      break
    case .success:
      listButton.setTitle("Success!", for: .normal)
      Timer.after(3.0) { [weak self] in
        self?.set(state: .normal)
      }
      break
    case .normal:
      listButton.setTitle("List Book!", for: .normal)
      spinner.stopAnimating()
      break
    }
  }
}























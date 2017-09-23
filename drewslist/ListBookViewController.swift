//
//  ListBookViewController.swift
//  drewslist
//
//  Created by Andrew Aquino on 8/31/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

class ListBookViewController: DLViewController {
  
  static let shared = ListBookViewController()
  
  let tableView = UITableView(frame: .zero, style: .plain)
  
  var listing: Listing? = Listing()
  var textFields: [Int: BasicTextField] = [:]
  var imagePickers: [Int: ImagePickerButton] = [:]
  
  deinit {
    log.debug("deinit")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorColor = .clear
    tableView.backgroundColor = .clear
    tableView.allowsSelection = false
    tableView.showsVerticalScrollIndicator = false
    tableView.register(ListImagesCell.self, forCellReuseIdentifier: "ListImagesCell")
    tableView.register(ListTextFieldCell.self, forCellReuseIdentifier: "ListTextFieldCell")
    tableView.register(ListButtonCell.self, forCellReuseIdentifier: "ListButtonCell")
    view.addSubview(tableView)
    tableView.fillSuperview(left: 0, right: 0, top: 44, bottom: 0)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    resignFirstResponder()
    
    headerView.leftButtonTappedHandler = {
      RootController.shared.presentBookListVC()
    }
    headerView.rightButtonTappedHandler = { [weak self] in
      self?.clearMetaData()
    }
    headerView.setLeftButtonText("Back")
    headerView.setRightButtonText("Clear")
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillAppear(animated)
    resignFirstResponder()
  }
}

extension ListBookViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.row {
    case 0:
      return (screen.width / 4) + 20
    case 6:
      return 84
    case 7:
      return screen.height / 2 // extra scroll space
    default:
      return 44
    }
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 8
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      if let cell = tableView.dequeueReusableCell(withIdentifier: "ListImagesCell", for: indexPath) as? ListImagesCell {
        cell.imagePickerButton1.didFinishWithImageHandler = { [weak self, weak cell] image in
          guard let image = image else { return }
          cell?.imagePickerButton1.spinner.startAnimating()
          Media(listing: self?.listing, image: image, index: 0).upload()
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
          Media(listing: self?.listing, image: image, index: 1).upload()
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
          Media(listing: self?.listing, image: image, index: 2).upload()
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
        self.imagePickers[0] = cell.imagePickerButton1
        self.imagePickers[1] = cell.imagePickerButton2
        self.imagePickers[2] = cell.imagePickerButton3
        return cell
      }
      break
    case 1:
      if let cell = tableView.dequeueReusableCell(withIdentifier: "ListTextFieldCell", for: indexPath) as? ListTextFieldCell {
        cell.iconImageView.image = #imageLiteral(resourceName: "title")
        cell.textField.placeholderString = "Title"
        cell.textField.didChangeTextHandler = { [weak self] text in
          self?.listing?.book?.title = text
        }
        cell.textField.shouldReturnHandler = { [weak self] in
          self?.selectNextResponder()
          return true
        }
        self.textFields[1] = cell.textField
        return cell
      }
      break
    case 2:
      if let cell = tableView.dequeueReusableCell(withIdentifier: "ListTextFieldCell", for: indexPath) as? ListTextFieldCell {
        cell.iconImageView.image = #imageLiteral(resourceName: "author")
        cell.textField.placeholderString = "Author"
        cell.textField.didChangeTextHandler = { [weak self] text in
          self?.listing?.book?.author = text
        }
        cell.textField.shouldReturnHandler = { [weak self] in
          self?.selectNextResponder()
          return true
        }
        self.textFields[2] = cell.textField
        return cell
      }
      break
    case 3:
      if let cell = tableView.dequeueReusableCell(withIdentifier: "ListTextFieldCell", for: indexPath) as? ListTextFieldCell {
        cell.iconImageView.image = #imageLiteral(resourceName: "isbn")
        cell.textField.placeholderString = "ISBN"
        cell.textField.keyboardType = .numberPad
        cell.textField.shouldBeginEditing = { [weak cell] callback in
          let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
          alert.addAction(UIAlertAction(title: "Scan ISBN", style: .default) { _ in
            cell?.textField.alternateTextSelectionHandler = { [weak self] callback in
              cell?.activityView.startAnimating()
              HeaderView.shared.hide()
              ISBNManager.presented(with: self) { isbn in
                cell?.activityView.stopAnimating()
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
        cell.textField.shouldReturnHandler = { [weak self] in
          self?.selectNextResponder()
          return true
        }
        self.textFields[3] = cell.textField
        return cell
      }
      break
    case 4:
      if let cell = tableView.dequeueReusableCell(withIdentifier: "ListTextFieldCell", for: indexPath) as? ListTextFieldCell {
        cell.iconImageView.image = #imageLiteral(resourceName: "zipcode")
        cell.textField.placeholderString = "Zip Code"
        cell.textField.keyboardType = .numberPad
        cell.textField.shouldBeginEditing = { [weak cell] callback in
          let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
          alert.addAction(UIAlertAction(title: "User Current Location", style: .default) { _ in
            cell?.activityView.startAnimating()
            cell?.textField.alternateTextSelectionHandler = { [weak self] callback in
              cell?.activityView.stopAnimating()
              let address = LocationManager.shared.currentAddress
              self?.listing?.address = address
              callback?(address?.zipcode)
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
          LocationManager.shared.address(from: text)
          .then { [weak self] address -> () in
            log.debug(address?.toJSON())
            self?.listing?.address = address
          }
          .catch { log.error($0) }
        }
        cell.textField.shouldReturnHandler = { [weak self] in
          self?.selectNextResponder()
          return true
        }
        self.textFields[4] = cell.textField
        return cell
      }
      break
    case 5:
      if let cell = tableView.dequeueReusableCell(withIdentifier: "ListTextFieldCell", for: indexPath) as? ListTextFieldCell {
        cell.iconImageView.image = #imageLiteral(resourceName: "call")
        cell.textField.placeholderString = "Contact Number"
        cell.textField.keyboardType = .numberPad
        cell.textField.didChangeTextHandler = { [weak self] text in
          self?.listing?.user?.contactNumber = text
        }
        cell.textField.shouldReturnHandler = { [weak self] in
          self?.selectNextResponder()
          return true
        }
        self.textFields[5] = cell.textField
        return cell
      }
      break
    case 6:
      if let cell = tableView.dequeueReusableCell(withIdentifier: "ListButtonCell", for: indexPath) as? ListButtonCell {
        cell.listButton.setTitle("List Book!", for: .normal)
        cell.listButton.didTapHandler = { [weak self, weak cell] in
          cell?.set(state: .listing)
          self?.listBook() { success in
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
  func listBook(completionHandler: @escaping ((Bool) -> ())) {
    if (listing?.media.first(where: { $0.imageURL != nil })) == nil {
      presentAlert(message: "Please upload at least one image of your book!")
      completionHandler(false)
    } else if (listing?.book?.title ?? "").isEmpty {
      presentAlert(message: "Please input your book's title!")
      completionHandler(false)
    } else if (listing?.book?.author ?? "").isEmpty {
      presentAlert(message: "Please input your book's author!")
      completionHandler(false)
    } else if (listing?.book?.isbn ?? "").isEmpty {
      presentAlert(message: "Please input your ISBN number!")
      completionHandler(false)
    } else if (listing?.address?.zipcode ?? "").isEmpty {
      presentAlert(message: "Please input your zip code!")
      completionHandler(false)
    } else if (listing?.user?.contactNumber ?? "").isEmpty {
      presentAlert(message: "Please input your contact number!")
      completionHandler(false)
    } else {
      listing?.list(completionHandler: { [weak self] (success) in
        self?.clearMetaData()
        self?.presentListSuccessAlert()
        completionHandler(success)
      })
    }
  }
  func clearMetaData() {
    resignFirstResponder()
    for (_, textfield) in self.textFields {
      textfield.text = nil
    }
    for (_, imagePicker) in self.imagePickers {
      imagePicker.deselect()
    }
    self.listing = Listing()
  }
  func presentListSuccessAlert() {
    let alertView = UIAlertController(title: "Successful Listing!", message: "Thank you for using Drew's List.\n\nPlease help share this app since more users means more buyers and sellers!\n\nGood luck with your listing.", preferredStyle: .alert)
    alertView.addAction(UIAlertAction(title: "Share App", style: .default, handler: { [weak self] (_) in
      HeaderView.shared.hide()
      self?.shareApp() {
        HeaderView.shared.show()
      }
    }))
    alertView.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { (_) in
    }))
    present(alertView, animated: true, completion: nil)
  }
  func presentAlert(message: String) {
    let alertView = UIAlertController(title: "Missing Metadata", message: message, preferredStyle: .alert)
    present(alertView, animated: true, completion: nil)
    Timer.after(3.0) { [weak alertView] in
      alertView?.dismiss(animated: true, completion: nil)
    }
  }
  func selectNextResponder() {
    self.textFields
    .sorted(by: { lhs, rhs in lhs.key < rhs.key })
    .first(where: { (index, textField) -> Bool in
      return (textField.text ?? "").isEmpty
    })?.value.becomeFirstResponder()
  }
  func shareApp(completionHandler: @escaping (() -> ())) {
    if let url = URL(string: "https://itunes.apple.com/us/app/drews-list/id1090805496") {
      let activityVC = UIActivityViewController(activityItems: [
        "Drew's List - buying and selling books done right!\n\n",
        url
      ], applicationActivities: nil)
      activityVC.excludedActivityTypes = [
        .airDrop,
        .addToReadingList,
        .assignToContact,
        .openInIBooks,
        .print
      ]
      activityVC.completionWithItemsHandler = { _ in
        completionHandler()
      }
      present(activityVC, animated: true, completion: nil)
    }
  }
}

class ListImagesCell: BasicTableViewCell {
  
  let imagePickerButton1 = ImagePickerButton()
  let imagePickerButton2 = ImagePickerButton()
  let imagePickerButton3 = ImagePickerButton()
  
  override func setup() {
    super.setup()
    
    addSubview(imagePickerButton2)
    imagePickerButton2.center().size(width: screen.width / 4, height: screen.width / 4)
    addSubview(imagePickerButton1)
    imagePickerButton1.anchor(.left, of: imagePickerButton2, padding: 10, matching: .width, .height)
    addSubview(imagePickerButton3)
    imagePickerButton3.anchor(.right, of: imagePickerButton2, padding: 10, matching: .width, .height)
  }
}

class ListTextFieldCell: BasicTableViewCell {
  let textField = BasicTextField()
  let iconImageView = BasicImageView()
  let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
  override func setup() {
    super.setup()
    addSubview(activityView)
    activityView.anchor(.top, .right, .bottom, padding: 10)
    addSubview(iconImageView)
    iconImageView.anchor(.top, .left, padding: 10).size(width: 36, height: 36)
    textField.font = UIFont(name: "AvenirNextCondensed-Light", size: 11)
    addSubview(textField)
    textField.anchor(.right, of: iconImageView, padding: 10, matching: .height, fill: true)
  }
}

class ListButtonCell: BasicTableViewCell {
  enum State {
    case listing
    case failed
    case success
    case normal
  }
  let spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
  let listButton = BasicButton()
  let bgView = UIView()
  let topCover = UIView()
  override func setup() {
    super.setup()
    backgroundColor = .clear
    topCover.backgroundColor = .white
    addSubview(topCover)
    topCover.anchor(.top, .left, .right).height(10)
    // bg view
    addSubview(bgView)
    bgView.fillSuperview(left: 0, right: 0, top: 10, bottom: 10)
    bgView.backgroundColor = .dlBlue
    // activity indicator
    addSubview(spinner)
    spinner.center(.x, offsetBy: -88).center(.y)
    // list button
    listButton.setTitleColor(.white, for: .normal)
    listButton.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Bold", size: 24)
    listButton.contentHorizontalAlignment = .center
    addSubview(listButton)
    listButton.fillSuperview(left: 10, right: 10, top: 10, bottom: 10)
  }
  func set(state: State) {
    switch state {
    case .listing:
      spinner.startAnimating()
      listButton.hide() { [weak self] in
        self?.listButton.setTitle("Listing...", for: .normal)
        self?.listButton.show()
      }
      break
    case .failed:
      listButton.hide() { [weak self] in
        self?.listButton.setTitle("Failed.", for: .normal)
        self?.listButton.show()
      }
      Timer.after(3.0) { [weak self] in
        self?.set(state: .normal)
      }
      break
    case .success:
      listButton.hide() { [weak self] in
        self?.listButton.setTitle("Success!", for: .normal)
        self?.listButton.show()
      }
      Timer.after(3.0) { [weak self] in
        self?.set(state: .normal)
      }
      break
    case .normal:
      listButton.hide() { [weak self] in
        self?.listButton.setTitle("List Book!", for: .normal)
        self?.listButton.show()
      }
      spinner.stopAnimating()
      break
    }
  }
  override func layoutSubviews() {
    super.layoutSubviews()
  }
}























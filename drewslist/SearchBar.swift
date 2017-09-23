//
//  SearchBar.swift
//  DrewsList
//
//  Created by Andrew Aquino on 9/17/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import UIKit

class SearchBar: BasicView {
  var textField = BasicTextField()
  var searchButton = BasicButton()
  var didChangeTextHandler: ((String?) -> ())?
  var didTapSearchHandler: ((String?) -> ())?
  var didTapFilterButton: ((String?) -> ())?
  private var textFieldBackground = UIView()
  override func setup() {
    super.setup()
    backgroundColor = .dlBlue
    
    searchButton.setTitle("By: Author", for: .normal)
    searchButton.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Medium", size: 12)
    searchButton.didTapHandler = { [weak self] in
      self?.showSearchFilterOptions()
    }
    addSubview(searchButton)
    searchButton.anchor(.top, .right, .bottom, padding: 10).autoresize(width: 50)

    addSubview(textFieldBackground)
    textFieldBackground
      .center(.y)
      .anchor(.left, padding: 10)
      .anchor(.left, of: searchButton, padding: 10)
      .height(36)
    textFieldBackground.backgroundColor = .white
    textFieldBackground.layer.cornerRadius = 8.0
    addSubview(textField)
    textField.returnKeyType = .search
    textField.placeholderString = "Search"
    textField.shouldReturnHandler = { [weak self] in
      self?.didTapSearchHandler?(self?.textField.text)
      return true
    }
    textField.didChangeTextHandler = { [weak self] text in
      self?.didChangeTextHandler?(text)
    }
    textField
      .center(.y)
      .anchor(.left, padding: 20)
      .anchor(.left, of: searchButton, padding: 20)
      .height(36)
    
    
    let topBorder = UIView()
    topBorder.backgroundColor = .black
    addSubview(topBorder)
    topBorder.anchor(.top, .left, .right).height(0.6)
  }
  @discardableResult
  override func resignFirstResponder() -> Bool {
    textField.resignFirstResponder()
    return true
  }
  func showSearchFilterOptions() {
  }
}

class FilterMenu: BasicView {
  enum Filter: String {
    case author
    case title
    case isbn
  }
  let tableView = UITableView(frame: .zero, style: .plain)
  let options: [Filter] = [
    .title,
    .author,
    .isbn
  ]
  override func setup() {
    super.setup()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(FilterMenuCell.self, forCellReuseIdentifier: "FilterMenuCell")
    addSubview(tableView)
    tableView.fillSuperview()
  }
}

extension FilterMenu: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return options.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "FilterMenuCell", for: indexPath) as? FilterMenuCell {
      cell.label.text = options[safe: indexPath.row]?.rawValue
      return cell
    }
    return .empty
  }
}

class FilterMenuCell: BasicTableViewCell {
  let label = DLLabel()
  override func setup() {
    super.setup()
    addSubview(label)
    label.fillSuperview()
  }
}


















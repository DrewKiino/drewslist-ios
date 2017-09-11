//
//  TestViewController.swift
//  drewslist
//
//  Created by Andrew Aquino on 9/3/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import UIKit
import Fakery

class TestViewController: BasicViewController {
  
  let tableView = UITableView(frame: .zero, style: .plain)
  
  let textField = UITextField(frame: .zero)
  
  
  var textDidChangeHandler: ((String) -> ())?
  
  lazy var names: [String] = {
    let faker = Faker()
    let array: [String] = [String?](repeating: nil, count: 10)
    .flatMap({ _ in faker.name.firstName() + " " + faker.name.lastName() })
    return array
  }()
  
  var filteredNames: [String] = []  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    tableView.separatorColor = .clear
    view.addSubview(tableView)
    tableView.fillSuperview(left: 0, right: 0, top: 56, bottom: 0)
    
//    textField.delegate = self
//    view.addSubview(textField)
//    textField.anchorToTop(padding: 20, height: 36)
    
    filteredNames = names
    
    textDidChangeHandler = { [weak self] newText in
      guard
        let names = self?.names,
        let filteredNames = self?.filteredNames
        else { return }
      
//      let items = filteredNames
//        .enumerated()
//        .sorted(by: { lhs, rhs in
//          (lhs.element.lowercased().contains(newText) ? 1 : 0) >
//          (rhs.element.lowercased().contains(newText) ? 1 : 0)
//        })
//      
//      for (index, item) in items {
//
//      }
      
      
      if let array = self?.insertionSort(
        filteredNames,
        { [weak self] oldIndex, newindex in
        },
        { (lhs, rhs) -> Bool in
          (lhs.lowercased().contains(newText) ? 1 : 0) >
          (rhs.lowercased().contains(newText) ? 1 : 0)
        }
      ) {
        self?.filteredNames = array
//        print(x)
      }
    }
  }
  
  @discardableResult
  func insertionSort<T>(
    _ array: [T],
    _ insertionBlock: ((Int, Int) -> ())? = nil,
    _ isOrderedBefore: (T, T) -> Bool
  ) -> [T] {
    guard array.count > 1 else { return array }
    var a = array
    for x in 1..<a.count {
      var y = x
      let temp = a[y]
      while y > 0 && isOrderedBefore(temp, a[y - 1]) {
        a[y] = a[y - 1]
        let z = y
        y -= 1
        insertionBlock?(z, y)
      }
      a[y] = temp
    }
    return a
  }
}

extension TestViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredNames.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let names = filteredNames
    let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
    cell.layer.borderColor = UIColor.black.cgColor
    cell.layer.borderWidth = 0.5
    cell.textLabel?.text = names[indexPath.row]
    return cell
  }
}

extension TestViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if let text = textField.text {
      let newText = NSString(string: text).replacingCharacters(in: range, with: string)
      textDidChangeHandler?(newText.description.lowercased())
    }
    return true
  }
}
















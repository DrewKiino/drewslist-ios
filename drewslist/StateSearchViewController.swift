//
//  StateSearchViewController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 9/18/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import UIKit

class StateSearchViewController: BasicViewController {
  static let shared = StateSearchViewController()
  let tableView = UITableView(frame: .zero, style: .plain)
  struct Section {
    var key: String!
    var states: [String] = []
  }
  var didSelectStateHandler: ((String) -> ())?
  let states: [String] = ["AK","AL","AR","AZ","CA","CO","CT","DC","DE","FL","GA","GU","HI","IA","ID", "IL","IN","KS","KY","LA","MA","MD","ME","MH","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY", "OH","OK","OR","PA","PR","PW","RI","SC","SD","TN","TX","UT","VA","VI","VT","WA","WI","WV","WY"]
  var sections: [Section] = []
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.showsVerticalScrollIndicator = false
    tableView.delegate = self
    tableView.dataSource = self
    tableView.sectionIndexColor = .black
    tableView.sectionIndexBackgroundColor = .clear
    tableView.backgroundColor = .clear
    tableView.register(SectionHeader.self, forHeaderFooterViewReuseIdentifier: "SectionHeader")
    tableView.registerBasicTableViewCell()
    view.addSubview(tableView)
    tableView.fillSuperview(left: 0, right: 0, top: 44, bottom: 0)
    
    var sorted: [String: [String]] = [:]
    states.forEach({ state in
      if let key = state.characters.first?.description {
        var array: [String] = sorted[key] ?? []
        array.append(state)
        sorted[key] = array
      }
    })
    for (key, state) in sorted.sorted(by: { lhs, rhs in lhs.key < rhs.key }) {
      sections.append(Section(key: key, states: state))
    }
    tableView.reloadData()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    headerView.setLeftButtonText("Back")
    headerView.setRightButtonText(nil)
    headerView.leftButtonTappedHandler = { [weak self] in
      self?.dismiss(animated: true) {
      }
    }
  }
}

extension StateSearchViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sections[section].states.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return .cell(
      text: sections[indexPath.section].states[indexPath.row],
      font: .dlFont(.light),
      using: tableView,
      at: indexPath
    ) { [weak self] indexPath in
      if let state = self?.sections[indexPath.section].states[indexPath.row] {
        self?.didSelectStateHandler?(state)
      }
    }
  }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeader") as? SectionHeader {
      return view
    }
    return nil
  }
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section].key
  }
  func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    return sections.flatMap({ $0.key })
  }
}

class SectionHeader: UITableViewHeaderFooterView {
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    textLabel?.font = .dlFont()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}

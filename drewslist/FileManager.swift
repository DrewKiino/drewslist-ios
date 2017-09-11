//
//  FileManager.swift
//  drewslist
//
//  Created by Andrew Aquino on 9/10/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation

class FileManager {
  class func jsonArray(_ filename: String?) -> [[String: Any]]? {
    return self.jsonFile(filename) as? [[String: Any]]
  }
  class func json(_ filename: String?) -> [String: Any]? {
    return self.jsonFile(filename) as? [String: Any]
  }
  private class func jsonFile(_ filename: String?) -> Any? {
    if
      let path = Bundle.main.path(forResource: filename, ofType: "json"),
      let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped),
      let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
    {
      return json
    }
    return nil
  }
}

//
//  URLRequest+extension.swift
//  Holk
//
//  Created by 张梦皓 on 2020-04-26.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

extension URLRequest {

  private func percentEscapeString(_ string: String) -> String {
    var characterSet = CharacterSet.alphanumerics
    characterSet.insert(charactersIn: "-._* ")

    return string
      .addingPercentEncoding(withAllowedCharacters: characterSet)!
      .replacingOccurrences(of: " ", with: "+")
      .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
  }

  mutating func encodeParameters(parameters: [String : String]) {

    let parameterArray = parameters.map { (arg) -> String in
      let (key, value) = arg
      return "\(key)=\(self.percentEscapeString(value))"
    }

    httpBody = parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
  }
}

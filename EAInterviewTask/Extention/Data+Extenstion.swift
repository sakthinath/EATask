//
//  Data+Extenstion.swift
//  
//
//  Created by Sathyanath Masthan on 04/04/23.
//

import Foundation

// MARK: - README

/*
 Data+Extensions

 This extension adds convenience methods to the Data type for handling JSON serialization and appending values.

 - jsonObject(options:): A method that deserializes the data into a JSON object. It returns Any to handle different types of JSON objects.
 - append<T>(values:): A mutating method that appends values of type T to the data. It supports appending strings and data objects.
 - appendString(_:): An extension on NSMutableData specifically, to append strings directly.

 README

 Usage:
 - jsonObject(options:): Use this method to deserialize JSON data into a JSON object. Pass appropriate options if needed.
 - append<T>(values:): Call this method to append values of type T to the data. It supports appending strings and data objects. Returns true if successful, false otherwise.
 - appendString(_:): Use this method to append a string directly to NSMutableData.

 Note:
 - Ensure that the data being appended is compatible with the type T. Unsupported types will result in an unsuccessful append operation.
 */

extension Data {
    public func jsonObject(options opt: JSONSerialization.ReadingOptions = []) throws -> Any {
        return try JSONSerialization.jsonObject(with: self, options: opt)
    }
}

extension Data {
    mutating func append<T>(values: [T]) -> Bool {
       var newData = Data()
       var status = true

       if T.self == String.self {
           for value in values {
               guard let convertedString = (value as! String).data(using: .utf8) else { status = false; break }
               newData.append(convertedString)
           }
       } else if T.self == Data.self {
           for value in values {
               newData.append(value as! Data)
           }
       } else {
           status = false
       }

       if status {
           self.append(newData)
       }

       return status
   }
    
}

extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}



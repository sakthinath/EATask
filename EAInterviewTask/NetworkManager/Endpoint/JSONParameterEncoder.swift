//
//  JSONParameterEncoder.swift
//  
//
//  Created by Sathyanath Masthan on 04/04/23.
//

import Foundation

public struct JSONParameterEncoder : ParameterEncoder {
    public static func encode(urlRequest: inout URLRequest, jsonBody body: Data?, withParameters parameters: Parameters) throws {
        if let dataBody = body {
            urlRequest.httpBody = dataBody
            
        }
        
        if urlRequest.value(forHTTPHeaderField: "\(HeaderKeyTypes.contentType.rawValue)") == nil {
            urlRequest.setValue("\(HeaderValueTypes.applicationJSON.rawValue)", forHTTPHeaderField: "\(HeaderKeyTypes.contentType.rawValue)")
        }
    }
}

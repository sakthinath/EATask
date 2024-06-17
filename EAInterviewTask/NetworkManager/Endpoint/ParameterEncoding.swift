//
//  ParameterEncoding.swift
//  
//
//  Created by Sathyanath Masthan on 04/04/23.
//

import Foundation

public typealias Parameters  = [String : Any]

public protocol ParameterEncoder {
    
    static func encode(urlRequest : inout URLRequest, jsonBody body : Data?,withParameters parameters : Parameters) throws
}


public protocol MultipartDataEncodable {
    
    static func encode<T>(urlRequest : inout URLRequest, multipartObject object : T?, withParameters parameters : Parameters) throws
}

public protocol ParameterBodyEncodable {
    static func encode(urlRequest : inout URLRequest,withParameters parameters : Parameters) throws
}

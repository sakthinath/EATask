//
//  HTTPTask.swift
//  
//
//  Created by Sathyanath Masthan on 04/04/23.
//

import Foundation

public typealias HTTPHeaders    = [String:String]

public typealias UserAgent      = [String:String]

public typealias OAuthHeaders   = [String:String]


public enum HTTPTask{
    case request
    
    case requestParameters(body : Parameters?,urlParameters : Parameters?, headers : HTTPHeaders?)
    
    case requestParametersWithHeaders(body : Parameters?, urlParameters : Parameters?, headers : HTTPHeaders?)
    
    case requestParametersWithOAuthAndJSONbody(body : Parameters?, jsonBody : Data?, urlParameters : Parameters?, headers : HTTPHeaders?)
    
    case requestWithBodyParameters(bodyParameters : Parameters?, headers : HTTPHeaders?)
    
    case requestWithJSONBody(bodyParameters : Parameters?, jsonBody: Data?, headers : HTTPHeaders?)
    
}

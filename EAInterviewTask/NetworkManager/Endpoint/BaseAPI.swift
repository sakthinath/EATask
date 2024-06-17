//
//  BaseAPI.swift
//  
//
//  Created by Sathyanath Masthan on 04/04/23.
//

import Foundation

public enum NetworkEnvironment {
    case production
    case development
    case local
}

public enum BaseAPI {
    case getBandDetails
   
}
extension BaseAPI : EndPointProtocol {
    
    var environmentBaseURL : String {
        switch self{
        case .getBandDetails:
            return "https://eacp.energyaustralia.com.au/codingtest/api/v1"
        }
        
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else{
            fatalError("Base url not configured")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getBandDetails:
            return "/festivals"
      
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
            
        case .getBandDetails:
            return .get
        
        }
    }
    
    var task: HTTPTask {
        switch self {
        
      
        case .getBandDetails:
            return .requestWithBodyParameters(bodyParameters: nil, headers: nil)
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getBandDetails:
            return [HeaderKeyTypes.authorization.rawValue: "\("")"]
            
        }
    }
}

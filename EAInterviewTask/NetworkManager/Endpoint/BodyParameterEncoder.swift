//
//  BodyParameterEncoder.swift
//  
//
//  Created by Sathyanath Masthan on 04/04/23.
//

import Foundation

public struct BodyParameterEncoder : ParameterBodyEncodable {
    
    public static func encode(urlRequest: inout URLRequest, withParameters parameters: Parameters) throws {
        
        do{
            guard urlRequest.url != nil else{
                throw NetworkErrors.missingURL
            }
            if !parameters.isEmpty{
                let parametersArray = parameters.map { (key, value) -> String in
                    if let valueString = value as? String, let encodedValue = valueString.stringByAddingPercentEncodingForFormData(plusForSpace: false){
                        return "\(key)=\(encodedValue)"
                    }else{
                        return "\(key)="
                    }
                }
                let encodedParameters = parametersArray.joined(separator: "&")
                urlRequest.httpBody = encodedParameters.data(using: .utf8)
            }
            
            if (urlRequest.value(forHTTPHeaderField: "\(HeaderKeyTypes.contentType.rawValue)") == nil){
                urlRequest.setValue("\(HeaderValueTypes.applicationForm.rawValue)\(HeaderValueTypes.utf8Charset.rawValue)", forHTTPHeaderField: "\(HeaderKeyTypes.contentType.rawValue)")
            }
        }catch{
            throw NetworkErrors.encodingFailed
        }
    }
}

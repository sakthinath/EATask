//
//  URLParameterEncoder.swift
//  
//
//  Created by Sathyanath Masthan on 04/04/23.
//

import Foundation

public struct URLParameterEncoder : ParameterEncoder{

    public static func encode(urlRequest: inout URLRequest, jsonBody body: Data?, withParameters parameters: Parameters) throws {
        
        do{
            guard let url = urlRequest.url else{
                throw NetworkErrors.missingURL
            }
            if let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty{
                let parametersArray = parameters.map { (key, value) -> String in
                    if let valueString = value as? String, let encodedValue = valueString.stringByAddingPercentEncodingForFormData(plusForSpace: false){
                        return "\(key)=\(encodedValue)"
                    }else{
                        return "\(key)="
                    }
                }
                let encodedParameters = parametersArray.joined(separator: "&")
                if let componentsURL = urlComponents.url {
                    urlRequest.url = URL(string: "\(componentsURL)?\(encodedParameters)")
                }
            }
            
            if (urlRequest.value(forHTTPHeaderField: "\(HeaderKeyTypes.contentType.rawValue)") == nil){
                urlRequest.setValue("\(HeaderValueTypes.applicationForm.rawValue)\(HeaderValueTypes.utf8Charset.rawValue)", forHTTPHeaderField: "\(HeaderKeyTypes.contentType.rawValue)")
            }
        }catch{
            throw NetworkErrors.encodingFailed
        }
    }
    
    
}


public struct MailURLParameterEncoder : ParameterEncoder{

    public static func encode(urlRequest: inout URLRequest, jsonBody body: Data?, withParameters parameters: Parameters) throws {
        
        do{
            guard let url = urlRequest.url else{
                throw NetworkErrors.missingURL
            }
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty{
                urlComponents.queryItems = [URLQueryItem]()
                
                for (key,value) in parameters {
                    if let valueString : String = value as? String{
                        let queryItem = URLQueryItem(name: key, value: valueString)
                        urlComponents.queryItems?.append(queryItem)
                    }
                }
                urlRequest.url = urlComponents.url
                print(urlComponents)

            }
            
            if (urlRequest.value(forHTTPHeaderField: "\(HeaderKeyTypes.contentType.rawValue)") == nil){
                urlRequest.setValue("\(HeaderValueTypes.applicationForm.rawValue)\(HeaderValueTypes.utf8Charset.rawValue)", forHTTPHeaderField: "\(HeaderKeyTypes.contentType.rawValue)")
            }
        }catch{
            throw NetworkErrors.encodingFailed
        }
    }
}
extension String {
    public func stringByAddingPercentEncodingForFormData(plusForSpace: Bool=false) -> String? {
        let unreserved = "*-._/"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        
        if plusForSpace {
            allowed.addCharacters(in: " ")
        }
        
        var encoded = addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
        if plusForSpace {
            encoded =  encoded?.replacingOccurrences(of: " ", with: "+")
        }
        return encoded
    }
    
}

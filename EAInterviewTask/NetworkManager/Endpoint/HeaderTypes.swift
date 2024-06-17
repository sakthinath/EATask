//
//  HeaderTypes.swift
//  
//
//  Created by Sathyanath Masthan on 04/04/23.
//

import Foundation

public enum HeaderValueTypes : String {
    case applicationForm            = "application/x-www-form-urlencoded;"
    case utf8Charset                = "charset=utf-8;"
    case applicationJSON            = "application/json;"
    case multiPartFormData          = "multipart/form-data;"
    
}

public enum HeaderKeyTypes : String{
    case contentType        = "Content-Type"
    case authorization      = "Authorization"
    case userAgent          = "User-Agent"
    case clientID           = "Client-Id"
}

//
//  NetworkErrors.swift
//  
//
//  Created by Sathyanath Masthan on 04/04/23.
//

import Foundation
public enum NetworkErrors : String, Error {
    case noParameters = "Parameters not found"
    case encodingFailed = "Parameters encoding failed"
    case missingURL = "URL is not specified"
    case noResponseFound = "No response received"
    case unknown = "Unknown error"
    case failedToBuildRequest = "Failed to build the request"
    case noURLRequestFound = "NO URL request found"
}

public enum DecodingErrors : String, Error {
    case decodingFailed = "Failed while decoding the response"
}

public enum FileErrors : String, Error {
    case deleteFailed  = "Failed to delete the file from the specified location"
    case writingFailed  = "Failed to write the file at the specified location"
}


public enum NetworkResponse  : String, Error {
    case success
    case authenticationError = "Authentication error"
    case badRequest = "Bad request"
    case unknown = "Unknown error"
    case nodata = "No data"
    case outdated = "OutDated"
    case failed = "Failed"
    case noResponseFound = "No Response Found"
}



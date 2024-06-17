//
//  Router.swift
//  NetworkLayer
//
//  Created by Sathyanath Masthan on 04/04/23.
//  Copyright © 2018 Sathyanath Masthan. All rights reserved.
//

import Foundation
import Combine

enum URLSessionConfigurationType {
    case upload
    case download
}

typealias RequestSuccessCompletion = (_ urlRequest:URLRequest?) -> ()

typealias RequestFailureCompletion = (_ error:Error?) -> ()

typealias ConfigureParametersSuccessBlock  = (_ urlRequest:URLRequest?) -> ()
typealias ConfigureParametersErrorBlock    = (_ error:Error?) -> ()


class Router<Endpoint : EndPointProtocol>  {
    private var task : URLSessionTask?
    
    
    ///   An async/await method for building request for a given endpoint
    /// - Parameter route: The endpoint for which the URLRequest has to be built
    /// - Returns: The constructed URLRequest or it will throw an error

    fileprivate func buildRequest(from route : Endpoint) async throws -> URLRequest{
        return try await withCheckedThrowingContinuation({
            (continuation: CheckedContinuation<URLRequest, Error>) in
            do {
                try self.buildRequest(from: route, success: { urlRequest in
                    guard let urlRequest = urlRequest else {
                        continuation.resume(throwing: NetworkErrors.noURLRequestFound)
                        return
                    }
                    continuation.resume(returning: urlRequest)
                }, failure: { error in
                    continuation.resume(throwing: NetworkErrors.failedToBuildRequest)
                })
            }catch {
                continuation.resume(throwing: NetworkErrors.failedToBuildRequest)
            }
        })
    }

    
    
    
    fileprivate func buildRequest(from route : Endpoint, success : @escaping RequestSuccessCompletion, failure : @escaping RequestFailureCompletion)throws{
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 120.0)
        request.httpMethod = route.httpMethod.rawValue
        
        
        switch route.task {
        case .request:
            request.setValue("\(HeaderValueTypes.applicationJSON)", forHTTPHeaderField: "\(HeaderKeyTypes.contentType)")
            
        case .requestParameters(body: let bodyParameters, urlParameters: let parameters, headers: let requestHeaders):
            self.setAdditionalHeaders(requestHeaders, request: &request)
            self.configureParameters(body: bodyParameters, urlParameters: parameters, request: &request, success: { (request) in
                success(request)
            }) { (error) in
                failure(error)
            }
            
        case.requestParametersWithHeaders(body: let bodyParameters, urlParameters: let  parameters, headers: let requestHeaders):
            
            self.setAdditionalHeaders(requestHeaders, request: &request)
            self.configureParameters(body: bodyParameters, urlParameters: parameters,  request: &request, success: { (request) in
                success(request)
            }) { (error) in
                failure(error)
            }
            
            
        case .requestParametersWithOAuthAndJSONbody(body: let bodyParameters, jsonBody: let jsonModel, urlParameters: let parameters, headers: let requestHeaders):
            self.setAdditionalHeaders(requestHeaders, request: &request)
            self.configureParameters(body: bodyParameters, jsonBody: jsonModel,urlParameters: parameters, request: &request, success: { (request) in
                success(request)
            }, failure: { (error) in
                failure(error)
            })
            
            
        case .requestWithBodyParameters(bodyParameters: let bodyParameters, headers: let headers):
            self.setAdditionalHeaders(headers, request: &request)
            
            self.configureParametersForBody(bodyParameters: bodyParameters, request: &request, success: { (request) in
                
                success(request)
            }, failure: { (error) in
                failure(error)
            })
            
            
        case .requestWithJSONBody(bodyParameters: let bodyParameters, jsonBody: let jsonData, headers: let headers):
            self.setAdditionalHeaders(headers, request: &request)
            
            self.configureParameters(body: bodyParameters, jsonBody: jsonData, urlParameters: nil, request: &request) { (request) in
                success(request)
            } failure: { (error) in
                failure(error)
            }

        }
    }
    
    fileprivate func configureParameters(body: Parameters?, jsonBody : Data? = nil ,urlParameters : Parameters?,request : inout URLRequest, success : @escaping ConfigureParametersSuccessBlock, failure : @escaping ConfigureParametersErrorBlock) {
        
        do {
            if let body = jsonBody {
                try JSONParameterEncoder.encode(urlRequest: &request, jsonBody:body ,withParameters: ["":""])
            }
            
            if let urlParameters = urlParameters{
                try URLParameterEncoder.encode(urlRequest: &request, jsonBody:jsonBody ,withParameters: urlParameters)
            }
            success(request)
        }catch {
            failure(error)
        }
        
    }
    

    
    fileprivate func configureParametersForBody(bodyParameters : Parameters?,request : inout URLRequest, success : @escaping ConfigureParametersSuccessBlock, failure : @escaping ConfigureParametersErrorBlock){
        
        do{
            if let bodyParams = bodyParameters {
                try BodyParameterEncoder.encode(urlRequest: &request, withParameters: bodyParams)
            }
            
            success(request)
        }catch {
            failure(error)
        }
    }
    
    
    
    fileprivate func setAdditionalHeaders(_ additionalHeader : HTTPHeaders?,request : inout URLRequest){
        
        guard let headers = additionalHeader else{
            return
        }
        
        
        for (key,value) in headers{
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    
    fileprivate func setUserAgent(_ userAgent : UserAgent?,request : inout URLRequest){
        guard let userAgentHeader = userAgent else{
            return
        }
        for (key,value) in userAgentHeader {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    fileprivate func setOAuthHeaders(_ oauthToken : String?, request : inout URLRequest){
        guard let oauthTokenValue = oauthToken else{
            return
        }
        request.setValue(oauthTokenValue, forHTTPHeaderField: HeaderKeyTypes.authorization.rawValue)
    }
    
    
    
}

extension Router {
    private func createBoundary() -> String? {
        var uuid = UUID().uuidString
        uuid = uuid.replacingOccurrences(of: "-", with: "")
        uuid = uuid.map { $0.lowercased() }.joined()
        let boundary = String(repeating: "-", count: 20) + uuid + "\(Int(Date.timeIntervalSinceReferenceDate))"
        return boundary
    }
    
    
    
    private func convertFormField(withBoundary boundary: String, httpBodyParameters : Parameters) -> Data {
        var body = Data()
        for (key, value) in httpBodyParameters {
            let values = ["--\(boundary)\r\n",
                          "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n",
                          "\(value)\r\n"]
            
            _ = body.append(values: values)
        }
        return body
    }
    
    func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
        let data = NSMutableData()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        return data as Data
    }
    
    private func close(usingBoundary boundary: String) -> String {
        return "\r\n--\(boundary)--\r\n"
    }
}

typealias NetworkResponseResult = (Data?,URLResponse?)

extension Router : NetworkRouter{
    
    func request(_ route: Endpoint) async throws -> NetworkResponseResult {
        let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let diskCacheURL = cachesURL.appendingPathComponent("DownloadCache")
        let cache = URLCache(memoryCapacity: 10_000_000, diskCapacity: 1_000_000_000, directory: diskCacheURL)
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = cache
        let session = URLSession(configuration: configuration)
        do {
            let request = try await self.buildRequest(from: route)
            Logger.logNetworkCalls(request: request)
            return try await session.data(for: request)
        }catch {
            throw NetworkErrors.noResponseFound
        }
    }

    
    func request(_ route: Endpoint) -> AnyPublisher<NetworkResponseResult, Error> {
        let session = URLSession.shared
        
        return Future<NetworkResponseResult, Error> { promise in
            do{
                try self.buildRequest(from: route, success: { (urlRequest) in
                    guard let request = urlRequest else{
                        return
                    }
                    Logger.logNetworkCalls(request: request)
                    
                    self.task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                        promise(.success((data,response)))
                    })
                    self.task?.resume()
                    
                }, failure: { (error) in
                    if let error = error {
                        promise(.failure(error))
                    }else{
                        promise(.failure(NetworkErrors.unknown))
                    }
                })
                
            }catch{
                promise(.failure(error))
            }
            
        }.eraseToAnyPublisher()
        
    }
    
//    func request(_ route: Endpoint) async throws -> NetworkResponseResult {
//        let session = URLSession.shared
//        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<NetworkResponseResult, Error>) in
//            do{
//                try self.buildRequest(from: route, success: { (urlRequest) in
//                    guard let request = urlRequest else{
//                        return
//                    }
//                    Logger.logNetworkCalls(request: request)
//
//                    self.task = session.dataTask(with: request, completionHandler: { (data, response, error) in
//                        if let error = error {
//                            continuation.resume(throwing: error)
//                        }
//                        if let response = response, let httpResponse = response as? HTTPURLResponse, let data = data {
//                            if 200...299 ~= httpResponse.statusCode {
//                                continuation.resume(returning: (data,response))
//                            }else {
//                                continuation.resume(throwing: NetworkErrors.unknown)
//                            }
//
//                        }else {
//                            continuation.resume(throwing: NetworkErrors.unknown)
//                        }
//
//                    })
//                    self.task?.resume()
//
//                }, failure: { (error) in
//                    if let error = error {
//                        continuation.resume(throwing: error)
//                    }else{
//                        continuation.resume(throwing: NetworkErrors.unknown)
//                    }
//                })
//
//            }catch{
//                continuation.resume(throwing: error)
//            }
//        })
//    }

    
    
    
    func downloadRequest(_ route: Endpoint, downloadedFilePath: @escaping DownloadTaskFilePath, downloadCompletionBlock: @escaping DownloadCompletionBlock, progress : @escaping DownloadProgressBlock) {
        do {
            try self.buildRequest(from: route, success: { (urlRequest) in
                if let request = urlRequest {
                    Logger.logNetworkCalls(request: request)
                    let downloadDelegate = RouterDownloadDelegateClass(didFinishDownloading: downloadedFilePath, didCompleteDownloadTask: { (session, task, error) in
                        session.finishTasksAndInvalidate()
                        downloadCompletionBlock(error)
                    }, downloadProgress: progress)
                    
                    let urlSession = self.session(for: .download, delegate: downloadDelegate)
                    let downloadTask = urlSession.downloadTask(with: request)
                    downloadTask.resume()
                }
            }, failure: downloadCompletionBlock)
            
        }catch {
            downloadCompletionBlock(error)
        }
    }
    
    func sessionConfiguration(for type: URLSessionConfigurationType) -> URLSessionConfiguration {
        let configuration: URLSessionConfiguration
        switch type {
        case .download:
            configuration = URLSessionConfiguration.default
            configuration.allowsCellularAccess = true
            configuration.isDiscretionary = true
            configuration.sessionSendsLaunchEvents = true
            configuration.waitsForConnectivity = true
            
        case .upload:
            configuration = URLSessionConfiguration.default
            configuration.allowsCellularAccess = true
            configuration.waitsForConnectivity = true
            
        }
        return configuration
    }
    
    func session(for type: URLSessionConfigurationType, delegate: URLSessionTaskDelegate) -> URLSession {
        let session: URLSession
        switch type {
        case .download:
            let configuration = self.sessionConfiguration(for: .download)
            session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
        case .upload:
            let configuration = self.sessionConfiguration(for: .upload)
            session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
        }
        return session
    }
    
    
    func uploadRequest(_ route: Endpoint, uploadCompletionBlock: @escaping UploadCompletionBlock, responseData : @escaping DataBlock,progress: @escaping UploadProgressBlock) {
        
        do {
            try self.buildRequest(from: route, success: { (urlRequest) in
                
                
                let uploadDelegate = RouterUploadDelegateClass(didCompleteUpload: uploadCompletionBlock,responseDataBlock: responseData, uploadProgressBlock: progress)
                let urlSession = self.session(for: .upload, delegate: uploadDelegate)
                if let request = urlRequest {
                    Logger.logNetworkCalls(request: request)
                    let uploadTask = urlSession.uploadTask(with: request, from: request.httpBody!)
                    uploadTask.resume()
                }
                
            }, failure: { (error) in
                uploadCompletionBlock(nil,nil,error)
            })
        }catch{
            uploadCompletionBlock(nil,nil,error)
        }
        
    }
    
    
    func cancel() {
        self.task?.cancel()
    }
}





//
//  NetworkRouter.swift
//  
//
//  Created by Sathyanath Masthan on 04/04/23.
//  Copyright © 2018 Sathyanath Masthan. All rights reserved.
//

import Foundation
import Combine

public typealias NetworkRouterCompletionBlock = (_ data:Data?, _ response : URLResponse?, _ error : Error?) -> ()

public typealias DownloadTaskFilePath    = (_ data : URLSession?, _ response : URLSessionDownloadTask?,_ urlPath : URL)->()
public typealias DownloadCompletionBlock    = (_ error : Error?)->()
public typealias DownloadProgressBlock          = (_ bytesWritten : Int64?,_ bytesToBeWritten : Int64?) -> ()

public typealias DataBlock = (_ responseData : Data)->()

public typealias UploadCompletionBlock = (_ session: URLSession?, _ uploadTask : URLSessionTask?, _ error : Error?)->()
public typealias UploadProgressBlock       = (_ bytesWritten:Int?, _ bytesToBeWritten :Int?)->()


protocol NetworkRouter : AnyObject {
    
    associatedtype Endpoint : EndPointProtocol
    
    func request(_ route: Endpoint) async throws -> NetworkResponseResult
        
    func downloadRequest(_ route: Endpoint, downloadedFilePath:@escaping DownloadTaskFilePath, downloadCompletionBlock : @escaping DownloadCompletionBlock, progress: @escaping DownloadProgressBlock)
    
    func uploadRequest(_ route: Endpoint, uploadCompletionBlock: @escaping UploadCompletionBlock, responseData : @escaping DataBlock,progress: @escaping UploadProgressBlock)
    
    func cancel()
}

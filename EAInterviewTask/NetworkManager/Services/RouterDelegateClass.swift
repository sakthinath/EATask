//
//  APICallLayer.swift
//  NetworkLayer
//
//  Created by Sathyanath Masthan on 04/04/23.
//  Copyright © 2018 Sathyanath Masthan. All rights reserved.
//

import Foundation

typealias DownloadTaskSuccessHandler = ()->()
typealias DownloadTaskFailureHandler = ()->()


class RouterDownloadDelegateClass : NSObject,  URLSessionTaskDelegate, URLSessionDownloadDelegate{
    
    var didFinishDownloading        : ((URLSession),(URLSessionDownloadTask),(URL)) -> ()
    var didCompleteDownloadTask        : ((URLSession),(URLSessionTask),(Error?)) -> ()
    var downloadProgressBlock       : (Int64,Int64)->()
    
    
    init(didFinishDownloading: @escaping ((URLSession),(URLSessionDownloadTask),(URL)) -> (),didCompleteDownloadTask : @escaping ((URLSession),(URLSessionTask),(Error?)) -> (),downloadProgress : @escaping (Int64,Int64) -> ()){
        self.didFinishDownloading   = didFinishDownloading
        self.didCompleteDownloadTask   = didCompleteDownloadTask
        self.downloadProgressBlock       = downloadProgress
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        didFinishDownloading(session,downloadTask,location)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        didCompleteDownloadTask(session,task,error)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        downloadProgressBlock(totalBytesWritten,totalBytesExpectedToWrite)
        
    }

}

class RouterUploadDelegateClass : NSObject, URLSessionTaskDelegate{
    
    var didCompleteUpload : ((URLSession?), (URLSessionTask?),(Error?) )->()
    var uploadProgressBlock : (Int,Int)->()
    var responseObjectBlock : ((_ responseData : Data)->())

    init(didCompleteUpload : @escaping (URLSession?,URLSessionTask?,Error?)->(), responseDataBlock :@escaping ((_ responseData : Data)->()),uploadProgressBlock : @escaping (Int,Int)->()){
        self.didCompleteUpload = didCompleteUpload
        self.responseObjectBlock = responseDataBlock
        self.uploadProgressBlock = uploadProgressBlock
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        didCompleteUpload(session,task,error)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        uploadProgressBlock(Int(totalBytesSent),Int(totalBytesExpectedToSend))
    }
}

extension RouterUploadDelegateClass : URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("session \(session), \(dataTask), \(data)")
        responseObjectBlock(data)
    }
}

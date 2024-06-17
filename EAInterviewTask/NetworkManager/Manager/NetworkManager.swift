//
//  NetworkManager.swift
//  
//
//  Created by Sathyanath Masthan on 04/04/23.
//

import Foundation

import Combine


typealias SuccessResponseBlock = (_ data : Data?,_ response:URLResponse?) -> ()

typealias FailureResponseBlock = (_ error:String?) -> ()
typealias ErrorBlock = (_ error:Error?) -> ()

struct NetworkManager{
    let environment : NetworkEnvironment = .development
    let router = Router<BaseAPI>()

    func getbandDetails() -> AnyPublisher<ArtistResponseModel,Error>{
        return router.request(.getBandDetails)
        
            .map { (data,response) in
                return self.validateResponse(data, response)
            }
            .switchToLatest()
            .decode(type: ArtistResponseModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
extension NetworkManager {
    
    fileprivate func validateResponse(_ data: Data?, _ response : URLResponse?) async throws -> Data {
        return try await withCheckedThrowingContinuation({ continuation in
            guard let response = response as? HTTPURLResponse else {
                continuation.resume(throwing: NetworkErrors.noResponseFound)
                return
            }
            let result = self.validateNetworkResponse(response)
            switch result {
            case .success:
                guard let responseData = data else{
                    continuation.resume(throwing: NetworkErrors.noResponseFound)
                    return
                }
                continuation.resume(returning: responseData)
            case .failure:
                continuation.resume(throwing: NetworkErrors.noResponseFound)
            }
        })
    }
    
    
     func validateResponse(_ data: Data?, _ response : URLResponse?) -> AnyPublisher<Data,Error>{
        return Future<Data,Error> { promise in
            if let response = response as? HTTPURLResponse {
                let result = self.validateNetworkResponse(response)
                
                switch result{
                case .success:
                    guard let responseData = data else{
                        promise(.failure(NetworkResponse.nodata))
                        return
                    }
                    promise(.success(responseData))
                case .failure(let networkFailureError):
                    promise(.failure(networkFailureError))
                }
            }else {
                promise(.failure(NetworkResponse.nodata))
            }
        }.eraseToAnyPublisher()
    }
    
    fileprivate func validateNetworkResponse(_ response: HTTPURLResponse) -> Result<Void,NetworkResponse>{
        
        switch response.statusCode {
        case 200...299: return .success(())
        case 400...500: return .failure(NetworkResponse.authenticationError)
        case 501...599: return .failure(NetworkResponse.badRequest)
        case 600: return .failure(NetworkResponse.outdated)
        default: return .failure(NetworkResponse.failed)
        }
    }
    
}



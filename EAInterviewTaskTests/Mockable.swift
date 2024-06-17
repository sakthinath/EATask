//
//  Mockable.swift
//  EAInterviewTaskTests
//
//  Created by Banka, Sathyanath (Cognizant) on 17/06/24.
//

import Foundation
import Combine
@testable import EAInterviewTask

protocol Mockable{
    var bundle: Bundle {get}
    func loadJson()-> AnyPublisher<EAInterviewTask.ArtistResponseModel, any Error>
}
extension Mockable {
    var bundle: Bundle{
        return Bundle(for: type(of: self) as! AnyClass)
    }
    func loadJson()-> AnyPublisher<EAInterviewTask.ArtistResponseModel, any Error> {
        Future<EAInterviewTask.ArtistResponseModel, any Error> { promise in
            
            guard let path = bundle.url(forResource: "BandResponse", withExtension: "json") else {
                let error = NSError(domain: "com.app.EAInterviewTask", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to Load JSON file"])
                promise(.failure(error))
                return
            }
            do {
                let data = try Data(contentsOf: path)
                let bands = try JSONDecoder().decode(EAInterviewTask.ArtistResponseModel.self, from: data)
                promise(.success(bands))
            }catch {
                
                let error = NSError(domain: "com.app.EAInterviewTask", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode."])

                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}

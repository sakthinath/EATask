//
//  MockImplementation.swift
//  EAInterviewTaskTests
//
//  Created by Banka, Sathyanath (Cognizant) on 17/06/24.
//

import Foundation
import Combine
import SwiftUI
@testable import EAInterviewTask


class HttpClientMockProtocol: HomeInterface, Mockable {
    
    func getbandDetails() -> AnyPublisher<EAInterviewTask.ArtistResponseModel, any Error>{
        return loadJson()
    }
    
    
}

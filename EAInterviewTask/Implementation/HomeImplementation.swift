//
//  HomeImplementation.swift
//  EAInterviewTask
//
//  Created by Banka, Sathyanath (Cognizant) on 14/06/24.
//

import Combine

// MARK: - README


/*
 HomeImplementation

 This class implements the HomeInterface protocol to provide functionality for fetching band details.

 Properties:
 - networkManager: An instance of NetworkManager used for making network requests.

 Methods:
 - init(manager: NetworkManager): Initializes the HomeImplementation with a provided instance of NetworkManager.
 - getbandDetails(): Implements the getbandDetails method from the HomeInterface protocol. It uses the networkManager to fetch band details from the network.

 README

 Usage:
 - networkManager: Provide an instance of NetworkManager when initializing HomeImplementation. This network manager should be configured to make network requests.
 - init(manager: NetworkManager): Call this initializer to create an instance of HomeImplementation with the specified network manager.
 - getbandDetails(): Call this method to fetch band details. It returns a Combine AnyPublisher with the result, allowing you to handle success or failure cases accordingly.
 */

class HomeImplementation: HomeInterface {
    let networkManager: NetworkManager
    init(manager: NetworkManager) {
        self.networkManager = manager
    }
    func getbandDetails()-> AnyPublisher<ArtistResponseModel,Error>{
        self.networkManager.getbandDetails()
    }
    
    
}

//
//  HomeInterface.swift
//  EAInterviewTask
//
//  Created by Banka, Sathyanath (Cognizant) on 14/06/24.
//


import Combine


// MARK: - README

/*
 HomeInterface

 This protocol defines the interface for fetching band details.

 Methods:
 - getbandDetails(): A method that returns a Combine AnyPublisher with the result of fetching band details. It can emit either an ArtistResponseModel upon success or an Error upon failure.

 README

 Usage:
 - Implement this protocol in classes or structs that need to fetch band details. The implementation should provide the actual functionality for fetching band details.
 - Define the getbandDetails method in conforming types to handle the actual fetching of band details and return the result as an AnyPublisher<ArtistResponseModel, Error>.
 - Use Combine framework to create and return an AnyPublisher, allowing asynchronous operations and error handling in a streamlined manner.
 */

protocol HomeInterface {
    func getbandDetails()-> AnyPublisher<ArtistResponseModel,Error>
}

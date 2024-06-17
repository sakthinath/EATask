//
//  ArtistResponseModel.swift
//  EAInterviewTask
//
//  Created by Banka, Sathyanath (Cognizant) on 14/06/24.
//

import Foundation


/*
 ArtistResponseModelItem

 This struct represents an item in the artist response model, containing details about a specific artist, including their name and associated bands.

 Properties:
 - id: A unique identifier generated using UUID.
 - name: The name of the artist.
 - bands: An optional array of Band structs representing the bands associated with the artist.

 Band

 This struct represents a band associated with an artist, containing details such as the band's name and record label.

 Properties:
 - id: A unique identifier generated using UUID.
 - name: The name of the band.
 - recordLabel: The record label associated with the band.

 ArtistResponseModel

 This type alias represents a collection of ArtistResponseModelItem structs, essentially representing the entire artist response model.

 README

 Usage:
 - ArtistResponseModelItem: Use this struct to represent an item in the artist response model. It contains information about an artist and their associated bands.
 - Band: Use this struct to represent a band associated with an artist. It contains details about the band's name and record label.
 - ArtistResponseModel: Use this type alias to represent the entire artist response model, which is a collection of ArtistResponseModelItem structs.

 Note: Make sure to conform to Codable protocol for serialization and deserialization if needed.
 */

// MARK: - ArtistResponseModelElement
struct ArtistResponseModelItem: Identifiable,Codable {
    let id = UUID()
    let name: String?
    let bands: [Band]?
}

// MARK: - Band
struct Band: Identifiable, Codable {
    let id = UUID()
    let name, recordLabel: String?
}

typealias ArtistResponseModel = [ArtistResponseModelItem]

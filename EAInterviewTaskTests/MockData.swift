//
//  MockData.swift
//  EAInterviewTaskTests
//
//  Created by Banka, Sathyanath (Cognizant) on 18/06/24.
//

import Foundation
@testable import EAInterviewTask

// MARK: - Mock Data
let mockData: [ArtistResponseModelItem] = [
    ArtistResponseModelItem(name: "Small Night In", bands: [
        Band(name: "Yanke East", recordLabel: "MEDIOCRE Music"),
        Band(name: "Wild Antelope", recordLabel: "Marner Sis. Recording"),
        Band(name: "Green Mild Cold Capsicum", recordLabel: "Marner Sis. Recording"),
        Band(name: "Squint-281", recordLabel: "Outerscope"),
        Band(name: "The Black Dashes", recordLabel: "Fourth Woman Records")
    ]),
    ArtistResponseModelItem(name: "Trainerella", bands: [
        Band(name: "Wild Antelope", recordLabel: "Still Bottom Records"),
        Band(name: "Manish Ditch", recordLabel: "ACR"),
        Band(name: "Adrian Venti", recordLabel: "Monocracy Records"),
        Band(name: "YOUKRANE", recordLabel: "Anti Records")
    ]),
    ArtistResponseModelItem(name: "", bands: [
        Band(name: "Critter Girls", recordLabel: "ACR"),
        Band(name: "Propeller", recordLabel: "Pacific Records")
    ]),
    ArtistResponseModelItem(name: "Twisted Tour", bands: [
        Band(name: "Auditones", recordLabel: "Marner Sis. Recording"),
        Band(name: "Squint-281", recordLabel: ""),
        Band(name: "Summon", recordLabel: "Outerscope")
    ])
]

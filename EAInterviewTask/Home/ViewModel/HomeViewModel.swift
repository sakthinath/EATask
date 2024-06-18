//
//  HomeViewModel.swift
//  EAInterviewTask
//
//  Created by Banka, Sathyanath (Cognizant) on 14/06/24.
//

import SwiftUI
import Combine

// MARK: - README

/*
 HomeViewModel

 This class serves as the view model for handling artist response model data.

 Properties:
 - cancellable: A set to hold AnyCancellable objects for managing Combine subscriptions.

 Methods:
 - getbandDetails(homeService: HomeInterface): Fetches band details using the provided home service and updates the view model's data accordingly.
 - getBandItems(item: ArtistResponseModel): Processes the received artist response model, sorting it alphabetically based on artist names and band names.

 README

 Usage:
 - cancellable: Use this property to manage Combine subscriptions. Ensure to store AnyCancellable objects returned by Combine publishers in this set to avoid memory leaks.
 - getbandDetails(homeService: HomeInterface): Call this method to fetch band details using a concrete implementation of HomeInterface. It updates the view model's data and handles any errors encountered during the fetch operation.
 - getBandItems(item: ArtistResponseModel): Call this method to process the received artist response model. It sorts the data alphabetically based on artist names and band names, preparing it for presentation.
 */

class HomeViewModel: Observable<ArtistResponseModel> {
    
   
    var cancellable = Set<AnyCancellable>()
    
    func getbandDetails(homeService: HomeInterface){
        self.isLoading = true
        homeService.getbandDetails().receive(on: DispatchQueue.main).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self.isLoading = false
                self.isShowAlert = true
                self.errorMessage = error.localizedDescription
            }
        } receiveValue: { item in
            self.isLoading = false
            self.getBandItems(item: item)
        }.store(in: &cancellable)

    }
    
    func groupBandsByRecordLabel(from artistResponse: [ArtistResponseModelItem]) -> [ArtistResponseModelItem]  {
        var groupedBands: [String: [Band]] = [:]
        var separatedData: [ArtistResponseModelItem] = []
        for item in artistResponse {
            guard let bands = item.bands else {
                continue
            }
            
            for band in bands {
                // Use empty string if recordLabel is nil
                let recordLabel = band.recordLabel ?? ""
                
                if groupedBands[recordLabel] == nil {
                    groupedBands[recordLabel] = []
                }
                
                groupedBands[recordLabel]?.append(Band(name: band.name, recordLabel: item.name))
            }
        }
    
        for (recordLabel, bands) in groupedBands {
            
            let separatedItem = ArtistResponseModelItem(name: recordLabel, bands: bands)
            separatedData.append(separatedItem)
        }
        
        return separatedData
    }
    
    func getBandItems(item: ArtistResponseModel){
        let dic = groupBandsByRecordLabel(from: item)
        self.data = dic.sorted { $0.name ?? "" < $1.name ?? ""}
                    .map { event in
                        ArtistResponseModelItem(name: event.name, bands: event.bands?.sorted { $0.name ?? "" < $1.name ?? ""})
                    }
    }
}



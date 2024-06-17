//
//  Observable.swift
//  
//
//  Created by Sathyanath Masthan on 04/04/23.
//

import Combine


// MARK: - README


/*
 Observable<T>

 This generic class extends ObservableObject and provides properties for managing state related to data loading, fetched data, and error messages.

 Properties:
 - isLoading: A published property indicating whether data is currently being loaded. It's an optional Bool, allowing it to be nil if the loading state is unknown or not applicable.
 - data: A published property holding the fetched data of type T. It's an optional generic type, allowing it to be nil if no data has been fetched or if an error occurred.
 - errorMessage: A published property containing any error message encountered during data fetching or processing. It's an optional String, allowing it to be nil if no error occurred.

 README

 Usage:
 - isLoading: Observe this property to track the loading state of data. It's optional, so it can be nil if the loading state is unknown or not applicable.
 - data: Observe this property to access the fetched data of type T. It's optional, so it can be nil if no data has been fetched or if an error occurred.
 - errorMessage: Observe this property to retrieve any error message encountered during data fetching or processing. It's optional, so it can be nil if no error occurred.

 Note:
 - This class is designed to be generic, allowing it to work with various data types. Ensure to specify the appropriate data type when creating an instance of Observable<T>.
 */

class Observable<T>: ObservableObject {

    @Published var isLoading:Bool?
    @Published var data:T?
    @Published var errorMessage:String?
    @Published var isShowAlert:Bool = false
}

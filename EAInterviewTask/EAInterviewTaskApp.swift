//
//  EAInterviewTaskApp.swift
//  EAInterviewTask
//
//  Created by Banka, Sathyanath (Cognizant) on 14/06/24.
//

import SwiftUI

@main
struct EAInterviewTaskApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: HomeViewModel())
        }
    }
}

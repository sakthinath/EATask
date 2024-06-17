//
//  LoaderView.swift
//  EAInterviewTask
//
//  Created by Banka, Sathyanath (Cognizant) on 15/06/24.
//

import SwiftUI

struct LoaderView: View {
    var loaderView: some View {
            VStack {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.clear)
            .transition(.opacity)
        
    }
    var body: some View {
        loaderView
    }
}

#Preview {
    LoaderView()
}

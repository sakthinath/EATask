//
//  ContentView.swift
//  EAInterviewTask
//
//  Created by Banka, Sathyanath (Cognizant) on 14/06/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject var viewModel: HomeViewModel
    
    
    
    var body: some View {
        ZStack{
            if viewModel.isLoading ?? false {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                LoaderView()
            }else {
                VStack {
                    
                    ScrollView(showsIndicators: false){
                        LazyVStack(alignment: .leading ,content: {
                            
                            ForEach(viewModel.data ?? [], id: \.id) { item in
                                Section {
                                    Text("\((item.name?.isEmpty ?? true) ? "No Record Name" : item.name ?? "No Record Name")")
                                    ScrollView {
                                        LazyVStack(content: {
                                            ForEach(item.bands ?? [], id: \.id) { band in
                                                BandView(band: band)
                                            }
                                        })
                                    }
                                }
                            }
                            
                        })
                    }
                }.onAppear {
                    if viewModel.data?.isEmpty ?? true {
                        viewModel.getbandDetails(homeService: HomeImplementation(manager: NetworkManager()))                                }
                    
                }
                .alert("Important message", isPresented: $viewModel.isShowAlert ) {
                            Button("OK", role: .cancel) {
                                viewModel.isShowAlert = false
                            }
                        }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView(viewModel: HomeViewModel())
}

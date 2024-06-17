//
//  BandView.swift
//  EAInterviewTask
//
//  Created by Banka, Sathyanath (Cognizant) on 14/06/24.
//

import SwiftUI

struct BandView: View {
    var band: Band
    var bandView: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.gray)
                    .frame(width: 75, height: 75)
                    
                
                VStack(alignment: .leading) {
                    Text(band.name ?? "No Name")
                        .font(.headline)
                    Text(band.recordLabel ?? "")
                        .font(.caption)
                }
                Spacer()
            }.padding()
            
        }
    }
    var body: some View {
        bandView
    }
}

#Preview {
    BandView(band: Band(name: "Sample", recordLabel: "Records"))
}

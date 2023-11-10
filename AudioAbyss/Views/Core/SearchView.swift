//
//  SearchView.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-04.
//

import SwiftUI

struct SearchView: View {
    
    @State private var searchTerm: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                
            }
            .searchable(text: $searchTerm, prompt: Text("Songs, Artists, Albums"))
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

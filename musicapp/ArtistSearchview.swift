//
//  ArtistSearchview.swift
//  musicapp
//
//  Created by Iria Parada on 13/02/2025.
//


import SwiftUI
import Foundation
import SwiftData

struct ArtistSearchview: View {
    
    @StateObject var viewModel = ViewModel()
    @State private var searchText = ""
    
    var filteredListArtists: [String] {
        return searchText.isEmpty ? viewModel.artists : viewModel.artists.filter { $0.lowercased().contains(searchText.lowercased()) }
    }
    
    
    var body: some View {
        
        NavigationStack{
            VStack {
                
                List(filteredListArtists, id: \.self) { artist in
                    NavigationLink(destination: AlbumListView(artistName: artist)) {
                        Text(artist)
                    }
                }
                .searchable(text: $searchText)
                .onChange(of: searchText) { _, newValue in
                    if newValue.count > 2 {
                        self.viewModel.searchArtist(query: newValue)
                    } else {
                        self.viewModel.artists = []
                    }
                }
                .navigationTitle("Search for an Artist")
                
            }
        }
        
    }
}


#Preview {
    ArtistSearchview()
}

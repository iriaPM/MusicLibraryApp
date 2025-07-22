//
//  ContentView.swift
//  musicapp
//
//  Created by Iria Parada on 07/02/2025.

import SwiftUI
import SwiftData
import Foundation

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    @State private var isExanded = false
    
    @AppStorage("savedAlbums") private var savedAlbums: Data = Data()
    
    var savedAlbumsList: [Album] {
        if let decoded = try? JSONDecoder().decode([Album].self, from: savedAlbums) {
            return decoded
        }
        return []
    }
    
    
    var body: some View {
        
        NavigationStack {
            
            if !savedAlbumsList.isEmpty {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                        ForEach(savedAlbumsList) { album in
                            NavigationLink(destination: AlbumDetailView(album: album)) {
                                VStack {
                                    urlImage(urlString: album.cover.absoluteString)
                                        .frame(width: 100, height: 100)
                                        .accessibilityLabel("image of album \(album.title)")
                                    Text(album.title)
                                        .font(.subheadline)
                                        .foregroundStyle(Color.primary)
                                        .lineLimit(2)
                                }
                            }
                        }
                    }
                }
                .padding()
                .navigationTitle("Your Favorite Albums")
                
            }
            
            
        }
        
    }
}

#Preview {
    NavigationBar()
}

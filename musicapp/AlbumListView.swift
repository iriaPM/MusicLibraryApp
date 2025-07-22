//
//  AlbumListView.swift
//  musicapp
//
//  Created by Iria Parada on 07/02/2025.
//
import Foundation
import SwiftData
import SwiftUI

struct AlbumListView: View {
    var artistName: String
    @StateObject var viewModel = ViewModel()
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            
            List(viewModel.albums) { album in
                NavigationLink(destination: AlbumDetailView(album: album)) {
                    HStack {
                        urlImage(urlString: album.cover.absoluteString)
                            .frame(width: 50, height: 50)
                        VStack(alignment: .leading) {
                            Text(album.title)
                                .font(.headline)
                                .lineLimit(2)
                            Text(album.artist.name)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            
        }
        .navigationTitle("\(artistName)'s Albums")
        .onAppear {
            viewModel.fetchAlbums(for: artistName) { success in
                isLoading = false
                if !success {
                    print("Failed to fetch albums for \(artistName)")
                }
            }
        }
    }
}

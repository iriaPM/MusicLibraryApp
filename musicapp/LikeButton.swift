//
//  LikeButton.swift
//  musicapp
//
//  Created by Iria Parada on 07/02/2025.
//


import SwiftUI
import Foundation
import SwiftData

struct LikeButton: View {
    let album: Album
    @AppStorage("savedAlbums") private var savedAlbums: Data = Data()
    @State private var isLiked: Bool = false
    
    var savedAlbumsList: [Album] {
        if let decoded = try? JSONDecoder().decode([Album].self, from: savedAlbums) {
            return decoded
        }
        return []
    }
    
    func toggleLike() {
        var albums = savedAlbumsList
        
        if isLiked {
            albums.removeAll { $0.id == album.id }
        } else {
            albums.append(album)
        }
        
        if let encoded = try? JSONEncoder().encode(albums) {
            savedAlbums = encoded
        }
        
        isLiked.toggle()
    }
    
    var body: some View {
        Button(action: toggleLike) {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .foregroundColor(isLiked ? .red : .gray)
                .padding()
        }
        .onAppear {
            isLiked = savedAlbumsList.contains(where: { $0.id == album.id })
        }
        .scaleEffect(isLiked ? 1.4 : 1)
        .animation(.easeInOut(duration: 0.5), value: isLiked)
    }
}
#Preview {
    NavigationBar()
}

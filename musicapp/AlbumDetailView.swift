//
//  AlbumDetailView.swift
//  musicapp
//
//  Created by Iria Parada on 10/02/2025.
//
import SwiftUI

struct AlbumDetailView: View {
    let album: Album
    
    var body : some View {
        
        VStack {
            
            urlImage(urlString: album.cover.absoluteString)
                .frame(width: 200, height: 200)
                .padding()
                .accessibilityLabel("image of album \(album.title)")

            VStack{
                Text(album.title)
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityValue(Text("album title"))
                
                Text(album.artist.name)
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .accessibilityValue(Text("artist name"))
                
                HStack{
                    Text(album.releaseDate)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    LikeButton(album: album)
                        .padding(.trailing)
                }
                .font(.title3)
            }
            
            VStack{
                
                Text("Tracklist:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .font(.title3)
                
                
                
                if album.tracklist.isEmpty {
                    Text("No tracks available")
                }else{
                    List(Array(album.tracklist.enumerated()), id: \.element.name){index, track in
                        
                        HStack{
                            Text(" \(index + 1). \(track.name)")
                                .font(.title3)
                            Spacer()
                            
                            if let duration = track.duration {
                                Text("\(duration) sec")
                                    .padding()
                                    .font(.subheadline)
                            }else{
                                Text("N/A")
                                    .padding()
                                    .font(.subheadline)
                                
                            }
                            
                            
                        }
                        
                        .listRowBackground(index.isMultiple(of: 2) ? Color.gray.opacity(0.2): Color.clear)
                        .accessibilityElement(children: .combine)

                    }
                    
                }
            }
            
        }
        .scrollContentBackground(.hidden)
        .navigationTitle(album.artist.name)
        .lineLimit(1)
        .allowsTightening(true)
        
    }
    
    
    
}



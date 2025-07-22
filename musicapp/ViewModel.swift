//
//  ViewModel.swift
//  musicapp
//
//  Created by Iria Parada on 07/02/2025.
//https://api.deezer.com/chart/0/albums
//https://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=b165f46b5b321fd72f09da7af347a63e&artist=cher&album=believe&format=json
import SwiftData
import Foundation
import SwiftUI

struct LastFMResponse: Codable {
    let album: LastFMAlbum
    
    struct LastFMAlbum: Codable {
        let name: String
        let artist: String
        let image: [LastFMImage]
        let tracks: TrackList?
        let wiki: Wiki?
        
        struct LastFMImage: Codable {
            let text: String
            let size: String
            
            enum CodingKeys: String, CodingKey {
                case text = "#text"
                case size
            }
        }
        
        struct TrackList: Codable {
            let track: [Track]
            
            init(from decoder: Decoder) throws {
                // realised all albums have tracks even if thrs only one track
                let container = try decoder.container(keyedBy: CodingKeys.self)
                if let tracksArray = try? container.decode([Track].self, forKey: .track) {
                    self.track = tracksArray
                } else if let singleTrack = try? container.decode(Track.self, forKey: .track) {
                    self.track = [singleTrack]
                } else {
                    self.track = []
                }
            }
            
            private enum CodingKeys: String, CodingKey {
                case track
            }
        }
        
        struct Wiki: Codable {
            let published: String?
        }
    }
}
struct LastFMTopAlbumsResponse: Codable {
    let topalbums: TopAlbums
    
    struct TopAlbums: Codable {
        let album: [AlbumData]
    }
    
    struct AlbumData: Codable {
        let name: String
        let image: [LastFMImage]
        
        struct LastFMImage: Codable {
            let text: String
            let size: String
            
            enum CodingKeys: String, CodingKey {
                case text = "#text"
                case size
            }
        }
    }
}



struct LFMartist_searchresponse: Codable{
    let results: LFMartist_searchresults
    
    struct LFMartist_searchresults: Codable{
        let artistmatches: artistMatches
        
    }
    
    struct   artistMatches: Codable{
        let artist: [LastFMArtist]
    }
    
}

struct LastFMArtist: Codable {
    let name: String
}

struct Album: Hashable, Identifiable, Codable {
    let id: String
    let title: String
    let cover: URL
    let artist: Artist
    let releaseDate: String
    let tracklist: [Track]
}

struct Artist: Codable, Hashable {
    let name: String
}

struct Track: Codable, Hashable {
    let name: String
    let duration: Int?
    
    enum CodingKeys: String, CodingKey {
        case name
        case duration
    }
}



class ViewModel: ObservableObject {
    @Published var albums: [Album] = []
    @Published var artists: [String] = []
    private let apiKey = "b165f46b5b321fd72f09da7af347a63e"
    
    func fetchAlbums(for artist: String, completion: @escaping (Bool) -> Void) {
        let urlString = "https://ws.audioscrobbler.com/2.0/?method=artist.gettopalbums&artist=\(artist)&api_key=\(apiKey)&format=json"
        
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(false) }
                return
            }
            
            do {
                let response = try JSONDecoder().decode(LastFMTopAlbumsResponse.self, from: data)
                let albumNames = response.topalbums.album.map { $0.name }
                
                DispatchQueue.main.async {
                    self.albums = []
                }
                
                for albumName in albumNames {
                    self.fetchAlbumInfo(for: albumName, artist: artist) { success in
                        if !success {
                            print("Failed to fetch details for album: \(albumName)")
                            
                        }
                    }
                }
                
                DispatchQueue.main.async { completion(true) }
                
            } catch {
                print("Error decoding albums: \(error)")
                DispatchQueue.main.async { completion(false) }
            }
        }.resume()
    }
    func fetchAlbumInfo(for albumName: String, artist: String, completion: @escaping (Bool) -> Void) {
        let encodedArtist = artist.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedAlbum = albumName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=\(apiKey)&artist=\(encodedArtist)&album=\(encodedAlbum)&format=json"
        
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, statusResponse, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(false) }
                return
            }
            
            do {
                let response = try JSONDecoder().decode(LastFMResponse.self, from: data)
                
                let newAlbum = Album(
                    id: response.album.name,
                    title: response.album.name,
                    cover: URL(string: response.album.image.last?.text ?? "") ?? URL(string: "https://via.placeholder.com/150")!,
                    artist: Artist(name: response.album.artist),
                    releaseDate: response.album.wiki?.published ?? "Unknown",
                    tracklist: response.album.tracks?.track.map{Track(name: $0.name, duration: $0.duration)} ?? []
                )
                
                DispatchQueue.main.async {
                    self.albums.append(newAlbum)
                    completion(true)
                }
                
            } catch {
                print("Error decoding album info: \(error)")
                DispatchQueue.main.async { completion(false)
                    print((statusResponse as? HTTPURLResponse)?.statusCode)
                }
            }
        }.resume()
    }
    
    func searchArtist(query: String) {
        let urlString = "https://ws.audioscrobbler.com/2.0/?method=artist.search&artist=\(query)&api_key=\(apiKey)&format=json"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let response = try JSONDecoder().decode(LFMartist_searchresponse.self, from: data)
                DispatchQueue.main.async {
                    self.artists = response.results.artistmatches.artist.map { $0.name }
                }
            } catch {
                print("Error decoding artist search:", error)
            }
        }.resume()
    }
}


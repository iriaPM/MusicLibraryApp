//
//  navbar.swift
//  musicapp
//
//  Created by Iria Parada on 17/02/2025.
//
import SwiftUI

struct NavigationBar: View {
    var body: some View {
        NavigationView {
            TabView {
                Tab(" ",systemImage: "house.fill"){
                    ContentView()
                }
                .accessibilityLabel("home")
                .accessibilityHint("go to homepage")
                
                Tab(" ",systemImage: "magnifyingglass"){
                    ArtistSearchview()
                }
                .accessibilityLabel("search")
                .accessibilityHint("search for an artist")
                
            }
            .padding(.top)
            
        }
    }
}

#Preview {
    NavigationBar()
}

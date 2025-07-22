//
//  urlImage.swift
//  musicapp
//
//  Created by Iria Parada on 07/02/2025.
//
import SwiftUI
import Foundation
import SwiftData

struct urlImage: View {
    
    let urlString: String
    @State var data: Data?
    
    var body: some View {
        if let data = data, let uiimage = UIImage(data: data) {
            Image(uiImage: uiimage)
                .resizable().scaledToFit()
                .aspectRatio(contentMode: .fill)
                .padding(2)
                //.frame(width: , height:  )
                .cornerRadius(10)
                

        } else {
            Image(systemName: "photo")
                .resizable()
                .background(Color.gray)
                .aspectRatio(contentMode: .fit)
                .onAppear {
                    fetchImage()
                }
        }
    }
    
    private func fetchImage() {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}

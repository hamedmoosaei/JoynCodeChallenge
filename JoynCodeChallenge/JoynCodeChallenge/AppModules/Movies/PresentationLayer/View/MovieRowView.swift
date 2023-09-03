//
//  MovieRowView.swift
//  JoynCodeChallenge
//
//  Created by Hamed Moosaei on 7/29/23.
//

import SwiftUI

struct MovieRawView: View {
    var model: MoviePresentationModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.random)
            VStack(alignment: .leading) {
                imageView
                Spacer()
                Text(model.tvShowTitle)
                    .font(.headline)
                    .padding(24)
                    .bold()
                Spacer()
                Text(model.titleDefault)
                    .font(.caption)
                    .padding(24)
            }
        }
        .cornerRadius(8)
        .frame(width: UIScreen.main.bounds.width * 0.44)
        
    }
    var imageView: some View {
        VStack {
            if let imageUrl = URL(string: model.imageURL) {
                CacheAsyncImage(url: imageUrl) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        placeholderIcon
                    }
                }
            } else {
                placeholderIcon
            }
        }
    }
    var placeholderIcon: some View {
        Image(systemName: "photo")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

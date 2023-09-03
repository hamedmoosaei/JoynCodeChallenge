//
//  MoviesListView.swift
//  JoynCodeChallenge
//
//  Created by Hamed Moosaei on 7/29/23.
//

import SwiftUI

struct MoviesListView: View {
    @ObservedObject var viewModel: MoviesListViewModel
    
    let movieDetailViewFactory: (MoviePresentationModel) -> MovieDetailView
    
    var body: some View {
        if viewModel.isLoading {
            loadingView
        } else if viewModel.isError {
            errorView
        } else {
            Text("Full Episodes")
                .font(.headline)
                .padding()
            
            listView
        }
    }
    
    var listView: some View {
        NavigationStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(viewModel.movies, id: \.imageURL) { (movie: MoviePresentationModel) in
                        NavigationLink(destination: movieDetailViewFactory(movie)) {
                            MovieRawView(model: movie)
                        }
                        .buttonStyle(PlainNavigationLinkButtonStyle())
                    }
                }
            }
        }
    }
    
    var loadingView: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .padding()
    }
    
    var errorView: some View {
        VStack {
            Text("Error occurred while loading Data")
                .foregroundColor(.red)
                .padding()
            Button {
                viewModel.fetchMovies()
            } label: {
                Text(NSLocalizedString("Try Again Button Title", value: "Try Again", comment: ""))
                    .foregroundColor(.blue)
            }
        }
    }
}

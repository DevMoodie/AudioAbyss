//
//  SearchView.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-04.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchView: View {
    
    @State private var searchTerm: String = ""
    @State private var currentTerm: SearchResultType = .tracks
    
    @StateObject private var searchVM: SearchViewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if searchTerm == "" {
                        LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                            if let categories = searchVM.categories {
                                ForEach(categories, id: \.self) { category in
                                    NavigationLink(destination: CategoryView(categoryVM: CategoryViewModel(category: category))) {
                                        ZStack (alignment: .bottom) {
                                            if let urlString = category.icons.first?.url, let imageURL = URL(string: urlString) {
                                                WebImage(url: imageURL)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: 120)
                                                    .cornerRadius(20.0)
                                                    .padding(2)
                                            }
                                            Text("\(category.name)")
                                                .font(.custom("Teko", size: 15.0).bold())
                                                .foregroundStyle(.foreground)
                                                .padding(5)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(5)
                    } else {
                        if let searchSections = searchVM.searchSections {
                            if searchSections.isEmpty {
                                Text("No Results Found")
                                    .font(.custom("Teko", size: 15.0).bold())
                            } else {
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(searchSections, id: \.self) { section in
                                            ZStack {
                                                if section.title == currentTerm.rawValue {
                                                    RoundedRectangle(cornerRadius: 30.0)
                                                        .foregroundStyle(.foreground)
                                                        .frame(width: 75, height: 40)
                                                    Text("\(section.title)")
                                                        .font(.custom("Teko", size: 15.0).bold())
                                                        .foregroundStyle(.background)
                                                } else {
                                                    RoundedRectangle(cornerRadius: 30.0)
                                                        .stroke(lineWidth: 3.0)
                                                        .foregroundStyle(.foreground)
                                                        .frame(width: 75, height: 40)
                                                    Text("\(section.title)")
                                                        .font(.custom("Teko", size: 15.0).bold())
                                                        .foregroundStyle(.foreground)
                                                }
                                            }
                                            .onTapGesture {
                                                withAnimation {
                                                    currentTerm = SearchResultType(rawValue: section.title)!
                                                }
                                            }
                                        }
                                    }
                                    .padding()
                                }
                                .scrollIndicators(.hidden)
                                .scrollClipDisabled()
                                ForEach(searchSections, id: \.self) { section in
                                    VStack (alignment: .leading) {
                                        if currentTerm.rawValue == section.title {
                                            ForEach(section.results, id: \.self) { result in
                                                switch result {
                                                case .track(let track):
                                                    NavigationLink(destination: PlayerView(playerVM: PlayerViewModel(track: track))) {
                                                        SearchResultView(urlString: track.album?.images.first?.url, primaryName: track.name, secondaryName: track.artists.first?.name, artist: false)
                                                    }
                                                case .artist(let artist):
                                                    Link(destination: URL(string: artist.external_urls["spotify"] ?? "")!) {
                                                        SearchResultView(urlString: artist.images.first?.url, primaryName: artist.name, artist: true)
                                                    }
                                                case .album(let album):
                                                    NavigationLink(destination: AlbumView(albumVM: AlbumViewModel(album: album))) {
                                                        SearchResultView(urlString: album.images.first?.url, primaryName: album.name, secondaryName: album.artists.first?.name, artist: false)
                                                    }
                                                case .playlist(let playlist):
                                                    NavigationLink(destination: PlaylistView(playlistVM: PlaylistViewModel(playlist: playlist))) {
                                                        SearchResultView(urlString: playlist.images.first?.url, primaryName: playlist.name, secondaryName: playlist.owner.display_name, artist: false)
                                                    }
                                                case .episode(let episode):
                                                    SearchResultView(urlString: episode.images.first?.url, primaryName: episode.name, secondaryName: episode.description, artist: false)
                                                case .show(let show):
                                                    SearchResultView(urlString: show.images.first?.url, primaryName: show.name, secondaryName: show.publisher, artist: false)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchTerm, prompt: Text("Songs, Artists, Albums"))
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.inline)
            .scrollIndicators(.hidden)
            .onChange(of: searchTerm) { _, term in
                searchVM.fetchSearchResults(with: term)
            }
        }
    }
}

struct SearchResultView: View {
    
    @State var urlString: String?
    @State var primaryName: String
    @State var secondaryName: String?
    
    @State var artist: Bool
    
    var body: some View {
        if let urlString = urlString, let imageURL = URL(string: urlString) {
            HStack (alignment: artist ? .center : .top) {
                if artist {
                    WebImage(url: imageURL)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 75, height: 75)
                        .cornerRadius(10.0)
                        .clipShape(Circle())
                } else {
                    WebImage(url: imageURL)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 75, height: 75)
                        .cornerRadius(10.0)
                }
                VStack (alignment: .leading, spacing: 5) {
                    Text("\(primaryName)")
                        .font(.custom("Teko", size: artist ? 25.0 : 15.0).bold())
                        .multilineTextAlignment(.leading)
                    Text("\(secondaryName ?? "")")
                        .font(.custom("Teko", size: 15.0))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
            }
            .padding(5)
        }
    }
}

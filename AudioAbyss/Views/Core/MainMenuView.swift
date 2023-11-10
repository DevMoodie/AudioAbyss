//
//  MainMenuView.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-04.
//

import SwiftUI
import SDWebImageSwiftUI

struct MainMenuView: View {
    @StateObject var mainMenuVM: MainMenuViewModel = MainMenuViewModel()
    @StateObject var profileVM: ProfileViewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (alignment: .leading) {
                    if let user = profileVM.user {
                        HStack (alignment: .top) {
                            if let urlString = user.images.first?.url, let imageURL = URL(string: urlString) {
                                WebImage(url: imageURL)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 45.0, height: 45.0)
                                    .cornerRadius(5.0)
                            }
                            VStack (alignment: .leading) {
                                Text("\(user.display_name)")
                                    .font(.custom("Teko", size: 18.0).bold())
                                Text("\(user.product)")
                                    .font(.custom("Teko", size: 13.0))
                            }
                        }
                    }
                    Text("The Best New Releases")
                        .font(.custom("Teko", size: 25.0).bold())
                    ScrollView (.horizontal, showsIndicators: false) {
                        LazyHStack {
                            if let newReleases = mainMenuVM.newReleases {
                                ForEach(newReleases.albums.items, id: \.self) { album in
                                    NavigationLink(destination: AlbumView(albumVM: AlbumViewModel(album: album))) {
                                        VStack (alignment: .leading) {
                                            if let urlString = album.images.first?.url, let imageURL = URL(string: urlString) {
                                                WebImage(url: imageURL)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 150, height: 150)
                                                    .cornerRadius(25.0)
                                            }
                                            Text("\(album.name)")
                                                .font(.custom("Teko", size: 20.0).bold())
                                                .lineLimit(1)
                                            Text("\(album.artists.first?.name ?? "")")
                                                .font(.custom("Teko", size: 15.0))
                                                .lineLimit(1)
                                        }
                                        .frame(width: 150)
                                    }
                                }
                            } else {
                                Text("Failed to load new releases!")
                                    .font(.custom("Teko", size: 20.0).bold())
                            }
                        }
                    }
                    .scrollClipDisabled()
                    .padding(.top, -10)
                    .padding(.bottom, 10)
                    Text("Featured Playlists")
                        .font(.custom("Teko", size: 25.0).bold())
                    ScrollView (.horizontal, showsIndicators: false) {
                        LazyHStack {
                            if let featuredPlaylists = mainMenuVM.featuredPlaylists {
                                ForEach(featuredPlaylists.playlists.items, id: \.self) { playlist in
                                    NavigationLink(destination: PlaylistView(playlistVM: PlaylistViewModel(playlist: playlist))) {
                                        VStack (alignment: .leading) {
                                            if let urlString = playlist.images.first?.url, let imageURL = URL(string: urlString) {
                                                WebImage(url: imageURL)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 150, height: 150)
                                                    .cornerRadius(25.0)
                                            }
                                            Text("\(playlist.name)")
                                                .font(.custom("Teko", size: 20.0).bold())
                                                .lineLimit(1)
                                            Text("\(playlist.owner.display_name)")
                                                .font(.custom("Teko", size: 15.0))
                                                .lineLimit(1)
                                        }
                                        .frame(width: 150)
                                    }
                                }
                            } else {
                                Text("Failed to load new releases!")
                                    .font(.custom("Teko", size: 20.0).bold())
                            }
                        }
                    }
                    .scrollClipDisabled()
                    .padding(.top, -10)
                    .padding(.bottom, 10)
                    Text("Recommendations")
                        .font(.custom("Teko", size: 25.0).bold())
                    ScrollView (.horizontal, showsIndicators: false) {
                        LazyHStack {
                            if let recommendations = mainMenuVM.recommendations {
                                ForEach(recommendations.tracks, id: \.self) { track in
                                    VStack (alignment: .leading) {
                                        if let urlString = track.album?.images.first?.url, let imageURL = URL(string: urlString) {
                                            WebImage(url: imageURL)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 150, height: 150)
                                                .cornerRadius(25.0)
                                        }
                                        Text("\(track.album?.name ?? "")")
                                            .font(.custom("Teko", size: 20.0).bold())
                                            .lineLimit(1)
                                        Text("\(track.artists.first?.name ?? "")")
                                            .font(.custom("Teko", size: 15.0))
                                            .lineLimit(1)
                                    }
                                    .frame(width: 150)
                                }
                            } else {
                                Text("Refresh")
                                    .font(.custom("Teko", size: 20.0).bold())
                                    .padding()
                                    .onTapGesture {
                                        mainMenuVM.fetchRecommendedGenres()
                                    }
                            }
                        }
                    }
                    .scrollClipDisabled()
                    .padding(.top, -10)
                    .padding(.bottom, 10)
                }
                .padding()
            }
        }
    }
}

#Preview {
    MainMenuView()
}

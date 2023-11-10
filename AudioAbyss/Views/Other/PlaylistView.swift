//
//  PlaylistView.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-04.
//

import SwiftUI
import SDWebImageSwiftUI

struct PlaylistView: View {
    @StateObject var playlistVM: PlaylistViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            if let _ = playlistVM.playlistDetails {
                VStack {
                    if let urlString = playlistVM.playlistDetails?.images.first?.url, let imageURL = URL(string: urlString) {
                        WebImage(url: imageURL)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .cornerRadius(30.0)
                            .padding()
                    }
                    HStack (alignment: .bottom) {
                        VStack (alignment: .leading) {
                            Text("\(playlistVM.playlistDetails?.name ?? "")")
                                .font(.custom("Teko", size: 25.0).bold())
                                .multilineTextAlignment(.center)
                            Text("\(playlistVM.playlistDetails?.description ?? "")")
                                .font(.custom("Teko", size: 15.0))
                                .multilineTextAlignment(.center)
                            Text("\(playlistVM.playlist?.owner.display_name ?? "")")
                                .font(.custom("Teko", size: 15.0))
                                .multilineTextAlignment(.center)
                                .padding(.bottom)
                        }
                        Spacer()
                        ZStack {
                            RoundedRectangle(cornerRadius: 25.0)
                                .frame(width: 100, height: 40)
                                .foregroundStyle(.foreground)
                            HStack {
                                Image(systemName: "play.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                                    .foregroundStyle(.background)
                                Text("Play All")
                                    .font(.custom("Teko", size: 20.0))
                                    .foregroundStyle(.background)
                            }
                        }
                        .frame(width: 100, height: 75)
                    }
                    .padding(.horizontal)
                    VStack (alignment: .leading) {
                        if let playlistTracks = playlistVM.playlistDetails?.tracks.items {
                            ForEach(playlistTracks, id: \.self) { track in
                                HStack (alignment: .top) {
                                    if let urlString = track.track.album?.images.first?.url, let imageURL = URL(string: urlString) {
                                        WebImage(url: imageURL)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 75, height: 75)
                                            .cornerRadius(10.0)
                                    }
                                    VStack (alignment: .leading, spacing: 5) {
                                        Text("\(track.track.name)")
                                            .font(.custom("Teko", size: 15.0).bold())
                                        Text("\(track.track.artists.first?.name ?? "")")
                                            .font(.custom("Teko", size: 15.0))
                                    }
                                }
                                .padding(5)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("\(playlistVM.playlist?.name ?? "")")
        .scrollIndicators(.hidden)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }, label: { Image(systemName: "arrow.backward") })
            }
        }
    }
}

//
//  AlbumView.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-08.
//

import SwiftUI
import SDWebImageSwiftUI

struct AlbumView: View {
    @StateObject var albumVM: AlbumViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            if let _ = albumVM.albumDetails {
                VStack {
                    if let urlString = albumVM.albumDetails?.images.first?.url, let imageURL = URL(string: urlString) {
                        WebImage(url: imageURL)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .cornerRadius(30.0)
                            .padding()
                    }
                    Text("\(albumVM.albumDetails?.name ?? "")")
                        .font(.custom("Teko", size: 25.0).bold())
                        .multilineTextAlignment(.center)
                    Text("\(albumVM.albumDetails?.artists.first?.name ?? "")")
                        .font(.custom("Teko", size: 15.0))
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    ZStack {
                        RoundedRectangle(cornerRadius: 25.0)
                            .frame(width: 80, height: 40)
                            .foregroundStyle(.foreground)
                        HStack {
                            Image(systemName: "play.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                                .foregroundStyle(.background)
                            Text("Play")
                                .font(.custom("Teko", size: 20.0))
                                .foregroundStyle(.background)
                        }
                    }
                    .frame(width: 100, height: 75)
                    .padding(.horizontal)
                    VStack (alignment: .leading) {
                        if let albumTracks = albumVM.albumDetails?.tracks.items {
                            ForEach(albumTracks, id: \.self) { track in
                                if let urlString = albumVM.albumDetails?.images.first?.url, let imageURL = URL(string: urlString) {
                                    NavigationLink(destination: PlayerView(playerVM: PlayerViewModel(track: track, albumImageURL: imageURL))) {
                                        HStack (alignment: .top) {
                                            WebImage(url: imageURL)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 75, height: 75)
                                                .cornerRadius(10.0)
                                            VStack (alignment: .leading, spacing: 5) {
                                                Text("\(track.name)")
                                                    .font(.custom("Teko", size: 15.0).bold())
                                                    .multilineTextAlignment(.leading)
                                                Text("\(track.artists.first?.name ?? "")")
                                                    .font(.custom("Teko", size: 15.0))
                                            }
                                            Spacer()
                                        }
                                        .frame(width: UIScreen.main.bounds.size.width / 1.05)
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom)
                }
            }
        }
        .navigationTitle("\(albumVM.album?.name ?? "")")
        .navigationBarTitleDisplayMode(.inline)
        .scrollIndicators(.hidden)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }, label: { Image(systemName: "arrow.backward").foregroundStyle(.foreground) })
            }
        }
    }
}

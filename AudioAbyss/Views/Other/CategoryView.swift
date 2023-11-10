//
//  CategoryView.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-09.
//

import SwiftUI
import SDWebImageSwiftUI

struct CategoryView: View {
    @StateObject var categoryVM: CategoryViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView (.vertical, showsIndicators: false) {
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                if let playlists = categoryVM.playlists {
                    ForEach(playlists, id: \.self) { playlist in
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
                    Text("Refresh")
                        .font(.custom("Teko", size: 20.0).bold())
                        .padding()
                        .onTapGesture {
                            categoryVM.fetchCategoryPlaylists(with: categoryVM.category)
                        }
                }
            }
        }
        .navigationTitle("\(categoryVM.category?.name ?? "")")
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

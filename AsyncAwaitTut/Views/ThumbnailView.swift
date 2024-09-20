//
//  ThumbnailView.swift
//  AsyncAwaitTut
//
//  Created by admin on 18.09.2024.
//

import SwiftUI

//struct ThumbnailView: View {
//    @ObservedObject var viewModel: ViewModel
//    var post: Post
//    @State private var image: UIImage?
//
//    var body: some View {
//        Image(uiImage: self.image ?? placeholder)
//            .onAppear {
//                Task {
//                    self.image = try? await self.viewModel.fetchThumbnail(for: post.id)
//                }
//            }
//    }
//}
//
//#Preview {
//    ThumbnailView(viewModel: ViewModel(), post: Post(name: "post name", imageURL: "image URl"))
//}

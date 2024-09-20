//
//  RestaurantRow.swift
//  AsyncAwaitTut
//
//  Created by admin on 18.09.2024.
//

import SwiftUI

struct RestaurantRow: View {
    var restaurant: Restaurant
    var body: some View {
        HStack {
            AsyncImage(
                url: URL(string: restaurant.image),
                            content: { image in
                                image.resizable()
                                     .aspectRatio(contentMode: .fit)
                                     .frame(maxWidth: 140, maxHeight: 140)
                                     .cornerRadius(10)
                            },
                            placeholder: {
                                ProgressView()
                            }
                        )
            Text(restaurant.name)
                .font(.system(size: 20, weight: .bold))
        }
    }
}

#Preview {
    RestaurantRow(restaurant: Restaurant.restaurants[0])
}

//
//  FarmerProfileView.swift
//  Agrismart
//
//  Created by Rohan Jain on 13/03/25.
//

import SwiftUI

struct FarmerProfileView: View {
    var farmer: User
    @State private var isFollowing = false

    var body: some View {
        VStack {
            // Farmer Profile Header
            HStack {
                Image(farmer.profile.profileImageUrl ?? "defaultProfileImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))

                VStack(alignment: .leading) {
                    Text(farmer.profile.name)
                        .font(.title)
                        .fontWeight(.bold)
                    Text("@\(farmer.profile.username)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    HStack {
                        ForEach(0..<5) { index in
                            Image(systemName: index < Int(farmer.metrics.rating) ? "star.fill" : "star")
                                .foregroundColor(index < Int(farmer.metrics.rating) ? .yellow : .gray)
                        }
                    }
                    Text("\(farmer.status.displayText)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding()

            // Follow and Message Buttons
            HStack {
                Button(action: {
                    isFollowing.toggle()
                }) {
                    Text(isFollowing ? "Following" : "Follow")
                        .padding()
                        .background(isFollowing ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Button(action: {
                    // Message action
                }) {
                    Text("Message")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()

            // Product List
            List {
                ForEach(SampleData.products.filter { $0.farmerId == farmer.id }) { product in
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        ProductRow(product: product)
                    }
                }
            }
        }
        .navigationBarTitle("\(farmer.profile.name)'s Profile", displayMode: .inline)
    }
}

struct ProductRow: View {
    var product: Product

    var body: some View {
        HStack {
            Image(product.imageNames.first ?? "placeholder_crop")
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                Text(product.formattedPrice)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
    }
}

struct ProductDetailView1: View {
    var product: Product

    var body: some View {
        VStack {
            Image(product.imageNames.first ?? "placeholder_crop")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
            Text(product.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(product.formattedPrice)
                .font(.title)
                .foregroundColor(.gray)
            Spacer()
        }
        .padding()
        .navigationBarTitle(Text(product.name), displayMode: .inline)
    }
}

// Sample Data for Preview
struct FarmerProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleFarmer = SampleData.farmers[0]
        NavigationView {
            FarmerProfileView(farmer: sampleFarmer)
        }
    }
}

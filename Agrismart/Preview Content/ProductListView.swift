////
////  ProductListView.swift
////  Agrismart
////
////  Created by Rohan Jain on 07/03/25.
////
import SwiftUI

struct ProductListView: View {
    @State private var searchText = ""
    @State private var products = SampleData.products
    let sampleFarmer = SampleData.farmers[0]

    @State private var filteredProducts = SampleData.products

    var body: some View {
        NavigationStack {
            VStack {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search products", text: $searchText, onCommit: filterProducts)
                        .foregroundColor(.black)
                        .padding()
                }
                .padding(.horizontal)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)

                // Product List
                List(filteredProducts) { product in
                    NavigationLink(destination: ProductDetailView(product: product, farmer: sampleFarmer)) {
                        ProductRow1(product: product)
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Explore")
            }
        }
        .onAppear {
            filterProducts()
        }
    }

    private func filterProducts() {
        if searchText.isEmpty {
            filteredProducts = products
        } else {
            filteredProducts = products.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}

struct ProductRow1: View {
    var product: Product

    var body: some View {
        HStack {
            if let imageName = product.imageNames.first {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .overlay(Text("No Image Available").foregroundColor(.gray))
            }
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                Text(product.formattedPrice)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                HStack {
                    Text(String(format: "%.1f", product.rating ?? 0))
                    Image(systemName: "star.fill").foregroundColor(.yellow)
                    Text("(\(product.reviewsCount))")
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// Preview
struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProductListView()
        }
    }
}

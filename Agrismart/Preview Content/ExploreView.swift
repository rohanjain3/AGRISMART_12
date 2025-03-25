//
//  ExploreView.swift
//  Agrismart
//
//  Created by Rohan Jain on 07/03/25.
//

import SwiftUI

// MARK: - ExploreView
struct ExploreView: View {
    @ObservedObject var cartManager = CartManager.shared // Observe CartManager globally

    @State private var farmers = convertUsersToFarmers(SampleData.farmers)
    @State private var cropCategories = convertProductsToCategories(SampleData.products)
    @State private var showPopup: Bool = false // State for showing the popup message
    @State private var popupMessage: String = "" // State for the popup message content

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Search Bar
                    searchBar
                    
                    // Farmer Profiles Section
                    farmerProfilesSection
                    
                    // Crop Categories Section
                    cropCategoriesSection
                }
            }
            .navigationTitle("AgriSmart")
            .toolbar {
                toolbarContent
            }
            .alert(isPresented: $showPopup) { // Display popup when showPopup is true
                Alert(title: Text("Success"), message: Text(popupMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    // MARK: Subviews
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            Text("Search for crops or farmers")
                .foregroundColor(.gray)
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding(.horizontal)
    }

    private var farmerProfilesSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Farmer Profile")
                    .font(.headline)
                Spacer()
                NavigationLink(destination: FarmersListView(farmers: farmers)) {
                    Text("View all")
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(farmers.prefix(4)) { farmer in
                    NavigationLink(destination: FarmerProfileView(farmer: SampleData.farmers[0])) {
                        FarmerCardView(farmer: farmer)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
        }
    }

    private var cropCategoriesSection: some View {
        VStack(alignment: .leading) {
            Text("Crop Categories")
                .font(.headline)
                .padding(.horizontal)

            ForEach(cropCategories) { category in
                cropCategorySection(for: category)
            }
        }
    }

    private func cropCategorySection(for category: CropCategory) -> some View {
        VStack(alignment: .leading) {
            Text(category.name)
                .font(.subheadline)
                .bold()
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(category.crops) { crop in
                        VStack {
                            NavigationLink(destination: ProductDetailView(product: crop.toProduct(), farmer: SampleData.farmers[0])) {
                                CropCardView(crop: crop)
                            }

                            // Add to Cart Button
                            Button(action: {
                                cartManager.addProduct(crop.toProduct(), quantity: 1) // Add crop to cart
                                popupMessage = "\(crop.name) has been added to the cart."
                                showPopup = true // Trigger popup
                            }) {
                                Text("Add to Cart")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.blue)
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private var toolbarContent: some View {
        HStack {
            NavigationLink(destination: AddToCartView()) {
                Image(systemName: "cart")
                    .overlay(
                        Text("\(cartManager.cartItems.count)") // Badge showing cart item count
                            .font(.footnote)
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Color.red)
                            .clipShape(Circle())
                            .offset(x: 10, y: -10)
                    )
            }
            NavigationLink(destination: NotificationView()) {
                Image(systemName: "bell")
            }
        }
    }
}

// MARK: - Helper Functions
func convertUsersToFarmers(_ users: [User]) -> [Farmer] {
    return users.map { user in
        Farmer(
            id: user.id,
            name: user.profile.name,
            imageName: user.profile.profileImageUrl ?? "placeholder_farmer",
            distance: Double.random(in: 1.5...15.0),
            rating: user.metrics.rating
        )
    }
}

func convertProductsToCategories(_ products: [Product]) -> [CropCategory] {
    let groupedProducts = Dictionary(grouping: products) { $0.category }
    return groupedProducts.map { (category, products) in
        CropCategory(
            name: category.rawValue.capitalized,
            crops: products.map { product in
                Crop(
                    id: product.id,
                    name: product.name,
                    imageName: product.imageNames.first ?? "placeholder_crop",
                    price: Double(product.pricePerKg),
                    originalProduct: product
                )
            }
        )
    }
}

// MARK: - View Model Structures
struct Farmer: Identifiable {
    let id: UUID
    let name: String
    let imageName: String
    let distance: Double
    let rating: Double
}

struct Crop: Identifiable {
    let id: UUID
    let name: String
    let imageName: String
    let price: Double
    let originalProduct: Product

    func toProduct() -> Product {
        return originalProduct
    }
}

struct CropCategory: Identifiable {
    let id = UUID()
    let name: String
    let crops: [Crop]
}

// MARK: - Supporting Views
struct CropCardView: View {
    let crop: Crop

    var body: some View {
        VStack {
            Image(crop.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipped()
                .cornerRadius(10)

            Text(crop.name)
                .font(.footnote)
                .lineLimit(1)

            Text("₹\(Int(crop.price))/kg")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(width: 120)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct FarmerCardView: View {
    let farmer: Farmer

    var body: some View {
        VStack {
            Image(farmer.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 100)
                .clipped()
                .cornerRadius(10)

            VStack(alignment: .leading) {
                Text(farmer.name)
                    .font(.headline)
                    .lineLimit(1)
                HStack {
                    Text("\(farmer.distance, specifier: "%.1f") km")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.gray)
                }
                HStack {
                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(farmer.rating) ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                    Text(String(format: "%.1f", farmer.rating))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding([.horizontal, .bottom])
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct FarmersListView: View {
    let farmers: [Farmer]

    var body: some View {
        List(farmers) { farmer in
            HStack {
                Image(farmer.imageName)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())

                VStack(alignment: .leading) {
                    Text(farmer.name)
                        .font(.headline)
                    Text("\(farmer.distance, specifier: "%.1f") km away")
                        .font(.subheadline)
                }
            }
        }
        .navigationTitle("All Farmers")
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}

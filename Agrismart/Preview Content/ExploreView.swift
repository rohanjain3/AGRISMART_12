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

    @State private var farmers = convertUsersToFarmers(SampleData.farmers) // Load all farmers initially
    @State private var cropCategories = convertProductsToCategories(SampleData.products) // Categorized crops
    @State private var crops: [Crop] = [] // Flattened list of all crops
    @State private var filteredFarmers: [Farmer] = [] // Filtered farmers based on search
    @State private var filteredCrops: [CropCategory] = [] // Filtered crop categories based on search
    @State private var searchText: String = "" // State for the search text
    @State private var showPopup: Bool = false // State for showing the popup message
    @State private var popupMessage: String = "" // State for the popup message content
    @State private var isSearching: Bool = false // Indicates if the user is actively searching

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
            .onAppear {
                crops = cropCategories.flatMap { $0.crops } // Flatten crops list on appearance
                filteredCrops = cropCategories // Initialize filtered crops with all categories
                applySearch() // Ensure all farmers and crops are displayed initially
            }
        }
    }

    // MARK: Subviews
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search for crops or farmers...", text: $searchText, onEditingChanged: { isEditing in
                isSearching = !searchText.isEmpty
                applySearch()
            }, onCommit: applySearch)
                .onChange(of: searchText, perform: { _ in applySearch() })
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                    isSearching = false
                    applySearch()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding(.horizontal)
    }

    private var farmerProfilesSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Farmer Profiles")
                    .font(.headline)
                Spacer()
                NavigationLink(destination: FarmersListView(farmers: farmers)) {
                    Text("View all")
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(Array(farmers.prefix(4))) { farmer in
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

            ForEach(filteredCrops) { category in
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
                            NavigationLink(destination: ProductDetailView(product: crop.toProduct(), farmer: SampleData.farmers.first(where: { $0.id == crop.originalProduct.farmerId }) ?? SampleData.farmers[0])) {
                                CropCardView(crop: crop)
                            }

                            // Add to Cart Button
                            Button(action: {
                                cartManager.addProduct(crop.toProduct(), quantity: 20) // Add crop to cart
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

    // MARK: - Helper Methods
    private func applySearch() {
        if searchText.isEmpty {
            // Show all farmers and crop categories if no search query
            filteredFarmers = farmers
            filteredCrops = cropCategories
        } else {
            // Filter farmers and crop categories based on search query
            filteredFarmers = farmers.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
            filteredCrops = cropCategories.map { category in
                CropCategory(
//                    id: category.id,
                    name: category.name,
                    crops: category.crops.filter { crop in
                        crop.name.lowercased().contains(searchText.lowercased())
                    }
                )
            }.filter { !$0.crops.isEmpty }
        }
    }
}

// MARK: - Supporting Functions and Models

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

// Card view for crops
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

// Card view for farmers
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

// List view for farmers
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

// MARK: - Product Detail View
struct ProductDetailView2: View {
    let product: Product
    let farmer: Farmer

    var body: some View {
        VStack {
            Image(product.imageNames.first ?? "placeholder_crop")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
            Text(product.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Price: ₹\(product.pricePerKg)/kg")
                .font(.title2)
                .foregroundColor(.gray)
            Text("Sold by: \(farmer.name)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
        .navigationBarTitle(Text(product.name), displayMode: .inline)
    }
}

// MARK: - Preview
struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}

//
//  ExploreView.swift
//  Agrismart
//
//  Created by Rohan Jain on 07/03/25.
//

import SwiftUI

// MARK: - ExploreView
struct ExploreView: View {
    @State private var farmers = convertUsersToFarmers(SampleData.farmers)
    @State private var cropCategories = convertProductsToCategories(SampleData.products)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Search Bar
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

                    // Farmer Profiles Section
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
                                FarmerCardView(farmer: farmer)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Crop Categories Section
                    VStack(alignment: .leading) {
                        Text("Crop Categories")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(cropCategories) { category in
                            VStack(alignment: .leading) {
                                Text(category.name)
                                    .font(.subheadline)
                                    .bold()
                                    .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(category.crops) { crop in
                                            NavigationLink(destination: ProductDetailView(product: crop.toProduct())) {
                                                CropCardView(crop: crop)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("AgriSmart")
            .toolbar {
                HStack {
                    NavigationLink(destination: AddToCartView()){
                        Image(systemName: "cart")
                    }
                    Image(systemName: "bell")
                }
            }
        }
    }
}

// MARK: - Helper functions
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
        let categoryName = String(describing: category).capitalized
        return CropCategory(
            name: categoryName,
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


//struct ExploreView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExploreView()
//    }
//}


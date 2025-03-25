//
//  ProductDetailView.swift
//  Agrismart
//
//  Created by Rohan Jain on 11/03/25.
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @State private var quantity: Int = 20
    @State private var pincodeText: String = ""
    @State private var isDeliveryAvailable: Bool? = nil
    @State private var showPincodeAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isAddedToCart: Bool
    let farmer: User // Farmer associated with the product

    init(product: Product, farmer: User) {
        self.product = product
        self.farmer = farmer
        self._isAddedToCart = State(initialValue: CartManager.shared.isProductInCart(product.id))
    }

    private let availablePincodes = ["560001", "110002", "400002", "700001", "500001"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Product Image
                if let imageName = product.imageNames.first {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: 250)
                        .cornerRadius(8)
                        .padding()
                }

                // Product Info Section
                VStack(alignment: .leading, spacing: 8) {
                    Text(product.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)

                    HStack {
                        Text(String(format: "%.1f", product.rating ?? 0))
                            .fontWeight(.medium)
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("(\(product.reviewsCount) Reviews)")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)

                    HStack {
                        Text("\u{20B9}")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("\(Int(product.pricePerKg)) per kg")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal)
                }

                // Quantity Selection Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Quantity").font(.headline)
                        .padding(.horizontal)
                    HStack {
                        Button(action: {
                            if quantity > 1 {
                                quantity -= 1
                            }
                        }) {
                            Image(systemName: "minus")
                                .frame(width: 44, height: 44)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                        Text("\(quantity) kg")
                            .font(.headline)
                        Button(action: { quantity += 1 }) {
                            Image(systemName: "plus")
                                .frame(width: 44, height: 44)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }

                // Add to Cart Button
                NavigationLink(destination: AddToCartView()) {
                    Button(action: {
                        if quantity >= 20 {
                            CartManager.shared.addProduct(product, quantity: quantity)
                            isAddedToCart = true
                        } else {
                            showAlert("Quantity must be at least 20 kg.")
                        }
                    }) {
                        HStack {
                            Image(systemName: isAddedToCart ? "cart.fill" : "cart")
                            Text(isAddedToCart ? "Added to Cart" : "Add to Cart")
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isAddedToCart ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                .padding()

                // Delivery Availability Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Delivery Availability").font(.headline)
                        .padding(.horizontal)
                    HStack {
                        TextField("Enter Pincode", text: $pincodeText)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        Button(action: { checkDeliveryAvailability() }) {
                            Text("Check")
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                    if let isAvailable = isDeliveryAvailable {
                        Text(isAvailable ? "Delivery available!" : "Sorry, delivery not available.")
                            .foregroundColor(isAvailable ? .green : .red)
                            .font(.subheadline)
                            .padding(.horizontal)
                    }
                }

                // Description Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description").font(.headline)
                        .padding(.horizontal)
                    Text(product.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }

                // Reviews Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Reviews").font(.headline)
                        .padding(.horizontal)
                    ForEach(product.reviews, id: \.self) { review in
                        VStack(alignment: .leading) {
                            Text(review)
                                .font(.subheadline)
                            Divider()
                        }
                    }
                }

                // Farmer Information Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Farmer Info").font(.headline)
                        .padding(.horizontal)
                    NavigationLink(destination: FarmerProfileView(farmer: farmer)) {
                        HStack {
                            Image(farmer.profile.profileImageUrl ?? "placeholder_farmer")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())

                            VStack(alignment: .leading) {
                                Text(farmer.profile.name)
                                    .font(.headline)
                                Text("View Farmer Profile")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }

                            Spacer()
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
            }
        }
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showPincodeAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddToCartView()) {
                    Image(systemName: "cart")
                        .foregroundColor(.blue)
                }
            }
        }
    }

    private func checkDeliveryAvailability() {
        if pincodeText.count != 6 {
            showAlert("Please enter a valid 6-digit pincode.")
            return
        }
        isDeliveryAvailable = availablePincodes.contains(pincodeText)
    }

    private func showAlert(_ message: String) {
        alertMessage = message
        showPincodeAlert = true
    }
}



// MARK: - Preview
struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleProduct = SampleData.products[0]
        let sampleFarmer = SampleData.farmers[0]
        NavigationView {
            ProductDetailView(product: sampleProduct, farmer: sampleFarmer)
                .navigationTitle(sampleProduct.name)
        }
    }
}

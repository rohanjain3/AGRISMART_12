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

    init(product: Product) {
        self.product = product
        self._isAddedToCart = State(initialValue: CartManager.shared.isProductInCart(product.id))
    }

    private let availablePincodes = ["560001", "110002", "400002", "700001", "500001"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageName = product.imageNames.first {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 200)
                        .cornerRadius(8)
                        .padding()
                        .centeredHorizontally()
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(maxWidth: 200)
                        .cornerRadius(8)
                        .padding()
                        .centeredHorizontally()
                        .overlay(Text("No Image Available").foregroundColor(.gray))
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(product.name)
                        .font(.title)
                        .fontWeight(.bold)

                    HStack {
                        Text(String(format: "%.1f", product.rating ?? 0))
                            .fontWeight(.medium)
                        Image(systemName: "star.fill").foregroundColor(.yellow)
                        Text("(\(product.reviewsCount))")
                            .foregroundColor(.gray)
                    }

                    HStack {
                        Text("\u{20B9}")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("\(Int(product.pricePerKg)) per kg")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 16) {
                    Text("Product Info").font(.title2).fontWeight(.bold)

                    HStack {
                        Text("Quantity").font(.headline)
                        Spacer()
                        HStack(spacing: 20) {
                            Button(action: {
                                if quantity > 1 {
                                    quantity -= 1
                                    if quantity < 20 {
                                        isAddedToCart = false
                                    }
                                } else {
                                    showAlert("Quantity cannot be less than 1")
                                }
                            }) {
                                Image(systemName: "minus")
                                    .frame(width: 44, height: 44)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                            Text("\(quantity)").font(.headline)
                            Button(action: {
                                quantity += 1
                            }) {
                                Image(systemName: "plus")
                                    .frame(width: 44, height: 44)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }

                    Text("Minimum 20 kg").font(.subheadline).foregroundColor(.gray)

                    NavigationLink(destination: AddToCartView(), isActive: $isAddedToCart) {
                        Button(action: {
                            if quantity >= 20 {
                                if isAddedToCart {
                                    isAddedToCart.toggle()
                                } else {
                                    CartManager.shared.addProduct(product)
                                    isAddedToCart = true
                                }
                            } else {
                                showAlert("Quantity must be at least 20 to add to cart")
                            }
                        }) {
                            HStack {
                                Image(systemName: isAddedToCart ? "cart" : "plus")
                                Text(isAddedToCart ? "Go to Cart" : "Add to Cart").fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Delivery Availability").font(.headline)

                    HStack {
                        TextField("Enter Pincode", text: $pincodeText)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        Button(action: { checkDeliveryAvailability() }) {
                            Text("Check")
                                .fontWeight(.medium)
                                .frame(width: 80)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }

                    if let isAvailable = isDeliveryAvailable {
                        Text(isAvailable ? "Delivery available!" : "Sorry, delivery not available.")
                            .foregroundColor(isAvailable ? .green : .red)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Description").font(.title2).fontWeight(.bold)
                    Text(product.description).font(.body).foregroundColor(.secondary)
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Reviews").font(.title2).fontWeight(.bold)

                    ForEach(product.reviews, id: \.self) { review in
                        VStack(alignment: .leading) {
                            HStack {
                                ForEach(0..<5) { index in
                                    Image(systemName: index < Int(product.rating ?? 0) ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                        .font(.system(size: 12))
                                }
                            }
                            Text(review).padding(.top, 4)
                            Divider().padding(.top, 8)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showPincodeAlert) {
            Alert(title: Text("Pincode Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func checkDeliveryAvailability() {
        if pincodeText.count != 6 {
            alertMessage = "Please enter a valid 6-digit pincode"
            showPincodeAlert = true
            return
        }
        isDeliveryAvailable = availablePincodes.contains(pincodeText)
    }

    private func showAlert(_ message: String) {
        alertMessage = message
        showPincodeAlert = true
    }
}

extension View {
    func centeredHorizontally() -> some View {
        HStack {
            Spacer()
            self
            Spacer()
        }
    }
}

// Preview provider
struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleProduct = SampleData.products[0]
        NavigationView {
            ProductDetailView(product: sampleProduct)
                .navigationTitle(sampleProduct.name)
        }
    }
}

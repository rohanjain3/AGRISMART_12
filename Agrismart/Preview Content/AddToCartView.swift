//
//  AddToCartView.swift
//  Agrismart
//
//  Created by Rohan Jain on 13/03/25.
//

import SwiftUI

struct AddToCartView: View {
    @State private var cartItems: [CartItem] = CartManager.shared.cartItems
    @State private var total: Double = CartManager.shared.cartItems.reduce(0) { $0 + (Double($1.pricePerUnit) * Double($1.quantity)) }

    var body: some View {
        NavigationView {
            VStack {
                // Total Amount
                Text("Total: ₹\(Int(total))")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                // Cart Items List
                List {
                    ForEach(cartItems.indices, id: \.self) { index in
                        CartItemRow(item: $cartItems[index], onUpdate: updateTotal)
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(PlainListStyle())

                // Proceed to Checkout Button
                Button(action: {
                    // Proceed to checkout action
                    // Uncomment and implement navigation to checkout view
                    // NavigationLink(destination: CheckoutView()) { EmptyView() }
                }) {
                    Text("Proceed to Checkout")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                .disabled(total <= 0)
            }
            .navigationTitle("Cart")
        }
    }

    private func updateTotal() {
        total = cartItems.reduce(0) { $0 + (Double($1.pricePerUnit) * Double($1.quantity)) }
    }

    private func deleteItems(at offsets: IndexSet) {
        cartItems.remove(atOffsets: offsets)
        updateTotal()
    }
}

struct CartItemRow: View {
    @Binding var item: CartItem
    var onUpdate: () -> Void

    var body: some View {
        HStack {
            if let imageName = item.imageName {
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
                Text(item.name)
                    .font(.headline)
                Text("₹\(item.pricePerUnit) per unit")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            VStack {
                HStack(spacing: 10) {
                    Button(action: {
                        if item.quantity > 20 {
                            item.quantity -= 1
                            onUpdate()
                        } else {
                            showAlert("Quantity cannot be less than 20")
                        }
                    }) {
                        Image(systemName: "minus")
                            .frame(width: 32, height: 32)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                    Text("\(item.quantity)")
                        .font(.headline)
                    Button(action: {
                        item.quantity += 1
                        onUpdate()
                    }) {
                        Image(systemName: "plus")
                            .frame(width: 32, height: 32)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                Text("Total: ₹\(item.pricePerUnit * item.quantity)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Quantity Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
}

// Preview
struct AddToCartView_Previews: PreviewProvider {
    static var previews: some View {
        AddToCartView()
    }
}

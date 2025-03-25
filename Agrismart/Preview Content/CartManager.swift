//
//  CartManager.swift
//  AgriSmart_12
//
//  Created by Rohan Jain on 20/01/25.
//

import Foundation

class CartManager: ObservableObject {
    static let shared = CartManager() // Singleton instance

    @Published var cartItems: [CartItem] = [] // Observable list of cart items

    private init() {}

    // Add a product to the cart
    func addProduct(_ product: Product, quantity: Int) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[index].quantity += quantity
        } else {
            let cartItem = CartItem(product: product, quantity: quantity)
            cartItems.append(cartItem)
        }
    }

    // Remove a product from the cart
    func removeProduct(_ productId: UUID) {
        cartItems.removeAll(where: { $0.product.id == productId })
    }

    // Check if a product is in the cart
    func isProductInCart(_ productId: UUID) -> Bool {
        return cartItems.contains(where: { $0.product.id == productId })
    }

    // Clear the cart after successful order placement
    func clearCart() {
        cartItems.removeAll()
    }
}

struct CartItem: Identifiable {
    let id = UUID()
    let product: Product
    var quantity: Int

    // Convenience properties
    var name: String { product.name }
    var pricePerUnit: Double { product.pricePerKg }
    var imageName: String? { product.imageNames.first }
}

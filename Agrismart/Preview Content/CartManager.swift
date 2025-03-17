//
//  CartManager.swift
//  AgriSmart_12
//
//  Created by Rohan Jain on 20/01/25.
//

import Foundation

class CartManager {

    static let shared = CartManager()
    private init() {}
    
    private(set) var cartItems: [CartItem] = []
    
    func addProduct(_ product: Product) {
        if let index = cartItems.firstIndex(where: { $0.id == product.id }) {
            cartItems[index].quantity += 1
        } else {
            let cartItem = CartItem(product: product)
            cartItems.append(cartItem)
        }
    }

    func removeProduct(_ productId: UUID) {
        if let index = cartItems.firstIndex(where: { $0.id == productId }) {
            cartItems.remove(at: index)
        }
    }

    func isProductInCart(_ productId: UUID) -> Bool {
        return cartItems.contains(where: { $0.id == productId })
    }
}

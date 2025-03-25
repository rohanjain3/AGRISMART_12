//
//  OrderHistoryView.swift
//  Agrismart
//
//  Created by Rohan Jain on 22/03/25.
//

import SwiftUI

import Foundation

class OrderManager: ObservableObject {
    static let shared = OrderManager() // Singleton instance

    @Published private(set) var orders: [Order] = [] // Dynamic updates via @Published

    private init() {}

    // Save a new order
    func saveOrder(_ order: Order) {
        orders.append(order) // Add the new order to the list
    }

    // Retrieve all orders
    func getOrders() -> [Order] {
        return orders
    }

    // Clear all orders (optional for testing/resetting)
    func clearOrders() {
        orders.removeAll()
    }
}

import SwiftUI

struct OrderHistoryView: View {
    @ObservedObject var orderManager = OrderManager.shared // Observe OrderManager for updates

    var body: some View {
        NavigationView {
            VStack {
                if orderManager.orders.isEmpty {
                    Text("No orders placed yet.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(orderManager.orders) { order in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(order.fullName)
                                .font(.headline)
                            Text(order.address)
                                .foregroundColor(.gray)
                            Text("\(order.city), \(order.state) - \(order.zipCode)")
                                .foregroundColor(.gray)
                            HStack {
                                Text("Total:")
                                Spacer()
                                Text("₹\(String(format: "%.2f", order.total))")
                                    .foregroundColor(.blue)
                            }
                            .font(.subheadline)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .navigationTitle("Order History")
        }
    }
}

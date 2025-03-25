//
//  CheckoutView.swift
//  Agrismart
//
//  Created by Rohan Jain on 22/03/25.
//

import SwiftUI

struct CheckoutView: View {
    let totalAmount: Double // Passed from AddToCartView
    
    @State private var fullName: String = ""
    @State private var addressLine1: String = ""
    @State private var addressLine2: String = "" // Optional
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var zipCode: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToHome: Bool = false
    @State private var states = [
        "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh", "Goa",
        "Gujarat", "Haryana", "Himachal Pradesh", "Jharkhand", "Karnataka", "Kerala",
        "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram", "Nagaland",
        "Odisha", "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura",
        "Uttar Pradesh", "Uttarakhand", "West Bengal", "Delhi", "Puducherry", "Ladakh",
        "Jammu and Kashmir"
    ]
    
    @Environment(\.presentationMode) var presentationMode // To navigate back to home
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Order Summary
                VStack(alignment: .leading, spacing: 8) {
                    Text("Order Summary")
                        .font(.headline)
                    HStack {
                        Text("Total")
                        Spacer()
                        Text("₹\(String(format: "%.2f", totalAmount))")
                    }
                    Divider()
                }
                .padding()
                
                // Delivery Details Form
                VStack(alignment: .leading, spacing: 16) {
                    Text("Delivery Details").font(.headline)
                    
                    TextField("Full Name", text: $fullName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextField("Address Line 1", text: $addressLine1)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextField("Address Line 2 (Optional)", text: $addressLine2)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextField("City", text: $city)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    // State Dropdown
                    VStack(alignment: .leading) {
                        Text("State").font(.subheadline)
                            .padding(.horizontal)
                        Menu {
                            ForEach(states, id: \.self) { state in
                                Button(action: {
                                    self.state = state
                                }) {
                                    Text(state)
                                }
                            }
                        } label: {
                            HStack {
                                Text(state.isEmpty ? "Select State" : state)
                                    .foregroundColor(state.isEmpty ? .gray : .black)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        }
                    }
                    
                    TextField("ZIP Code", text: $zipCode)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                .padding(.top)
                
                // Place Order Button
                Button(action: placeOrder) {
                    Text("Place Order")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(8)
                        .padding()
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Order Placed"),
                    message: Text("Your order has been successfully placed."),
                    dismissButton: .default(Text("OK")) {
                        // Navigate to the home screen
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // CheckoutView - Place Order Logic
    private func placeOrder() {
        if fullName.isEmpty || addressLine1.isEmpty || city.isEmpty || state.isEmpty || zipCode.isEmpty {
            // Handle validation errors
            alertMessage = "Please fill in all required fields."
            showAlert = true
            return
        }
        
        // Create the order object
        let order = Order(
            id: UUID(),
            fullName: fullName,
            address: "\(addressLine1), \(addressLine2)",
            city: city,
            state: state,
            zipCode: zipCode,
            total: totalAmount // Total from cart or checkout
        )
        
        // Save the order
        OrderManager.shared.saveOrder(order)
        
        // Clear the cart after placing the order
        CartManager.shared.clearCart()
        
        // Show confirmation message or redirect
        alertMessage = "Your order has been placed successfully!"
        showAlert = true
    }
}

import SwiftUI

struct AddToCartView: View {
    @State private var cartItems: [CartItem] = CartManager.shared.cartItems // Use CartManager's shared cart items
    @State private var total: Double = 0.0 // Total cart amount

    var body: some View {
        NavigationView {
            VStack {
                // Total Amount Display
                Text("Total: ₹\(Int(total))")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                // Cart Items List
                if cartItems.isEmpty {
                    Text("Your cart is empty")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(cartItems.indices, id: \.self) { index in
                            CartItemRow(item: $cartItems[index], onUpdate: updateTotal)
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(PlainListStyle())
                }

                // Proceed to Checkout Button
                NavigationLink(destination: CheckoutView(totalAmount: total)) {
                                    Text("Proceed to Checkout")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(total > 0 ? Color.blue : Color.gray)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                .padding()
                                .disabled(total <= 0) // Disable if cart is empty

            }
            .navigationTitle("Cart")
            .onAppear(perform: updateTotal) // Update the total when the view appears
        }
    }

    // Function to recalculate total amount
    private func updateTotal() {
        total = cartItems.reduce(0) { result, cartItem in
            result + (cartItem.pricePerUnit * Double(cartItem.quantity))
        }
    }

    // Function to delete a cart item
    private func deleteItems(at offsets: IndexSet) {
        cartItems.remove(atOffsets: offsets)
        CartManager.shared.cartItems = cartItems // Update CartManager's shared cart items
        updateTotal() // Recalculate total
    }
}

struct CartItemRow: View {
    @Binding var item: CartItem
    var onUpdate: () -> Void // Callback to update total

    var body: some View {
        HStack {
            // Item Image
            itemImage

            // Item Details
            itemDetails

            Spacer()

            // Quantity Controls
            quantityControls
        }
        .padding(.vertical, 8)
    }

    // Display the image of the cart item
    private var itemImage: some View {
        Group {
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
                    .overlay(Text("No Image").foregroundColor(.gray))
            }
        }
    }

    // Display details of the cart item
    private var itemDetails: some View {
        VStack(alignment: .leading) {
            Text(item.name)
                .font(.headline)
            Text("₹\(item.pricePerUnit, specifier: "%.2f") per unit")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("Total: ₹\(item.pricePerUnit * Double(item.quantity), specifier: "%.2f")")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }

    // Controls to increment or decrement item quantity
    private var quantityControls: some View {
        HStack(spacing: 10) {
            decrementButton
            Text("\(item.quantity)")
                .font(.headline)
            incrementButton
        }
    }

    // Button to decrement item quantity
    private var decrementButton: some View {
        Button(action: {
            if item.quantity > 1 {
                item.quantity -= 1
                onUpdate() // Notify parent view to update total
            }
        }) {
            Image(systemName: "minus")
                .frame(width: 32, height: 32)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }

    // Button to increment item quantity
    private var incrementButton: some View {
        Button(action: {
            item.quantity += 1
            onUpdate() // Notify parent view to update total
        }) {
            Image(systemName: "plus")
                .frame(width: 32, height: 32)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }
}

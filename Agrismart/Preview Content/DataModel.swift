//
//  DataModel.swift
//  Agrismart
//
//  Created by Rohan Jain on 07/03/25.
//

import Foundation
import UIKit

// MARK: - User Base Models

// Enum representing different user roles: buyer or farmer
enum UserRole {
    case buyer
    case farmer
}

// Struct to hold user information
//struct User {
//    let id: UUID
//    var role: UserRole      // buyer or farmer
//    var profile: Profile    // User profile details
//    var settings: UserSettings  // User settings (notifications, etc.)
//    var status: UserStatus   // User online/offline status
//    var metrics: UserMetrics  // User activity metrics
//}
struct User: Identifiable {
    let id: UUID
    var role: UserRole
    var profile: Profile
    var settings: UserSettings
    var status: UserStatus
    var metrics: UserMetrics
}

// Struct for user profile details
struct Profile {
    var name: String
    var username: String
    var email: String
    var contactNumber: String
    var dateOfBirth: Date
    var countryRegion: String
    var joinedDate: Date
    var profileImageUrl: String?  // Optional profile image URL
    var defaultAddress: Address?  // Optional default address
    var savedAddresses: [Address]  // List of saved addresses
}

// MARK: - Address Model

// Struct representing a physical address
struct Address {
    var fullName: String
    var addressLine1: String
    var addressLine2: String?
    var city: String
    var state: String
    var zipCode: String
    var contactNumber: String
    
    // Computed property to return the full address in a formatted way
    var formattedAddress: String {
        return [addressLine1, addressLine2, "\(city), \(state)", zipCode]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
}

// Struct to hold user activity metrics (posts, comments, ratings)
struct UserMetrics {
    var postCount: Int
    var commentCount: Int
    var isTopContributor: Bool
    var rating: Double
    var reviewCount: Int
}

// Struct for user settings (e.g., notifications, dark mode)
struct UserSettings {
    var pushNotificationsEnabled: Bool
    var darkModeEnabled: Bool
    var emailNotificationsEnabled: Bool
}

// Enum for representing user online/offline status
enum UserStatus {
    case online
    case offline
    case lastSeen(Date)
    
    // Computed property to return user status as a string
    var displayText: String {
        switch self {
        case .online:
            return "Online Now"
        case .offline:
            return "Offline"
        case .lastSeen(let date):
            let formatter = RelativeDateTimeFormatter()
            return "Last seen " + formatter.localizedString(for: date, relativeTo: Date())
        }
    }
}

// MARK: - Product/Crop Models

// Struct representing a product (crop) for sale
struct Product: Identifiable {
    let id: UUID
    var name: String
    var category: ProductCategory
    var pricePerKg: Double
    var quantityAvailable: Double
    var originalQuantity: Double
    var description: String
    var imageNames: [String] // Changed from imageUrls to imageNames
    var imageUrls: [String]
    var status: ProductStatus
    var expiryDate: Date
    var farmerId: UUID
    var rating: Double?
    var reviewsCount: Int
    var reviews: [String] // Array to store reviews
    
    // Computed property to calculate the percentage of product left
    var percentageLeft: Int {
        Int((quantityAvailable / originalQuantity) * 100)
    }
    
    // Computed property to return formatted price per kg
    var formattedPrice: String {
        return "₹\(Int(pricePerKg)) per kg"
    }
}

// Enum representing different product categories
enum ProductCategory: String, CaseIterable {
    case vegetables = "Vegetables"
    case fruits = "Fruits"
    case grains = "Grains"
    case pulses = "Pulses"
    case dairy = "Dairy"
    case spices = "Spices"
    case organic = "Organic"
}

// Enum for product status (Available, Sold Out, Expired)
enum ProductStatus: String {
    case available = "Available"
    case soldOut = "Sold Out"
    case expired = "Expired"
    
    // Computed property to return a color representation for product status
    var displayColor: String {
        switch self {
        case .available: return "green"
        case .soldOut: return "gray"
        case .expired: return "red"
        }
    }
}

// MARK: - Order Models

struct OrderHistory: Codable {
    let orderId: String
    let items: [CartItem1]
    let totalPrice: Double
    let shippingCost: Double
    let orderDate: Date
}


// Struct for an order, containing multiple items
struct Order: Identifiable {
    let id: UUID
   // var items: [OrderItem]
    let fullName: String
    let address: String
    let city: String
    let state: String
    let zipCode: String
    let total: Double
  //  var shippingAddress: Address
  //  var status: OrderStatus
  //  var createdAt: Date
    
    // Computed property to calculate the total amount of the order
//    var totalAmount: Double {
//        return items.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
//    }
}

// Struct for an individual order item (product)
struct OrderItem {
    var product: Product
    var quantity: Int
    var price: Double
}

// Enum representing the status of an order
enum OrderStatus {
    case pending
    case approved
    case processing
    case shipped
    case delivered
    case cancelled
}

// MARK: - Cart Model

struct CartItem1: Codable {
    let id: UUID
    
    let name: String
    let details: String
    let pricePerUnit: Int
    var quantity: Int
    let imageName: String? // Name of the image asset
    
    // Initializer to convert Product to CartItem
    init(product: Product) {
        self.id = product.id
        self.name = product.name
        self.details = product.description
        self.pricePerUnit = Int(product.pricePerKg)
        self.quantity = 1
        self.imageName = product.imageNames.first
    }
}

// Struct for a cart, containing multiple items
struct Cart {
    var items: [OrderItem]
    
    // Computed property to calculate the subtotal of the cart
    var subtotal: Double {
        return items.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }
    
    // Computed property to calculate shipping cost (fixed value of 200)
    var shippingCost: Double {
        return subtotal > 0 ? 200 : 0 // Fixed shipping cost
    }
    
    // Computed property to calculate the total cost (including shipping)
    var total: Double {
        return subtotal + shippingCost
    }
}

// MARK: - Communication Models

// Struct for messages exchanged between users
struct Message: Identifiable {
    let id: UUID
    let senderId: UUID
    let receiverId: UUID
    let content: String
    let timestamp: Date
    var isRead: Bool
    var attachedProductId: UUID?
    var attachedImageUrl: String?
    
    // Computed property to return a formatted time string for the message
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
}

// MARK: - Social Mode
// Struct representing a social media post by a user
struct Post: Identifiable {
    let id: UUID
    let title: String
    let content: String
    let authorId: UUID
    let timestamp: Date
    var imageUrls: [String]
    var likes: Int
    var comments: [Comment]
}

// Struct representing a comment on a post
struct Comment: Identifiable {
    let id: UUID
    let content: String
    let authorId: UUID
    let timestamp: Date
    var likes: Int
    var replies: [Comment]
}

// MARK: - Notification Model

// Struct representing a notification for the user
struct Notification: Identifiable {
    let id: UUID
    var type: NotificationType
    var title: String
    var message: String
    var timestamp: Date
    var isRead: Bool
    var relatedId: UUID?
    var senderId: UUID?
}

// Enum for different types of notifications
enum NotificationType {
    case newOrder
    case orderStatus
    case chatMessage
    case postLike
    case postComment
    case priceUpdate
    case systemAlert
    case weatherAlert
    case marketUpdate
    case governmentScheme
}

// MARK: - Validation Helpers

// Struct for validating product data
struct ProductValidation {
    static func validateName(_ name: String) -> Bool {
        return !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    static func validatePrice(_ price: Double) -> Bool {
        return price > 0
    }
    
    static func validateQuantity(_ quantity: Double) -> Bool {
        return quantity > 0
    }
    
    static func validateExpiryDate(_ date: Date) -> Bool {
        return date > Date()
    }
    
    static func validateDescription(_ description: String) -> Bool {
        return description.trimmingCharacters(in: .whitespaces).count >= 10
    }
}

// MARK: - Extensions

// Extension for User to update profile and check user status
extension User {
    mutating func updateProfile(with newProfile: Profile) {
        self.profile = newProfile
    }

    mutating func updateSettings(with newSettings: UserSettings) {
        self.settings = newSettings
    }

    func isUserTopContributor() -> Bool {
        return self.metrics.isTopContributor
    }
}

// Extension for Profile to manage addresses
extension Profile {
    mutating func addAddress(_ address: Address) {
        savedAddresses.append(address)
    }
    
    mutating func updateDefaultAddress(to address: Address) {
        self.defaultAddress = address
    }
    
    func hasValidContactNumber() -> Bool {
        return contactNumber.count >= 10 && contactNumber.allSatisfy { $0.isNumber }
    }
}

// Extension for Product to manage quantity and validation
extension Product {
    mutating func updateQuantity(_ newQuantity: Double) {
        guard newQuantity >= 0 else { return }
        self.quantityAvailable = newQuantity
    }

    func isAvailable() -> Bool {
        return status == .available && quantityAvailable > 0
    }

    func validateProduct() -> Bool {
        return ProductValidation.validateName(name) &&
               ProductValidation.validatePrice(pricePerKg) &&
               ProductValidation.validateQuantity(quantityAvailable) &&
               ProductValidation.validateExpiryDate(expiryDate) &&
               ProductValidation.validateDescription(description)
    }
}

// Extension for Cart to manage items
extension Cart {
    mutating func addItem(_ item: OrderItem) {
        items.append(item)
    }
    
    mutating func removeItem(byProductId productId: UUID) {
        items.removeAll { $0.product.id == productId }
    }
    
    func isEmpty() -> Bool {
        return items.isEmpty
    }
}

// Extension for Address to check if it's complete
extension Address {
    func isComplete() -> Bool {
        return !fullName.isEmpty &&
               !addressLine1.isEmpty &&
               !city.isEmpty &&
               !state.isEmpty &&
               !zipCode.isEmpty &&
               !contactNumber.isEmpty
    }
}

// Extension for Order to update status and get summary
//extension Order {
//    mutating func updateStatus(to newStatus: OrderStatus) {
//        self.status = newStatus
//    }
//    
//    func getSummary() -> String {
//        let itemCount = items.count
//        return "Order ID: \(id)\nItems: \(itemCount)\nTotal: \(totalAmount)\nStatus: \(status)"
//    }
//}

// Extension for Notification to manage read/unread status
extension Notification {
    mutating func markAsRead() {
        self.isRead = true
    }

    func isSystemNotification() -> Bool {
        return type == .systemAlert || type == .marketUpdate || type == .weatherAlert
    }
}

// Extension for Post to manage comments and likes
extension Post {
    mutating func addComment(_ comment: Comment) {
        comments.append(comment)
    }

    mutating func likePost() {
        likes += 1
    }
}

// Extension for Comment to manage replies and likes
extension Comment {
    mutating func addReply(_ reply: Comment) {
        replies.append(reply)
    }
    
    mutating func likeComment() {
        likes += 1
    }
}

// Extension for ProductValidation to validate user
extension ProductValidation {
    static func validateUser(_ user: User) -> Bool {
        return !user.profile.name.isEmpty &&
               user.profile.hasValidContactNumber()
    }
}

// Example User
var user = User(
    id: UUID(),
    role: .buyer,
    profile: Profile(
        name: "John Doe",
        username: "johndoe123",
        email: "john@example.com",
        contactNumber: "9876543210",
        dateOfBirth: Date(),
        countryRegion: "USA",
        joinedDate: Date(),
        profileImageUrl: nil,
        defaultAddress: nil,
        savedAddresses: []
    ),
    settings: UserSettings(pushNotificationsEnabled: true, darkModeEnabled: false, emailNotificationsEnabled: true),
    status: .online,
    metrics: UserMetrics(postCount: 10, commentCount: 5, isTopContributor: true, rating: 4.8, reviewCount: 12)
)

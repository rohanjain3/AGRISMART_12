//
//  SampleData.swift
//  Agrismart
//
//  Created by Rohan Jain on 07/03/25.
//

import Foundation
    struct SampleData {
        // Sample data for 5 farmers
        static let farmers: [User] = [
            User(
                id: UUID(),
                role: .farmer,
                profile: Profile(
                    name: "John Farmer",
                    username: "john123",
                    email: "john@example.com",
                    contactNumber: "9876543210",
                    dateOfBirth: Date(),
                    countryRegion: "India",
                    joinedDate: Date().addingTimeInterval(-2 * 365 * 24 * 60 * 60),
                    profileImageUrl: "farm1", // Added image name
                    defaultAddress: Address(
                        fullName: "John Farmer",
                        addressLine1: "123 Greenfield Lane",
                        addressLine2: nil,
                        city: "Mumbai",
                        state: "Maharashtra",
                        zipCode: "400001",
                        contactNumber: "9876543210"
                    ),
                    savedAddresses: []
                ),
                settings: UserSettings(pushNotificationsEnabled: true, darkModeEnabled: false, emailNotificationsEnabled: true),
                status: .online,
                metrics: UserMetrics(postCount: 5, commentCount: 3, isTopContributor: false, rating: 4.5, reviewCount: 10)
            ),
            User(
                id: UUID(),
                role: .farmer,
                profile: Profile(
                    name: "Alice Grower",
                    username: "alice_grower",
                    email: "alice@example.com",
                    contactNumber: "9876543211",
                    dateOfBirth: Date(),
                    countryRegion: "India",
                    joinedDate: Date().addingTimeInterval(-1 * 365 * 24 * 60 * 60),
                    profileImageUrl: "farm2", // Added image name
                    defaultAddress: Address(
                        fullName: "Alice Grower",
                        addressLine1: "456 Orchard Drive",
                        addressLine2: "Near Green Park",
                        city: "Delhi",
                        state: "Delhi",
                        zipCode: "110001",
                        contactNumber: "9876543211"
                    ),
                    savedAddresses: []
                ),
                settings: UserSettings(pushNotificationsEnabled: true, darkModeEnabled: true, emailNotificationsEnabled: false),
                status: .offline,
                metrics: UserMetrics(postCount: 8, commentCount: 6, isTopContributor: true, rating: 4.7, reviewCount: 15)
            ),
            User(
                id: UUID(),
                role: .farmer,
                profile: Profile(
                    name: "Raj Patel",
                    username: "raj_patel",
                    email: "raj@example.com",
                    contactNumber: "9876543212",
                    dateOfBirth: Date(),
                    countryRegion: "India",
                    joinedDate: Date().addingTimeInterval(-3 * 365 * 24 * 60 * 60),
                    profileImageUrl: "farm3", // Added image name
                    defaultAddress: Address(
                        fullName: "Raj Patel",
                        addressLine1: "789 Riverbend Road",
                        addressLine2: nil,
                        city: "Ahmedabad",
                        state: "Gujarat",
                        zipCode: "380001",
                        contactNumber: "9876543212"
                    ),
                    savedAddresses: []
                ),
                settings: UserSettings(pushNotificationsEnabled: false, darkModeEnabled: true, emailNotificationsEnabled: true),
                status: .lastSeen(Date().addingTimeInterval(-1 * 24 * 60 * 60)),
                metrics: UserMetrics(postCount: 12, commentCount: 9, isTopContributor: false, rating: 4.2, reviewCount: 20)
            ),
            User(
                id: UUID(),
                role: .farmer,
                profile: Profile(
                    name: "Meera Shah",
                    username: "meera_shah",
                    email: "meera@example.com",
                    contactNumber: "9876543213",
                    dateOfBirth: Date(),
                    countryRegion: "India",
                    joinedDate: Date().addingTimeInterval(-4 * 365 * 24 * 60 * 60),
                    profileImageUrl: "farm4", // Added image name
                    defaultAddress: Address(
                        fullName: "Meera Shah",
                        addressLine1: "101 Harvest Hills",
                        addressLine2: "Apartment 203",
                        city: "Chennai",
                        state: "Tamil Nadu",
                        zipCode: "600001",
                        contactNumber: "9876543213"
                    ),
                    savedAddresses: []
                ),
                settings: UserSettings(pushNotificationsEnabled: true, darkModeEnabled: false, emailNotificationsEnabled: true),
                status: .online,
                metrics: UserMetrics(postCount: 15, commentCount: 12, isTopContributor: true, rating: 4.9, reviewCount: 30)
            ),
            User(
                id: UUID(),
                role: .farmer,
                profile: Profile(
                    name: "Amit Verma",
                    username: "amit_verma",
                    email: "amit@example.com",
                    contactNumber: "9876543214",
                    dateOfBirth: Date(),
                    countryRegion: "India",
                    joinedDate: Date().addingTimeInterval(-5 * 365 * 24 * 60 * 60),
                    profileImageUrl: "farm5", // Added image name
                    defaultAddress: Address(
                        fullName: "Amit Verma",
                        addressLine1: "222 Countryside View",
                        addressLine2: nil,
                        city: "Lucknow",
                        state: "Uttar Pradesh",
                        zipCode: "226001",
                        contactNumber: "9876543214"
                    ),
                    savedAddresses: []
                ),
                settings: UserSettings(pushNotificationsEnabled: false, darkModeEnabled: true, emailNotificationsEnabled: false),
                status: .lastSeen(Date().addingTimeInterval(-7 * 24 * 60 * 60)),
                metrics: UserMetrics(postCount: 10, commentCount: 8, isTopContributor: false, rating: 4.0, reviewCount: 12)
            )
        ]


        // Sample products for farmers
        static let products: [Product] = [
            Product(
                id: UUID(),
                name: "Tomatoes",
                category: .vegetables, // Updated category
                pricePerKg: 50,
                quantityAvailable: 100,
                originalQuantity: 100,
                description: "Fresh organic tomatoes.",
                imageNames: ["tomato"], // Updated to use imageNames
                imageUrls: [], // Not used anymore
                status: .available,
                expiryDate: Date().addingTimeInterval(7 * 24 * 60 * 60),
                farmerId: farmers[0].id,
                rating: 4.5,
                reviewsCount: 20,
                reviews: ["Very fresh and juicy", "Excellent taste"]
            ),
            Product(
                id: UUID(),
                name: "Mangoes",
                category: .fruits,
                pricePerKg: 120,
                quantityAvailable: 50,
                originalQuantity: 50,
                description: "Juicy Alphonso mangoes.",
                imageNames: ["mango"], // Updated to use imageNames
                imageUrls: [],
                status: .available,
                expiryDate: Date().addingTimeInterval(10 * 24 * 60 * 60),
                farmerId: farmers[1].id,
                rating: 4.8,
                reviewsCount: 30,
                reviews: ["Sweet and tangy", "Best mangoes I've ever had"]
            ),
            Product(
                id: UUID(),
                name: "Wheat",
                category: .grains,
                pricePerKg: 30,
                quantityAvailable: 500,
                originalQuantity: 500,
                description: "High-quality wheat grains.",
                imageNames: ["wheat"], // Updated to use imageNames
                imageUrls: [],
                status: .available,
                expiryDate: Date().addingTimeInterval(15 * 24 * 60 * 60),
                farmerId: farmers[2].id,
                rating: 4.4,
                reviewsCount: 25,
                reviews: ["Fine grains", "Very good quality wheat"]
            ),
            Product(
                id: UUID(),
                name: "Milk",
                category: .dairy,
                pricePerKg: 60,
                quantityAvailable: 200,
                originalQuantity: 200,
                description: "Fresh cow's milk.",
                imageNames: ["milk"], // Updated to use imageNames
                imageUrls: [],
                status: .available,
                expiryDate: Date().addingTimeInterval(3 * 24 * 60 * 60),
                farmerId: farmers[3].id,
                rating: 4.9,
                reviewsCount: 40,
                reviews: ["Fresh and creamy", "Best milk in town"]
            ),
            Product(
                id: UUID(),
                name: "Chilies",
                category: .spices,
                pricePerKg: 90,
                quantityAvailable: 20,
                originalQuantity: 20,
                description: "Spicy red chilies.",
                imageNames: ["chilie"], // Updated to use imageNames
                imageUrls: [],
                status: .available,
                expiryDate: Date().addingTimeInterval(5 * 24 * 60 * 60),
                farmerId: farmers[4].id,
                rating: 4.3,
                reviewsCount: 15,
                reviews: ["Spicy and fresh", "Adds great flavor to dishes"]
            ),
            Product(id: UUID(), name: "Cabbage", category: .vegetables, pricePerKg: 30, quantityAvailable: 150, originalQuantity: 150, description: "Fresh green cabbage.", imageNames: ["cabbage"], imageUrls: [], status: .available, expiryDate: Date().addingTimeInterval(7 * 24 * 60 * 60), farmerId: farmers[0].id, rating: 4.6, reviewsCount: 7, reviews: ["Fresh and crispy", "Great quality", "Value for money", "Perfect for salads", "Farm fresh", "Loved it", "Amazing taste"]),
            Product(id: UUID(), name: "Strawberries", category: .fruits, pricePerKg: 200, quantityAvailable: 60, originalQuantity: 60, description: "Sweet and juicy strawberries.", imageNames: ["strawberries"], imageUrls: [], status: .available, expiryDate: Date().addingTimeInterval(6 * 24 * 60 * 60), farmerId: farmers[0].id, rating: 4.7, reviewsCount: 7, reviews: ["Super sweet", "Good packaging", "Fresh and juicy", "Very tasty", "High quality", "Loved it", "Amazing"]),
            Product(id: UUID(), name: "Carrots", category: .vegetables, pricePerKg: 40, quantityAvailable: 100, originalQuantity: 100, description: "Organic and fresh carrots.", imageNames: ["carrots"], imageUrls: [], status: .available, expiryDate: Date().addingTimeInterval(8 * 24 * 60 * 60), farmerId: farmers[0].id, rating: 4.5, reviewsCount: 7, reviews: ["Crunchy and fresh", "Loved the taste", "Great for juicing", "Healthy and organic", "Fresh delivery", "Farm fresh", "Excellent quality"]),
            Product(id: UUID(), name: "Apples", category: .fruits, pricePerKg: 150, quantityAvailable: 80, originalQuantity: 80, description: "Crisp and sweet apples.", imageNames: ["apples"], imageUrls: [], status: .available, expiryDate: Date().addingTimeInterval(10 * 24 * 60 * 60), farmerId: farmers[1].id, rating: 4.8, reviewsCount: 7, reviews: ["Fresh and delicious", "Good size", "Sweet and crunchy", "Loved it", "Juicy and fresh", "Good packaging", "Top-notch quality"]),
            Product(id: UUID(), name: "Bananas", category: .fruits, pricePerKg: 50, quantityAvailable: 120, originalQuantity: 120, description: "Ripe yellow bananas.", imageNames: ["bananas"], imageUrls: [], status: .available, expiryDate: Date().addingTimeInterval(5 * 24 * 60 * 60), farmerId: farmers[1].id, rating: 4.6, reviewsCount: 7, reviews: ["Perfectly ripe", "Great taste", "Healthy snack", "Freshly delivered", "Value for money", "Sweet and delicious", "Excellent quality"]),
            Product(id: UUID(), name: "Potatoes", category: .vegetables, pricePerKg: 20, quantityAvailable: 300, originalQuantity: 300, description: "Fresh potatoes for cooking.", imageNames: ["potatoes"], imageUrls: [], status: .available, expiryDate: Date().addingTimeInterval(15 * 24 * 60 * 60), farmerId: farmers[1].id, rating: 4.3, reviewsCount: 7, reviews: ["Clean and fresh", "Perfect for cooking", "Good quality", "Loved it", "Farm fresh", "Value for money", "Great size"]),
            Product(id: UUID(), name: "Spinach", category: .vegetables, pricePerKg: 25, quantityAvailable: 50, originalQuantity: 50, description: "Fresh green spinach.", imageNames: ["spinach"], imageUrls: [], status: .available, expiryDate: Date().addingTimeInterval(3 * 24 * 60 * 60), farmerId: farmers[2].id, rating: 4.9, reviewsCount: 7, reviews: ["Fresh and green", "Great for smoothies", "Very healthy", "Organic and clean", "Excellent quality", "Farm fresh", "Loved it"]),
            Product(id: UUID(), name: "Pineapples", category: .fruits, pricePerKg: 90, quantityAvailable: 30, originalQuantity: 30, description: "Sweet and tangy pineapples.", imageNames: ["pineapples"], imageUrls: [], status: .available, expiryDate: Date().addingTimeInterval(7 * 24 * 60 * 60), farmerId: farmers[2].id, rating: 4.7, reviewsCount: 7, reviews: ["Delicious and juicy", "Sweet and tangy", "Freshly delivered", "Perfect for desserts", "High quality", "Loved it", "Amazing flavor"]),
                    Product(id: UUID(), name: "Peppers", category: .vegetables, pricePerKg: 70, quantityAvailable: 40, originalQuantity: 40, description: "Fresh bell peppers.", imageNames: ["peppers"], imageUrls: [], status: .available, expiryDate: Date().addingTimeInterval(5 * 24 * 60 * 60), farmerId: farmers[3].id, rating: 4.6, reviewsCount: 7, reviews: ["Bright and fresh", "Loved the taste", "Good packaging", "Perfect for cooking", "Farm fresh", "Great quality", "Very fresh"]),
            Product(id: UUID(), name: "Oranges", category: .fruits, pricePerKg: 80, quantityAvailable: 70, originalQuantity: 70, description: "Juicy and sweet oranges.", imageNames: ["oranges"], imageUrls: [], status: .available, expiryDate: Date().addingTimeInterval(8 * 24 * 60 * 60), farmerId: farmers[3].id, rating: 4.8, reviewsCount: 7, reviews: ["Sweet and juicy", "Loved it", "High quality", "Perfectly ripe", "Very fresh", "Farm fresh", "Delicious"]),
            Product(id: UUID(), name: "Corn", category: .grains, pricePerKg: 45, quantityAvailable: 200, originalQuantity: 200, description: "Fresh and sweet corn.", imageNames: ["corn"], imageUrls: [], status: .available, expiryDate: Date().addingTimeInterval(12 * 24 * 60 * 60), farmerId: farmers[3].id, rating: 4.7, reviewsCount: 7, reviews: ["Sweet and fresh", "Perfect for cooking", "Farm fresh", "Loved it", "Great for salads", "High quality", "Value for money"]),
            Product(id: UUID(), name: "Onions", category: .vegetables, pricePerKg: 30, quantityAvailable: 150, originalQuantity: 150, description: "Fresh onions for cooking.", imageNames: ["onions"], imageUrls: [], status: .available, expiryDate: Date().addingTimeInterval(10 * 24 * 60 * 60), farmerId: farmers[4].id, rating: 4.5, reviewsCount: 7, reviews: ["Great quality", "Farm fresh", "Perfect for cooking", "Loved it", "Very fresh", "Value for money", "Excellent"]),
            Product(id: UUID(), name: "Garlic", category: .spices, pricePerKg: 100, quantityAvailable: 25, originalQuantity: 25, description: "Fresh and aromatic garlic.", imageNames: ["garlic"], imageUrls: [], status: .available, expiryDate: Date().addingTimeInterval(20 * 24 * 60 * 60), farmerId: farmers[4].id, rating: 4.7, reviewsCount: 7, reviews: ["Very aromatic", "Freshly delivered", "Great taste", "Farm fresh", "High quality", "Loved it", "Perfect for cooking"]),
            Product(id: UUID(), name: "Papayas", category: .fruits, pricePerKg: 60, quantityAvailable: 50, originalQuantity: 50, description: "Sweet and fresh papayas.", imageNames: ["papayas"], imageUrls: [], status: .available, expiryDate: Date().addingTimeInterval(7 * 24 * 60 * 60), farmerId: farmers[0].id, rating: 4.7, reviewsCount: 7, reviews: ["Juicy and sweet", "Perfectly ripe", "Farm fresh", "Loved the taste", "High quality", "Fresh and healthy", "Amazing flavor"]),
            
            Product(id: UUID(), name: "Pomegranates", category: .fruits, pricePerKg: 120, quantityAvailable: 60, originalQuantity: 60, description: "Juicy and antioxidant-rich pomegranates.", imageNames: ["pomegranates"], imageUrls: [], status: .available, expiryDate: Date().addingTimeInterval(6 * 24 * 60 * 60), farmerId: farmers[1].id, rating: 4.8, reviewsCount: 7, reviews: ["Sweet and juicy", "Loved the freshness", "Farm fresh", "High quality", "Perfectly ripe", "Very healthy", "Amazing"]),
            Product(id: UUID(), name: "Cauliflower", category: .vegetables, pricePerKg: 35, quantityAvailable: 90, originalQuantity: 90, description: "Fresh and clean cauliflower.", imageNames: ["cauliflower"], imageUrls: [], status: .available, expiryDate: Date().addingTimeInterval(4 * 24 * 60 * 60), farmerId: farmers[1].id, rating: 4.6, reviewsCount: 7, reviews: ["Clean and fresh", "Perfect for cooking", "Loved it", "Farm fresh", "Very healthy", "Great taste", "High quality"]),
            Product(id: UUID(), name: "Zucchini", category: .vegetables, pricePerKg: 50, quantityAvailable: 70, originalQuantity: 70, description: "Fresh green zucchini.", imageNames: ["zucchini"], imageUrls: [], status: .available, expiryDate: Date().addingTimeInterval(6 * 24 * 60 * 60), farmerId: farmers[2].id, rating: 4.5, reviewsCount: 7, reviews: ["Loved the quality", "Farm fresh", "Great for cooking", "Very fresh", "High quality", "Value for money", "Amazing taste"]),
            Product(id: UUID(), name: "Peas", category: .vegetables, pricePerKg: 45, quantityAvailable: 100, originalQuantity: 100, description: "Fresh green peas.", imageNames: ["green_beans"], imageUrls: [], status: .available, expiryDate: Date().addingTimeInterval(5 * 24 * 60 * 60), farmerId: farmers[2].id, rating: 4.6, reviewsCount: 7, reviews: ["Loved the freshness", "Very healthy", "Farm fresh", "Perfect for cooking", "High quality", "Great packaging", "Amazing taste"]),
            Product(id: UUID(), name: "Lettuce", category: .vegetables, pricePerKg: 25, quantityAvailable: 40, originalQuantity: 40, description: "Fresh green lettuce.", imageNames: ["lettuce"], imageUrls: [], status: .available, expiryDate: Date().addingTimeInterval(4 * 24 * 60 * 60), farmerId: farmers[3].id, rating: 4.9, reviewsCount: 7, reviews: ["Crisp and fresh", "Perfect for salads", "Farm fresh", "Loved it", "Very healthy", "High quality", "Amazing"]),
            Product(id: UUID(), name: "Coconuts", category: .fruits, pricePerKg: 70, quantityAvailable: 50, originalQuantity: 50, description: "Fresh coconuts for cooking and drinking.", imageNames: ["coconuts"], imageUrls: [], status: .available, expiryDate: Date().addingTimeInterval(10 * 24 * 60 * 60), farmerId: farmers[3].id, rating: 4.8, reviewsCount: 7, reviews: ["Very fresh", "Great for cooking", "Loved the water", "Farm fresh", "High quality", "Value for money", "Amazing taste"]),
            Product(id: UUID(), name: "Chickpeas", category: .grains, pricePerKg: 60, quantityAvailable: 150, originalQuantity: 150, description: "Organic and fresh chickpeas.", imageNames: ["chickpeas"], imageUrls: [], status: .available, expiryDate: Date().addingTimeInterval(15 * 24 * 60 * 60), farmerId: farmers[3].id, rating: 4.7, reviewsCount: 7, reviews: ["Clean and fresh", "Perfect for cooking", "High quality", "Loved it", "Farm fresh", "Great packaging", "Very healthy"]),
            Product(id: UUID(), name: "Basil", category: .spices, pricePerKg: 100, quantityAvailable: 20, originalQuantity: 20, description: "Fresh aromatic basil leaves.", imageNames: ["basil"], imageUrls: [], status: .available, expiryDate: Date().addingTimeInterval(3 * 24 * 60 * 60), farmerId: farmers[4].id, rating: 4.9, reviewsCount: 7, reviews: ["Aromatic and fresh", "Loved it", "Great for cooking", "Farm fresh", "High quality", "Amazing taste", "Value for money"]),
            Product(id: UUID(), name: "Mint", category: .spices, pricePerKg: 30, quantityAvailable: 25, originalQuantity: 25, description: "Fresh and aromatic mint leaves.", imageNames: ["mint"], imageUrls: [], status: .available, expiryDate: Date().addingTimeInterval(4 * 24 * 60 * 60), farmerId: farmers[4].id, rating: 4.8, reviewsCount: 7, reviews: ["Fresh and aromatic", "Perfect for drinks", "Farm fresh", "High quality", "Loved the freshness", "Amazing flavor", "Great value"]),
            Product(id: UUID(), name: "Rice", category: .grains, pricePerKg: 50, quantityAvailable: 500, originalQuantity: 500, description: "Premium quality basmati rice.", imageNames: ["rice"], imageUrls: [], status: .available, expiryDate: Date().addingTimeInterval(20 * 24 * 60 * 60), farmerId: farmers[4].id, rating: 4.9, reviewsCount: 7, reviews: ["Great aroma", "Loved the quality", "Very fresh", "High quality", "Farm fresh", "Perfect for cooking", "Amazing taste"])


        ]
    }


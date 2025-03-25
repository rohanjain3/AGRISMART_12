//
//  ConsumerSettingsView.swift
//  Agrismart
//
//  Created by Rohan Jain on 13/03/25.
//

import SwiftUI

// MARK: - ConsumerSettingsView
struct ConsumerSettingsView: View {
    @State private var accountSettings = ["Order history"] // Updated account settings
    @State private var moreOptions = ["About us", "Privacy policy", "Terms and conditions", "Help Desk"]

    // Mocked user information
    @State private var profileName = "John Doe"
    @State private var profileImageName = "profile_photo" // Replace with a real image if available

    var body: some View {
        NavigationView {
            List {
                // Profile Header Section
                Section {
                    HStack(spacing: 16) {
                        Image(profileImageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))

                        VStack(alignment: .leading) {
                            Text(profileName)
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Manage your account") // Optional subtitle for clarity
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 10)
                }

                // Account Settings Section
                Section(header: Text("Account Settings")) {
                    ForEach(accountSettings.indices, id: \.self) { index in
                        if accountSettings[index] == "Order history" {
                            NavigationLink(destination: OrderHistoryView()) {
                                Text("Order history")
                            }
                        }
                    }
                }

                // More Options Section
                Section(header: Text("More")) {
                    ForEach(moreOptions.indices, id: \.self) { index in
                        NavigationLink(destination: InfoDetailView(option: moreOptions[index])) {
                            Text(moreOptions[index])
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button(action: {
                logout()
            }) {
                Text("Logout")
                    .foregroundColor(.red)
            })
        }
    }

    private func logout() {
        print("Logout tapped")
        // Add your logout logic here
    }
}

// MARK: - InfoDetailView
struct InfoDetailView: View {
    let option: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(option)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                if option == "About us" {
                    Text("AgriSmart is dedicated to connecting farmers with consumers, fostering transparency, and enabling sustainable agriculture practices. Our mission is to empower local farmers and provide fresh, high-quality produce directly to customers.")
                } else if option == "Privacy policy" {
                    Text("At AgriSmart, we value your privacy. We are committed to protecting your data and ensuring that it is only used for the intended purposes. For detailed information about how we handle your data, please visit our privacy policy online.")
                } else if option == "Terms and conditions" {
                    Text("By using AgriSmart, you agree to abide by our terms and conditions. These include fair usage of the platform, respect for all users, and compliance with applicable laws. For more details, please review our full terms and conditions.")
                } else if option == "Help Desk" {
                    Text("Need assistance? Our Help Desk is here for you. Whether you have questions about your orders, technical issues, or feedback, feel free to reach out to us at helpdesk@agrismart.com or call us at +91-123-456-7890.")
                } else {
                    Text("Content not available.")
                }
            }
            .padding()
        }
        .navigationTitle(option)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
struct ConsumerSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ConsumerSettingsView()
    }
}

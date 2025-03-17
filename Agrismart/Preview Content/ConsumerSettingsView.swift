//
//  ConsumerSettingsView.swift
//  Agrismart
//
//  Created by Rohan Jain on 13/03/25.
//

import SwiftUI

struct ConsumerSettingsView: View {
    @State private var isDarkModeEnabled = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
    @State private var pushNotificationsEnabled = UserDefaults.standard.bool(forKey: "pushNotificationsEnabled")
    @State private var accountSettings = ["Edit profile", "Change password", "Push notifications", "Dark mode"]
    @State private var moreOptions = ["About us", "Privacy policy", "Terms and conditions", "Help Desk"]

    let sections = ["Account Settings", "More"]

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Account Settings")) {
                    ForEach(accountSettings.indices, id: \.self) { index in
                        if index == 2 {
                            Toggle("Push notifications", isOn: $pushNotificationsEnabled)
                                .onChange(of: pushNotificationsEnabled) { value in
                                    print("Push notifications toggled: \(value)")
                                    // Save preference to UserDefaults
                                    UserDefaults.standard.set(value, forKey: "pushNotificationsEnabled")
                                }
                        } else if index == 3 {
                            Toggle("Dark mode", isOn: $isDarkModeEnabled)
                                .onChange(of: isDarkModeEnabled) { value in
                                    print("Dark mode toggled: \(value)")
                                    toggleDarkMode(isDarkMode: value)
                                }
                        } else {
                            NavigationLink(destination: SettingsDetailView(setting: accountSettings[index])) {
                                Text(accountSettings[index])
                            }
                        }
                    }
                }

                Section(header: Text("More")) {
                    ForEach(moreOptions.indices, id: \.self) { index in
                        NavigationLink(destination: SettingsDetailView(setting: moreOptions[index])) {
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
            .onAppear {
                applySavedDarkModePreference()
            }
        }
        .environment(\.colorScheme, isDarkModeEnabled ? .dark : .light)
    }

    private func toggleDarkMode(isDarkMode: Bool) {
        UserDefaults.standard.set(isDarkMode, forKey: "isDarkModeEnabled")
        isDarkModeEnabled = isDarkMode
    }

    private func applySavedDarkModePreference() {
        let isDarkModeEnabled = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
        self.isDarkModeEnabled = isDarkModeEnabled
    }

    private func logout() {
        // Handle logout action
        print("Logout tapped")
        // You can add your logout logic here
    }
}

struct SettingsDetailView: View {
    var setting: String

    var body: some View {
        Text("\(setting) Detail View")
            .navigationTitle(setting)
    }
}

struct ConsumerSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ConsumerSettingsView()
    }
}

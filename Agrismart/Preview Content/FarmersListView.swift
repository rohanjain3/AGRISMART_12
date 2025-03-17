//
//  FarmersListView.swift
//  Agrismart
//
//  Created by Rohan Jain on 13/03/25.
//

import SwiftUI

struct FarmersListView1: View {
    @State private var farmers = SampleData.farmers
    @State private var filteredFarmers = SampleData.farmers
    @State private var searchText = ""
    @State private var selectedFilter: FilterOption = .none
    
    var body: some View {
        NavigationStack {
            VStack {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search farmers", text: $searchText, onCommit: {
                        filterFarmers()
                    })
                    .foregroundColor(.black)
                    .padding()
                }
                .padding(.horizontal)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Filter Dropdown
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(FilterOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.horizontal)
                
                // Farmers List
                List(filteredFarmers) { farmer in
                    NavigationLink(destination: FarmerProfileView(farmer: farmer)) {
                        FarmerCardView1(farmer: farmer)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(PlainListStyle())
            }
            // .navigationTitle("Farmers")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        applyFilter()
                    }) {
                        Text("Apply Filter")
                    }
                }
            }
        }
        .onAppear {
            filterFarmers()
        }
    }
    
    private func filterFarmers() {
        if searchText.isEmpty {
            filteredFarmers = farmers
        } else {
            filteredFarmers = farmers.filter {
                $0.profile.name.lowercased().contains(searchText.lowercased())
            }
        }
        applyFilter()
    }
    
    private func applyFilter() {
        switch selectedFilter {
        case .none:
            break
        case .alphabetical:
            filteredFarmers.sort { $0.profile.name < $1.profile.name }
        case .rating:
            filteredFarmers.sort { $0.metrics.rating > $1.metrics.rating }
            
        }
    }
    
    enum FilterOption: String, CaseIterable {
        case none = "None"
        case alphabetical = "Alphabetical"
        case rating = "Rating"
        // case online = "Online Status"
    }
    
    struct FarmerCardView1: View {
        let farmer: User
        
        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Image(farmer.profile.profileImageUrl ?? "defaultProfileImage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                    
                    VStack(alignment: .leading) {
                        Text(farmer.profile.name)
                            .font(.headline)
                        Text(farmer.status.displayText)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Text("\(farmer.metrics.rating, specifier: "%.1f") ⭐️")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
            }
            .padding(.horizontal)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
        }
    }
    
    // Conform UserStatus to Equatable
    enum UserStatus: Equatable {
        case online
        case offline
        case lastSeen(Date)
        
        var displayText: String {
            switch self {
            case .online: return "Online Now"
            case .offline: return "Offline"
            case .lastSeen(let date):
                let formatter = RelativeDateTimeFormatter()
                return "Last seen " + formatter.localizedString(for: date, relativeTo: Date())
            }
        }
        
        static func == (lhs: UserStatus, rhs: UserStatus) -> Bool {
            switch (lhs, rhs) {
            case (.online, .online), (.offline, .offline):
                return true
            case (.lastSeen(let lhsDate), .lastSeen(let rhsDate)):
                return lhsDate == rhsDate
            default:
                return false
            }
        }
    }
}
    
    // Preview
    struct FarmersListView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                FarmersListView1()
                    .navigationTitle("Farmers")
            }
        }
    }
//}

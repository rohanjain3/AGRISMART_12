//
//  NotificationView.swift
//  Agrismart
//
//  Created by Rohan Jain on 22/03/25.
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
        VStack {
            Text("Notification Screen")
                .font(.largeTitle)
                .padding()
            // Add your notification list or UI components here
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}

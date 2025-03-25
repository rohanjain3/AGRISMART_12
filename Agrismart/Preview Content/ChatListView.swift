//
//  ChatListView.swift
//  Agrismart
//
//  Created by Rohan Jain on 25/03/25.
//

import SwiftUI

// MARK: - ChatListView
struct ChatListView: View {
    let farmers = SampleData.farmers // Farmers from SampleData

    var body: some View {
        NavigationView {
            List(farmers) { farmer in
                NavigationLink(destination: ChatScreen(farmer: farmer)) {
                    HStack {
                        Image(farmer.profile.profileImageUrl ?? "defaultProfileImage")                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())

                        VStack(alignment: .leading) {
                            Text(farmer.profile.name)
                                .font(.headline)
                            Text(farmer.statusDescription)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Chats")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}

// MARK: - ChatScreen
struct ChatScreen: View {
    let farmer: User // Farmer selected from the list
    @State private var messages: [Message] = [
        Message(
            id: UUID(),
            senderId: UUID(), // Example senderId (User)
            receiverId: UUID(), // Example receiverId (Farmer)
            content: "Hello, how are you?",
            timestamp: Date().addingTimeInterval(-300), // 5 minutes ago
            isRead: true
        ),
        Message(
            id: UUID(),
            senderId: UUID(), // Example receiverId (Farmer)
            receiverId: UUID(), // Example senderId (User)
            content: "I'm doing well, thank you! How can I help you today?",
            timestamp: Date().addingTimeInterval(-240), // 4 minutes ago
            isRead: true
        )
    ]
    @State private var newMessage: String = ""

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages) { message in
                        ChatBubble(message: message, farmer: farmer)
                    }
                }
                .padding()
            }

            HStack {
                TextField("Type a message...", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: 40)
                Button(action: sendMessage) {
                    Text("Send")
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationTitle("Chat with \(farmer.profile.name)")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sendMessage() {
        let newMessageEntry = Message(
            id: UUID(),
            senderId: UUID(), // Placeholder for user ID
            receiverId: farmer.id,
            content: newMessage,
            timestamp: Date(),
            isRead: false
        )
        messages.append(newMessageEntry)

        // Mock farmer response for demo purposes
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let farmerReply = Message(
                id: UUID(),
                senderId: farmer.id,
                receiverId: UUID(), // Placeholder for user ID
                content: "Thank you for reaching out. I'll get back to you soon!",
                timestamp: Date(),
                isRead: true
            )
            messages.append(farmerReply)
        }

        newMessage = ""
    }
}

// MARK: - ChatBubble
struct ChatBubble: View {
    let message: Message
    let farmer: User

    var body: some View {
        HStack {
            if message.senderId == farmer.id {
                // Farmer's message
                VStack(alignment: .leading) {
                    Text(message.content)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                    Text(message.formattedTime)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
            } else {
                // User's message
                Spacer()
                VStack(alignment: .trailing) {
                    Text(message.content)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    Text(message.formattedTime)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

// MARK: - Extensions
extension User {
    var statusDescription: String {
        switch status {
        case .online:
            return "Online"
        case .offline:
            return "Offline"
        case .lastSeen(let date):
            let formatter = RelativeDateTimeFormatter()
            return "Last seen \(formatter.localizedString(for: date, relativeTo: Date()))"
        }
    }
}

// MARK: - Preview
struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}

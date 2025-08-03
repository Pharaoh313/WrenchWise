import SwiftUI

struct MessagingView: View {
    @State private var conversations: [Conversation] = []
    
    var body: some View {
        NavigationView {
            Group {
                if conversations.isEmpty {
                    EmptyMessagesView()
                } else {
                    List {
                        ForEach(conversations) { conversation in
                            NavigationLink(destination: ChatView(conversation: conversation)) {
                                ConversationRow(conversation: conversation)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            loadSampleConversations()
        }
    }
    
    private func loadSampleConversations() {
        conversations = [
            Conversation(
                id: UUID(),
                participants: [UUID(), UUID()],
                lastMessage: Message(
                    id: UUID(),
                    conversationID: UUID(),
                    senderID: UUID(),
                    receiverID: UUID(),
                    content: "Thanks for the quick service on my car!",
                    messageType: .text,
                    isRead: false,
                    createdAt: Date().addingTimeInterval(-3600),
                    senderName: "Sarah Johnson"
                ),
                unreadCount: 1,
                createdAt: Date().addingTimeInterval(-86400),
                updatedAt: Date().addingTimeInterval(-3600),
                otherParticipantName: "Mike's Auto Repair",
                otherParticipantImage: nil
            )
        ]
    }
}

struct ConversationRow: View {
    let conversation: Conversation
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(.quaternary)
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: "wrench.and.screwdriver")
                        .foregroundColor(.secondary)
                        .font(.title3)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(conversation.otherParticipantName)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    if let lastMessage = conversation.lastMessage {
                        Text(lastMessage.createdAt, style: .relative)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                if let lastMessage = conversation.lastMessage {
                    Text(lastMessage.content)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            
            if conversation.unreadCount > 0 {
                Circle()
                    .fill(.blue)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Text("\(conversation.unreadCount)")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    )
            }
        }
        .padding(.vertical, 4)
    }
}

struct ChatView: View {
    let conversation: Conversation
    @State private var messageText = ""
    @State private var messages: [Message] = []
    
    var body: some View {
        VStack(spacing: 0) {
            // Messages
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(messages) { message in
                        MessageBubble(message: message, isFromCurrentUser: message.senderID == UUID())
                    }
                }
                .padding()
            }
            
            // Input Area
            VStack(spacing: 0) {
                Divider()
                
                HStack(spacing: 12) {
                    TextField("Message", text: $messageText, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(1...4)
                    
                    Button(action: sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                            .foregroundColor(messageText.isEmpty ? .secondary : .blue)
                    }
                    .disabled(messageText.isEmpty)
                }
                .padding()
            }
            .background(.regularMaterial)
        }
        .navigationTitle(conversation.otherParticipantName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadMessages()
        }
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        
        let newMessage = Message(
            id: UUID(),
            conversationID: conversation.id,
            senderID: UUID(), // Current user
            receiverID: UUID(),
            content: messageText,
            messageType: .text,
            isRead: false,
            createdAt: Date(),
            senderName: "You"
        )
        
        messages.append(newMessage)
        messageText = ""
    }
    
    private func loadMessages() {
        messages = [
            Message(
                id: UUID(),
                conversationID: conversation.id,
                senderID: UUID(),
                receiverID: UUID(),
                content: "Hi! I'd like to schedule a brake inspection for my car.",
                messageType: .text,
                isRead: true,
                createdAt: Date().addingTimeInterval(-7200),
                senderName: "You"
            ),
            Message(
                id: UUID(),
                conversationID: conversation.id,
                senderID: UUID(),
                receiverID: UUID(),
                content: "Sure! What type of car do you have and when would you like to come in?",
                messageType: .text,
                isRead: true,
                createdAt: Date().addingTimeInterval(-3900),
                senderName: conversation.otherParticipantName
            ),
            Message(
                id: UUID(),
                conversationID: conversation.id,
                senderID: UUID(),
                receiverID: UUID(),
                content: "It's a 2018 Honda Civic. How about tomorrow afternoon?",
                messageType: .text,
                isRead: true,
                createdAt: Date().addingTimeInterval(-3600),
                senderName: "You"
            )
        ]
    }
}

struct MessageBubble: View {
    let message: Message
    let isFromCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isFromCurrentUser {
                Spacer(minLength: 50)
            }
            
            VStack(alignment: isFromCurrentUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        isFromCurrentUser ? Color.blue : Color.secondary.opacity(0.1),
                        in: RoundedRectangle(cornerRadius: 18)
                    )
                    .foregroundColor(isFromCurrentUser ? .white : .primary)
                
                Text(message.createdAt, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            if !isFromCurrentUser {
                Spacer(minLength: 50)
            }
        }
    }
}

struct EmptyMessagesView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "message")
                .font(.system(size: 64))
                .foregroundColor(.secondary)
            
            Text("No Messages Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Start a conversation with a mechanic to get help with your car")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    MessagingView()
}
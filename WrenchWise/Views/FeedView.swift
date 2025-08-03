import SwiftUI

struct FeedView: View {
    @State private var posts: [Post] = []
    @State private var isRefreshing = false
    @State private var showingCreatePost = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(posts) { post in
                        PostCard(post: post)
                    }
                    
                    if posts.isEmpty {
                        EmptyFeedView()
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .navigationTitle("WrenchWise")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingCreatePost = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .refreshable {
                await refreshFeed()
            }
            .sheet(isPresented: $showingCreatePost) {
                CreatePostView()
            }
        }
        .onAppear {
            loadSampleData()
        }
    }
    
    private func refreshFeed() async {
        isRefreshing = true
        try? await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay
        loadSampleData()
        isRefreshing = false
    }
    
    private func loadSampleData() {
        posts = [
            Post(
                id: UUID(),
                authorID: UUID(),
                mechanicID: UUID(),
                content: "Just had an amazing experience at Mike's Auto Repair! They diagnosed my engine issue quickly and explained everything clearly. Fair pricing and excellent service. Highly recommend! 🔧",
                photos: [],
                postType: .review,
                likes: 24,
                comments: [],
                createdAt: Date().addingTimeInterval(-3600),
                authorName: "Sarah Johnson",
                authorProfileImage: nil,
                mechanicInfo: Mechanic.sampleMechanic
            ),
            Post(
                id: UUID(),
                authorID: UUID(),
                mechanicID: nil,
                content: "Quick tip: If your car is making a grinding noise when braking, get it checked immediately. It could save you money and keep you safe! 🚗",
                photos: [],
                postType: .tip,
                likes: 15,
                comments: [],
                createdAt: Date().addingTimeInterval(-7200),
                authorName: "Mike Torres",
                authorProfileImage: nil
            ),
            Post(
                id: UUID(),
                authorID: UUID(),
                mechanicID: UUID(),
                content: "Anyone know a good mechanic near downtown? Need brake work done and want someone trustworthy. Thanks!",
                photos: [],
                postType: .question,
                likes: 8,
                comments: [],
                createdAt: Date().addingTimeInterval(-10800),
                authorName: "Alex Chen",
                authorProfileImage: nil
            )
        ]
    }
}

struct PostCard: View {
    let post: Post
    @State private var isLiked = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Author Header
            HStack(spacing: 12) {
                Circle()
                    .fill(.quaternary)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.secondary)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.authorName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(post.createdAt, style: .relative)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                PostTypeBadge(type: post.postType)
            }
            
            // Content
            Text(post.content)
                .font(.body)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            
            // Mechanic Card (if applicable)
            if let mechanic = post.mechanicInfo {
                MechanicPreviewCard(mechanic: mechanic)
            }
            
            // Actions
            HStack(spacing: 24) {
                Button(action: { isLiked.toggle() }) {
                    HStack(spacing: 6) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .secondary)
                        Text("\(post.likes + (isLiked ? 1 : 0))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .buttonStyle(.plain)
                
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: "bubble.right")
                            .foregroundColor(.secondary)
                        Text("\(post.comments.count)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 4)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        .animation(.easeInOut(duration: 0.2), value: isLiked)
    }
}

struct PostTypeBadge: View {
    let type: PostType
    
    private var badgeConfig: (text: String, color: Color) {
        switch type {
        case .review:
            return ("Review", .blue)
        case .question:
            return ("Question", .orange)
        case .tip:
            return ("Tip", .green)
        case .showcase:
            return ("Showcase", .purple)
        }
    }
    
    var body: some View {
        Text(badgeConfig.text)
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(badgeConfig.color, in: Capsule())
    }
}

struct MechanicPreviewCard: View {
    let mechanic: Mechanic
    
    var body: some View {
        HStack(spacing: 12) {
            TrustScoreBadge(score: mechanic.trustScore, reviewCount: mechanic.totalReviews, size: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(mechanic.businessName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(mechanic.location.city + ", " + mechanic.location.state)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    if mechanic.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.blue)
                            .font(.caption)
                    }
                    
                    ForEach(mechanic.services.prefix(2), id: \.id) { service in
                        Text(service.category.rawValue)
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.quaternary, in: Capsule())
                    }
                }
            }
            
            Spacer()
            
            Button("View") {
                // Navigate to mechanic profile
            }
            .font(.caption)
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
        }
        .padding(12)
        .background(.quaternary.opacity(0.5), in: RoundedRectangle(cornerRadius: 10))
    }
}

struct EmptyFeedView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "wrench.and.screwdriver")
                .font(.system(size: 64))
                .foregroundColor(.secondary)
            
            Text("Welcome to WrenchWise!")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Connect with trusted mechanics and share your automotive experiences")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.vertical, 60)
    }
}

struct CreatePostView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var postContent = ""
    @State private var selectedType: PostType = .review
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Post Type Picker
                Picker("Post Type", selection: $selectedType) {
                    ForEach(PostType.allCases, id: \.self) { type in
                        Text(type.rawValue.capitalized)
                            .tag(type)
                    }
                }
                .pickerStyle(.segmented)
                
                // Content Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("What's on your mind?")
                        .font(.headline)
                    
                    TextEditor(text: $postContent)
                        .frame(minHeight: 120)
                        .padding(12)
                        .background(.quaternary, in: RoundedRectangle(cornerRadius: 10))
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        // Handle post creation
                        dismiss()
                    }
                    .disabled(postContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

#Preview {
    FeedView()
}
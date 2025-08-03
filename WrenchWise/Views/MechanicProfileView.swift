import SwiftUI

struct MechanicProfileView: View {
    let mechanic: Mechanic
    @State private var selectedTab = 0
    @State private var showingContact = false
    @State private var showingBooking = false
    @State private var reviews: [Review] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 16) {
                    // Business Name & Verification
                    HStack(spacing: 8) {
                        Text(mechanic.businessName)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        if mechanic.isVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.blue)
                                .font(.title2)
                        }
                    }
                    
                    // Location
                    HStack(spacing: 4) {
                        Image(systemName: "location")
                            .foregroundColor(.secondary)
                            .font(.caption)
                        
                        Text("\(mechanic.location.address), \(mechanic.location.city), \(mechanic.location.state)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Trust Score
                    TrustScoreCard(mechanic: mechanic)
                    
                    // Action Buttons
                    HStack(spacing: 12) {
                        Button(action: { showingContact = true }) {
                            HStack(spacing: 6) {
                                Image(systemName: "message")
                                Text("Message")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(.quaternary, in: RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                        
                        Button(action: { showingBooking = true }) {
                            HStack(spacing: 6) {
                                Image(systemName: "calendar")
                                Text("Book Service")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(.blue, in: RoundedRectangle(cornerRadius: 10))
                            .foregroundColor(.white)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                
                // Content Tabs
                VStack(spacing: 0) {
                    // Tab Picker
                    Picker("Content", selection: $selectedTab) {
                        Text("About").tag(0)
                        Text("Services").tag(1)
                        Text("Reviews").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // Tab Content
                    TabView(selection: $selectedTab) {
                        AboutTabView(mechanic: mechanic)
                            .tag(0)
                        
                        ServicesTabView(services: mechanic.services)
                            .tag(1)
                        
                        ReviewsTabView(reviews: reviews)
                            .tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(height: 400)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingContact) {
            ContactSheet(mechanic: mechanic)
        }
        .sheet(isPresented: $showingBooking) {
            BookingSheet(mechanic: mechanic)
        }
        .onAppear {
            loadReviews()
        }
    }
    
    private func loadReviews() {
        reviews = [
            Review.sampleReview,
            Review(
                id: UUID(),
                userID: UUID(),
                mechanicID: mechanic.id,
                rating: 4,
                title: "Good service",
                content: "Quick oil change and fair pricing. Would come back again.",
                photos: [],
                serviceType: .oilChange,
                isRecommended: true,
                aiSummary: "Customer appreciated quick service and fair pricing for oil change.",
                createdAt: Date().addingTimeInterval(-86400),
                updatedAt: Date().addingTimeInterval(-86400),
                userName: "John Doe",
                userProfileImage: nil
            )
        ]
    }
}

struct AboutTabView: View {
    let mechanic: Mechanic
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("About")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(mechanic.description)
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                // Contact Information
                VStack(alignment: .leading, spacing: 8) {
                    Text("Contact Information")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        if let phone = mechanic.contactInfo.phone {
                            ContactInfoRow(icon: "phone", title: "Phone", value: phone)
                        }
                        
                        if let email = mechanic.contactInfo.email {
                            ContactInfoRow(icon: "envelope", title: "Email", value: email)
                        }
                        
                        if let website = mechanic.contactInfo.website {
                            ContactInfoRow(icon: "globe", title: "Website", value: website)
                        }
                    }
                }
                
                // Working Hours
                VStack(alignment: .leading, spacing: 8) {
                    Text("Working Hours")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 8) {
                        ForEach(mechanic.contactInfo.workingHours, id: \.day) { hours in
                            HStack {
                                Text(hours.day)
                                    .fontWeight(.medium)
                                    .frame(width: 80, alignment: .leading)
                                
                                Spacer()
                                
                                Text(hours.isClosed ? "Closed" : "\(hours.openTime) - \(hours.closeTime)")
                                    .foregroundColor(hours.isClosed ? .secondary : .primary)
                            }
                            .font(.subheadline)
                        }
                    }
                    .padding()
                    .background(.quaternary.opacity(0.5), in: RoundedRectangle(cornerRadius: 10))
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct ContactInfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.subheadline)
            }
            
            Spacer()
        }
    }
}

struct ServicesTabView: View {
    let services: [Service]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(services) { service in
                    ServiceCard(service: service)
                }
            }
            .padding()
        }
    }
}

struct ServiceCard: View {
    let service: Service
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(service.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                if let price = service.estimatedPrice {
                    Text(price.displayString)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                }
            }
            
            Text(service.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(service.category.rawValue)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.blue.opacity(0.1), in: Capsule())
                .foregroundColor(.blue)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct ReviewsTabView: View {
    let reviews: [Review]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(reviews) { review in
                    ReviewCard(review: review)
                }
                
                if reviews.isEmpty {
                    EmptyReviewsView()
                }
            }
            .padding()
        }
    }
}

struct ReviewCard: View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(spacing: 12) {
                Circle()
                    .fill(.quaternary)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(review.userName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < review.rating ? "star.fill" : "star")
                                .foregroundColor(index < review.rating ? .yellow : .secondary)
                                .font(.caption)
                        }
                        
                        Text(review.createdAt, style: .relative)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Text(review.serviceType.rawValue)
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(.quaternary, in: Capsule())
            }
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text(review.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(review.content)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                
                if let aiSummary = review.aiSummary {
                    HStack(spacing: 6) {
                        Image(systemName: "sparkles")
                            .foregroundColor(.purple)
                            .font(.caption)
                        
                        Text("AI Summary: \(aiSummary)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                    .padding(.top, 4)
                }
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct EmptyReviewsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "star")
                .font(.system(size: 32))
                .foregroundColor(.secondary)
            
            Text("No Reviews Yet")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("Be the first to leave a review!")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 40)
    }
}

struct ContactSheet: View {
    let mechanic: Mechanic
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Contact \(mechanic.businessName)")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                VStack(spacing: 16) {
                    if let phone = mechanic.contactInfo.phone {
                        Button(action: {
                            if let url = URL(string: "tel:\(phone)") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack {
                                Image(systemName: "phone.fill")
                                Text("Call \(phone)")
                                Spacer()
                            }
                            .padding()
                            .background(.green.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
                            .foregroundColor(.green)
                        }
                    }
                    
                    Button(action: {
                        // Navigate to messaging
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "message.fill")
                            Text("Send Message")
                            Spacer()
                        }
                        .padding()
                        .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
                        .foregroundColor(.blue)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

struct BookingSheet: View {
    let mechanic: Mechanic
    @Environment(\.dismiss) private var dismiss
    @State private var selectedService: Service?
    @State private var selectedDate = Date()
    @State private var description = ""
    @State private var urgency: UrgencyLevel = .medium
    
    var body: some View {
        NavigationView {
            Form {
                Section("Service Required") {
                    Picker("Service Type", selection: $selectedService) {
                        Text("Select a service...")
                            .tag(nil as Service?)
                        
                        ForEach(mechanic.services, id: \.id) { service in
                            Text(service.name)
                                .tag(service as Service?)
                        }
                    }
                }
                
                Section("Preferred Date") {
                    DatePicker("Date", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                }
                
                Section("Urgency") {
                    Picker("Urgency Level", selection: $urgency) {
                        ForEach(UrgencyLevel.allCases, id: \.self) { level in
                            Text(level.rawValue.capitalized)
                                .tag(level)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Description") {
                    TextEditor(text: $description)
                        .frame(minHeight: 60)
                }
            }
            .navigationTitle("Book Service")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Send Request") {
                        // Handle booking request
                        dismiss()
                    }
                    .disabled(selectedService == nil)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        MechanicProfileView(mechanic: Mechanic.sampleMechanic)
    }
}
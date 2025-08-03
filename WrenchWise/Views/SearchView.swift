import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var selectedFilter: ServiceCategory? = nil
    @State private var mechanics: [Mechanic] = []
    @State private var showingFilters = false
    
    var filteredMechanics: [Mechanic] {
        var filtered = mechanics
        
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.businessName.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText) ||
                $0.services.contains { service in
                    service.name.localizedCaseInsensitiveContains(searchText) ||
                    service.category.rawValue.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
        
        if let filter = selectedFilter {
            filtered = filtered.filter { mechanic in
                mechanic.services.contains { $0.category == filter }
            }
        }
        
        return filtered.sorted { $0.trustScore > $1.trustScore }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search and Filter Bar
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                            
                            TextField("Search mechanics or services", text: $searchText)
                                .textFieldStyle(.plain)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(.quaternary, in: RoundedRectangle(cornerRadius: 10))
                        
                        Button(action: { showingFilters.toggle() }) {
                            Image(systemName: selectedFilter != nil ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                                .foregroundColor(selectedFilter != nil ? .accentColor : .secondary)
                        }
                    }
                    
                    if selectedFilter != nil {
                        FilterChipsView(selectedFilter: $selectedFilter)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                // Results
                if filteredMechanics.isEmpty {
                    EmptySearchView(searchText: searchText)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredMechanics) { mechanic in
                                NavigationLink(destination: MechanicProfileView(mechanic: mechanic)) {
                                    MechanicSearchCard(mechanic: mechanic)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Find Mechanics")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingFilters) {
                FilterSheet(selectedFilter: $selectedFilter)
            }
        }
        .onAppear {
            loadSampleMechanics()
        }
    }
    
    private func loadSampleMechanics() {
        mechanics = [
            Mechanic.sampleMechanic,
            Mechanic(
                id: UUID(),
                userID: UUID(),
                businessName: "QuickFix Auto",
                description: "Fast and reliable automotive service. Specializing in oil changes, brakes, and routine maintenance.",
                services: [
                    Service(id: UUID(), name: "Oil Change", description: "Quick lube service", estimatedPrice: PriceRange(min: 30, max: 50), category: .oilChange),
                    Service(id: UUID(), name: "Brake Service", description: "Brake inspection and repair", estimatedPrice: PriceRange(min: 100, max: 300), category: .brakes)
                ],
                location: Location(
                    latitude: 37.7849,
                    longitude: -122.4094,
                    address: "456 Oak Street",
                    city: "San Francisco",
                    state: "CA",
                    zipCode: "94103"
                ),
                trustScore: 7.8,
                totalReviews: 89,
                photos: [],
                contactInfo: ContactInfo.sampleContact,
                isVerified: false,
                createdAt: Date()
            ),
            Mechanic(
                id: UUID(),
                userID: UUID(),
                businessName: "Premium Motors",
                description: "Luxury vehicle specialists with certified technicians. Expert service for BMW, Mercedes, Audi, and more.",
                services: [
                    Service(id: UUID(), name: "Engine Diagnostics", description: "Computer diagnostics", estimatedPrice: PriceRange(min: 120, max: 200), category: .engine),
                    Service(id: UUID(), name: "Transmission Service", description: "Transmission repair and maintenance", estimatedPrice: PriceRange(min: 200, max: 800), category: .transmission)
                ],
                location: Location(
                    latitude: 37.7649,
                    longitude: -122.4194,
                    address: "789 Pine Street",
                    city: "San Francisco",
                    state: "CA",
                    zipCode: "94104"
                ),
                trustScore: 9.2,
                totalReviews: 156,
                photos: [],
                contactInfo: ContactInfo.sampleContact,
                isVerified: true,
                createdAt: Date()
            )
        ]
    }
}

struct MechanicSearchCard: View {
    let mechanic: Mechanic
    
    var body: some View {
        HStack(spacing: 12) {
            // Trust Score
            TrustScoreBadge(score: mechanic.trustScore, reviewCount: mechanic.totalReviews, size: 50)
            
            // Info
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text(mechanic.businessName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    if mechanic.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.blue)
                            .font(.caption)
                    }
                }
                
                Text(mechanic.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text("\(mechanic.location.city), \(mechanic.location.state)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // Services
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(mechanic.services.prefix(3), id: \.id) { service in
                            Text(service.category.rawValue)
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.quaternary, in: Capsule())
                        }
                    }
                    .padding(.horizontal, 1)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.tertiary)
                .font(.caption)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct FilterChipsView: View {
    @Binding var selectedFilter: ServiceCategory?
    
    var body: some View {
        HStack {
            Text("Filtered by:")
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack(spacing: 8) {
                if let filter = selectedFilter {
                    HStack(spacing: 4) {
                        Text(filter.rawValue)
                            .font(.caption)
                        
                        Button(action: { selectedFilter = nil }) {
                            Image(systemName: "xmark")
                                .font(.caption2)
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.blue.opacity(0.1), in: Capsule())
                    .foregroundColor(.blue)
                }
            }
            
            Spacer()
        }
        .animation(.easeInOut(duration: 0.2), value: selectedFilter)
    }
}

struct FilterSheet: View {
    @Binding var selectedFilter: ServiceCategory?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section("Service Categories") {
                    ForEach(ServiceCategory.allCases, id: \.self) { category in
                        Button(action: {
                            selectedFilter = selectedFilter == category ? nil : category
                            dismiss()
                        }) {
                            HStack {
                                Text(category.rawValue)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if selectedFilter == category {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Filter by Service")
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

struct EmptySearchView: View {
    let searchText: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: searchText.isEmpty ? "location" : "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text(searchText.isEmpty ? "Find Mechanics Near You" : "No Results Found")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(searchText.isEmpty ? 
                 "Search for mechanics by name, service type, or location" :
                 "Try adjusting your search or filters")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SearchView()
}
import Foundation
import SwiftUI

// MARK: - User Model
struct User: Identifiable, Codable {
    let id: UUID
    let email: String
    let name: String
    let profileImageURL: String?
    let location: Location?
    let createdAt: Date
    
    init(id: UUID = UUID(), email: String, name: String, profileImageURL: String? = nil, location: Location? = nil, createdAt: Date = Date()) {
        self.id = id
        self.email = email
        self.name = name
        self.profileImageURL = profileImageURL
        self.location = location
        self.createdAt = createdAt
    }
}

// MARK: - Mechanic Model
struct Mechanic: Identifiable, Codable {
    let id: UUID
    let userID: UUID
    let businessName: String
    let description: String
    let services: [Service]
    let location: Location
    let trustScore: Double // 1-10 scale
    let totalReviews: Int
    let photos: [String] // URLs
    let contactInfo: ContactInfo
    let isVerified: Bool
    let createdAt: Date
    
    var trustScoreColor: Color {
        if trustScore >= 8.0 { return .green }
        if trustScore >= 6.0 { return .orange }
        return .red
    }
}

// MARK: - Service Model
struct Service: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let estimatedPrice: PriceRange?
    let category: ServiceCategory
}

enum ServiceCategory: String, CaseIterable, Codable {
    case oilChange = "Oil Change"
    case brakes = "Brakes"
    case tires = "Tires"
    case engine = "Engine"
    case transmission = "Transmission"
    case electrical = "Electrical"
    case bodyWork = "Body Work"
    case inspection = "Inspection"
    case other = "Other"
}

struct PriceRange: Codable {
    let min: Double
    let max: Double
    
    var displayString: String {
        "$\(Int(min)) - $\(Int(max))"
    }
}

// MARK: - Location Model
struct Location: Codable {
    let latitude: Double
    let longitude: Double
    let address: String
    let city: String
    let state: String
    let zipCode: String
}

// MARK: - Contact Info Model
struct ContactInfo: Codable {
    let phone: String?
    let email: String?
    let website: String?
    let workingHours: [WorkingHours]
}

struct WorkingHours: Codable {
    let day: String
    let openTime: String
    let closeTime: String
    let isClosed: Bool
}

// MARK: - Review Model
struct Review: Identifiable, Codable {
    let id: UUID
    let userID: UUID
    let mechanicID: UUID
    let rating: Int // 1-5 stars
    let title: String
    let content: String
    let photos: [String] // URLs
    let serviceType: ServiceCategory
    let isRecommended: Bool
    let aiSummary: String?
    let createdAt: Date
    let updatedAt: Date
    
    // User info for display
    var userName: String = ""
    var userProfileImage: String?
}

// MARK: - Post Model
struct Post: Identifiable, Codable {
    let id: UUID
    let authorID: UUID
    let mechanicID: UUID?
    let content: String
    let photos: [String]
    let postType: PostType
    let likes: Int
    let comments: [Comment]
    let createdAt: Date
    
    // Author info for display
    var authorName: String = ""
    var authorProfileImage: String?
    var mechanicInfo: Mechanic?
}

enum PostType: String, CaseIterable, Codable {
    case review = "review"
    case question = "question"
    case tip = "tip"
    case showcase = "showcase"
}

// MARK: - Comment Model
struct Comment: Identifiable, Codable {
    let id: UUID
    let postID: UUID
    let userID: UUID
    let content: String
    let likes: Int
    let createdAt: Date
    
    // User info for display
    var userName: String = ""
    var userProfileImage: String?
}

// MARK: - Message Model
struct Message: Identifiable, Codable {
    let id: UUID
    let conversationID: UUID
    let senderID: UUID
    let receiverID: UUID
    let content: String
    let messageType: MessageType
    let isRead: Bool
    let createdAt: Date
    
    // Sender info for display
    var senderName: String = ""
    var senderProfileImage: String?
}

enum MessageType: String, CaseIterable, Codable {
    case text = "text"
    case image = "image"
    case bookingRequest = "booking_request"
    case contactRequest = "contact_request"
}

// MARK: - Conversation Model
struct Conversation: Identifiable, Codable {
    let id: UUID
    let participants: [UUID]
    let lastMessage: Message?
    let unreadCount: Int
    let createdAt: Date
    let updatedAt: Date
    
    // Participant info for display
    var otherParticipantName: String = ""
    var otherParticipantImage: String?
}

// MARK: - Booking Request Model
struct BookingRequest: Identifiable, Codable {
    let id: UUID
    let userID: UUID
    let mechanicID: UUID
    let serviceType: ServiceCategory
    let description: String
    let preferredDate: Date?
    let urgency: UrgencyLevel
    let status: BookingStatus
    let createdAt: Date
}

enum UrgencyLevel: String, CaseIterable, Codable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case emergency = "emergency"
}

enum BookingStatus: String, CaseIterable, Codable {
    case pending = "pending"
    case accepted = "accepted"
    case declined = "declined"
    case completed = "completed"
    case cancelled = "cancelled"
}

// MARK: - Sample Data for Development
extension User {
    static let sampleUser = User(
        email: "john@example.com",
        name: "John Smith",
        profileImageURL: nil,
        location: Location.sampleLocation
    )
}

extension Mechanic {
    static let sampleMechanic = Mechanic(
        id: UUID(),
        userID: UUID(),
        businessName: "Mike's Auto Repair",
        description: "Trusted auto repair with 15 years of experience. Specializing in engine work and diagnostics.",
        services: [Service.sampleService],
        location: Location.sampleLocation,
        trustScore: 8.5,
        totalReviews: 127,
        photos: [],
        contactInfo: ContactInfo.sampleContact,
        isVerified: true,
        createdAt: Date()
    )
}

extension Service {
    static let sampleService = Service(
        id: UUID(),
        name: "Oil Change",
        description: "Full synthetic oil change with filter replacement",
        estimatedPrice: PriceRange(min: 45, max: 75),
        category: .oilChange
    )
}

extension Location {
    static let sampleLocation = Location(
        latitude: 37.7749,
        longitude: -122.4194,
        address: "123 Main St",
        city: "San Francisco",
        state: "CA",
        zipCode: "94102"
    )
}

extension ContactInfo {
    static let sampleContact = ContactInfo(
        phone: "(555) 123-4567",
        email: "mike@mikesauto.com",
        website: "www.mikesauto.com",
        workingHours: [
            WorkingHours(day: "Monday", openTime: "8:00 AM", closeTime: "6:00 PM", isClosed: false),
            WorkingHours(day: "Sunday", openTime: "", closeTime: "", isClosed: true)
        ]
    )
}

extension Review {
    static let sampleReview = Review(
        id: UUID(),
        userID: UUID(),
        mechanicID: UUID(),
        rating: 5,
        title: "Excellent Service!",
        content: "Mike fixed my engine issue quickly and at a fair price. Highly recommend!",
        photos: [],
        serviceType: .engine,
        isRecommended: true,
        aiSummary: "Customer praised quick service and fair pricing for engine repair.",
        createdAt: Date(),
        updatedAt: Date(),
        userName: "Sarah Johnson",
        userProfileImage: nil
    )
}
# WrenchWise 🔧

A social-powered iOS app that helps everyday people find and book trusted mechanics through reviews, ratings, and community feedback.

## 📱 Overview

WrenchWise is a modern iOS application built with SwiftUI that connects car owners with trusted local mechanics through a social, community-driven platform. The app combines the trust and transparency of social networks with the practical needs of automotive service discovery.

## ✨ Features

### Core Functionality
- **🔐 Email Authentication**: Secure signup and login with Supabase
- **📍 Location-Based Discovery**: Find mechanics near you
- **⭐ Trust Score System**: Visual 1-10 trust rating with color-coded indicators (red-orange-green)
- **📱 Social Feed**: Instagram/TikTok-style scrollable feed of reviews and posts
- **💬 Direct Messaging**: Chat directly with mechanics
- **📅 Booking System**: Request services and schedule appointments
- **🔍 Smart Search**: Filter by service type, location, and ratings

### Social Features
- **👥 Community Posts**: Share experiences, ask questions, and give tips
- **📝 Review System**: Post detailed reviews with photos
- **🤖 AI-Powered Summaries**: Get quick insights from community reviews
- **💭 Comment Threads**: Engage in Q&A on posts and reviews
- **❤️ Social Interactions**: Like and share valuable content

### Mechanic Profiles
- **🏪 Business Information**: Complete profiles with services, photos, and contact info
- **✅ Verification System**: Verified mechanic badges
- **📊 Trust Metrics**: Detailed breakdown of quality, reliability, communication, and value
- **🕒 Working Hours**: Clear availability information
- **💰 Service Pricing**: Transparent pricing ranges

## 🎨 Design Philosophy

WrenchWise follows **Apple's Human Interface Guidelines** closely:

### Visual Design
- **Material Design**: Uses Apple's `.regularMaterial` and `.quaternary` backgrounds
- **System Colors**: Leverages `.accentColor`, `.secondary`, and semantic colors
- **Typography**: San Francisco font with proper text styles
- **Spacing**: Consistent 8pt grid system
- **Corner Radius**: Standardized 10-12pt rounded corners

### Interaction Patterns
- **Native Navigation**: Standard iOS navigation patterns
- **Pull to Refresh**: Standard refresh gestures
- **Sheets & Modals**: Proper presentation styles with `.presentationDetents`
- **Form Controls**: Native `Picker`, `TextField`, and `Button` styles
- **Accessibility**: VoiceOver support and semantic markup

### User Experience
- **Progressive Disclosure**: Information revealed at appropriate times
- **Clear Hierarchy**: Visual importance through typography and spacing
- **Consistent Patterns**: Familiar iOS interaction models
- **Performance**: Lazy loading and efficient data management

## 🛠 Tech Stack

- **Frontend**: SwiftUI (iOS 17.0+)
- **Backend**: Supabase (Authentication + Database)
- **Database**: PostgreSQL with Row Level Security
- **Real-time**: Supabase real-time subscriptions
- **Maps**: Apple MapKit (future integration)
- **AI**: OpenAI API for review summaries (future integration)

## 📁 Project Structure

```
WrenchWise/
├── WrenchWise.xcodeproj/
├── WrenchWise/
│   ├── WrenchWiseApp.swift          # App entry point
│   ├── ContentView.swift            # Main navigation controller
│   ├── Models.swift                 # Data models
│   ├── Views/
│   │   ├── AuthView.swift           # Authentication UI
│   │   ├── FeedView.swift           # Social feed
│   │   ├── SearchView.swift         # Mechanic discovery
│   │   ├── MechanicProfileView.swift # Detailed profiles
│   │   ├── MessagingView.swift      # Chat interface
│   │   └── TrustScoreView.swift     # Trust rating components
│   ├── Services/
│   │   └── SupabaseService.swift    # Backend integration
│   ├── Assets.xcassets/             # App assets
│   └── Preview Content/             # Development previews
└── README.md
```

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0+ deployment target
- Supabase account (for backend services)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/wrenchwise.git
   cd wrenchwise
   ```

2. **Open in Xcode**
   ```bash
   open WrenchWise.xcodeproj
   ```

3. **Set up Supabase**
   - Create a new project at [supabase.com](https://supabase.com)
   - Copy your project URL and anon key
   - Update `SupabaseService.swift` with your credentials

4. **Install Dependencies**
   - Add Supabase Swift SDK via Swift Package Manager:
   ```
   https://github.com/supabase/supabase-swift
   ```

5. **Configure Database**
   - Run the SQL schema provided in `SupabaseService.swift`
   - Set up Row Level Security policies
   - Enable real-time for messages and notifications

6. **Build and Run**
   - Select your target device/simulator
   - Press `Cmd+R` to build and run

## 🗄 Database Schema

The app uses a PostgreSQL database with the following key tables:

- **users**: User profiles and authentication
- **mechanics**: Business profiles and services
- **reviews**: User reviews and ratings
- **posts**: Social feed content
- **messages**: Direct messaging
- **conversations**: Chat threads
- **booking_requests**: Service appointments

See `SupabaseService.swift` for complete schema definitions.

## 🔧 Configuration

### Supabase Setup
1. Create tables using the provided SQL schema
2. Configure authentication providers
3. Set up Row Level Security policies
4. Enable real-time subscriptions
5. Update service credentials in the app

### Environment Variables
Create a `.env` file (not tracked in git):
```
SUPABASE_URL=your_project_url
SUPABASE_ANON_KEY=your_anon_key
OPENAI_API_KEY=your_openai_key
```

## 🎯 User Journey

1. **Onboarding**: Email signup with clean, accessible forms
2. **Discovery**: Browse social feed of mechanic posts and reviews
3. **Search**: Find mechanics by location and service type
4. **Evaluation**: View detailed profiles with trust scores
5. **Communication**: Message mechanics directly
6. **Booking**: Schedule services through the app
7. **Review**: Share experiences with the community

## 🔮 Future Enhancements

### Planned Features
- **Apple ID Login**: Single sign-on integration
- **Photo Reviews**: Camera integration for review photos
- **Video Stories**: Short video testimonials
- **Payment Integration**: Stripe for in-app transactions
- **Push Notifications**: Real-time updates
- **Apple Maps**: Navigation to mechanic locations
- **Siri Integration**: Voice-activated search
- **Apple Watch**: Quick access to bookings and messages

### AI Features
- **Smart Matching**: ML-powered mechanic recommendations
- **Diagnostic Assistant**: ChatGPT integration for car issues
- **Price Prediction**: Dynamic pricing insights
- **Sentiment Analysis**: Advanced review processing

## 🤝 Contributing

We welcome contributions! Please read our contributing guidelines and submit pull requests for any improvements.

### Development Workflow
1. Fork the repository
2. Create a feature branch
3. Follow Apple's Swift style guide
4. Test on multiple device sizes
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Apple** for comprehensive Human Interface Guidelines
- **Supabase** for excellent backend-as-a-service platform
- **SwiftUI Community** for open-source components and inspiration

## 📞 Support

For support and questions:
- 📧 Email: support@wrenchwise.com
- 🐛 Issues: [GitHub Issues](https://github.com/yourusername/wrenchwise/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/yourusername/wrenchwise/discussions)

---

**Built with ❤️ for the automotive community**

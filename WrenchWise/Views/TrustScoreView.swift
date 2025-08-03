import SwiftUI

struct TrustScoreView: View {
    let score: Double
    let size: CGFloat
    
    init(score: Double, size: CGFloat = 60) {
        self.score = max(1, min(10, score)) // Clamp between 1-10
        self.size = size
    }
    
    private var scoreColor: Color {
        if score >= 8.0 { return .green }
        if score >= 6.0 { return .orange }
        return .red
    }
    
    private var progress: Double {
        (score - 1) / 9 // Convert 1-10 scale to 0-1
    }
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: size * 0.1)
                .frame(width: size, height: size)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    scoreColor,
                    style: StrokeStyle(
                        lineWidth: size * 0.1,
                        lineCap: .round
                    )
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 1.0), value: progress)
            
            // Score text
            VStack(spacing: 2) {
                Text(String(format: "%.1f", score))
                    .font(.system(size: size * 0.25, weight: .bold))
                    .foregroundColor(scoreColor)
                
                Text("TRUST")
                    .font(.system(size: size * 0.1, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct TrustScoreBadge: View {
    let score: Double
    let reviewCount: Int
    let size: CGFloat
    
    init(score: Double, reviewCount: Int, size: CGFloat = 50) {
        self.score = score
        self.reviewCount = reviewCount
        self.size = size
    }
    
    var body: some View {
        VStack(spacing: 4) {
            TrustScoreView(score: score, size: size)
            
            Text("\(reviewCount) reviews")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

struct TrustScoreCard: View {
    let mechanic: Mechanic
    
    var body: some View {
        VStack(spacing: 12) {
            TrustScoreView(score: mechanic.trustScore, size: 80)
            
            VStack(spacing: 4) {
                Text("Trust Score")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Based on \(mechanic.totalReviews) reviews")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Score breakdown
            VStack(spacing: 8) {
                TrustMetric(label: "Quality", value: mechanic.trustScore)
                TrustMetric(label: "Reliability", value: mechanic.trustScore - 0.3)
                TrustMetric(label: "Communication", value: mechanic.trustScore + 0.2)
                TrustMetric(label: "Value", value: mechanic.trustScore - 0.1)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(16)
    }
}

struct TrustMetric: View {
    let label: String
    let value: Double
    
    private var clampedValue: Double {
        max(1, min(10, value))
    }
    
    private var color: Color {
        if clampedValue >= 8.0 { return .green }
        if clampedValue >= 6.0 { return .orange }
        return .red
    }
    
    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .leading)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 4)
                        .cornerRadius(2)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * (clampedValue - 1) / 9, height: 4)
                        .cornerRadius(2)
                        .animation(.easeOut(duration: 0.8), value: clampedValue)
                }
            }
            .frame(height: 4)
            
            Text(String(format: "%.1f", clampedValue))
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(color)
                .frame(width: 25, alignment: .trailing)
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        TrustScoreView(score: 8.5)
        
        TrustScoreBadge(score: 7.2, reviewCount: 45)
        
        TrustScoreCard(mechanic: Mechanic.sampleMechanic)
    }
    .padding()
}
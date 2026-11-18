
import SwiftUI

struct PoseDetailView: View {
    @State var pose: YogaPose

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                Image(systemName: "figure.mind.and.body")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                    .frame(maxWidth: .infinity)
                    .padding()

                Text(pose.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(pose.sanskritName)
                    .font(.title3)
                    .foregroundColor(.secondary)

                Group {
                    detailRow(title: "Category", value: pose.category)
                    detailRow(title: "Difficulty", value: pose.difficulty)
                    detailRow(title: "Hold Time", value: "\(pose.holdTime) seconds")
                    detailRow(title: "Practice Count", value: "\(pose.practiceCount)")
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Benefits")
                        .font(.headline)
                    Text(pose.benefits)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Precautions")
                        .font(.headline)
                    Text(pose.precautions)
                }

                Button {
                    pose.practiceCount += 1
                    pose.lastPracticedDate = Date()
                } label: {
                    Label("Practised Today", systemImage: "checkmark.circle.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle("Pose Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .fontWeight(.semibold)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        PoseDetailView(
            pose: YogaPose(
                name: "Mountain Pose",
                sanskritName: "Tadasana",
                category: "Standing",
                difficulty: "Beginner",
                holdTime: 30,
                benefits: "Improves posture and balance",
                precautions: "Avoid standing for too long if dizzy"
            )
        )
    }
}

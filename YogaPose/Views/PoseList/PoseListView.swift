
import SwiftUI

struct PoseListView: View {

    @EnvironmentObject private var viewModel: PoseLibraryViewModel

    var body: some View {

        List {
            ForEach(viewModel.poses) { pose in

                NavigationLink {
                    PoseDetailView(pose: pose)
                } label: {

                    HStack(spacing: 15) {

                        Image(systemName: "figure.mind.and.body")
                            .font(.system(size: 35))
                            .foregroundColor(.green)
                            .frame(width: 50)

                        VStack(alignment: .leading, spacing: 6) {

                            Text(pose.name)
                                .font(.headline)
                                .foregroundColor(.primary)

                            Text(pose.sanskritName)
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            HStack {
                                Text(pose.category)
                                Text("•")
                                Text(pose.difficulty)
                            }
                            .font(.caption)
                            .foregroundColor(.green)

                            Text("Hold: \(pose.holdTime) seconds")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle("Yoga Poses")
    }
}

#Preview {
    NavigationStack {
        PoseListView()
            .environmentObject(PoseLibraryViewModel())
    }
}

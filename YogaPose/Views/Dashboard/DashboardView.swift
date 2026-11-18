
import SwiftUI

struct DashboardView: View {

    @EnvironmentObject var viewModel: PoseLibraryViewModel

    private var totalPoses: Int {
        viewModel.poses.count
    }

    private var totalCategories: Int {
        Set(viewModel.poses.map { $0.category }).count
    }

    private var practicedThisWeek: Int {
        guard let week = Calendar.current.dateInterval(
            of: .weekOfYear,
            for: Date()
        ) else {
            return 0
        }

        return viewModel.poses.filter {
            if let date = $0.lastPracticedDate {
                return week.contains(date)
            }
            return false
        }.count
    }

    private var recentPoses: [YogaPose] {
        Array(
            viewModel.poses
                .sorted { $0.dateAdded > $1.dateAdded }
                .prefix(3)
        )
    }

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 22) {

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome to Yoga Pose Library 🧘")
                            .font(.title)
                            .fontWeight(.bold)

                        Text("Find your balance. Build your strength.")
                            .foregroundColor(.secondary)
                    }

                    // Dashboard Statistics

                    Text("Your Progress")
                        .font(.title2)
                        .fontWeight(.bold)

                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 15
                    ) {

                        DashboardStatCard(
                            title: "Total Poses",
                            value: "\(totalPoses)",
                            icon: "figure.mind.and.body"
                        )

                        DashboardStatCard(
                            title: "Categories",
                            value: "\(totalCategories)",
                            icon: "square.grid.2x2"
                        )

                        DashboardStatCard(
                            title: "Practised This Week",
                            value: "\(practicedThisWeek)",
                            icon: "calendar"
                        )

                        DashboardStatCard(
                            title: "Never Practised",
                            value: "\(viewModel.poses.filter { $0.practiceCount == 0 }.count)",
                            icon: "clock"
                        )
                    }

                    // Recently Added

                    Text("Recently Added Poses")
                        .font(.title2)
                        .fontWeight(.bold)

                    if recentPoses.isEmpty {

                        Text("No poses added yet.")
                            .foregroundColor(.secondary)

                    } else {

                        ForEach(recentPoses) { pose in

                            HStack {
                                Image(systemName: "figure.mind.and.body")
                                    .font(.title2)
                                    .foregroundColor(.green)

                                VStack(alignment: .leading) {
                                    Text(pose.name)
                                        .fontWeight(.semibold)

                                    Text(pose.category)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                Text(pose.difficulty)
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }

                    // Navigation

                    Text("Explore Yoga")
                        .font(.title2)
                        .fontWeight(.bold)

                    NavigationLink(destination: PoseListView()) {
                        DashboardCard(
                            title: "Yoga Poses",
                            subtitle: "Explore all yoga poses",
                            icon: "figure.mind.and.body"
                        )
                    }

                    NavigationLink(destination: AddPoseView()) {
                        DashboardCard(
                            title: "Add New Pose",
                            subtitle: "Create your own yoga pose",
                            icon: "plus.circle"
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Dashboard")
        }
    }
}

// Statistics Card

struct DashboardStatCard: View {

    let title: String
    let value: String
    let icon: String

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.green)

            Text(value)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(15)
    }
}

// Navigation Card

struct DashboardCard: View {

    let title: String
    let subtitle: String
    let icon: String

    var body: some View {

        HStack(spacing: 15) {

            Image(systemName: icon)
                .font(.system(size: 35))
                .foregroundColor(.green)

            VStack(alignment: .leading) {

                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
    }
}

#Preview {
    DashboardView()
        .environmentObject(PoseLibraryViewModel())
}

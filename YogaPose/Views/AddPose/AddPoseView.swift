
import SwiftUI

struct AddPoseView: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: PoseLibraryViewModel

    @State private var name = ""
    @State private var sanskritName = ""
    @State private var category = "Standing"
    @State private var difficulty = "Beginner"
    @State private var holdTime = "30"
    @State private var benefits = ""
    @State private var precautions = ""

    let categories = [
        "Standing", "Seated", "Balancing",
        "Backbend", "Relaxation"
    ]

    let difficulties = [
        "Beginner", "Intermediate", "Advanced"
    ]

    var body: some View {

        Form {

            Section("Pose Information") {

                TextField("Pose Name", text: $name)

                TextField("Sanskrit Name", text: $sanskritName)

                Picker("Category", selection: $category) {
                    ForEach(categories, id: \.self) { item in
                        Text(item)
                    }
                }

                Picker("Difficulty", selection: $difficulty) {
                    ForEach(difficulties, id: \.self) { item in
                        Text(item)
                    }
                }

                TextField("Hold Time (seconds)", text: $holdTime)
                    .keyboardType(.numberPad)
            }

            Section("Benefits and Precautions") {

                TextField("Benefits", text: $benefits, axis: .vertical)

                TextField("Precautions", text: $precautions, axis: .vertical)
            }

            Section {

                Button("Save Pose") {
                    savePose()
                }
                .disabled(
                    name.trimmingCharacters(in: .whitespaces).isEmpty ||
                    sanskritName.trimmingCharacters(in: .whitespaces).isEmpty ||
                    (Int(holdTime) ?? 0) <= 0
                )
            }
        }
        .navigationTitle("Add New Pose")
    }

    private func savePose() {

        guard let seconds = Int(holdTime), seconds > 0 else {
            return
        }

        let newPose = YogaPose(
            name: name,
            sanskritName: sanskritName,
            category: category,
            difficulty: difficulty,
            holdTime: seconds,
            benefits: benefits,
            precautions: precautions
        )

        viewModel.addPose(newPose)

        dismiss()
    }
}

#Preview {
    NavigationStack {
        AddPoseView()
            .environmentObject(PoseLibraryViewModel())
    }
}

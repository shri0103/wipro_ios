
import Foundation
import Combine

class PoseLibraryViewModel: ObservableObject {

    @Published var poses: [YogaPose] = [

        YogaPose(
            name: "Mountain Pose",
            sanskritName: "Tadasana",
            category: "Standing",
            difficulty: "Beginner",
            holdTime: 30,
            benefits: "Improves posture and balance",
            precautions: "Avoid standing for too long if dizzy"
        ),

        YogaPose(
            name: "Tree Pose",
            sanskritName: "Vrikshasana",
            category: "Balancing",
            difficulty: "Beginner",
            holdTime: 30,
            benefits: "Improves balance and concentration",
            precautions: "Avoid if you have severe balance problems"
        ),

        YogaPose(
            name: "Cobra Pose",
            sanskritName: "Bhujangasana",
            category: "Backbend",
            difficulty: "Intermediate",
            holdTime: 20,
            benefits: "Strengthens the back",
            precautions: "Avoid with certain back injuries"
        )
    ]

    // Add a new pose
    func addPose(_ pose: YogaPose) {
        poses.append(pose)
    }

    // Delete a pose
    func deletePose(at index: Int) {
        poses.remove(at: index)
    }

    // Mark pose as practised
    func markPracticed(_ pose: YogaPose) {
        if let index = poses.firstIndex(where: { $0.id == pose.id }) {
            poses[index].practiceCount += 1
            poses[index].lastPracticedDate = Date()
        }
    }
}


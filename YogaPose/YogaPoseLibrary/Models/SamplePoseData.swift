//
//  SamplePoseData.swift
//  YogaPoseLibrary
//
//  Starter poses used the first time the app launches.
//

import Foundation

enum SamplePoseData {

    /// Builds the default pose collection. Some poses are intentionally left
    /// "Never Practised" so the highlight is visible straight away.
    static func make(now: Date = Date()) -> [Pose] {
        func daysAgo(_ days: Int) -> Date {
            Calendar.current.date(byAdding: .day, value: -days, to: now) ?? now
        }

        return [
            Pose(name: "Mountain Pose", sanskritName: "Tadasana", category: .standing,
                 difficulty: .beginner, holdTimeSeconds: 30,
                 benefits: "Improves posture, strengthens thighs and ankles, and builds body awareness.",
                 precautions: "Avoid if you have severe headaches or low blood pressure; keep a slight bend in the knees if dizzy.",
                 practiceCount: 6, lastPracticedDate: now, dateAdded: daysAgo(12)),
            Pose(name: "Warrior II", sanskritName: "Virabhadrasana II", category: .standing,
                 difficulty: .beginner, holdTimeSeconds: 45,
                 benefits: "Builds leg strength and stamina, opens the hips and chest.",
                 precautions: "Take care with knee injuries; keep the front knee over the ankle.",
                 practiceCount: 3, lastPracticedDate: daysAgo(2), dateAdded: daysAgo(10)),
            Pose(name: "Tree Pose", sanskritName: "Vrikshasana", category: .balancing,
                 difficulty: .beginner, holdTimeSeconds: 30,
                 benefits: "Improves balance and concentration, strengthens ankles and calves.",
                 precautions: "Use a wall for support if unsteady; avoid pressing the foot against the knee joint.",
                 practiceCount: 2, lastPracticedDate: daysAgo(9), dateAdded: daysAgo(9)),
            Pose(name: "Easy Pose", sanskritName: "Sukhasana", category: .seated,
                 difficulty: .beginner, holdTimeSeconds: 120,
                 benefits: "Calms the mind, lengthens the spine and gently opens the hips.",
                 precautions: "Sit on a folded blanket if your knees rise above your hips.",
                 practiceCount: 1, lastPracticedDate: daysAgo(1), dateAdded: daysAgo(8)),
            Pose(name: "Seated Forward Bend", sanskritName: "Paschimottanasana", category: .seated,
                 difficulty: .intermediate, holdTimeSeconds: 45,
                 benefits: "Stretches the hamstrings and lower back, and soothes the nervous system.",
                 precautions: "Bend the knees if you have lower back pain or a herniated disc.",
                 dateAdded: daysAgo(6)),
            Pose(name: "Camel Pose", sanskritName: "Ustrasana", category: .backbend,
                 difficulty: .intermediate, holdTimeSeconds: 30,
                 benefits: "Opens the chest and shoulders, and strengthens the back muscles.",
                 precautions: "Avoid with neck or serious lower-back injuries; do not drop the head back if you feel strain.",
                 dateAdded: daysAgo(5)),
            Pose(name: "Crow Pose", sanskritName: "Bakasana", category: .balancing,
                 difficulty: .advanced, holdTimeSeconds: 15,
                 benefits: "Strengthens arms, wrists and core while building focus.",
                 precautions: "Avoid with wrist injuries; practise near a cushion in case of a fall.",
                 dateAdded: daysAgo(4)),
            Pose(name: "Wheel Pose", sanskritName: "Urdhva Dhanurasana", category: .backbend,
                 difficulty: .advanced, holdTimeSeconds: 20,
                 benefits: "Energises the body, strengthens arms, legs and spine, and opens the chest.",
                 precautions: "Avoid with high blood pressure, wrist, shoulder or back injuries, and during pregnancy.",
                 dateAdded: daysAgo(3)),
            Pose(name: "Child's Pose", sanskritName: "Balasana", category: .relaxation,
                 difficulty: .beginner, holdTimeSeconds: 90,
                 benefits: "Gently stretches hips and back and relieves stress and fatigue.",
                 precautions: "Place a pillow under the hips or head if the knees are sensitive.",
                 practiceCount: 4, lastPracticedDate: daysAgo(3), dateAdded: daysAgo(2)),
            Pose(name: "Corpse Pose", sanskritName: "Savasana", category: .relaxation,
                 difficulty: .beginner, holdTimeSeconds: 300,
                 benefits: "Deeply relaxes the body, reduces stress and helps integrate the practice.",
                 precautions: "Place a bolster under the knees if you have lower back discomfort.",
                 dateAdded: daysAgo(1))
        ]
    }
}

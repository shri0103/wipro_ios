//
//  PoseFormView.swift
//  YogaPoseLibrary
//
//  Form used for both adding a new pose and editing an existing one.
//

import SwiftUI

struct PoseFormView: View {
    @StateObject private var viewModel: PoseFormViewModel
    @Environment(\.dismiss) private var dismiss

    init(repository: PoseRepository, mode: PoseFormViewModel.Mode) {
        _viewModel = StateObject(wrappedValue: PoseFormViewModel(mode: mode, repository: repository))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Names") {
                    TextField("Pose name (required)", text: $viewModel.name)
                    TextField("Sanskrit name", text: $viewModel.sanskritName)
                }

                Section("Classification") {
                    Picker("Category", selection: $viewModel.category) {
                        ForEach(PoseCategory.allCases) { Text($0.rawValue).tag($0) }
                    }
                    Picker("Difficulty", selection: $viewModel.difficulty) {
                        ForEach(DifficultyLevel.allCases) { Text($0.rawValue).tag($0) }
                    }
                }

                Section("Recommended Hold Time") {
                    Stepper(value: $viewModel.holdTimeSeconds, in: 5...600, step: 5) {
                        Text(Pose.formatHoldTime(viewModel.holdTimeSeconds))
                    }
                }

                Section("Benefits") {
                    TextEditor(text: $viewModel.benefits)
                        .frame(minHeight: 90)
                }

                Section("Precautions") {
                    TextEditor(text: $viewModel.precautions)
                        .frame(minHeight: 90)
                }

                if let message = viewModel.errorMessage {
                    Section {
                        Label(message, systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle(viewModel.screenTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if viewModel.save() { dismiss() }
                    }
                    .disabled(!viewModel.canSave)
                }
            }
        }
    }
}

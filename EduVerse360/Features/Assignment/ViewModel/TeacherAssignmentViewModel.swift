//
//  TeacherAssignmentViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 05/09/2026.
//
import Foundation
import Observation

@Observable
class TeacherAssignmentViewModel {

    var title = ""
    var description = ""
    var className = ""
    var section = ""
    var subject = ""
    var dueDate = ""
    var maxMarks = 0
    var status = ""
    var attachment: Data? = nil
    var attachmentFileName: String? = nil
    var isLoading = false
    var isSuccess = false
    var errorMessage: String?

    private let teacherAssignmentService: AssignmentProtocol

    init(
        teacherAssignmentService: AssignmentProtocol = AssignmentServerAPI()
    ) {
        self.teacherAssignmentService = teacherAssignmentService
    }

    func createTeacherAssignment() async {

        isLoading = true
        isSuccess = false
        errorMessage = nil
        print("Create Teacher Assignment is started")

        defer {
            isLoading = false
            print("Create Teacher Assignment is ended")
        }

        let request = AssignmentRequest(
            title: title,
            description: description,
            className: className,
            section: section,
            subject: subject,
            dueDate: dueDate,
            maxMarks: maxMarks,
            status: status,
            attachment: attachment,
            attachmentFileName: attachmentFileName
        )

        do {

            let response = try await teacherAssignmentService
                .createAssignment(req: request)

            print("✅ Assignment created successfully")
            print("Assignment ID:", response.data.id)

            isSuccess = true

        } catch {

            print("❌ Create assignment failed:", error)

            errorMessage = error.localizedDescription
            isSuccess = false
        }
    }
}

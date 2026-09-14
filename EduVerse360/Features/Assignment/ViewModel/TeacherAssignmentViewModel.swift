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
    var classes: [Class] = []
    var listSection: [Section] = []
    var isLoading = false

    var title = ""
    var description = ""
    var className = ""
    var section = ""
    var subject = ""
    var dueDate = ""
    var maxMarks = 0

    
    var selectedFilter = "Published"

    var attachment: Data? = nil
    var attachmentFileName: String? = nil

    var isAllSecSuccess = false
    var isSuccess = false
    var isFetchingAllClasses = false
    var errorMessage: String?

    private let teacherAssignmentService: AssignmentProtocol
    private let allClassService: ClassProtocol
    private let listSectionService: SectionProtocol

    init(
        teacherAssignmentService: AssignmentProtocol = AssignmentServerAPI(),
        allclassservice: ClassProtocol = ClassServerAPI(),
        listsectionservice: SectionProtocol = SectionServerAPI()
    ) {
        self.teacherAssignmentService = teacherAssignmentService
        self.allClassService = allclassservice
        self.listSectionService = listsectionservice
    }

    func getAllClasses() async {
        print("Fetching all classes...")

        isLoading = true
        defer {
            isLoading = false
            print("disclose all classes")
        }

        do {
            let allclassesRes: AllclassesRes = try await self.allClassService.getAllClasses()
            classes = allclassesRes.data

            isFetchingAllClasses = true
            print("All Classes are fetched Successfully", isFetchingAllClasses)

        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func getAllSection() async {
        print("Listing section process is started")
        isLoading = true
        defer {
            isLoading = false
            print("Listing section process is finished")
        }
        do {
            let response: ListSectionRes = try await self.listSectionService.listSection()
            listSection = response.data
            isAllSecSuccess = true
            print("All section Fetched Successfully")
        } catch {
            errorMessage = error.localizedDescription
        }
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
            status: selectedFilter.lowercased(),
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

            print("Create assignment failed:", error)

            errorMessage = error.localizedDescription
          
        }
    }
}

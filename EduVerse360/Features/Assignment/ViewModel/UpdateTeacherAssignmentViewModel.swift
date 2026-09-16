//
//  UpdateTeacherAssignmentViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 15/09/2026.
//

import Foundation
import Observation

@Observable
class UpdateTeacherAssignmentViewModel{

    var classes: [Class] = []
    var listSection: [Section] = []

    var isLoading = false
    var isSuccess = false
    var isFetchingAssignment = false
    var assignment : Assignment?

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

    var errorMessage : String?

    private var updateTeacherAssignmentService : AssignmentProtocol
    private let allClassService: ClassProtocol
    private let listSectionService: SectionProtocol

    init(
        updateteacherassignmentservice:AssignmentProtocol = AssignmentServerAPI(),
        allclassservice: ClassProtocol = ClassServerAPI(),
        listsectionservice: SectionProtocol = SectionServerAPI()
    ){
        self.updateTeacherAssignmentService = updateteacherassignmentservice
        self.allClassService = allclassservice
        self.listSectionService = listsectionservice
    }

    // Fetches the assignment plus the Class / Section menus, then fills
    // the form with the assignment's current values so the teacher edits
    // what's already there instead of an empty form.
    func loadAssignment(id: Int) async {
        await getAllClasses()
        await getAllSection()
        await fetchAssignment(id: id)
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
            print("All Classes are fetched Successfully")
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
            print("All section Fetched Successfully")
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func fetchAssignment(id: Int) async {
        isLoading = true
        print("Fetching assignment for update is started")
        defer {
            isLoading = false
            print("Fetching assignment for update is ended")
        }
        do {
            let response: TeacherAssignimentByIdRes = try await updateTeacherAssignmentService.getTeacherAssignmentById(id: id)
            assignment = response.data
            prefill(from: response.data)
            isFetchingAssignment = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func prefill(from assignment: Assignment) {
        title = assignment.title
        description = assignment.description
        className = assignment.className
        section = assignment.section
        subject = assignment.subject
        dueDate = assignment.dueDate
        maxMarks = assignment.maxMarks
        selectedFilter = assignment.status.capitalized
        attachmentFileName = assignment.attachmentOriginalName
        attachment = nil
    }

    func updateTeacherAssignment(id:Int)async {
        isLoading = true
        print("Update Teacher Assignment is started")
        defer{
            isLoading = false
            print("Update Teacher Assignment is ended")
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

        do{
            let response : UpdateAssignmentRes = try await self.updateTeacherAssignmentService.updateTeacherAssignment(id: id, req:  request)
            assignment = response.data
            isSuccess = true
            print(" Teacher Assignment Successfully Updated")
        }catch{
            errorMessage = error.localizedDescription
        }


    }
}

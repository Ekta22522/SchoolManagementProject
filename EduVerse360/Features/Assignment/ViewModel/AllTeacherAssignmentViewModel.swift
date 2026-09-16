//
//  AllTeacherAssignmentViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 07/09/2026.
//

import Foundation
import Observation

enum AssignmentFilter:Int,Hashable{
    case all = 0
    case published
    case pending
}


@MainActor
@Observable

class AllTeacherAssignmentViewModel{
private var assignments: [Assignment] = []
    var isLoading = false
    var isSuccess = true
    var errorMessage: String?
    var showAssignmentPdf = false
    var showFileImporter = false
    
    var selectedFilter: AssignmentFilter = .all
    
    var filteredAssignments : [Assignment] = []

    var totalCount: Int { assignments.count }
    var publishedCount: Int { assignments.filter { $0.status.lowercased() == "published" }.count }
    var pendingCount: Int { assignments.filter { $0.status.lowercased() == "pending" }.count }
    var recentAssignments: [Assignment] {
        Array(assignments.sorted { $0.createdAt > $1.createdAt }.prefix(5))
    }


    private var allTeacherAssignmentService : AssignmentProtocol
    init(allteacherassignmentservice: AssignmentProtocol = AssignmentServerAPI()){
        self.allTeacherAssignmentService = allteacherassignmentservice
    }
    
    func filterAssignment (status:AssignmentFilter){
      
        switch status {
        case .all:
            filteredAssignments = assignments
            break
        case.pending:
           let  filteredData = assignments.filter{assignment in
                assignment.status.lowercased() == "pending"
            }
            filteredAssignments = filteredData
            break
        case.published:
            filteredAssignments = assignments.filter{assignment in
                assignment.status.lowercased() == "published"
            }
            break
        }
    }
    
    func allTeacherAssignment () async {
        isLoading = true
        print("All Teacher assignment process is started")
        
        defer{
            isLoading = false
            print("All Teacher assignment process is finished")
            
        }
        do{
            let response: AllTeacherAssignmentRes = try await allTeacherAssignmentService.getAllAssignment()
            isSuccess = true
            print("All Teacher assignment fetched successfully")
            assignments = response.data
            filterAssignment(status: selectedFilter)
        }catch{
            errorMessage = error.localizedDescription
        }
    }
}

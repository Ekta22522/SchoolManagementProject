//
//  AssignmentProtocol.swift
//  EduVerse360
//
//  Created by Ekta Rai on 05/09/2026.
//

protocol AssignmentProtocol{
    func createAssignment(req:AssignmentRequest) async throws -> AssignmentResponse
    func getAllAssignment() async throws -> AllTeacherAssignmentRes
    func getTeacherAssignmentById (id:Int) async throws -> TeacherAssignimentByIdRes
    func updateTeacherAssignment(id:Int) async throws -> UpdateAssignmentRes
    
}

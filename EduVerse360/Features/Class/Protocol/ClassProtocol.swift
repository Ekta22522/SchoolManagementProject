//
//  ClassProtocol.swift
//  EduVerse360
//
//  Created by Ekta Rai on 17/08/2026.
//

protocol ClassProtocol{
    func createClass (req: ClassReq) async throws -> ClassRes
    func getAllClasses () async throws -> AllclassesRes
    func getClassByID (id: String) async throws -> ClassByIDRes
    func updateClass (id:String, req: ClassReq) async throws -> UpdateClassRes
    func deleteClass (id:String, req: ClassReq)async throws -> DeleteClassRes
}

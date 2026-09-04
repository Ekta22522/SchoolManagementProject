//
//  OnlinceClassProtocol.swift
//  EduVerse360
//
//  Created by Ekta Rai on 31/08/2026.
//

protocol OnlineClassProtocol{
    func getOnlineClass (req: OnlineClassReq) async throws -> OnlineClassRes
    func readAllOnlineClass ()async throws -> ListOnlineClassRes
    func getOnlineClassById(id:Int) async throws -> OnlineClassByIdRes
    func updateOnlineClass(id:Int,req: UpdateOnlineClassReq)async throws -> UpdateOnlineClassRes
    func getDeleteOnlineClass(id:Int) async throws -> DeleteOnlineClassRes
}

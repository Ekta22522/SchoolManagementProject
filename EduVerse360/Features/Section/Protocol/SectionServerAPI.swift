//
//  Untitled.swift
//  EduVerse360
//
//  Created by Ekta Rai on 20/08/2026.
//

class SectionServerAPI : SectionProtocol{
    
    func createSection(req: SectionReq,id:String) async throws -> SectionRes {
        do{
            let sectionRes : SectionRes = try await APIClient.shared.request(APIEndpoint.createSection(id: id), body: req)
            return sectionRes
            
        }catch let error{
           throw error
        }
        
    }
}

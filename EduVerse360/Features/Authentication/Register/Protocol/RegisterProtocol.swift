//
//  RegisterRepository.swift
//  EduVerse360
//
//  Created by Ekta Rai on 05/08/2026.
//


protocol RegisterProtocol{
    func register(req: RegisterRequest)  async throws -> RegisterResponse
    
    func verifyRegistration (req:VerifyRegisterationReq) async throws -> VerifyRegisterationRes
    
    
}

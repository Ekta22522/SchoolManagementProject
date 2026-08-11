//
//  ForgotPasswordProtocol.swift
//  EduVerse360
//
//  Created by Ekta Rai on 10/08/2026.
//

protocol ForgotPasswordProtocol{
    func forgotPassword (req: ForgotPasswordReq) async throws -> ForgotPasswordRes
    func verifyOtp ( req: VerifyOtpReq) async throws -> VerifyOtpRes
}

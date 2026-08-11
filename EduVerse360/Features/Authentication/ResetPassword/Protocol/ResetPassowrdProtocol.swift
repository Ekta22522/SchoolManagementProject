//
//  ResetPassowrdProtocol.swift
//  EduVerse360
//
//  Created by Ekta Rai on 11/08/2026.
//

import Foundation

protocol ResetPassowrdProtocol{
    func resetPassword (req:ResetPasswordReq) async throws -> ResetPasswordRes
}

//
//  AuthRoute.swift
//  EduVerse360
//
//  Created by Ekta Rai on 12/09/2026.
//

import Foundation

enum AuthRoute: Hashable {
    case register
    case verifyRegistrationOTP(email: String)
    case forgotPassword
    case verifyOtp(email: String)
    case resetPassword(email: String)
}

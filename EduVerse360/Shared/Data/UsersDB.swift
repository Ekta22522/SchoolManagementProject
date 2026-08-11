import Foundation

let dummyDB: [UserModel] = [
    UserModel(
        id: 1,
        username: "Admin",
        email: "admin@example.com",
        role: "admin",
        isVerified: true,
        createdAt: ""
    ),
    UserModel(
        id: 2,
        username: "John Doe",
        email: "john@example.com",
        role: "teacher",
        isVerified: true,
        createdAt: ""
    ),
    UserModel(
        id: 3,
        username: "Emma Watson",
        email: "emma@example.com",
        role: "student",
        isVerified: false,
        createdAt: ""
    ),
    UserModel(
        id: 4,
        username: "Sophia",
        email: "sophia@example.com",
        role: "student",
        isVerified: true,
        createdAt: ""
    )
]

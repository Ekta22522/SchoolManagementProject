
import Foundation
import Observation

enum onlineClassError: Hashable {
    case idError
    case descriptionError
    case classNameError
    case sectionError
    case subjectError
    case teacherIdError
    case meetingUrlError
    case scheduledAtError
    case durationMinutesError
    case statusError
    case createdAtError
    case updatedAtError
}

@MainActor
@Observable
class CreateOnlineClassViewModel {

    // MARK: - Online Class

    var onlineClass: OnlineClass?

    // MARK: - Loading / Success

    var isLoading = false
    var isOnlineClassSuccess = false

    // MARK: - Fields

    var title = ""
    var description = ""
    var className = ""
    var section = ""
    var subject = ""
    var meetingUrl = ""

    var scheduledDate = Date()
    var durationMinutes = 60

    // MARK: - Field Errors

    var descriptionError: String?
    var meetingUrlError: String?
    var titleError: String?
    var classNameError: String?
    var sectionError: String?
    var subjectError: String?
    var scheduledAtError: String?
    var durationMinutesError: String?

    // MARK: - General Error

    var errorMessage: String?
    var createOnlineClassError: String?

    // MARK: - Duration Options

    let durationOptions = [30, 45, 60, 90, 120]

    // MARK: - Service

    private let createOnlineClassService: OnlineClassProtocol

    init(
        onlineclassservice: OnlineClassProtocol = OnlineClassProtocolImp()
    ) {
        self.createOnlineClassService = onlineclassservice
    }

    // MARK: - Validation

    func checkAllFields() {

        // Clear previous errors
        titleError = nil
        descriptionError = nil
        classNameError = nil
        sectionError = nil
        subjectError = nil
        meetingUrlError = nil
        scheduledAtError = nil
        durationMinutesError = nil
        createOnlineClassError = nil
        errorMessage = nil

        // Title
        if title.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty {

            titleError = "Title is required."
            return

        }

        // Class name
        else if className.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty {

            classNameError = "Class name is required."
            return

        }

        // Subject
        else if subject.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty {

            subjectError = "Subject is required."
            return

        }

        // Scheduled date
        else if scheduledDate <= Date.distantPast {

            scheduledAtError = "Schedule date and time is required."
            return

        }

        // Duration
        else if durationMinutes <= 0 {

            durationMinutesError = "Duration must be greater than 0."
            return
        }
    }

    // MARK: - Create Online Class

    func createOnlineClass() async {

        checkAllFields()

        // Stop if validation failed
        if titleError != nil ||
            classNameError != nil ||
            subjectError != nil ||
            scheduledAtError != nil ||
            durationMinutesError != nil {

            return
        }

        print("Create Online class process is started")

        isLoading = true
        isOnlineClassSuccess = false
        errorMessage = nil

        defer {
            isLoading = false
            print("Create Online class process is finished")
        }

        do {

            // MARK: - Date Formatting

            let formatter = ISO8601DateFormatter()

            let scheduledAt = formatter.string(
                from: scheduledDate
            )

            // MARK: - Request

            let request = OnlineClassReq(
                title: title,
                description: description,
                className: className,
                section: section,
                subject: subject,
                meetingUrl: meetingUrl,
                scheduledAt: scheduledAt,
                durationMinutes: durationMinutes
            )

            // MARK: - API Call

            let response: OnlineClassRes =
                try await createOnlineClassService.getOnlineClass(
                    req: request
                )

            // MARK: - Success

            onlineClass = response.data
            isOnlineClassSuccess = true

            print(
                "Online class created successfully:",
                isOnlineClassSuccess
            )

        } catch let error as NetworkError {

            // MARK: - Server Error Handling

            switch error {

            case .serverError(let statusCode):

                if statusCode == 400 {

                    errorMessage =
                        "Invalid online class information."

                } else if statusCode == 401 {

                    errorMessage =
                        "Authentication required. Please login again."

                } else if statusCode == 403 {

                    errorMessage =
                        "You are not allowed to create an online class."

                } else if statusCode == 404 {

                    errorMessage =
                        "The requested resource was not found."

                } else if statusCode >= 500 {

                    errorMessage =
                        "Server error. Please try again later."

                } else {

                    errorMessage =
                        "Something went wrong. Please try again."
                }

            case .unauthorized:

                errorMessage =
                    "Authentication required. Please login again."

            case .noInternet:

                errorMessage =
                    "No internet connection. Please check your network."

            case .invalidURL:

                errorMessage =
                    "Invalid server URL."

            case .invalidResponse:

                errorMessage =
                    "Invalid response from server."

            case .decodingFailed:

                errorMessage =
                    "Unable to process server response."

            case .unknown(let error):

                errorMessage =
                    error.localizedDescription
            }

        } catch {

            errorMessage =
                error.localizedDescription
        }
    }
}


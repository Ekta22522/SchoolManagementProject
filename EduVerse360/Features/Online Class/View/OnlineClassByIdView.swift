import SwiftUI

struct OnlineClassByIdView: View {

    @State private var viewModel = OnlineClassByIDViewModel()
    @Environment(NavigationRouter.self) private var router

    let onlineClassId: Int

    var body: some View {

        ZStack {

            Color.white
                .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {

                if let onlineClass = viewModel.onlineClassId {

                    VStack(alignment: .leading, spacing: 20) {
                        
                        // MARK: - Header
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            Text("Online Class")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text("Class details and schedule")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .padding(.horizontal, 25)
                        .padding(.top, 30)
                        
                        
                        // MARK: - Class Detail Card
                        
                        VStack(alignment: .leading, spacing: 18) {
                            
                            // MARK: Title
                            
                            VStack(alignment: .leading, spacing: 6) {
                                
                                Text("Title")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text(onlineClass.title ?? "No title")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                            }
                            
                            
                            // MARK: Description
                            
                            VStack(alignment: .leading, spacing: 6) {
                                
                                Text("Description")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text(onlineClass.description)
                                    .font(.subheadline)
                                    .lineSpacing(3)
                                
                            }
                            
                            
                            Divider()
                            
                            
                            // MARK: Class Information
                            
                            HStack(spacing: 15) {
                                
                                VStack(
                                    alignment: .leading,
                                    spacing: 5
                                ) {
                                    
                                    Text("Class")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Text(onlineClass.className)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }
                                
                                Spacer()
                                
                                VStack(
                                    alignment: .trailing,
                                    spacing: 5
                                ) {
                                    
                                    Text("Subject")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Text(onlineClass.subject)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }
                            }
                            
                            
                            // MARK: Section & Duration
                            
                            HStack {
                                
                                Label(
                                    onlineClass.section,
                                    systemImage: "person.3"
                                )
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Label(
                                    "\(onlineClass.durationMinutes) min",
                                    systemImage: "clock"
                                )
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            }
                            
                            
                            Divider()
                            
                            
                            // MARK: Schedule
                            
                            VStack(
                                alignment: .leading,
                                spacing: 10
                            ) {
                                
                                Text("Schedule")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                HStack(spacing: 12) {
                                    
                                    // MARK: Date
                                    
                                    VStack(
                                        alignment: .leading,
                                        spacing: 5
                                    ) {
                                        
                                        Text("Date")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        
                                        Label(
                                            formattedDate(
                                                from: onlineClass.scheduledAt
                                            ),
                                            systemImage: "calendar"
                                        )
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        
                                    }
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )
                                    .padding(12)
                                    .background(
                                        Color.gray.opacity(0.08)
                                    )
                                    .clipShape(
                                        RoundedRectangle(
                                            cornerRadius: 10
                                        )
                                    )
                                    
                                    
                                    // MARK: Time
                                    
                                    VStack(
                                        alignment: .leading,
                                        spacing: 5
                                    ) {
                                        
                                        Text("Time")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        
                                        Label(
                                            formattedTime(
                                                from: onlineClass.scheduledAt
                                            ),
                                            systemImage: "clock"
                                        )
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        
                                    }
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )
                                    .padding(12)
                                    .background(
                                        Color.gray.opacity(0.08)
                                    )
                                    .clipShape(
                                        RoundedRectangle(
                                            cornerRadius: 10
                                        )
                                    )
                                }
                            }
                            
                            
                            Divider()
                            
                            
                            // MARK: Meeting URL
                            
                            VStack(
                                alignment: .leading,
                                spacing: 8
                            ) {
                                
                                Text("Meeting URL")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                
                                if let url = URL(
                                    string: onlineClass.meetingUrl
                                ) {
                                    
                                    Link(destination: url) {
                                        
                                        HStack(spacing: 8) {
                                            
                                            Image(
                                                systemName: "video.fill"
                                            )
                                            
                                            Text("Join Online Class")
                                                .fontWeight(.semibold)
                                            
                                            Spacer()
                                            
                                            Image(
                                                systemName: "arrow.up.right"
                                            )
                                        }
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 14)
                                        .frame(
                                            maxWidth: .infinity
                                        )
                                        .frame(height: 48)
                                        .background(Color.primary)
                                        .clipShape(
                                            RoundedRectangle(
                                                cornerRadius: 12
                                            )
                                        )
                                    }
                                    
                                } else {
                                    
                                    Text("Meeting link unavailable")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(20)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .background(Color.white)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 20,
                                style: .continuous
                            )
                        )
                        .overlay(
                            RoundedRectangle(
                                cornerRadius: 20,
                                style: .continuous
                            )
                            .stroke(
                                Color.gray.opacity(0.15),
                                lineWidth: 1
                            )
                        )
                        .shadow(
                            color: .black.opacity(0.08),
                            radius: 8,
                            x: 0,
                            y: 3
                        )
                        .padding(.horizontal, 25)
                        
                        HStack(spacing:20){
                            Button(action:{
                                router.goToUpdateOnlineClass(id: onlineClassId)
                            },label:{
                                Text("Update")
                                    .foregroundStyle(Color.white)
                            })
                            .frame(maxWidth: 200,maxHeight: 50)
                            .background(Color.primary)
                            .cornerRadius(10)
                            
                            Button(action:{
                                router.goToDeleteOnlineClass(id: onlineClassId)
                            },label:{
                                Text("Delete")
                                    .foregroundStyle(Color.white)
                            })
                            .frame(maxWidth: 200,maxHeight: 50)
                            .background(Color.primary)
                            .cornerRadius(10)
                            
                        }
                    }

                }
                else if viewModel.isLoading {

                    // MARK: - Loading

                    VStack(spacing: 12) {

                        ProgressView()

                        Text("Loading class details...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 500
                    )

                }
                else {

                    // MARK: - Error

                    VStack(spacing: 12) {

                        Image(systemName: "exclamationmark.circle")
                            .font(.system(size: 40))
                            .foregroundColor(.red)

                        Text("Unable to Load Online Class")
                            .font(.headline)

                        if let errorMessage = viewModel.errorMessage {

                            Text(errorMessage)
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                    }
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 500
                    )
                    .padding(.horizontal, 30)
                }
            }
        }
        .task {

            await viewModel.getOnlineClassById(
                id: onlineClassId
            )
        }
    }


    // MARK: - Formatted Date

    private func formattedDate(
        from scheduledAt: String
    ) -> String {

        guard let date = parseScheduledDate(scheduledAt)
        else {
            return "Not available"
        }

        let formatter = DateFormatter()

        formatter.dateStyle = .medium

        return formatter.string(from: date)
    }


    // MARK: - Formatted Time

    private func formattedTime(
        from scheduledAt: String
    ) -> String {

        guard let date = parseScheduledDate(scheduledAt)
        else {
            return "Not available"
        }

        let formatter = DateFormatter()

        formatter.timeStyle = .short

        return formatter.string(from: date)
    }


    // MARK: - Parse Scheduled Date

    private func parseScheduledDate(
        _ scheduledAt: String
    ) -> Date? {

        let isoFormatter = ISO8601DateFormatter()

        isoFormatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]

        if let date = isoFormatter.date(
            from: scheduledAt
        ) {
            return date
        }

        isoFormatter.formatOptions = [
            .withInternetDateTime
        ]

        if let date = isoFormatter.date(
            from: scheduledAt
        ) {
            return date
        }

        let formatter = DateFormatter()

        formatter.locale = Locale(
            identifier: "en_US_POSIX"
        )

        formatter.dateFormat =
            "yyyy-MM-dd'T'HH:mm:ss"

        if let date = formatter.date(
            from: scheduledAt
        ) {
            return date
        }

        formatter.dateFormat =
            "yyyy-MM-dd'T'HH:mm:ss.SSS"

        if let date = formatter.date(
            from: scheduledAt
        ) {
            return date
        }

        print(
            "❌ Could not parse scheduledAt:",
            scheduledAt
        )

        return nil
    }
}

#Preview {
    OnlineClassByIdView(
        onlineClassId: 1
    )
}

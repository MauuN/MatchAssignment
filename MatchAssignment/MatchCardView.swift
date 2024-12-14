//
//  MatchCardView.swift
//  MatchAssignment
//
//  Created by NIKTE Mayuri on 14/12/24.
//

import SwiftUI

struct MatchCardView: View {
    @ObservedObject var profile: Profile
    @State private var status: String
    @State private var hideButton: Bool = false

    init(profile: Profile) {
        self.profile = profile
        _status = State(initialValue: profile.status ?? "none")
    }

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: profile.pictureUrl ?? "")) { image in
                image.resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding(5)
            } placeholder: {
                ProgressView()
            }

            Text(profile.name ?? "No Name")
                .font(.title2)
            Text("Age: \(profile.age)")
            Text(profile.city ?? "Unknown City")
                .font(.subheadline)

            if hideButton {
                Text(profile.status ?? "")
                    .font(.caption)
                    .foregroundColor(status == "accepted" ? .green : .red)
                    .padding(6)
                    .background(status == "accepted" ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                    .cornerRadius(8)
            } else {
                HStack {
                    Button{
                        updateStatus("accepted")
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.green)
                    }
           
                    Button{
                        updateStatus("declined")
                    }label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal, 50)
                .padding(.vertical, 5)
              
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 8)
    }

    // Update the status of the profile
    func updateStatus(_ newStatus: String) {
        status = newStatus
        profile.status = newStatus
        
        // Update status in CoreData via ViewModel
        let viewModel = MatchListViewModel()  // Assuming MatchListViewModel is where CoreData updates happen
        viewModel.updateProfileStatus(profile: profile, status: newStatus)
        hideButton = true
    }
}



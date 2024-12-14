//
//  MatchListViewModel.swift
//  MatchAssignment
//
//  Created by NIKTE Mayuri on 14/12/24.
//

import Foundation
import Combine
import CoreData

class MatchListViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var profiles: [Profile] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchProfilesFromCoreData()
        fetchUsersFromNetwork()
    }

    // Fetch users from the network and save them to CoreData
    func fetchUsersFromNetwork() {
        NetworkManager.shared.fetchUsers { [weak self] fetchedUsers in
            guard let self = self, let fetchedUsers = fetchedUsers else { return }
            DispatchQueue.main.async {
                self.users = fetchedUsers
                // Save users to CoreData
                for user in fetchedUsers {
                    self.saveProfileToCoreData(user: user)
                }
                self.fetchProfilesFromCoreData()
            }
        }
    }

    // Fetch saved profiles from CoreData
    func fetchProfilesFromCoreData() {
        let context = PersistenceController.shared.container.viewContext
        let request: NSFetchRequest<Profile> = Profile.fetchRequest()

        do {
            let profiles = try context.fetch(request)
            self.profiles = profiles
        } catch {
            print("Failed to fetch profiles: \(error.localizedDescription)")
        }
    }

    // Save a user to CoreData
    func saveProfileToCoreData(user: User) {
        let context = PersistenceController.shared.container.viewContext
        let profile = Profile(context: context)
        profile.id = user.id
        profile.name = "\(user.name.first) \(user.name.last)"
        profile.age = Int16(user.dob.age)
        profile.city = user.location.city
        profile.pictureUrl = user.picture.large
        profile.status = "none"

        do {
            try context.save()
        } catch {
            print("Failed to save profile: \(error.localizedDescription)")
        }
    }

    // Update profile status (accept/decline)
    func updateProfileStatus(profile: Profile, status: String) {
        profile.status = status
        let context = PersistenceController.shared.container.viewContext
        do {
            try context.save()
        } catch {
            print("Failed to update profile: \(error.localizedDescription)")
        }
    }
    
//    func acceptUser(at index: Int) {
//           users[index].status = .accepted
//       }
//       
//      
//       func declineUser(at index: Int) {
//           users[index].status = .declined
//       }
}


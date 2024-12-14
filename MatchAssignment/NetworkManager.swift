//
//  NetworkManager.swift
//  MatchAssignment
//
//  Created by NIKTE Mayuri on 14/12/24.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String { login.uuid }
    var name: Name
    var picture: Picture
    var location: Location
    var dob: DateOfBirth
    var email: String
    var login: Login 
    var status: MatchStatus = .none
    
    // Name struct
    struct Name: Codable {
        var title: String
        var first: String
        var last: String
    }

    // Picture struct
    struct Picture: Codable {
        var large: String
    }

    // Location struct
    struct Location: Codable {
        var city: String
        var state: String?
    }

    // DateOfBirth struct with an age field
    struct DateOfBirth: Codable {
        var age: Int
    }

    // Login struct to hold uuid
    struct Login: Codable {
        var uuid: String
    }
    
    enum MatchStatus: String, Codable {
            case accepted
            case declined
            case none
        }
}

struct UserResponse: Codable {
    var results: [User]
}


class NetworkManager {
    static let shared = NetworkManager()

    private let apiUrl = "https://randomuser.me/api/?results=10"

    func fetchUsers(completion: @escaping ([User]?) -> Void) {
        guard let url = URL(string: apiUrl) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                completion(nil)
                return
            }

            // Debugging: Print out the raw JSON response for further inspection
            if let rawJSONString = String(data: data, encoding: .utf8) {
                print("Raw JSON Response: \(rawJSONString)")
            }

            do {
                // Decode the JSON as UserResponse, which contains a results key
                let response = try JSONDecoder().decode(UserResponse.self, from: data)
                completion(response.results)
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
                completion(nil)
            }
        }

        task.resume()
    }
}




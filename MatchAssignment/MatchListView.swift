//
//  MatchListView.swift
//  MatchAssignment
//
//  Created by NIKTE Mayuri on 14/12/24.
//

import SwiftUI

struct MatchListView: View {
    @StateObject private var viewModel = MatchListViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.profiles, id: \.id) { profile in
                MatchCardView(profile: profile)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
            .background(Color.clear)
            .navigationTitle("Matches")
            .onAppear {
                viewModel.fetchProfilesFromCoreData()
            }
        }
    }
}


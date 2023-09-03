//
//  JoynCodeChallengeApp.swift
//  JoynCodeChallenge
//
//  Created by Hamed Moosaei on 7/29/23.
//

import SwiftUI

@main
struct JoynCodeChallengeApp: App {
    let appDependencyContainer = AppDependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            appDependencyContainer.moviesDependencyContainer.moviesListView
        }
    }
}

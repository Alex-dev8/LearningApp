//
//  LearningAppApp.swift
//  LearningApp
//
//  Created by Alex Cannizzo on 30/09/2021.
//

import SwiftUI

@main
struct LearningApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}

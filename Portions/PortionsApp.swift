//
//  PortionsApp.swift
//  Portions
//
//  Created by Thais Rodríguez on 12/8/23.
//

import ComposableArchitecture
import SwiftUI

@main
struct PortionsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store:
                Store(initialState: Content.State()) {
                    Content()._printChanges()
                }
            )
        }
    }
}

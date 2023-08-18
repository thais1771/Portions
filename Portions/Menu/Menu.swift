//
//  Menu.swift
//  Portions
//
//  Created by Thais Rodríguez on 18/8/23.
//

import ComposableArchitecture
import Foundation
import UIKit

struct MenuOption: Equatable, Hashable, Identifiable {
    var id = UUID()

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }

    static func == (lhs: MenuOption, rhs: MenuOption) -> Bool {
        lhs.title == rhs.title
    }

    let title: String
    let icon: String?
    let action: () -> Void
}

struct Menu: Reducer {
    enum Action: Equatable {
        case dismiss
    }

    struct State: Equatable {
        var options: [MenuOption] = [MenuOption(title: "Share",
                                                icon: "square.and.arrow.up",
                                                action: {
                                                    if let url = URL(string: "https://www.hackingwithswift.com") {
                                                        UIApplication.shared.open(url)
                                                    }
                                                }),
                                     MenuOption(title: "Report a bug",
                                                icon: "ladybug",
                                                action: {
                                                    if let url = URL(string: "mailto:thais1771@gmail.com") {
                                                        UIApplication.shared.open(url)
                                                    }
                                                })]
    }

    var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .dismiss:
                return .none
            }
        }
    }
}

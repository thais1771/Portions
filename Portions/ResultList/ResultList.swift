//
//  ResultList.swift
//  Portions
//
//  Created by Thais Rodríguez on 16/8/23.
//

import ComposableArchitecture
import Foundation

struct ResultList: Reducer {
    enum Action: Equatable {
        case dismiss
    }

    struct State: Equatable {
        let ingredients: [Ingredient]
        let portions: Int
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

//
//  ResultListView.swift
//  Portions
//
//  Created by Thais Rodríguez on 15/8/23.
//

import ComposableArchitecture
import SwiftUI

struct ResultList: Reducer {
    enum Action: Equatable {
        case dismiss
    }

    struct State: Equatable {
        let ingredients: [Ingredient]
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

struct ResultListView: View {
    let store: StoreOf<ResultList>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Section {
                    ForEach(viewStore.ingredients, id: \.self) { ingredient in
                        HStack {
                            Text(ingredient.name)
                            Spacer()
                            Text("\(ingredient.quantity) gr")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
    }
}

struct ResultListView_Previews: PreviewProvider {
    static var previews: some View {
        ResultListView(
            store: Store(
                initialState: ResultList.State(ingredients: [Ingredient(name: "Avena",
                                                                               quantity: 15),
                                                                    Ingredient(name: "Yogurt",
                                                                               quantity: 60),
                                                                    Ingredient(name: "Honey",
                                                                               quantity: 5)])) {
                                                                                   ResultList()
            }
        )
    }
}

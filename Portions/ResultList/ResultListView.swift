//
//  ResultListView.swift
//  Portions
//
//  Created by Thais Rodríguez on 15/8/23.
//

import ComposableArchitecture
import SwiftUI

struct ResultListView: View {
    let store: StoreOf<ResultList>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Text("Ingredients")
                    .foregroundColor(.primary)
                    .bold()
                    .font(Font.system(size: 30))
                    .padding(.top, 50)
                Form {
                    Section(footer: HStack {
                        Spacer()
                        Text("TOTAL: \(PortionerManager.sumIngredientsQuantity(viewStore.ingredients)) gr")
                            .foregroundColor(.primary)
                            .bold()
                    }) {
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
                .scrollContentBackground(.hidden)
            }
            .background(
                Image("resultBkg")
                    .resizable()
                    .foregroundColor(.primary)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.3)
            )
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

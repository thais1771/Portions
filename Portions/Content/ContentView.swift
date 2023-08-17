//
//  ContentView.swift
//  Portions
//
//  Created by Thais Rodríguez on 12/8/23.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
    let store: StoreOf<Content>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Section(header: Text("NEW INGREDIENT FORM")) {
                    HStack {
                        TextField("Name", text: viewStore.binding(get: \.txtfieldIngredientName,
                                                                  send: Content.Action.ingredientNameTextDidChange))
                        Spacer()
                        Button {
                            viewStore.send(.addIngredientBtnTapped)
                        } label: {
                            Image(systemName: "plus")
                        }
                        Spacer()
                    }
                    HStack {
                        TextField("Quantity", text: viewStore.binding(get: \.txtfieldQuantity,
                                                                      send: Content.Action.quantityTextDidChange))
                        Spacer()
                        Text("gr")
                            .foregroundColor(.secondary)
                    }
                }
                if !viewStore.ingredients.isEmpty {
                    Section(header: Text("INGREDIENTS LIST"),
                            footer: HStack {
                                Spacer()
                                Text("TOTAL: \(PortionerManager.sumIngredientsQuantity(viewStore.ingredients)) gr")
                            }) {
                        ForEach(viewStore.ingredients, id: \.self) { ingredient in
                            HStack {
                                Text(ingredient.name)
                                Spacer()
                                Text("\(ingredient.quantity) gr")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .onDelete { indexSet in
                            viewStore.send(.deleteIngredientSwipeAction(indexSet: indexSet))
                        }
                    }
                }
                Section(header: Text("DESIRED AMOUNT")) {
                    HStack {
                        Text("Ingredients units")
                        Spacer()
                        Picker("", selection: viewStore.binding(get: \.ingredientsUnits, send: Content.Action.ingredientsUnitsPickerDidSelect)) {
                            ForEach(IngredientsUnits.allCases, id: \.self) { unit in
                                Text(unit.rawValue.capitalized)
                            }
                        }.pickerStyle(.automatic)
                    }
                    if viewStore.ingredientsUnits == .portions {
                        HStack {
                            Text("Entered recipe portions")
                            TextField("Portions", text: viewStore.binding(get: \.txtfieldRecipePortions,
                                                                          send: Content.Action.recipePortionsTextDidChange))
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    HStack {
                        Text("Desired amount")
                        TextField(viewStore.ingredientsUnits.rawValue.capitalized, text: viewStore.binding(get: \.desiredAmount,
                                                                                                           send: Content.Action.desiredAmounTextDidChange))
                            .multilineTextAlignment(.trailing)
                    }
                }
                Section {
                    Button {
                        viewStore.send(.converBtnTapped)
                    } label: {
                        VStack(alignment: .center) {
                            Text("Convert")
                        }.frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .sheet(store: store.scope(
            state: \.$resultState,
            action: Content.Action.resultSheet)) { store in
                NavigationView {
                    ResultListView(store: store)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store:
            Store(initialState: Content.State(ingredients: [Ingredient(name: "Avena", quantity: 15),
                                                            Ingredient(name: "Yogurt", quantity: 60),
                                                            Ingredient(name: "Honey", quantity: 5)],
                                              txtfieldIngredientName: "",
                                              txtfieldQuantity: "",
                                              txtfieldRecipePortions: "2",
                                              desiredAmount: "3",
                                              error: nil)) {
                Content()
            }
        )
    }
}

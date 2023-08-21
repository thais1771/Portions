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
    @FocusState private var focusForm1: Form1?

    enum Form1: Int, Hashable {
        case name
        case quantity
    }

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                Form {
                    Section(header: Text("NEW INGREDIENT FORM"),
                            footer: HStack {
                                Spacer()
                                Text("Add ingredient")
                                Button(action: {
                                    viewStore.send(.addIngredientBtnTapped)
                                    self.focusPreviousField($focusForm1)
                                }) {
                                    Image(systemName: "plus")
                                }
                                .padding(.vertical, 5)
                                .disabled(
                                    viewStore.txtfieldIngredientName.isEmpty ||
                                    viewStore.txtfieldQuantity.isEmpty
                                )
                            }) {
                        TextField("Name", text: viewStore.binding(get: \.txtfieldIngredientName,
                                                                  send: Content.Action.ingredientNameTextDidChange))
                            .focused($focusForm1, equals: .name)
                            .onSubmit { self.focusNextField($focusForm1) }
                        HStack {
                            TextField("Quantity", text: viewStore.binding(get: \.txtfieldQuantity,
                                                                          send: Content.Action.quantityTextDidChange))
                                .focused($focusForm1, equals: .quantity)
                                .keyboardType(.numberPad)
                            Spacer()
                            Picker("", selection: viewStore.binding(get: \.ingredientUnit, send: Content.Action.ingredientUnitPickerDidSelect)) {
                                ForEach([IngredientsUnits.gr, IngredientsUnits.ml], id: \.self) { unit in
                                    Text(unit.rawValue.capitalized)
                                }
                            }.pickerStyle(.navigationLink)
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
                    Section(
                        header: Text("Data")
                    ) {
                        HStack {
                            Text("Ingredients units")
                            Spacer()
                            Picker("", selection: viewStore.binding(get: \.recipeUnits, send: Content.Action.recipeUnitsPickerDidSelect)) {
                                ForEach([IngredientsUnits.portions, IngredientsUnits.gr], id: \.self) { unit in
                                    Text(unit.rawValue.capitalized)
                                }
                            }.pickerStyle(.navigationLink)
                        }
                        if viewStore.recipeUnits == .portions {
                            HStack {
                                Text("Entered recipe portions")
                                TextField("Portions", text: viewStore.binding(get: \.txtfieldRecipePortions,
                                                                              send: Content.Action.recipePortionsTextDidChange))
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.numberPad)
                                    .scrollDismissesKeyboard(.immediately)
                            }
                        }
                        HStack {
                            Text("Desired amount")
                            TextField(viewStore.recipeUnits.rawValue.capitalized, text: viewStore.binding(get: \.desiredAmount,
                                                                                                               send: Content.Action.desiredAmounTextDidChange))
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.numberPad)
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
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Ok") {
                            viewStore.send(.addIngredientBtnTapped)
                            hideKeyboard()
                        }
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            viewStore.send(.menuBtnTapped)
                        } label: {
                            Image(systemName: "list.bullet")
                        }
                    }
                }
                .navigationDestination(
                    store: store.scope(
                        state: \.$menuState,
                        action: Content.Action.menuPresent)) {
                    MenuView(store: $0)
                }
            }
        }
        .sheet(
            store: store.scope(
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

extension View {
    func focusNextField<F: RawRepresentable>(_ field: FocusState<F?>.Binding) where F.RawValue == Int {
        guard let currentValue = field.wrappedValue else { return }
        let nextValue = currentValue.rawValue + 1
        if let newValue = F(rawValue: nextValue) {
            field.wrappedValue = newValue
        }
    }

    func focusPreviousField<F: RawRepresentable>(_ field: FocusState<F?>.Binding) where F.RawValue == Int {
        guard let currentValue = field.wrappedValue else { return }
        let nextValue = currentValue.rawValue - 1
        if let newValue = F(rawValue: nextValue) {
            field.wrappedValue = newValue
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

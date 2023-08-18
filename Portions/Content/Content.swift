//
//  Content.swift
//  Portions
//
//  Created by Thais Rodríguez on 14/8/23.
//

import ComposableArchitecture
import Foundation

struct Ingredient: Hashable {
    let name: String
    let quantity: Int
}

enum IngredientsUnits: String, CaseIterable {
    case portions
    case gr
}

struct Content: Reducer {
    enum Action {
        // Text fileds changed
        case quantityTextDidChange(quantity: String)
        case desiredAmounTextDidChange(quantity: String)
        case recipePortionsTextDidChange(portions: String)
        case ingredientNameTextDidChange(name: String)

        // Button tapped
        case addIngredientBtnTapped
        case converBtnTapped

        // Others
        case deleteIngredientSwipeAction(indexSet: IndexSet)
        case ingredientsUnitsPickerDidSelect(unit: IngredientsUnits)

        // Result List
        case resultSheet(PresentationAction<ResultList.Action>)
    }

    struct State: Equatable {
        var ingredients: [Ingredient] = []
        var txtfieldIngredientName = ""
        var txtfieldQuantity = ""
        var txtfieldRecipePortions = ""
        var desiredAmount = ""
        var error: String? = nil
        var ingredientsUnits = IngredientsUnits.portions
        var resultIngredients: [Ingredient] = []
        @PresentationState var resultState: ResultList.State?
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            // Text fileds changed
            case .quantityTextDidChange(let quantity):
                state.txtfieldQuantity = quantity
            case .desiredAmounTextDidChange(let quantity):
                state.desiredAmount = quantity
            case .recipePortionsTextDidChange(let portions):
                state.txtfieldRecipePortions = portions
            case .ingredientNameTextDidChange(let name):
                state.txtfieldIngredientName = name

            // Button tapped
            case .addIngredientBtnTapped:
                if !state.txtfieldIngredientName.isEmpty, !state.txtfieldQuantity.isEmpty, let quantity = Int(state.txtfieldQuantity) {
                    state.ingredients.append(Ingredient(name: state.txtfieldIngredientName, quantity: quantity))
                    state.txtfieldIngredientName = ""
                    state.txtfieldQuantity = ""
                }
            case .converBtnTapped:
                if state.ingredients.isEmpty { return .none }
                guard let desiredAmount = Int(state.desiredAmount) else { return .none }
                
                var ingredients: [Ingredient] = []

                if state.ingredientsUnits == .gr {
                    ingredients.append(contentsOf: PortionerManager.calculate(ingredients: state.ingredients, for: desiredAmount))
                } else {
                    guard let recipePortions = Int(state.txtfieldRecipePortions) else { return .none }
                    ingredients.append(contentsOf: PortionerManager.calculate(ingredients: state.ingredients, portions: recipePortions, for: desiredAmount))
                }

                state.resultState = ResultList.State(ingredients: ingredients, portions: desiredAmount)
                return .none

            // Others
            case .deleteIngredientSwipeAction(let indexSet):
                state.ingredients.remove(atOffsets: indexSet)
            case .ingredientsUnitsPickerDidSelect(let unit):
                state.ingredientsUnits = unit

            // Result List
            case .resultSheet:
                break
            }
            return .none
        }
        .ifLet(\.$resultState, action: /Action.resultSheet) {
            ResultList()
        }
    }
}

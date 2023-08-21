//
//  ContentViewTests.swift
//  PortionsTests
//
//  Created by Thais Rodríguez on 16/8/23.
//

import ComposableArchitecture
@testable import Portions
import XCTest

let contentDefaultState = Content.State(ingredients: [],
                                        txtfieldIngredientName: "chocolat",
                                        txtfieldQuantity: "2",
                                        txtfieldRecipePortions: "",
                                        desiredAmount: "200",
                                        error: nil,
                                        recipeUnits: .gr,
                                        resultIngredients: [],
                                        resultState: nil)

let store = TestStore(initialState: contentDefaultState) {
    Content()
}

@MainActor
final class ContentViewTests: XCTestCase {
    func testIngredientNameTextDidChange() async throws {
        await store.send(.ingredientNameTextDidChange(name: "chocolate")) {
            $0.txtfieldIngredientName = "chocolate"
        }
    }

    func testWriteQuantityName() async throws {
        await store.send(.quantityTextDidChange(quantity: "20")) {
            $0.txtfieldQuantity = "20"
        }
    }
    
    func testDesiredAmounTextDidChange() async throws {
        await store.send(.desiredAmounTextDidChange(quantity: "2")) {
            $0.desiredAmount = "2"
        }
    }
    
    func testRecipePortionsTextDidChange() async throws {
        await store.send(.recipePortionsTextDidChange(portions: "3")) {
            $0.txtfieldRecipePortions = "3"
        }
    }

    func testAddIngredientBtnTapped() async throws {
        await store.send(.addIngredientBtnTapped) {
            $0.ingredients = [Ingredient(name: "chocolat", quantity: 2)]
            $0.txtfieldIngredientName = ""
            $0.txtfieldQuantity = ""
        }
    }
    
    func testDeleteIngredientSwipeAction() async throws {
        let store = TestStore(initialState: Content.State(ingredients: [Ingredient(name: "chocolat", quantity: 2)])) {
            Content()
        }
        
        await store.send(.deleteIngredientSwipeAction(indexSet: IndexSet(integer: 0))) {
            $0.ingredients = []
        }
    }
    
    func testRecipeUnitsPickerDidSelect() async throws {
        await store.send(.recipeUnitsPickerDidSelect(unit: .portions)) {
            $0.recipeUnits = .portions
        }
    }
    
    func testIngredientUnitPickerDidSelect() async throws {
        await store.send(.ingredientUnitPickerDidSelect(unit: .ml)) {
            $0.ingredientUnit = .ml
        }
    }
}

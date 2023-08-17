//
//  PortionerManager.swift
//  Portions
//
//  Created by Thais Rodríguez on 13/8/23.
//

import Foundation

class PortionerManager {
    static func calculate(ingredients: [Ingredient], for desiredAmount: Int) -> [Ingredient] {
        if desiredAmount < 0 { return [] }
        let ingredientsQuantity: Int = ingredients.reduce(0) { $0 + $1.quantity }
        
        return ingredients.map { ingredient in
            Ingredient(name: ingredient.name, quantity: (desiredAmount * ingredient.quantity) / ingredientsQuantity)
        }
    }
    
    static func calculate(ingredients: [Ingredient], portions: Int, for desiredPortions: Int) -> [Ingredient] {
        ingredients.map { ingredient in
            Ingredient(name: ingredient.name, quantity: (ingredient.quantity / portions) * desiredPortions)
        }
    }
    
    static func sumIngredientsQuantity(_ ingredients: [Ingredient]) -> Int {
        return ingredients.reduce(0) { $0 + $1.quantity }
    }
}

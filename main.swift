//
//  main.swift
//  Unit-1-Assessment
//
//  Created by Anthony Gonzalez on 7/25/19.
//  Copyright © 2019 Anthony Gonzalez. All rights reserved.
//


import Foundation

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}




struct Item {
    let name: String
    let price: Double
}
var productArray = [Item]()
var prices = [Double]()
var currentItem = productArray.popLast()

var cash = Bool()

func getIntFromUser() -> Int {
    print("Enter your number: ", terminator: "")
    while true {
        let input = readLine()
        if let input = input,
            let userNum = Int(input) {
            return userNum
        } else {
            print("[You did not enter a valid number.]")
        }
    }
}




func welcome() {
    print("""
[Welcome to Anthony's Itty Bitty Market O' Wonders 🐸]

Will you be paying with cash or credit today?
Enter 0 for cash and 1 for credit

""")
    let cashOrCredit = getIntFromUser()
    if cashOrCredit == 0 {
        cash = true
        groceryItems()
        
    } else if cashOrCredit == 1 {
        cash = false
        groceryItems()
        
    } else {
        print("['\(cashOrCredit)' is not a 0 or 1, clown]")
        print("")
        welcome()
    }
}




func groceryItems () {
    print("""

Enter the number of the product you want to purchase or select an additional option.
~~~~ ALL ITEMS ~~~~
0) Bulletproof Nail Clippers ($3.50)
1) Glow-in-the-dark Turban ($20.99)
2) Solar-powered Baseball Cap ($15.60)
3) David Rifkin's Autograph ($12.55)
4) Painting of Circus Clowns Storming the Beach at Normandy ($50.99)
~~~~~~~~~~~~~~~~~~~~

Additonal Options:
-1) Checkout
-2) Manually enter item name
-3) Show cart

""")
    userChoices()
}




func userChoices () {
    let myOptionChoice = getIntFromUser()
    
    switch myOptionChoice {
        
    case 0: let bulletproofNailClippers = Item(name: "Bulletproof Nail Clippers", price: 3.50)
    quantity(thing: bulletproofNailClippers)
        
        
        
    case 1:  let turban = Item(name: "Glow-in-the-dark Turban", price: 20.99)
    quantity(thing: turban)
        
        
    case 2: let solarCap = Item(name: "Solar-powered Baseball Cap", price: 15.60)
    quantity(thing: solarCap)
        
        
    case 3: let davidAutograph = Item(name: "David Rifkin's Autograph", price: 12.55)
    quantity(thing: davidAutograph)
        
    case 4: let painting = Item(name: "Painting of Circus Clowns Storming the Beach at Normandy", price: 50.99)
    quantity(thing: painting)
        
        
    case -1:
        checkout()
        
        
    case -2:
        manualItem()
        
        
    case -3: cart(productArray)
        
    default: print("[error: invalid input]")
    groceryItems()
    }
}




func manualItem () {
    print("Please enter the item name:", terminator: " ")
    let input = readLine()?.capitalized.replacingOccurrences(of: "[ ]+", with: " ", options: .regularExpression)
    if let input = input {
        if input == "" || input == " " {
            print("[error: You did not enter an item.]")
        } else {
            let newItem = Item(name: input, price: Double.random(in: 1.0 ... 10.0).rounded())
            productArray.append(newItem)
            prices.append(newItem.price)
            print("""
                
                ["\(input)" has been added to your cart]
                Remember to check your cart by entering -3
                
                """)
            groceryItems()
        }
    }
}




func quantity (thing: Item) {
    let currentItem = thing
    print("Enter desired quantity for '\(currentItem.name)'")
    let amount = getIntFromUser()
    if amount == 0 {
        print("\(currentItem.name) was not added to your cart")
        groceryItems()
    }
    if amount < 0 {
        print("[Invalid quantity]")
        quantity(thing: currentItem)
    }
    for _ in 1 ... Int(amount) {
        productArray.append(currentItem)
        prices.append(currentItem.price)
    }
    print("[\(amount) '\(currentItem.name)' added to cart]")
    userChoices()
}




func cart(_:[Item]){
    let totalPrice = prices.reduce(0, +)
    
    print("""

🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒
""")
    print("Your current cart (\(productArray.count) items)")
    for product in productArray {
        print("""
            Item(price: $\(product.price), name: "\(product.name)")
            """)
    }
    print("""
        
        {Cart total: $ \(Double((totalPrice)).roundTo(places: 2))}
        🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒🛒
        
        [Would you like to checkout, yes or no? Or enter 'clear' to empty your cart]
        
        """)
    let answer = readLine()?.lowercased()
    if answer == "yes" {
        checkout()
    } else if answer == "no" {
        groceryItems()
    } else if answer == "clear" {
        productArray.removeAll()
        prices.removeAll()
        print("[Your cart has been emptied]")
        groceryItems()
    } else {
        print("[You did not provide a valid input]")
        cart(productArray)
    }
}




func checkout () {
    let totalPrice = Double(prices.reduce(0, +)).roundTo(places: 2)
    let discount = Double(totalPrice * 0.04).roundTo(places: 2)
    
    if productArray.isEmpty == true {
        print("[You have no items to checkout]")
        print("")
        groceryItems()
    } else {
        switch cash {
        case true: print("""
            
            [With a 4% discount, your total is $\(Double((totalPrice - discount)).roundTo(places: 2)). You saved $\(discount)!]
            """)
        case false: print("[Your total is $\(totalPrice)]")
        }
        print("Thanks for your money 🤡")
    }
}



welcome()

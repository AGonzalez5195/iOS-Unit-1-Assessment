//
//  main.swift
//  Unit-1-Assessment
//
//  Created by Anthony on 7/25/19.
//  Copyright © 2019 Anthony. All rights reserved.
//


import Foundation

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


struct Item: Hashable {
    let name: String
    let price: Double
}


var productArray: [Item] = [Item(name: "Bulletproof Nail Clippers", price: 3.50), Item(name: "Glow-in-the-dark Turban", price: 20.99), Item(name: "Solar-powered Baseball Cap", price: 15.60), Item(name: "David Rifkin's Autograph", price: 12.55), Item(name: "Oil Painting of Circus Clowns Storming the Beach at Normandy", price: 66.44), Item(name: "Teeny Weeny Mussolini", price: 18.83), Item(name: "How to Read - A Written Tutorial", price: 10.00)]


var cartArray = [Item]()
var prices = [Double]()
var counter = 0
var cash = Bool()
var indexNumForUserChoices = Int()


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




func getAnswerFromUser() -> String {
    print("""
Enter number or an additional command

(additional commands: "checkout", "show list", "show cart", "unlisted item")
""")
    while true {
        let input = readLine()?.lowercased().replacingOccurrences(of: "[ ]+", with: " ", options: .regularExpression)
        if let input = input {
            return input
        } else {
            print("[invalid input]")
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

Enter the number of the product you want to purchase.
~~~~ ALL ITEMS ~~~~
""")
    for stuff in productArray {
        print("""
            \(counter)) \(stuff.name) ($\(stuff.price.roundTo(places: 2)))
            """)
        counter += 1
    }
    
    print("""
~~~~~~~~~~~~~~~~~~~~

""")
    counter = 0
    userChoices()
}




func userChoices () {
    let myOptionChoice = getAnswerFromUser()
    if let userNum = Int(myOptionChoice) {
        indexNumForUserChoices = userNum
    } else {
    }
    let isIndexValid = productArray.indices.contains(indexNumForUserChoices)
    switch myOptionChoice {
    case "checkout":
        checkout()
        
        
    case "unlisted item":
        unlistedItem()
        
        
    case "show cart" : cart(cartArray)
        
    case "show list" : groceryItems()
        
    case String(indexNumForUserChoices): if isIndexValid == true {
        quantity(thing: productArray[indexNumForUserChoices])
    } else {
        print("[error: invalid catalog number]")
        userChoices()
        }
    default: print("[error: invalid input]")
    userChoices()
    }
}





func unlistedItem () {
    print("Please enter the item name:", terminator: " ")
    let input = readLine()?.capitalized.replacingOccurrences(of: "[ ]+", with: " ", options: .regularExpression)
    if let input = input {
        if input == "" || input == " " {
            print("[error: You did not enter an item.]")
        } else {
            let newItem = Item(name: input, price: Double.random(in: 1.0 ... 10.0).roundTo(places: 2))
            print("[Catalog updated]")
            productArray.append(newItem)
            quantity(thing: newItem)
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
    for _ in 1 ... amount {
        cartArray.append(currentItem)
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
    print("Your current cart (\(cartArray.count) items)")
    for product in cartArray {
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
        userChoices()
    } else if answer == "clear" {
        cartArray.removeAll()
        prices.removeAll()
        print("[Your cart has been emptied]")
        groceryItems()
    } else {
        print("[You did not provide a valid input]")
        cart(cartArray)
    }
}




func checkout () {
    let totalPrice = Double(prices.reduce(0, +)).roundTo(places: 2)
    let discount = Double(totalPrice * 0.04).roundTo(places: 2)
    
    if cartArray.isEmpty == true {
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



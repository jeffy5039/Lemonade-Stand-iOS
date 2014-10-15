//
//  ViewController.swift
//  Lemonade Stand
//
//  Created by jordan on 13/10/2014.
//  Copyright (c) 2014 jordan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //variables
    var lemon = 0
    var ice = 0
    var strawberry = 0
    var money: Double = 10
    var lemonMix = 0
    var iceMix = 0
    var strawberryMix = 0
    var numCustomers = 0

    //player stats
    @IBOutlet weak var playerLemonLabel: UILabel!
    @IBOutlet weak var playerIceLabel: UILabel!
    @IBOutlet weak var playerStrawberryLabel: UILabel!
    @IBOutlet weak var playerMoneyLabel: UILabel!
    
    //mixing labels
    @IBOutlet weak var mixLemonLabel: UILabel!
    @IBOutlet weak var mixIceLabel: UILabel!
    @IBOutlet weak var mixStrawberryLabel: UILabel!
    
    //customer order label
    @IBOutlet weak var customerOrderLabel: UILabel!
    
    //weather image
    @IBOutlet weak var weatherImageView: UIImageView!
    
    //Array of customer instances
    var customers = [Customer]()

    var acidities = [1.0, 0.5, 0.25]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
        showNextCustomerButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //Buy ingredients buttons
    @IBAction func buyLemonButton() {
        if money >= 2 {
            lemon++
            money-=2
            updateUI()
        } else {
            showAlert(message: "Not enough money")
        }
    }
    @IBAction func buyIceButton() {
        if money >= 0.5 {
            ice++
            money-=0.5
            updateUI()
        } else {
            showAlert(message: "Not enough money")
        }
    }
    @IBAction func buyStrawberryButton() {
        if money >= 1 {
            strawberry++
            money-=1
            updateUI()
        } else {
            showAlert(message: "Not enough money")
        }
    }
    
    //Mix buttons 
    @IBAction func addLemonButton() {
        if lemon>=1{
            lemon--
            lemonMix++
            updateUI()
        } else {
            showAlert(message: "No more lemons")
        }
    }
    @IBAction func removeLemonButton() {
        if lemonMix >= 1 {
            lemonMix--
            lemon++
            updateUI()
        } else {
            showAlert(message: "You arent mixing any lemons")
        }
    }
    @IBAction func addIceButton() {
        if ice >= 1 {
            ice--
            iceMix++
            updateUI()
        } else {
            showAlert(message: "No more ice")
        }
    }
    @IBAction func removeIceButton() {
        if iceMix >= 1 {
            iceMix--
            ice++
            updateUI()
        } else {
            showAlert(message: "You arent mixing any ice")
        }
    }
    @IBAction func addStrawberryButton() {
        if strawberry >= 1 {
            strawberry--
            strawberryMix++
            updateUI()
        } else {
            showAlert(message: "No more strawberries")
        }
    }
    @IBAction func removeStrawberryButton() {
        if strawberryMix >= 1 {
            strawberryMix--
            strawberry++
            updateUI()
        } else {
            showAlert(message: "You arent mixing any strawberries")
        }
    }
    
    //Action Buttons
    @IBAction func showNextCustomerButton() {
        //Try a for loop?
        if money <= 10 && numCustomers == 0 {
            showAlert(header: "Game Over", message: "You cannot make any more money")
            reset()
        } else if money > 10 && numCustomers == 0{
            showAlert(header: "Winner", message: "You successfully made money")
            reset()
        } else if money == 0 && lemon == 0 && strawberry == 0 && ice == 0{
            showAlert(header: "Game Over", message: "You cannot make any more money")
            reset()
        }
        
        var customer  = customers[numCustomers-1]
        var acidityWord: String
        var order: String = ""
        
        switch customer.acidity {
        case 1.0:
            acidityWord = "strong"
        case 0.5:
            acidityWord = "regular"
        default:
            acidityWord = "weak"
        }
        if customer.withStrawberry {
            order = "\(customer.numOfDrinks) \(acidityWord) lemonade with a strawberry"
        } else {
            order = "\(customer.numOfDrinks) \(acidityWord) lemonade"
        }
        numCustomers--
        
        lemonMix = 0
        iceMix = 0
        strawberryMix = 0
        customerOrderLabel.text = order
        updateUI()
    }
    @IBAction func serveCustomerButton() {
        var customer = customers[numCustomers]
        var correctNumOfLemons = customer.numOfDrinks
        var correctNumOfIce = Double(customer.numOfDrinks)/customer.acidity
        if correctNumOfLemons == lemonMix && correctNumOfIce == Double(iceMix) {
            money += 3.5 * Double(customer.numOfDrinks)
        }
        if customer.withStrawberry && strawberryMix == customer.numOfDrinks {
            money += 2 * Double(customer.numOfDrinks)
        }
        lemonMix = 0
        iceMix = 0
        strawberryMix = 0
        updateUI()
    }
    
    //Helper functions
    func updateUI() {
        playerLemonLabel.text = "\(lemon)"
        playerIceLabel.text = "\(ice)"
        playerStrawberryLabel.text = "\(strawberry)"
        playerMoneyLabel.text = "\(money)"
        
        mixLemonLabel.text = "\(lemonMix)"
        mixIceLabel.text = "\(iceMix)"
        mixStrawberryLabel.text = "\(strawberryMix)"
    }
    
    func showAlert(header: String = "Warning", message: String) {
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func getWeather() {
        var rnd = Int(arc4random_uniform(UInt32(3)))
        switch rnd {
        case 0:
            weatherImageView.image = UIImage(named: "Cold")
            numCustomers = 8
        case 1:
            weatherImageView.image = UIImage(named: "Mild")
            numCustomers = 12
        case 2:
            weatherImageView.image = UIImage(named: "warm")
            numCustomers = 15
        default:
            weatherImageView.image = UIImage(named: "Mild")
            numCustomers = 12
        }
    }
    
    func reset() {
        money = 10
        getWeather()
        for var i = 0; i < numCustomers; i++ {
            var customer = Customer()
            customer.acidity = acidities[Int(arc4random_uniform(UInt32(acidities.count)))]
            var rnd = Int(arc4random_uniform(UInt32(4))) + 1
            customer.numOfDrinks = rnd
            var rndStrawberry = Int(arc4random_uniform(UInt32(3)))
            if rndStrawberry == 0 {
                customer.withStrawberry = true
            }
            customers.append(customer)
        }
    }
}
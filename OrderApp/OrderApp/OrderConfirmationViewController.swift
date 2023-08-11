//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by Marwan Hazem on 09/08/2023.
//

import UIKit
import Cosmos


class OrderConfirmationViewController: UIViewController {
    @IBOutlet weak var confirmationLabel: UILabel!
    var label : String = ""
    var mins = 0
    let minutesToPrepare: Int
    
    @IBOutlet weak var butt: UIButton!
    init?(coder: NSCoder, minutesToPrepare: Int, label1 : String) {
            self.minutesToPrepare = minutesToPrepare
        self.label=label1
        super.init(coder: coder)
        }
    
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let orderTotal =
        MenuController.shared.order.menuItems.reduce(0.0)
        { (result, menuItem) -> Double in
            return result + menuItem.price
        }
        confirmationLabel.text = "You Order is of total : \(MenuController.shared.order.menuItems.count) items "       // Do any additional setup after loading the view.
        if orderTotal == 0
        {
            butt.isEnabled = false
        }
        else
        {
            butt.isEnabled = true
        }
    }
    
   
    @IBAction func orderConfirmation(_ sender: UIButton) {
        lazy var cosmos:CosmosView = { var view = CosmosView()
            return view
        }()
       
        let orderTotal =
        MenuController.shared.order.menuItems.reduce(0.0)
        { (result, menuItem) -> Double in
            return result + menuItem.price
        }
        
        let formattedTotal = orderTotal.formatted(.currency(code: "egp"))
        let alertController = UIAlertController(title: "Confirm Order", message: "You are about to submit your order with a total of \(formattedTotal)", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Submit",
                                                style: .default, handler: { [self] _ in confirmationLabel.text = "Thank you for your order! Your wait time is approximately \(Int(orderTotal / 1.5)) minutes." + "\n\n" +  "Rate your experience \n"
            MenuController.shared.order.menuItems.removeAll()
            butt.isEnabled = false
            view.addSubview(cosmos)
            cosmos.center = view.center
            
            
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel",style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    func displayError(_ error: Error, title: String) {
        guard let _ = viewIfLoaded?.window else { return }
        let alert = UIAlertController(title: title, message:
           error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default,
           handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

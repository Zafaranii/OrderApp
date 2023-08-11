//
//  MenuItemViewController.swift
//  OrderApp
//
//  Created by Marwan Hazem on 08/08/2023.
//

import UIKit
@MainActor
class MenuItemViewController: UIViewController {
    let menuItem: MenuItem
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addToOrdelButton: UIButton!
    @IBOutlet weak var detailTextLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
        init?(coder: NSCoder, menuItem: MenuItem) {
            self.menuItem = menuItem
            super.init(coder: coder)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()
    }
    
    func updateUI() {
        nameLabel.text = menuItem.name
        priceLabel.text = menuItem.price.formatted(.currency(code: "egp"))
        detailTextLabel.text = menuItem.detailText
    
        Task.init {
            if let image = try? await
               MenuController.shared.fetchImage(from: menuItem.imageURL) {
                imageView.image = image
            }
        }
    }


    @IBAction func buttonClicked(_ sender: UIButton) {
        UIView.animate(withDuration: 2.0, delay: 0,
               usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1,
               options: [], animations: {
            self.addToOrdelButton.transform =
                   CGAffineTransform(scaleX: 2.0, y: 2.0)
                self.addToOrdelButton.transform =
                   CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        MenuController.shared.order.menuItems.append(menuItem)
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

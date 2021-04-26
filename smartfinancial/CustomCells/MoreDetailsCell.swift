//
//  MoreDetailsCell.swift
//  smartfinancial
//
//  Created by Rafael Fróes Monteiro Carvalho
//  Copyright © rafafroes. All rights reserved.
//

import UIKit

class MoreDetailsCell: UITableViewCell {
    
    static let identifier = "MoreDetailsCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "MoreDetailsCell", bundle: nil)
    }
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var statusView: UIView!
    @IBOutlet var navioLabel: UILabel!
    @IBOutlet var praticoLabel: UILabel!
    @IBOutlet var dataLabel: UILabel!
    @IBOutlet var valorLabel: UILabel!
    @IBOutlet var clienteLabel: UILabel!
    @IBOutlet var contratoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 20, bottom: 4, right: 20))
    }
    
    public func configure(status: String, navio: String, pratico: String, data: String, valor: Double, cliente: String, contrato: String){
        Decorator.styleContainerView(containerView)
        navioLabel.text = navio
        praticoLabel.text = pratico
        dataLabel.text = data
        valorLabel.text = formatValue(value: valor)
        clienteLabel.text = cliente
        contratoLabel.text = contrato
        paintStatus(status)
    }
    
    func formatValue(value: Double) -> String{
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.init(identifier: "pt_BR")
        return currencyFormatter.string(from: NSNumber(value: value))!
    }
    
    func paintStatus(_ status: String){
        statusView.layer.cornerRadius = 8.0
        statusView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        if(status == "LIQUIDADO"){
            statusView.backgroundColor = UIColor.smartGreen
        }else if(status == "PENDENTE"){
            statusView.backgroundColor = UIColor.smartYellow
        }else{
            statusView.backgroundColor = UIColor.smartRed
        }
    }

}

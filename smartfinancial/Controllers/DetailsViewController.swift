//
//  DetailsViewController.swift
//  smartfinancial
//
//  Created by Rafael Fróes Monteiro Carvalho on
//  Copyright © rafafroes. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var aReceberLabel: UILabel!
    @IBOutlet weak var faturadoLabel: UILabel!
    @IBOutlet weak var liquidadoLabel: UILabel!
    @IBOutlet weak var ticLabel: UILabel!
    @IBOutlet weak var custoEditText: UITextField!
    @IBOutlet weak var custoButtonOutlet: UIButton!
    
    
    var loadingIndicator: ProgressHUD?
    var status = [String]()
    var navios = [String]()
    var praticos = [String]()
    var datas = [String]()
    var valores = [Double]()
    var contratos = [String]()
    var clientes = [String]()
    var cicloNumber = 0
    var ciclo = Ciclo()
    var totalFaturado = 0.0
    var multiplicadorTaxa = 0.84 //taxa 16%, ou seja, multiplica por 0.84
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        loadingIndicator = ProgressHUD(text: "Carregando")
        self.view.addSubview(loadingIndicator!)

        setupToolbar()
        //todo estilizar butao de custo?
        
        loadingIndicator?.show()
        Connection.getCiclo(numeroCiclo: cicloNumber) { ciclo in
            self.ciclo = ciclo
            self.prepareArrays()
            self.table.register(MoreDetailsCell.nib(), forCellReuseIdentifier: MoreDetailsCell.identifier)
            self.table.delegate = self
            self.table.dataSource = self
            self.populateView()
            self.loadingIndicator?.hide()
        }
    }
    
    @IBAction func calculateCosts(_ sender: Any) {
        if let custo = Double(custoEditText.text!){
            ticLabel.text = formatValue(value: ((totalFaturado * multiplicadorTaxa) - custo))
            custoEditText.text!.removeAll()
            custoEditText.endEditing(true)
        }else{
            let alert = UIAlertController(title: "Erro: Campo de custo vazio", message: "Preencha o campo de custo", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Entendido", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func populateView(){
        var faturado = 0.0
        var liquidado = 0.0
        for i in 0..<ciclo.manobras!.count{
            faturado += ciclo.manobras![i].valor!
            
            if(ciclo.manobras![i].statusBoleto! == "LIQUIDADO"){
                liquidado += ciclo.manobras![i].valor!
            }
        }
        let aReceber = faturado - liquidado
        faturadoLabel.text = formatValue(value: faturado)
        liquidadoLabel.text = formatValue(value: liquidado)
        aReceberLabel.text = formatValue(value: aReceber)
        self.totalFaturado = faturado
    }
    
    func prepareArrays(){
        for i in 0..<ciclo.manobras!.count{
            status.append(ciclo.manobras![i].statusBoleto!)
            navios.append(ciclo.manobras![i].navio!)
            praticos.append(ciclo.manobras![i].realizadoPor!)
            datas.append(ciclo.manobras![i].dataManobra!)
            valores.append(ciclo.manobras![i].valor!)
            contratos.append(ciclo.manobras![i].contratro!)
            clientes.append(ciclo.manobras![i].cliente!)
        }
    }
    
    func formatValue(value: Double) -> String{
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.init(identifier: "pt_BR")
        return currencyFormatter.string(from: NSNumber(value: value))!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ciclo.manobras!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MoreDetailsCell.identifier, for: indexPath) as! MoreDetailsCell
        cell.configure(status: status[indexPath.row], navio: navios[indexPath.row], pratico: praticos[indexPath.row], data: datas[indexPath.row], valor: valores[indexPath.row], cliente: clientes[indexPath.row], contrato: contratos[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func setupToolbar() {
        let label = UILabel()
        label.text = "Ciclo \(cicloNumber)"
        label.textAlignment = .left
        label.textColor = UIColor.smartBlack
        label.font = UIFont(name:"Archivo-Bold", size: 36)
        
        //uncomment if want to add a button to choose ciclo
        /*
        let margin = UILabel()
        margin.text = "C"
        margin.textColor = UIColor.smartWhite
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), for: .normal)
        button.tintColor = UIColor.smartRed
         */

        let spacer = UIView()
        let constraint = spacer.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat.greatestFiniteMagnitude)
        constraint.isActive = true
        constraint.priority = .defaultLow
        
        let stack = UIStackView(arrangedSubviews: [label, spacer])
        //let stack = UIStackView(arrangedSubviews: [label, margin, button, spacer])
        stack.axis = .horizontal

        navigationItem.titleView = stack
        
        let yourBackImage = UIImage(systemName: "arrow.left")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(-5.0, for: .default)
    }
}

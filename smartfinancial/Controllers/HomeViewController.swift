//
//  HomeViewController.swift
//  smartfinancial
//
//  Created by Rafael Fróes Monteiro Carvalho
//  Copyright © rafafroes. All rights reserved.
//

import UIKit
import Charts

class HomeViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var viewDetailsButton: UIButton!
    @IBOutlet weak var mediaPorCiclo: UILabel!
    @IBOutlet weak var faturamentoSeisCiclos: UILabel!
    @IBOutlet weak var cicloSummaryView: UIView!
    @IBOutlet weak var periodoDoCiclo: UILabel!
    @IBOutlet weak var faturadoNoCiclo: UILabel!
    @IBOutlet weak var variacao: UILabel!
    @IBOutlet weak var imagemVariacao: UIImageView!
    @IBOutlet weak var faturamentoSummaryView: UIView!
    @IBOutlet weak var iconDownContainer: UITextField!
    @IBOutlet weak var iconDown: UIImageView!
    @IBOutlet weak var cicloLabel: UILabel!
    @IBOutlet weak var chart: CombinedChartView!
    @IBOutlet weak var faturadoMenosImposto: UILabel!
    
    
    var allCicloNames = [String]()
    var ciclos = [Ciclo]()
    var nomeCiclos = [String]()
    var faturadoPorCiclo = [Double]()
    var mediaFaturadoPorCiclo = [Double]()
    var selectedCicle: String?
    var loadingIndicator: ProgressHUD?

    //TODO 2: atualizar as manobras para os ciclos mais recentes na colecao manobras no firebase
    //TODO: meelhor visualizacao dos numeros no grafico
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chart.delegate = self
        
        loadingIndicator = ProgressHUD(text: "Carregando")
        self.view.addSubview(loadingIndicator!)
        
        populateAllCiclosNamesArray()
        setUpUIElements()
        createPicker()
        fetchCiclos()
    }
    
    @IBAction func goToMoreDetails(_ sender: Any) {
        performSegue(withIdentifier: "moreDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let number = Int(String(cicloLabel.text!.suffix(2)))
        let moreDetailsVC = segue.destination as! DetailsViewController
        moreDetailsVC.cicloNumber = number!
    }
    
    func populateAllCiclosNamesArray(){
        Connection.getAllCiclos { fetchedCiclos in
            for i in 5..<fetchedCiclos.count{
                //self.allCicloNames.append("Ciclo " + String(fetchedCiclos[i].numero!))
                self.allCicloNames.insert("Ciclo " + String(fetchedCiclos[i].numero!), at: 0)
            }
        }
    }
    
    func formatValue(value: Double) -> String{
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.init(identifier: "pt_BR")
        return currencyFormatter.string(from: NSNumber(value: value))!
    }
    
    func updateCicloViewData(){
        faturadoNoCiclo.text = formatValue(value: faturadoPorCiclo[faturadoPorCiclo.count-1])
        faturadoMenosImposto.text = formatValue(value: (faturadoPorCiclo[faturadoPorCiclo.count-1] * 0.84))
        periodoDoCiclo.text = ciclos[ciclos.count-1].dataInicio! + " a " + ciclos[ciclos.count-1].dataFim!
        cicloLabel.text = "Ciclo " + String(ciclos[ciclos.count-1].numero!)
        
        let variation = calculateVariation()
        
        if(variation > 0){
            variacao.text = String(format: "%.1f", variation) + "%"
            variacao.textColor = UIColor.smartGreen
            imagemVariacao.image = UIImage(systemName: "arrow.up")
            imagemVariacao.tintColor = UIColor.smartGreen
        }else{
            let substring = String(format: "%.1f", variation)
            let start = substring.index(substring.startIndex, offsetBy: 1)
            let range = start..<substring.endIndex
            
            variacao.text = String(substring[range]) + "%"
            variacao.textColor = UIColor.smartRed
            imagemVariacao.image = UIImage(systemName: "arrow.down")
            imagemVariacao.tintColor = UIColor.smartRed
        }
    }
    
    func updateFaturamentoViewData(){
        faturamentoSeisCiclos.text = formatValue(value: calculateTotal())
        mediaPorCiclo.text = formatValue(value: calculateAverage())
    }
    
    //verificar porcentual se ta correto
    func calculateVariation() -> Double{
        let variation = ((faturadoPorCiclo[faturadoPorCiclo.count-1] - faturadoPorCiclo[faturadoPorCiclo.count-2])/faturadoPorCiclo[faturadoPorCiclo.count-1])*100
        return variation
    }
    
    func calculateAverage() -> Double{
        return (calculateTotal()/Double(faturadoPorCiclo.count))
    }
    
    func calculateTotal() -> Double{
        var aux = 0.0
        for i in 0..<faturadoPorCiclo.count{
            aux += faturadoPorCiclo[i]
        }
        return aux
    }
    
    //getCiclosDataFromLast() and getCiclosData() will return 6 ciclos always
    func fetchCiclos(){
        loadingIndicator?.show()
        Connection.getLastCiclo { lastCiclo in
            let group = DispatchGroup()
            
            for i in stride(from: 5, to: 0, by: -1) {
                group.enter()
                Connection.getCiclo(numeroCiclo: (lastCiclo.numero! - i)) { ciclo in
                    self.ciclos.append(ciclo)
                    group.leave()
                }
            }
            
            group.notify(queue: .main){
                self.ciclos.append(lastCiclo)
                self.loadingIndicator?.hide()
                self.prepareChartData()
                self.updateCicloViewData()
                self.updateFaturamentoViewData()
            }
        }
    }
    
    func getCiclosData(fromNumber: Int){
        loadingIndicator?.show()
        Connection.getCiclo(numeroCiclo: fromNumber) { lastCiclo in
            let group = DispatchGroup()
            
            for i in stride(from: 5, to: 0, by: -1) {
                group.enter()
                Connection.getCiclo(numeroCiclo: (lastCiclo.numero! - i)) { ciclo in
                    self.ciclos.append(ciclo)
                    group.leave()
                }
            }
            
            group.notify(queue: .main){
                self.ciclos.append(lastCiclo)
                self.loadingIndicator?.hide()
                self.prepareChartData()
                self.updateCicloViewData()
                self.updateFaturamentoViewData()
            }
        }
    }
    
    func prepareArrays(){
        ciclos.sort { $0.numero! < $1.numero! }
        
        for i in 0..<ciclos.count{
            nomeCiclos.append("Ciclo " + String(ciclos[i].numero!))
            
            var total = 0.0
            for j in 0..<ciclos[i].manobras!.count{
                total += ciclos[i].manobras![j].valor!
            }
            faturadoPorCiclo.append(total)
        }
        mediaFaturadoPorCiclo = getCiclosAverage(faturamento: faturadoPorCiclo)
    }
    
    func cleanArrays(){
        ciclos.removeAll()
        nomeCiclos.removeAll()
        faturadoPorCiclo.removeAll()
        mediaFaturadoPorCiclo.removeAll()
    }
    
    func prepareChartData(){
        prepareArrays()
        
        prepareChart(xValues: nomeCiclos, yValues: faturadoPorCiclo, yLineValues: mediaFaturadoPorCiclo)
    }
    
    func prepareChart(xValues: [String], yValues: [Double], yLineValues: [Double]){
        chart.noDataText = "Nenhum dado encontrado"
        
        let xaxis = chart.xAxis
        xaxis.drawGridLinesEnabled = true
        xaxis.labelPosition = .bottom
        xaxis.valueFormatter = IndexAxisValueFormatter(values:self.nomeCiclos)
        xaxis.granularityEnabled = true
        xaxis.granularity = 1
        xaxis.labelCount = xValues.count
        xaxis.spaceMin = 0.5
        xaxis.spaceMax = 0.5

        let yaxis = chart.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = false
        yaxis.valueFormatter = CustomIntFormatter()
        
        chart.rightAxis.enabled = false
        
        var barDataEntries = [BarChartDataEntry]()
        var lineDataEntries = [ChartDataEntry]()
        
        for i in 0..<xValues.count {
            barDataEntries.append(BarChartDataEntry(x: Double(i), y: yValues[i]))
            lineDataEntries.append(ChartDataEntry(x: Double(i), y: yLineValues[i]))
        }
        
        let lineChartSet = LineChartDataSet(entries: lineDataEntries, label: "Media ao longo dos ciclos")
        lineChartSet.colors = [UIColor.smartRed]
        lineChartSet.circleColors = [UIColor.smartRed]
        lineChartSet.lineWidth = 5
        
        let barChartSet = BarChartDataSet(entries: barDataEntries, label: "Faturamento por Ciclo")
        barChartSet.colors = [UIColor.smartBlack]
        barChartSet.valueFont = UIFont(name: "archivo-regular", size: 12.0)!
            
        let data = CombinedChartData()
        data.barData = BarChartData(dataSet: barChartSet)
        data.barData.setValueFormatter(xAxisFormatter())
        data.lineData = LineChartData(dataSet: lineChartSet)
        data.lineData.setDrawValues(false)
    
        chart.data = data
        
        chart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
    }
    
    func getCiclosAverage(faturamento: [Double]) -> [Double]{
        var avgs = [Double]()
        var sum = 0.0
        for i in 0..<faturamento.count{
            sum = sum + faturamento[i]
            let avg = sum/Double(i+1)
            avgs.append(avg)
        }
        return avgs
    }
    
    func createPicker(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        iconDownContainer.inputView = pickerView
        
        //Customization
        pickerView.backgroundColor = UIColor.smartWhite
        
        createPickerToolbar()
    }
    
    func createPickerToolbar(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //Customizations
        toolbar.backgroundColor = UIColor.smartWhite
        toolbar.isTranslucent = false
        toolbar.tintColor = UIColor.smartBlack
        
        let title = UILabel()
        title.text = "Selecione um Ciclo"
        title.font = UIFont(name:"Archivo-regular", size: 20.0)
        
        let toolbarTitle = UIBarButtonItem(customView: title)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Pronto", style: .plain, target: self, action: #selector(self.dismissPicker))
        done.tintColor = UIColor.smartRed
        
        toolbar.setItems([toolbarTitle, space, done], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        iconDownContainer.inputAccessoryView = toolbar
    }
    
    @objc func dismissPicker(){
        view.endEditing(true)
        cicloLabel.text = selectedCicle
        let number = Int(String((selectedCicle?.suffix(2))!))
        cleanArrays()
        getCiclosData(fromNumber: number!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setUpUIElements(){
        iconDownContainer.layer.zPosition = 2
        iconDown.layer.zPosition = 0
        
        Decorator.styleHollowButtonRed(viewDetailsButton)
        Decorator.styleContainerView(cicloSummaryView)
        Decorator.styleContainerView(faturamentoSummaryView)
    }
}

final class CustomIntFormatter: IAxisValueFormatter{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let val = Int((value/1000).rounded())
        return String(val) + "k"
    }
}

final class xAxisFormatter: IValueFormatter{
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        let val = Int(value)
        return String(val) + "k"
    }
}

extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allCicloNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allCicloNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCicle = allCicloNames[row]
        pickerView.reloadAllComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let color = (row == pickerView.selectedRow(inComponent: component)) ? UIColor.smartRed : UIColor.smartBlack
        return NSAttributedString(string: self.allCicloNames[row], attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}

//
//  Constants.swift
//  smartfinancial
//
//  Created by Rafael Fróes Monteiro Carvalho
//  Copyright © rafafroes. All rights reserved.
//

import Foundation

struct Constants{
    
    struct Storyboard{
        static let homeViewController = "HomeVC"
    }
    
    struct DatabaseCollections {
        static let Manobras = "manobras-smart"
        static let Support = "support"
    }
    
    struct CollectionFields {
        static let Boleto = "boleto"
        static let Ciclo = "ciclo"
        static let Cliente = "cliente"
        static let Contrato = "contrato"
        static let DataManobra = "dataManobra"
        static let Navio = "navio"
        static let RealizadoPor = "realizadoPor"
        static let StatusBoleto = "statusBoleto"
        static let Valor = "valor"
        static let VencimentoBoleto = "vencimentoBoleto"
    }
}

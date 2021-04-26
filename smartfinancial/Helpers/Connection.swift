//
//  Connection.swift
//  smartfinancial
//
//  Created by Rafael Fróes Monteiro Carvalho
//  Copyright © rafafroes. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Connection{
    
    //mas nao pegas as manobras
    static func getAllCiclos(completion: @escaping([Ciclo]) -> Void){
        var ciclos = [Ciclo]()
        
        let database = Firestore.firestore()
        database.collection("ciclos").order(by: "numero", descending: false).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print(err)
                completion(ciclos)
                return
            }
            for document in querySnapshot!.documents {
                var ciclo = Ciclo()
                let data = document.data()
                ciclo.numero = data["numero"] as? Int
                ciclo.dataFim = data["dataFim"] as? String
                ciclo.dataInicio = data["dataInicio"] as? String
                ciclos.append(ciclo)
            }
            completion(ciclos)
        }
    }
    
    static func getLastCiclo(completion: @escaping(Ciclo) -> Void){
        var ciclo = Ciclo()
        
        let database = Firestore.firestore()
        database.collection("ciclos").order(by: "numero", descending: true).limit(to: 1)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print(err)
                    completion(ciclo)
                    return
                }
                for document in querySnapshot!.documents {
                    let data = document.data()
                    ciclo.numero = data["numero"] as? Int
                    ciclo.dataFim = data["dataFim"] as? String
                    ciclo.dataInicio = data["dataInicio"] as? String
                }
                getManobrasForCiclo(numeroCiclo: ciclo.numero!) { manobras in
                    ciclo.manobras = manobras
                    completion(ciclo)
                }
        }
    }
    
    static func getCiclo(numeroCiclo: Int, completion: @escaping(Ciclo) -> Void){
        var ciclo = Ciclo()
        
        let database = Firestore.firestore()
        database.collection("ciclos").whereField("numero", isEqualTo: numeroCiclo)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print(err)
                    completion(ciclo)
                    return
                }
                for document in querySnapshot!.documents {
                    let data = document.data()
                    ciclo.numero = data["numero"] as? Int
                    ciclo.dataFim = data["dataFim"] as? String
                    ciclo.dataInicio = data["dataInicio"] as? String
                }
                getManobrasForCiclo(numeroCiclo: ciclo.numero!) { manobras in
                    ciclo.manobras = manobras
                    completion(ciclo)
                }
        }
    }
    
    private static func getManobrasForCiclo(numeroCiclo: Int, completion: @escaping([Manobra]) -> Void){
        var manobras = [Manobra]()
        
        let database = Firestore.firestore()
        database.collection("manobras-smart").whereField("ciclo", isEqualTo: String(numeroCiclo))
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print(err)
                    completion(manobras)
                    return
                }
                for document in querySnapshot!.documents {
                    let data = document.data()
                    var manobra = Manobra()
                    //insere -1 no ciclo caso nao consiga castar pra int
                    let stringCiclo = data["ciclo"] as? String
                    manobra.ciclo = Int(stringCiclo!) ?? 0
                    manobra.boleto = data["boleto"] as? String
                    manobra.cliente = data["cliente"] as? String
                    manobra.contratro = data["contrato"] as? String
                    manobra.dataManobra = data["dataManobra"] as? String
                    manobra.navio = data["navio"] as? String
                    manobra.realizadoPor = data["realizadoPor"] as? String
                    manobra.statusBoleto = data["statusBoleto"] as? String
                    manobra.valor = data["valor"] as? Double
                    manobra.vencimentoBoleto = data["vencimentoBoleto"] as? String
                    manobras.append(manobra)
                }
                completion(manobras)
        }
    }
    
}

//
//  Decorator.swift
//  smartfinancial
//
//  Created by Rafael Fróes Monteiro Carvalho
//  Copyright © rafafroes. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextFieldsTheming

class Decorator{
    static func styleTextField(_ textfield: MDCOutlinedTextField,_ container: UIView,_ text: String,_ placeholder: String){
        /*
            1- Deve-se criar uma view na posiçao e de tamanho desejado para o MDTextField;
            2- Em seguida cria-se a instancia do MDTextField e seta o frame para o frame da view criada;
            3- Depois seta label.text, placeholder, sizetofit(), textColor, setfloatinglabelcolor para
            cada estado setnormallabelcolor para o estado normal e setoutlinecolor para cada estado;
            4- Adiciona o MDTextField como subview da view criada no passo 1;
         */
        
        
        textfield.frame = CGRect(x:0 , y:0, width: container.frame.width, height: container.frame.height)
        textfield.sizeToFit()
        textfield.label.text = text
        textfield.placeholder = placeholder
        
        textfield.textColor = UIColor.smartBlack
        
        textfield.setFloatingLabelColor(UIColor.smartRed, for: MDCTextControlState.editing)
        textfield.setFloatingLabelColor(UIColor.smartDarkGrey, for: MDCTextControlState.normal)
        
        textfield.setNormalLabelColor(UIColor.smartDarkGrey, for: MDCTextControlState.normal)
        
        textfield.setOutlineColor(UIColor.smartRed, for: MDCTextControlState.editing)
        textfield.setOutlineColor(UIColor.smartDarkGrey , for: MDCTextControlState.normal)
        
        container.addSubview(textfield)
    }
    
    static func styleFilledButton(_ button: UIButton){
        button.backgroundColor = UIColor.smartRed
        button.layer.cornerRadius = 8.0
        button.tintColor = UIColor.smartWhite
    }
    
    static func styleHollowButton(_ button: UIButton){
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.smartBlack.cgColor
        button.layer.cornerRadius = 8.0
        button.tintColor = UIColor.smartBlack
    }
    
    static func styleHollowButtonRed(_ button: UIButton){
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.smartRed.cgColor
        button.layer.cornerRadius = 8.0
        button.tintColor = UIColor.smartRed
    }
    
    static func styleContainerView(_ view: UIView){
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.smartLightGrey.cgColor
        view.layer.cornerRadius = 8.0
    }
}

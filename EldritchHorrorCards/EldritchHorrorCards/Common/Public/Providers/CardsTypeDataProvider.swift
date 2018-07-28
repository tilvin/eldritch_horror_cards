//
//  CardsTypeDataProvider.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 28.07.2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

struct CardsType {
    var title: String
    var image: UIImage 
}
protocol CardsTypeDataProtocol {
    var cardShirt: [CardsType] { get set }
    func load()
}

class CardsTypeDataProvider: CardsTypeDataProtocol {
    var cardShirt: [CardsType] = []
    
    func load() {
        cardShirt = [CardsType(title:"Общие контакты", image: UIImage.contact),CardsType(title:"Контакты в Америке", image: UIImage.contactAmerica),CardsType(title:"Секретные карты Култху", image: UIImage.secretCthulhu),CardsType(title:"Поисковые карты Култху", image: UIImage.searchContactCthulhu),CardsType(title:"Специальные контакты Култху", image: UIImage.specialContactCthulhu)]
        print(cardShirt)
    }
}

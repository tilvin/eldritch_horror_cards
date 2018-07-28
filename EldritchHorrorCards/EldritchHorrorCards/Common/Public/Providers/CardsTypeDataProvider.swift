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
    private var cardsDataProvider = DI.providers.resolve(CardsDataProviderProtocol.self)!
    private var portals: [StoryCard] = []
    private var cities: [CityCard] = []
    private var expeditions: [StoryCard] = []
    private var contacts: [PlaceCard] = []
    private var evidences: [PlaceCard] = []
    private var specialContacts: [StoryCard] = []
    func load() {
        cardsDataProvider.load { (success) in
            if success {
                Log.writeLog(logLevel: .debug, message: "Monster is load!")
            }
            else {
                Log.writeLog(logLevel: .error, message: "Something gone wrong!")
            }
        }
        portals = cardsDataProvider.portals
        cities = cardsDataProvider.cities
        expeditions = cardsDataProvider.expeditions
        contacts = cardsDataProvider.contacts
        evidences = cardsDataProvider.evidences
        specialContacts = cardsDataProvider.specialContacts
        print(portals)
        if portals.count > 0 {
            cardShirt.append(CardsType(title: "card.type.portal".localized, image: .portal))
        }
        }
//        cardShirt = [CardsType(title:"Общие контакты", image: UIImage.contact),CardsType(title:"Контакты в Америке", image: UIImage.contactAmerica),CardsType(title:"Секретные карты Култху", image: UIImage.secretCthulhu),CardsType(title:"Поисковые карты Култху", image: UIImage.searchContactCthulhu),CardsType(title:"Специальные контакты Култху", image: UIImage.specialContactCthulhu)]
        
}
}

//
//  CardDataProvider.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/25/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

protocol CardsDataProviderProtocol {
    var portals: [StoryCard] { get set }
    var cities: [CityCard] { get set }
    var expeditions: [StoryCard] { get set }
    var contacts: [PlaceCard] { get set }
    var evidences: [PlaceCard] { get set }
    var specialContacts: [StoryCard] { get set }
    func load(completion: @escaping (Bool) -> Void)
}

class CardsDataProvider: CardsDataProviderProtocol {
    var portals: [StoryCard] = []
    var cities: [CityCard] = []
    var expeditions: [StoryCard] = []
    var contacts: [PlaceCard] = []
    var evidences: [PlaceCard] = []
    var specialContacts: [StoryCard] = []
    
    func load(completion: @escaping (Bool) -> Void){
        guard let path = Bundle.main.path(forResource: "cards", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) else {
                print("can't parse json!")
                return
        }
        
        if let json = try? JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.mutableContainers]) {
            let jsonDecks = DataParseService().parse(type: .decks, json: json)
            switch jsonDecks {
            case .decks(let decks):
                portals = decks.portals
                cities = decks.cities
                expeditions = decks.expeditions
                contacts = decks.contacts
                evidences = decks.evidences
                specialContacts = decks.specialContacts
                completion(true)
            case .error(error: let error):
                print(error)
                completion(false)
            default: break
            }
        }
        else {
            print("Invalid serialize data") 
            completion(false)
        }
    }
}


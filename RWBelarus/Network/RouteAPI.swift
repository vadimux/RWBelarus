//
//  RouteAPI.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/19/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Alamofire
import SwiftSoup

class NetworkManager {
    
    static func autocomplete(term: String, completion: @escaping (Result<AutocompleteAPI?>) -> Void) {
        Alamofire.request(APIRouter.autocomplete(term: term))
            .response { response in
                if let error = response.error {
                    completion(.failure(error))
                    return
                }
                guard let responseData = response.data else { return }
                
                let autocompleteAPI = try? JSONDecoder().decode(AutocompleteAPI.self, from: responseData)
                completion(.success(autocompleteAPI))
        }
    }

    /**
     * Запрос на получение поездов по заданному маршруту
     *
     * @param from    станция отправления
     * @param to      станция назначения
     * @param date    дата поездки
     * @param fromExp идентификатор станции отправления
     * @param toExp   идентификатор станции назначения
     * @return возвращает {@link ResponseBody} для получения и парсинга html страницы
     */
    static func getRouteBetweenCities(from: String, to: String, date: String, fromExp: String, fromEsr: String, toExp: String, toEsr: String, completion: @escaping (Result<[Route]?>) -> Void) {
        
        //        let STATION = "a[class=train_name -map train_text]"
        //        let ARRIVAL = "b[class=train_end-time]"
        //        let ARRIVED = "b[class=train_start-time]"
        //        let TRAVEL_TIME = "span[class=train_time-total]"
        //        let STAY = "b[class=train_stop-time]"
        
        let TRAIN_ID = "small[class=train_id]"
        let PATH = "a[class=train_text]"
        let TRAIN_TYPE = "div[class=train_description]"
        let TIME_END = "b[class=train_end-time]"
        let TIME_START = "b[class=train_start-time]"
        let TRAVEL_TIME = "span[class=train_time-total]"
        let DAYS = "td[class=train_item train_days regional_only hidden]"
        let STOPSEXCEPT = "td[class=train_item train_halts regional_only everyday_regional_only hidden]"
        let AB = "td[class=train_item train_details non_regional_only]"
        
        let ELECTRONIC_REGISTRATION = "i[class=b-spec spec_reserved]"
        let FAVOURITE_TRAIN = "i[class=b-spec spec_comfort]"
        let FAST_TRAIN = "i[class=b-spec spec_speed]"
        
        Alamofire.request(APIRouter.search(from: from, to: to, date: date, fromExp: fromExp, fromEsr: fromEsr, toExp: toExp, toEsr: toEsr))
            .responseString { response in
                
                if let error = response.error {
                    completion(.failure(error))
                    return
                }
                
                guard let responseData = response.data, let html = String(data: responseData, encoding: .utf8) else {
                    return
                }

                var routeList = [Route]()
                
                do {
                    
                    let doc: Document = try SwiftSoup.parse(html)
                    
                    guard let table: Element = try doc.select("table").first() else {
                        return
                    }
                    
                    let trCollection: Elements = try table.select("tr")

                    for element in trCollection {
                        let trainId = try element.select(TRAIN_ID).first()?.text()
                        let travelTime = try element.select(TRAVEL_TIME).first()?.text()
                        let startTime = try element.select(TIME_START).first()?.text()
                        let finishTime = try element.select(TIME_END).first()?.text()
                        let routeName = try element.select(PATH).first()?.text()
                        let days = try element.select(DAYS).first()?.text()
                        let trainType = try element.select(TRAIN_TYPE).first()?.text()
                        let exceptStops = try element.select(STOPSEXCEPT).first()?.text()
                        let elementPlace = try element.select("ul[class=train_details-group]")
                        
                        print(trainId)
                        var placesList = [TrainPlace]()
                        
                        for j in 0..<elementPlace.array().count {
                            let countPlace = try elementPlace.array()[j].getElementsByClass("train_seats lnk")
                            let name = try elementPlace.array()[j].getElementsByClass("train_note").text()
                            for i in 0..<countPlace.array().count {
                                let cost = try elementPlace.array()[j].getElementsByClass("train_price").text()
                                let count = try countPlace.array()[i].text()
                                let link = try elementPlace.array()[j].attr("data-get")
                                placesList.append(TrainPlace(name: name, count: count, link: link, cost: cost))
                            }
                        }
                        
                        let route = Route(trainId: trainId, travelTime: travelTime, startTime: startTime, finishTime: finishTime, routeName: routeName, days: days, trainType: trainType, exceptStops: exceptStops, place: placesList)
                        
                        routeList.append(route)
                    }
                    routeList.remove(at: 0)
                    completion(.success(routeList))
                } catch let error {
                    completion(.failure(error))
                }
        }
    }

}


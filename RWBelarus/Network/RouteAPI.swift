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
    
    /**
     * Запрос на получение списка станций удовлетворяющих введенному названию
     *
     * @param term символы, входящие в название станции или полное наименование станции
     * @completion список станций Result<AutocompleteAPI?>, удовлетворяющих введенному названию
     */
    
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
     * @completion возвращает Result<[Route]?> как список соответствующих маршрутов
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
                        let trainId: String = try element.select(TRAIN_ID).first()?.text() ?? ""
                        let travelTime: String = try element.select(TRAVEL_TIME).first()?.text() ?? ""
                        let startTime: String = try element.select(TIME_START).first()?.text() ?? ""
                        let finishTime: String = try element.select(TIME_END).first()?.text() ?? ""
                        let routeName: String = try element.select(PATH).first()?.text() ?? ""
                        let days: String = try element.select(DAYS).first()?.text() ?? ""
                        let trainType: TrainType = TrainType(rawValue: try element.select(TRAIN_TYPE).first()?.text() ?? "") ?? .unknown
                        let exceptStops: String = try element.select(STOPSEXCEPT).first()?.text()  ?? ""
                        let elementPlace = try element.select("ul[class=train_details-group]")
                        var places = [TrainPlace]()
                        
                        for i in 0..<elementPlace.array().count {
                            let countPlace = try elementPlace.array()[i].getElementsByClass("train_seats lnk")
                            let name = try elementPlace.array()[i].getElementsByClass("train_note").text()
                            for j in 0..<countPlace.array().count {
                                let cost = try elementPlace.array()[i].getElementsByClass("train_price").text()
                                let count = try countPlace.array()[j].text()
                                let link = try elementPlace.array()[i].attr("data-get")
                                places.append(TrainPlace.create()
                                    .name(name)
                                    .cost(cost)
                                    .link(link)
                                    .count(count)
                                    .build())
                            }
                        }
                        
                        routeList.append(Route.create()
                            .trainId(trainId)
                            .travelTime(travelTime)
                            .startTime(startTime)
                            .finishTime(finishTime)
                            .routeName(routeName)
                            .fromExp(fromExp)
                            .toExp(toExp)
                            .days(days)
                            .trainType(trainType)
                            .date(date)
                            .exceptStops(exceptStops)
                            .place(places)
                            .build())
                    }
                    //FIXIT: remove this logic
                    routeList.remove(at: 0)
                    completion(.success(routeList))
                } catch let error {
                    completion(.failure(error))
                }
        }
    }
    
    
    /**
     * Запрос на получение маршрута поезда
     *
     * @param trainNumber номер поезда
     * @param date  дата для поиска
     * @completion возвращает {@link ResponseBody} для получения и парсинга html страницы
     */

    static func getFullRoute(trainNumber: String, fromExp: String, toExp: String, date: String, completion: @escaping (Result<[Route]?>) -> Void) {
        
        let STATION = "a[class=train_name -map train_text]"
        let ARRIVAL = "b[class=train_end-time]"
        let DEPARTURE = "b[class=train_start-time]"
        let TRAVEL_TIME = "span[class=train_time-total]"
        let STAY = "b[class=train_stop-time]"
        
        Alamofire.request(APIRouter.searchFullRoute(trainNumber: trainNumber, fromExp: fromExp, toExp: toExp, date: date))
            .responseString { response in
                
                if let error = response.error {
                    completion(.failure(error))
                    return
                }
                
                guard let responseData = response.data, let html = String(data: responseData, encoding: .utf8) else {
                    return
                }
                
                do {
                    
                    let doc: Document = try SwiftSoup.parse(html)
                    
                    guard let table: Element = try doc.select("table").first() else {
                        return
                    }
                    
                    let trCollection: Elements = try table.select("tr")
                    
                    for element in trCollection {
                        let station: String = try element.select(STATION).first()?.text() ?? ""
                        let arrival: String = try element.select(ARRIVAL).first()?.text() ?? ""
                        let departure: String = try element.select(DEPARTURE).first()?.text() ?? ""
                        let travelTime: String = try element.select(TRAVEL_TIME).first()?.text() ?? ""
                        let stay: String = try element.select(STAY).first()?.text() ?? ""
                        
                        print(station, arrival, departure, travelTime, stay)
                    }
                    
                } catch let error {
                    completion(.failure(error))
                }
        }
    }
    
    
    
}


//
//  RWAPI.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/19/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Alamofire
import SwiftSoup
//import Cache

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
     * @completion возвращает Result<[Route]?> как список соответствующих маршрутов
     */
    static func getRouteBetweenCities(fromData: AutocompleteAPIElement, toData: AutocompleteAPIElement, date: String, completion: @escaping (Result<[Route]?>) -> Void) {
        
        Alamofire.request(APIRouter.search(fromData: fromData, toData: toData, date: date))
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
                        let trainId: String? = try element.select(K.APIParseConstant.TRAIN_ID).first()?.text()
                        let travelTime: String? = try element.select(K.APIParseConstant.TRAVEL_TIME).first()?.text()
                        let startTime: String? = try element.select(K.APIParseConstant.TIME_START).first()?.text()
                        let finishTime: String? = try element.select(K.APIParseConstant.TIME_END).first()?.text()
                        let routeName: String? = try element.select(K.APIParseConstant.PATH).first()?.text()
                        let days: String? = try element.select(K.APIParseConstant.DAYS).first()?.text()
                        let trainType: TrainType = TrainType(rawValue: try element.select(K.APIParseConstant.TRAIN_TYPE).first()?.text() ?? "") ?? .unknown
                        let exceptStops: String? = try element.select(K.APIParseConstant.STOPSEXCEPT).first()?.text()
                        let urlPath: String? = try element.select(K.APIParseConstant.URL).first()?.select("a").first()?.attr("href")
                        let elementPlace = try element.select(K.APIParseConstant.PLACE)
                        
                        var places = [TrainPlace]()
                        
                        for i in 0..<elementPlace.array().count {
                            let countPlace = try elementPlace.array()[i].getElementsByClass("train_seats lnk")
                            let name = try elementPlace.array()[i].getElementsByClass("train_note").text()
                            
                            for j in 0..<countPlace.array().count {
                                let cost = try elementPlace.array()[i].getElementsByClass("train_price").text()
                                let splitCost = cost.components(separatedBy: ". ")[j]
                                let count = try countPlace.array()[j].text()
                                let link = try countPlace.array()[j].attr("data-get")

                                places.append(TrainPlace.create()
                                    .name(name)
                                    .cost(splitCost)
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
                            .fromExp(fromData.exp)
                            .toExp(toData.exp)
                            .fromStation(fromData.value)
                            .toStation(toData.value)
                            .days(days)
                            .trainType(trainType)
                            .date(date)
                            .exceptStops(exceptStops)
                            .place(places)
                            .urlPath(urlPath)
                            .build())
                    }
                    //FIXIT: remove this logic
                    routeList.removeFirst()
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

    static func getFullRoute(for route: Route, completion: @escaping (Result<[RouteItem]?>) -> Void) {
        
        //FIXIT: move to Constant
        let URL = "div[class=train_inner]"
        
        Alamofire.request(APIRouter.searchFullRoute(urlPath: route.urlPath))
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
                    
                    guard let table: Element = try doc.select("table").first() else { return }
                    
                    let trCollection: Elements = try table.select("tr")
                    var stations = [RouteItem]()

                    for element in trCollection {
                        let station: String? = try element.select(K.APIParseConstant.STATION).first()?.text()
                        let arrival: String? = try element.select(K.APIParseConstant.ARRIVAL).first()?.text()
                        let departure: String? = try element.select(K.APIParseConstant.DEPARTURE).first()?.text()
                        let travelTime: String? = try element.select(K.APIParseConstant.TRAVEL_TIME).first()?.text()
                        let stay: String? = try element.select(K.APIParseConstant.STAY).first()?.text()
                        let urlPath: String? = try element.select(URL).first()?.select("a").first()?.attr("href")
                        var stationId: String?
                        
                        //TODO: check if need to add exp
                        if let range = urlPath?.range(of: "exp=") {
                            stationId = urlPath?[range.upperBound...].trimmingCharacters(in: .whitespaces)
                        }
                        
                        stations.append(RouteItem.create()
                            .station(station)
                            .arrival(arrival)
                            .departure(departure)
                            .travelTime(travelTime)
                            .stay(stay)
                            .stationId(stationId)
                            .build())
                    }
                    stations.removeFirst()
                    completion(.success(stations))
                } catch let error {
                    completion(.failure(error))
                }
        }
    }
    
    static func getSchemePlaces(with urlPath: String, completion: @escaping (Result<SchemeCarAPIModel?>) -> Void) {
        Alamofire.request(APIRouter.getSchemePlaces(urlPath: urlPath))
            .response { response in
                if let error = response.error {
                    completion(.failure(error))
                    return
                }
                guard let responseData = response.data else { return }
                
                let autocompleteAPI = try? JSONDecoder().decode(SchemeCarAPIModel.self, from: responseData)
                completion(.success(autocompleteAPI))
        }
    }
    
    static func getScheduleByStation(station: String?, date: String?, completion: @escaping (Result<[Route]?>) -> Void) {
        Alamofire.request(APIRouter.getScheduleByStation(station: station, date: date))
            .response { response in
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
                        let trainId: String? = try element.select(K.APIParseConstant.TRAIN_ID).first()?.text()
                        let startTime: String? = try element.select(K.APIParseConstant.TIME_START).first()?.text()
                        let finishTime: String? = try element.select(K.APIParseConstant.TIME_END).first()?.text()
                        let routeName: String? = try element.select(K.APIParseConstant.PATH).first()?.text()
                        let days: String? = try element.select(K.APIParseConstant.DAYS_VERSION_2).first()?.text()
                        let trainType: TrainType = TrainType(rawValue: try element.select(K.APIParseConstant.TRAIN_TYPE).first()?.text() ?? "") ?? .unknown
                        let exceptStops: String? = try element.select(K.APIParseConstant.STOPS_EXCEPT_VERSION_2).first()?.text()
                        let urlPath: String? = try element.select(K.APIParseConstant.URL_VERSION_2).first()?.select("a").first()?.attr("href")
                        
                        routeList.append(Route.create()
                            .trainId(trainId)
                            .startTime(startTime)
                            .finishTime(finishTime)
                            .routeName(routeName)
                            .days(days)
                            .trainType(trainType)
                            .date(date)
                            .exceptStops(exceptStops)
                            .urlPath(urlPath)
                            .build())
                    }
                    //FIXIT: remove this logic
                    routeList.removeFirst()
                    completion(.success(routeList))
                } catch let error {
                    completion(.failure(error))
                }
        }
    }
}

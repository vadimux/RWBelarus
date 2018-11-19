//
//  RWAPI.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/19/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Alamofire
import SwiftSoup

struct APIError: Error {
    var errorText: String?
}

class NetworkManager {
    
    // Request for receiving the list of stations satisfying the entered name
    static func autocomplete(term: String, completion: @escaping (Result<AutocompleteAPI?>) -> Void) {
        Alamofire.request(APIRouter.autocomplete(term: term))
            .response { response in
                if let error = response.error {
                    completion(.failure(error))
                    return
                }
                guard let responseData = response.data else {
                    let error = APIError(errorText: "Полученную информацию не удается преобразовать".localized)
                    completion(.failure(error))
                    return
                }
                
                let autocompleteAPI = try? JSONDecoder().decode(AutocompleteAPI.self, from: responseData)
                completion(.success(autocompleteAPI))
        }
    }
    
    // Request to receive trains for a given route
    static func getRouteBetweenCities(fromData: AutocompleteAPIElement, toData: AutocompleteAPIElement, date: String, completion: @escaping (Result<[Route]?>) -> Void) {

        Alamofire.request(APIRouter.search(fromData: fromData, toData: toData, date: date))
            .responseString { response in
                
                if let error = response.error {
                    completion(.failure(error))
                    return
                }
                
                guard let responseData = response.data, let html = String(data: responseData, encoding: .utf8) else {
                    let error = APIError(errorText: "Полученную информацию не удается преобразовать".localized)
                    completion(.failure(error))
                    return
                }

                var routeList = [Route]()
                
                do {
                    
                    let doc: Document = try SwiftSoup.parse(html)
                    
                    guard let table: Element = try doc.select("table").first() else {
                        let errorTitle: String? = try doc.select(K.APIParseConstant.ERROR_TITLE).first()?.text()
                        let errorText: String? = try doc.select(K.APIParseConstant.ERROR).first()?.text()
                        let error = APIError(errorText: (errorTitle ?? "") + (errorText ?? "" ))
                        completion(.failure(error))
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
    
    // Request for getting the train route
    static func getFullRoute(for route: Route, completion: @escaping (Result<[RouteItem]?>) -> Void) {

        Alamofire.request(APIRouter.searchFullRoute(urlPath: route.urlPath))
            .responseString { response in
                
                if let error = response.error {
                    completion(.failure(error))
                    return
                }
                
                guard let responseData = response.data, let html = String(data: responseData, encoding: .utf8) else {
                    let error = APIError(errorText: "Полученную информацию не удается преобразовать".localized)
                    completion(.failure(error))
                    return
                }
                
                do {
                    
                    let doc: Document = try SwiftSoup.parse(html)
                    
                    guard let table: Element = try doc.select("table").first() else {
                        let errorTitle: String? = try doc.select(K.APIParseConstant.ERROR_TITLE).first()?.text()
                        let errorText: String? = try doc.select(K.APIParseConstant.ERROR).first()?.text()
                        let error = APIError(errorText: (errorTitle ?? "") + (errorText ?? "" ))
                        completion(.failure(error))
                        return
                    }
                    
                    let trCollection: Elements = try table.select("tr")
                    var stations = [RouteItem]()

                    for element in trCollection {
                        let station: String? = try element.select(K.APIParseConstant.STATION).first()?.text()
                        let arrival: String? = try element.select(K.APIParseConstant.ARRIVAL).first()?.text()
                        let departure: String? = try element.select(K.APIParseConstant.DEPARTURE).first()?.text()
                        let travelTime: String? = try element.select(K.APIParseConstant.TRAVEL_TIME).first()?.text()
                        let stay: String? = try element.select(K.APIParseConstant.STAY).first()?.text()
                        let urlPath: String? = try element.select(K.APIParseConstant.URL_VERSION_3).first()?.select("a").first()?.attr("href")
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
    
    // Request for getting of the scheme of the car and info about places
    static func getSchemePlaces(with urlPath: String, completion: @escaping (Result<SchemeCarAPIModel?>) -> Void) {
        Alamofire.request(APIRouter.getSchemePlaces(urlPath: urlPath))
            .response { response in
                if let error = response.error {
                    completion(.failure(error))
                    return
                }
                guard let responseData = response.data else {
                    let error = APIError(errorText: "Полученную информацию не удается преобразовать".localized)
                    completion(.failure(error))
                    return
                }
                let autocompleteAPI = try? JSONDecoder().decode(SchemeCarAPIModel.self, from: responseData)
                completion(.success(autocompleteAPI))
        }
    }
    
    // Request for receiving the schedule for the selected station
    static func getScheduleByStation(station: String?, date: String?, completion: @escaping (Result<[Route]?>) -> Void) {
        Alamofire.request(APIRouter.getScheduleByStation(station: station, date: date))
            .response { response in
                if let error = response.error {
                    completion(.failure(error))
                    return
                }
                
                guard let responseData = response.data, let html = String(data: responseData, encoding: .utf8) else {
                    let error = APIError(errorText: "Полученную информацию не удается преобразовать".localized)
                    completion(.failure(error))
                    return
                }
                
                var routeList = [Route]()
                
                do {
                    
                    let doc: Document = try SwiftSoup.parse(html)
                    
                    guard let table: Element = try doc.select("table").first() else {
                        let errorTitle: String? = try doc.select(K.APIParseConstant.ERROR_TITLE).first()?.text()
                        let errorText: String? = try doc.select(K.APIParseConstant.ERROR).first()?.text()
                        let error = APIError(errorText: (errorTitle ?? "") + (errorText ?? "" ))
                        completion(.failure(error))
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
    
    static func login(with login: String, password: String, completion: @escaping (Result<String?>) -> Void) {
        //
        Alamofire.request(APIRouter.getLoginCredentials())
            .response { response in
                if let error = response.error {
                    completion(.failure(error))
                    return
                }
                guard let responseData = response.data, let html = String(data: responseData, encoding: .utf8) else {
                    let error = APIError(errorText: "Полученную информацию не удается преобразовать".localized)
                    completion(.failure(error))
                    return
                }
                
                do {
                    let doc: Document = try SwiftSoup.parse(html)
                    guard let table: Elements = try? doc.select("table") else {
                        let error = APIError(errorText: "Полученную информацию не удается преобразовать".localized)
                        completion(.failure(error))
                        return
                    }
                    let url: String? = try table.array()[1].select("td[class=status]").first()?.select("a").first()?.attr("onclick")
                    guard let urlPath = url else { return }
                    var urlPath1 = urlPath.replacingOccurrences(of: "window.location.href=baseUrlThSsl+\"", with: K.RWServer.baseRWURL)
                    urlPath1 = urlPath1.replacingOccurrences(of: "\"", with: "")
                    
                    //
                    Alamofire.request(APIRouter.getAuthCredentials(url: urlPath1))
                        .response { response in
                            if let error = response.error {
                                print(error)
                                return
                            }
                            guard let responseData = response.data, let html = String(data: responseData, encoding: .utf8) else {
                                let error = APIError(errorText: "Полученную информацию не удается преобразовать".localized)
                                completion(.failure(error))
                                return
                            }
                            
                            do {
                                let doc: Document = try SwiftSoup.parse(html)
                                guard let table: Elements = try? doc.select("table") else {
                                    let error = APIError(errorText: "Полученную информацию не удается преобразовать".localized)
                                    completion(.failure(error))
                                    return
                                }
                                let url: String? = try table.array()[1].select("td[class=status]").first()?.select("a").first()?.attr("onclick")
                                guard let urlPath = url else { return }
                                var urlPath1 = urlPath.replacingOccurrences(of: "window.location.href=baseUrlThSsl+\"", with: K.RWServer.baseRWURL)
                                urlPath1 = urlPath1.replacingOccurrences(of: "\"", with: "")
                                let addUrl: String? = try table.array()[2].select("form").array().first?.select("form").first()?.attr("action")
                                let fullPath = urlPath1 + (addUrl ?? "")
                                
                                //
                                Alamofire.request(APIRouter.login(login: login, password: password, url: fullPath))
                                    .response { response in
                                        if let error = response.error {
                                            print(error)
                                            return
                                        }
                                        guard let responseData = response.data, let html = String(data: responseData, encoding: .utf8) else {
                                            let error = APIError(errorText: "Полученную информацию не удается преобразовать".localized)
                                            completion(.failure(error))
                                            return
                                        }
                                        do {
                                            
                                            //
                                            Alamofire.request(APIRouter.orders())
                                                .response { response in
                                                    if let error = response.error {
                                                        print(error)
                                                        return
                                                    }
                                                    guard let responseData = response.data, let html = String(data: responseData, encoding: .utf8) else {
                                                        let error = APIError(errorText: "Полученную информацию не удается преобразовать".localized)
                                                        completion(.failure(error))
                                                        return
                                                    }
                                                    do {
                                                        let doc: Document = try SwiftSoup.parse(html)
                                                        
                                                        guard let table: Elements = try? doc.select("table") else {
                                                            let error = APIError(errorText: "Полученную информацию не удается преобразовать".localized)
                                                            completion(.failure(error))
                                                            return
                                                        }
                                                        
                                                        
                                                        if table.array().count > 0 {
                                                            completion(.success(try table.array()[1].select("nobr").first()?.text()))
                                                        } else {
                                                            let error1 = try doc.select("title").text()
                                                            if error1.contains(find: "403") {
                                                                let error = APIError(errorText: "Неверный логин или пароль".localized)
                                                                completion(.failure(error))
                                                            }
                                                        }
                                                    } catch let error {
                                                        print(error)
                                                    }
                                            }
                                        } catch let error {
                                            let error = APIError(errorText: error.localizedDescription)
                                            completion(.failure(error))
                                        }
                                }
                            } catch let error {
                                let error = APIError(errorText: error.localizedDescription)
                                completion(.failure(error))
                            }
                    }
                } catch let error {
                    let error = APIError(errorText: error.localizedDescription)
                    completion(.failure(error))
                }
        }
    }
}

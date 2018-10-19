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

                do {
                    let doc: Document = try SwiftSoup.parse(html)
                    
                    let trainId = try doc.select(TRAIN_ID)
                    let travelTime = try doc.select(TRAVEL_TIME)
                    let startTime = try doc.select(TIME_START)
                    let finishTime = try doc.select(TIME_END)
                    let routeName = try doc.select(PATH)
                    let days = try doc.select(DAYS)
                    let trainType = try doc.select(TRAIN_TYPE)

                    var routeList = [Route]()
                    
                    for i in 0..<trainId.array().count {
                        
                        let trainId = try trainId.array()[i].text()
                        let travelTime = try travelTime.array()[i].text()
                        let days = try days.array()[i].text()
                        let startTime = try startTime.array()[i].text()
                        let finishTime = try finishTime.array()[i].text()
                        let routeName = try routeName.array()[i].text()
                        
                        let route = Route(trainId: trainId, travelTime: travelTime, startTime: startTime, finishTime: finishTime, routeName: routeName, days: days)
                        routeList.append(route)
                    }
                    completion(.success(routeList))
                } catch let error {
                    completion(.failure(error))
                }
        }
    }

}


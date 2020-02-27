//
//  Titles.swift
//  Jiber
//
//  Created by I on 9/2/19.
//  Copyright © 2019 Shyngys. All rights reserved.
//

import Foundation
import UIKit

class Title {

    static let empty = ""

    class Controller {
        static let settings = "Настройки"
        static let aboutApp = "О приложений"
        static let profileEdit = "Личные данные"
    }

    class Tabbar {
        static let main = "Главная"
        static let create = "Создать"
        static let favorite = "Избранные"
        static let profile = "Профиль"
    }

    class Main {
        static let delivery = "Доставка"
        static let parcel = "Посылка"
        static let main = "Главная"
    }

    class Search {
        static let search = "Поиск"
    }

    class Create {
        static let fromCity = "Откуда"
        static let toCity = "Куда"
        static let dateOfDispatch = "Дата и время доставки"
        static let dateOfDeparture = "Дата и время выезда"
        static let dateOfArrived = "Дата и время прибытия"
        static let typeOfParcel = "Тип посылки"
        static let price = "Цена, тг"
        static let photoPicker = "Фото посылки и груза(минимум 3 фотки)"
        static let description = "Описание"
        static let forDelivery = "Для клиента"
        static let forParcel = "Для курьера"
        static let confirm = "Подтвердить"
        static let clear = "Очистить"
        static let submit = "Подать"
        static let delivery = "Доставки"
        static let parcel = "Посылки"
    }
    
    class Details {
        static let contactInformation = "Контактная информация"
        static let price = "Цена за услугу, тг"
        static let typeOfParcel = "Город, дата и время"
        static let betweenCity = "Город, дата и время"
        static let fio = "ФИО"
        static let phoneNumber = "Телефон"
    }

    class Filter {
        static let filter = "Фильтр"
        static let apply = "Применить"
        static let fromCity = "Откуда"
        static let toCity = "Куда"
        static let typeOfParcel = "Тип посылки"
        static let dateOfDispatch = "Дата отправки"
        static let price = "Цена, тг"
        static let typeOfMovement = "Типы перемещения"
        static let clear = "Очистить"
    }

    class Settings {
        static let main = "Основные"
        static let additional = "Дополнительные"
        static let language = "Язык"
        static let notifications = "Уведомления"
        static let aboutApp = "О приложении"
        static let contactUs = "Cвязаться с нами"
        static let rateTheApp = "Оценить приложение"
        static let shareApp = "Поделиться приложением"
        static let licenseAgreement = "Лицензионное соглашение"
    }

    class Profile {
        static let editProfile = "Редактировать профиль"
        static let gender = "Пол"
        static let phoneNumber = "Номер"
        static let city = "Город"
    }

    class Registration {
        static let name = "Имя"
        static let surname = "Фамилия"
        static let gender = "Пол"
        static let phoneNumber = "Номер"
        static let city = "Город"
        static let registration = "ЗАРЕГИСТРИРОВАТЬСЯ"
    }

    class ListOfRequests {
        static let delivery = "Доставка"
        static let parcel = "Посылка"
    }

    class ImagePicker {
        static let takePhoto = "Фотографировать"
        static let cameraRoll = "Фотопленка"
        static let photoLibrary = "Библиотека фотографий"
        static let cancel = "Отмена"
    }
}

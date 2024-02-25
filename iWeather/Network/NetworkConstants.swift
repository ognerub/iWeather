import Foundation

let token = "f49e4f1a-de08-4104-b3b7-0bceff802479"
let base = "https://api.weather.yandex.ru"

let moscowLatLon = "55.7522200;37.6155600"
let saintPetersburgLatLon = "59.9386300;30.3141300"
let novosibirskLatLon = "55.0415000;82.9346000"
let ekaterinburgLatLon = "56.8519000;60.6122000"
let nizhniyNovgorodLatLon = "56.3286700;44.0020500"
let samaraLatLon = "53.2000700;50.1500000"
let omskLatLon = "54.9924400;73.3685900"
let kazanLatLon = "55.7887400;49.1221400"
let chelyabinskLatLon = "55.1540200;61.4291500"
let rostovOnDonLatLon = "47.2313500;39.7232800"
let murmanskLatLon = "68.9791700;33.0925100"

struct NetworkConstants {
    
    let baseURL: String
    let personalToken: String
    let moscow: String
    let saintPetersburg: String
    let novosibirsk: String
    let ekaterinburg: String
    let nizhniyNovgorod: String
    let samara: String
    let omsk: String
    let kazan: String
    let chelyabinsk: String
    let rostovOnDon: String
    let murmansk: String
    
    init(
        baseURL: String,
        personalToken: String,
        moscow: String,
        saintPetersburg: String,
        novosibirsk: String,
        ekaterinburg: String,
        nizhniyNovgorod: String,
        samara: String,
        omsk: String,
        kazan: String,
        chelyabinsk: String,
        rostovOnDon: String,
        murmansk: String
    ) {
        self.baseURL = baseURL
        self.personalToken = personalToken
        self.moscow = moscow
        self.saintPetersburg = saintPetersburg
        self.novosibirsk = novosibirsk
        self.ekaterinburg = ekaterinburg
        self.nizhniyNovgorod = nizhniyNovgorod
        self.samara = samara
        self.omsk = omsk
        self.kazan = kazan
        self.chelyabinsk = chelyabinsk
        self.rostovOnDon = rostovOnDon
        self.murmansk = murmansk
    }
    
    static var standart: NetworkConstants {
        return NetworkConstants(
            baseURL: base,
            personalToken: token,
            moscow: moscowLatLon,
            saintPetersburg: saintPetersburgLatLon,
            novosibirsk: novosibirskLatLon,
            ekaterinburg: ekaterinburgLatLon,
            nizhniyNovgorod: nizhniyNovgorodLatLon,
            samara: samaraLatLon,
            omsk: omskLatLon,
            kazan: kazanLatLon,
            chelyabinsk: chelyabinskLatLon,
            rostovOnDon: rostovOnDonLatLon,
            murmansk: murmanskLatLon
        )
    }
}




import UIKit

class Company {
    let name: String
    var ceo: CEO
    
    init(name: String, ceo: CEO) {
        self.name = name
        self.ceo = ceo
    }
    
    func printMe() {
        print("Компания \(name)")
        ceo.printCompany()
        print("-------------")
    }
}

class CEO {
    let name: String
    var productManager: ProductManager?
    
    init(name: String) {
        self.name = name
    }
    
    lazy var printManager: () -> () = { [weak self] in
        if let manager = self?.productManager {
            print(manager.name)
        }
    }
    
    lazy var printDevelopers: () -> () = { [weak self] in
        if let manager = self?.productManager {
            print("(CEO просит менеджера распечатать разработчиков)")
            manager.printDevelopers()
        }
    }
    
    lazy var printCompany: () -> () = { [weak self] in
        if let manager = self?.productManager {
            print("(CEO просит менеджера распечатать всю компанию)")
            manager.printCompany()
        }
    }
    
    lazy var getMessage = { [weak self] (from: String, message: String) -> () in
        print("CEO получил от \(from) сообщение: \"\(message)\"")
    }
    
    
    deinit {
        print("\(name) уничтожен")
    }
}

class ProductManager {
    let name: String
    weak var ceo: CEO?
    var firstDeveloper: Developer?
    var secondDeveloper: Developer?
    
    
    init(name: String) {
        self.name = name
    }
    
    func printDevelopers() {
        if let first = firstDeveloper {
            print(first.name)
        }
        
        if let second = secondDeveloper {
            print(second.name)
        }
    }
    
    func printCompany() {
        if let ceo = self.ceo {
            print(ceo.name)
            print("У СЕО под контролем \(name)")
            print("\(name) контроллирует:")
            printDevelopers()
        }
    }
    
    func sendToDeveloper(recipient: Developer, to developer: String, with message: String) {
        if let first = firstDeveloper {
            if first.name == developer {
                print("(\(name) передает сообщение \(developer) от \(recipient.name))")
                first.getMessage(from: recipient.name, with: message)
                return
            }
        }
        if let second = secondDeveloper {
            if second.name == developer {
                print("(\(name) передает сообщение \(developer) от \(recipient.name))")
                second.getMessage(from: recipient.name, with: message)
                return
            }
        }
        print("(\(name) передает сообщение \(recipient.name))")
        recipient.getMessage(from: name, with: "Такого разработчика у нас нет")
    }
    
    func sendToCEO(recipient: String, with message: String) {
        if let ceo = ceo {
            print("(\(name) передает сообщение \(ceo.name) от \(recipient))")
            ceo.getMessage(recipient, message)
        }
    }
    
    func getMessage(from: String, with message: String) {
        print("\(name) получил от \(from) сообщение: \"\(message)\"")
    }
    
    deinit {
        print("\(name) уничтожен")
    }
}

class Developer {
    let name: String
    weak var productManager: ProductManager?
    
    init(name: String) {
        self.name = name
    }
    
    func sendMessageToDeveloper(to developer: String, with message: String) {
        print("(" + name + " просит менеджера найти \(developer) и передать ему сообщение)")
        if let manager = productManager {
            manager.sendToDeveloper(recipient: self, to: developer, with: message)
        }
    }
    
    func sendMessageToManager(message: String) {
        print("(" + name + " передает менеджеру сообщение)")
        if let manager = productManager {
            manager.getMessage(from: name, with: message)
        }
    }
    
    func sendMessageToCEO(message: String) {
        print("(" + name + " просит менеджера передать СЕО сообщение)")
        if let manager = productManager {
            manager.sendToCEO(recipient: name, with: message)
        }
    }
    
    func getMessage(from developer: String, with message: String) {
        print(name + " получил от " + developer + " сообщение: \"" + message + "\"")
    }
    
    deinit {
        print("\(name) уничтожен")
    }
}


//Создаю зону видимости, по выходу из которой все объекты должны уничтожиться (если не уничтожаться, то где-то retain cycle)
if true {
    
    //Инициализация
    let company = Company(name: "Tinkoff", ceo: CEO(name: "CEO Стас"))
    
    let manager = ProductManager(name: "Manager Анатолий")
    manager.ceo = company.ceo
    company.ceo.productManager = manager
    
    let developer1 = Developer(name: "Developer Василий")
    developer1.productManager = manager
    manager.firstDeveloper = developer1
    
    let developer2 = Developer(name: "Developer Геннадий")
    developer2.productManager = manager
    manager.secondDeveloper = developer2
    
    //Общение между объектами
    developer1.sendMessageToDeveloper(to: developer2.name, with: "Гена ты зачем съел мое печенье?")
    print("-----------------")
    developer2.sendMessageToDeveloper(to: "Developer Михаил", with: "Привет")
    print("-----------------")
    developer1.sendMessageToManager(message: "Дай задание")
    print("-----------------")
    developer2.sendMessageToCEO(message: "Дай денег")
    print("-----------------")
    
    company.printMe()
}



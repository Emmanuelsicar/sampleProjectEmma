import UIKit


//    func getPeople(_ search: String, _ order: ReturnOrder? = nil, _ factor: OrderFactor? = nil) -> [Person] {
//        var orderPeople: [Person] = []
//        if search != "" {
//            orderPeople = self.filter(people, search: search)
//        }else {
//            if let opcional = order, let opcional2 = factor {
//                orderPeople = self.order(people, order: opcional, factor: opcional2)
//            }
//        }
//        return orderPeople
//    }


//    func actualizarLista(_ person: Person, _ type: PersonType) {
//        provider.addPerson(person) { [unowned self] response in
//            if response {
//
//            }
//        } onFail: { [unowned self] mensaje in
//
//            print(mensaje)
//        }
//    }

//func addPerson(_ person: Person, onSucc:@escaping (Bool) -> Void, onFail: @escaping (String) -> Void) {
   // let numeroAleatorio = Int.random(in: 1..<15)
       
    /*DispatchQueue.main.asyncAfter(deadline: .now() + Double(numeroAleatorio)) {
        
        if numeroAleatorio <= 8 {
            if !self.people.contains(where: {$0.id == person.id}){
                self.people.append(person)
                onSucc(true)
                print("Registro exitoso tiempo: \(numeroAleatorio)")
            }
        } else {
            onFail(self.verificacionError(numero: numeroAleatorio))
        }
    }*/
//  }

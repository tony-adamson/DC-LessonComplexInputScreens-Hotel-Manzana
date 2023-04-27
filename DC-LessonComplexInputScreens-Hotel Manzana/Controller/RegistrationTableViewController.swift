//
//  RegistrationTableViewController.swift
//  DC-LessonComplexInputScreens-Hotel Manzana
//
//  Created by Антон Адамсон on 26.04.2023.
//

import UIKit

class RegistrationTableViewController: UITableViewController {

    //создаем объект, который будет содержать массив регистраций в отеле
    var registrations: [Registration] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    //метод для unwind segue, чтобы AddRegistrationTableViewController мог вернуться к RegistrationTableViewController
    @IBAction func unwindFromAddRegistration(unwindSegue: UIStoryboardSegue) {
    
        //В реализации получим исходный view controller (AddRegistrationTableViewController), чтобы получить доступ к свойству registration. Если это свойство не равно nil, вы добавите его в массив registrations и перезагрузите таблицу
        guard let addRegistrationTableViewController = unwindSegue.source as? AddRegistrationTableViewController,
              let registration = addRegistrationTableViewController.registration else { return }
    
        registrations.append(registration)
        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registrations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationCell", for: indexPath)

        //создаем обект registration который будет принимать в себя данные из массива registrations по indexPath.row
        let registration = registrations[indexPath.row]
        
        //конфигурируем контент ячейки через создание нового обьекта
        var content = cell.defaultContentConfiguration()
        content.text = registration.firstName + " " + registration.lastName
        content.secondaryText = (registration.checkInDate..<registration.checkOutDate).formatted(date: .numeric, time: .omitted) + ":" + registration.roomType.name
        
        //загружаем обработанный объект в ячейку
        cell.contentConfiguration = content

        return cell
    }

    //подготовим данные по нажатию на ячейку с данными
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        //если идентификатор перехода - нажатие на ячейку то
//        if segue.identifier == "ShowAddRegistrationDetails" {
//            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
//                let registration = registrations[indexPath.row]
//                let destinationVC = segue.destination as! AddRegistrationTableViewController
//                destinationVC.registration = registration
//            }
//        }
//    }

}

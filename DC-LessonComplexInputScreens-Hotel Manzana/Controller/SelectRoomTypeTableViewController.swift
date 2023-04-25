//
//  SelectRoomTypeTableViewController.swift
//  DC-LessonComplexInputScreens-Hotel Manzana
//
//  Created by Антон Адамсон on 25.04.2023.
//

import UIKit

//необходимо создать кастомный протокол. Протокол определяет функции и свойства, которые другой класс будет реализовывать.
protocol SelectRoomTypeTableViewControllerDelegate: AnyObject {
    //принимает два параметра: SelectRoomTypeTableViewController и экземпляр RoomType.
    func selectRoomTypeTableViewController(_ controller: SelectRoomTypeTableViewController,
                                           didSelect roomType: RoomType)
}

class SelectRoomTypeTableViewController: UITableViewController {
    
    //слабое свойство соотвествующее протоколу SelectRoomTypeTableViewControllerDelegate
    weak var delegate: SelectRoomTypeTableViewControllerDelegate?
    
    var roomType: RoomType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return RoomType.all.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTypeCell", for: indexPath)

        //инициализируем переменную значением из массива all по indexPath.row
        let roomType = RoomType.all[indexPath.row]
        
        //переменная content примет в себя тсандартную конфигурацию ячейки
        var content = cell.defaultContentConfiguration()
        //конфигурируем
        content.text = roomType.name
        content.secondaryText = "$ \(roomType.price)"
        //возвращаем назад
        cell.contentConfiguration = content
        
        //Если roomType для текущей строки таблицы соответствует self.roomType (текущий выбранный тип комнаты), то cell.accessoryType устанавливается в .checkmark, чтобы отобразить галочку. В противном случае, если тип комнаты не совпадает с выбранным типом, то cell.accessoryType устанавливается в .none, чтобы убрать галочку.
        if roomType == self.roomType {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }

    //реагирования на выбор пользователем типа номера
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let roomType = RoomType.all[indexPath.row]
        
        self.roomType = roomType
        
        //вызываем метод делагата
        delegate?.selectRoomTypeTableViewController(self, didSelect: roomType)
        tableView.reloadData()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

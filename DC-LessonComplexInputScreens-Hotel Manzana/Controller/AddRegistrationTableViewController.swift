//
//  AddRegistrationTableViewController.swift
//  DC-LessonComplexInputScreens-Hotel Manzana
//
//  Created by Антон Адамсон on 25.04.2023.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController {

    //свойства для отслеживания состояния представлений в ячейках
    //хранят индекс пути к датапикерам для удобного сравнения в методах делегата.
    let checkInDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
    let checkOutDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
    
    let checkInDateLabelCellIndexPath = IndexPath(row: 0, section: 1)
    let checkOutDateLabelCellIndexPath = IndexPath(row: 2, section: 1)
    
    //переменные для отслеживания состояния представлений в ячейках
    //хранят, будут ли датапикеры показаны или нет, и соответственно показывают или скрывают их, когда свойства устанавливаются. Оба датапикера начинаются с отображения в скрытом состоянии.
    var isCheckInDatePickerVisible: Bool = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckInDatePickerVisible
        }
    }
    var isCheckOutDatePickerVisible: Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerVisible
        }
    }
    
    //Выходы
    //для 0 секции
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    //для 1 секции с датами
    @IBOutlet var checkInDateLabel: UILabel!
    @IBOutlet var checkInDatePicker: UIDatePicker!
    @IBOutlet var checkOutDateLabel: UILabel!
    @IBOutlet var checkOutDatePicker: UIDatePicker!
    
    //для 2 секции с количеством проживающих
    @IBOutlet var numberOfAdultsLabel: UILabel!
    @IBOutlet var numberOfAdultsStepper: UIStepper!
    @IBOutlet var numberOfChildrenLabel: UILabel!
    @IBOutlet var numberOfChildrenStepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //инициализируем константу и передаем в него текущую дату из календаря устройства
        let midnightToday = Calendar.current.startOfDay(for: Date())
        //устанавливаем свойство .minimumDate у пикера равным текущей дате
        checkInDatePicker.minimumDate = midnightToday
        //устанавливаем дату на самом пикере равной текущей дате
        checkInDatePicker.date = midnightToday
        
        updateDateViews()
        updateNumberOfGuests()
    }

    //по нажатию кнопки Done в правом верхнем углу
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        //безопасное извлечение, если не пришел текст, то назначить пустой текст ""
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        
        print("DONE TAPPED")
        print("firstName: \(firstName)")
        print("lastName: \(lastName)")
        print("email: \(email)")
        print("checkIn: \(checkInDate)")
        print("checkOut: \(checkOutDate)")
        print("numberOfAdults: \(numberOfAdults)")
        print("numberOfChildren: \(numberOfChildren)")
    }
    
    //MARK: все для секции выбора дат
    //функция срабатывает при изменении значения первого пикера
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    
    //для обновления данных в полях даты заезда и даты выезда
    func updateDateViews() {
        //присваиваем минимальную дату пикеру используя обращение к текущей дате и date(byAdding:value:to:) добавляя один день
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: checkInDatePicker.date)
        
        //обращаемся к дате в пикере и форматируем ее .abbreviated - аббревиатура, .omitted - исключенная/пропущенная
        checkInDateLabel.text = checkInDatePicker.date.formatted(date: .abbreviated, time: .omitted)
        checkOutDateLabel.text = checkOutDatePicker.date.formatted(date: .abbreviated, time: .omitted)
    }
    
    //метод делегата таблицы запрашивает высоту строки при отображении строк таблицы.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //Используя switch на indexPath мы добавим случаи для двух строк выбора даты с where-условием для каждого, чтобы дополнительно определить, когда случай сработает. (where-условие работает как условие if.)
        switch indexPath {
        //возвращаем высоту 0 для ячеек выбора даты, когда они не отображаются.
        case checkInDatePickerCellIndexPath where isCheckInDatePickerVisible == false:
            return 0
        case checkOutDatePickerCellIndexPath where isCheckOutDatePickerVisible == false:
            return 0
        //используем значение по умолчанию для всех остальных ситуаций, чтобы позволить ячейкам автоматически определить свою высоту.
        default:
            return UITableView.automaticDimension
        }
    }
    
    //возвращаем правильную оценочную высоту строки для каждой строки, высота согласно size inspector
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case checkInDatePickerCellIndexPath:
            return 190
        case checkOutDatePickerCellIndexPath:
            return 190
        default:
            return UITableView.automaticDimension
        }
    }
    
    //метод для работы с выделением ячейки через didSelectRowAt, позволяет включать пикеры по нажатию на ячейку
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == checkInDateLabelCellIndexPath && isCheckOutDatePickerVisible == false {
                //выбрана метка Check-in, check-out picker не виден, переключить check-in picker
                isCheckInDatePickerVisible.toggle()
            } else if indexPath == checkOutDateLabelCellIndexPath && isCheckInDatePickerVisible == false {
                //выбрана метка Check-out, check-in picker не виден, переключить check-out picker
                isCheckOutDatePickerVisible.toggle()
            } else if indexPath == checkInDateLabelCellIndexPath || indexPath == checkOutDateLabelCellIndexPath {
                //выбрана метка, но предыдущие условия не выполнены,виден один пикер, переключить оба
                isCheckInDatePickerVisible.toggle()
                isCheckOutDatePickerVisible.toggle()
            } else {
                return
            }
        
        //обновляем вью для пересчета высоты ячеек после действий выбора
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    //MARK: Все для секции с количеством гостей
    //функция для обновления представлений количества проживающих
    func updateNumberOfGuests() {
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuests()
    }
}

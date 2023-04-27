//
//  AddRegistrationTableViewController.swift
//  DC-LessonComplexInputScreens-Hotel Manzana
//
//  Created by Антон Адамсон on 25.04.2023.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController, SelectRoomTypeTableViewControllerDelegate, UITextFieldDelegate {
    
    //добавили делегат тектового поля для реализации скрытия клавиатуры по нажатию кнопки
    
    //MARK: для соответствия протоколу SelectRoomTypeTableViewControllerDelegate
    func selectRoomTypeTableViewController(_ controller: SelectRoomTypeTableViewController, didSelect roomType: RoomType) {
        self.roomType = roomType
        updateRoomType()
    }
    
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
    
    //переменная для хранения выбранного номера
    var roomType: RoomType?
    
    //вычисляемое свойство с именем registration, которое возвращает объект типа Registration?
    var registration: Registration? {
    
        guard let roomType = roomType else { return nil }
    
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let hasWifi = wifiSwitch.isOn
    
        return Registration(firstName: firstName,
                            lastName: lastName,
                            emailAddress: email,
                            checkInDate: checkInDate,
                            checkOutDate: checkOutDate,
                            numberOfAdults: numberOfAdults,
                            numberOfChildren: numberOfChildren,
                            wifi: hasWifi,
                            roomType: roomType)
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
    
    //для 3 секции с опциями проживания
    @IBOutlet var wifiSwitch: UISwitch!
    
    //для 4 секции с выбором номера
    @IBOutlet var roomTypeLabel: UILabel!
    
    //атулет для бар баттон
    @IBOutlet var doneBarButton: UIBarButtonItem!
    
    //Аутлеты для Сharges
    @IBOutlet var numberOfNightsCount: UILabel!
    @IBOutlet var dateInformationLabel: UILabel!
    @IBOutlet var totalPriceForRoomLabel: UILabel!
    @IBOutlet var totalPriceForRoomInfoLabel: UILabel!
    @IBOutlet var wifiPriceLabel: UILabel!
    @IBOutlet var wifiInfoLabel: UILabel!
    @IBOutlet var totalPriceLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Устанавливаем делегатом для каждого текстового поля текущий класс для реализации скрытия клавиатуры
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        
        //инициализируем константу и передаем в него текущую дату из календаря устройства
        let midnightToday = Calendar.current.startOfDay(for: Date())
        //устанавливаем свойство .minimumDate у пикера равным текущей дате
        checkInDatePicker.minimumDate = midnightToday
        //устанавливаем дату на самом пикере равной текущей дате
        checkInDatePicker.date = midnightToday
        
        updateDateViews()
        updateNumberOfGuests()
        updateRoomType()
        
        doneBarButton.isEnabled = false
        
        //Установим начальные значения для charges
        calculateCharges()
        
        //добавляем отслеживание для 3х текстовых полей по наличию измненеий
        firstNameTextField.addTarget(self, action: #selector(updateDoneButtonState), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(updateDoneButtonState), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(updateDoneButtonState), for: .editingChanged)
    }
    
    //MARK: метод для расчета всех полей в charges
    func calculateCharges() {
        //создаем промежуточную переменную для подсчета денег
        var medianCalc = 0
        
        //подсчитаем количество дней
        // Вычисляем количество дней между двумя датами
        let dateComponents = Calendar.current.dateComponents([.day], from: checkInDatePicker.date, to: checkOutDatePicker.date)
        let numberOfDays = dateComponents.day ?? 0 // количество дней между двумя датами
        numberOfNightsCount.text = "\(numberOfDays)"
        
        //устанавливаем гард для извлечения опционала из текстового определения даты
        guard let checkInDate = checkInDateLabel.text, let checkOutDate = checkOutDateLabel.text else { return }
        //заполняем поле
        dateInformationLabel.text = checkInDate + "-" + checkOutDate
        
        //заполним поле с номером отеля
        //обновление метки выполнено в updateRoomType()
        if let roomType = roomType {
            totalPriceForRoomInfoLabel.text = "\(roomType.name) @ $\(roomType.price)/night"
            totalPriceForRoomLabel.text = "$ \(roomType.price * numberOfDays)"
            medianCalc += roomType.price * numberOfDays
        } else {
            totalPriceForRoomLabel.text = "$ 0"
            totalPriceForRoomInfoLabel.text = "Set Room"
        }
        
        //субтитры и стоимость вайфай на все дни
        if wifiSwitch.isOn {
            wifiPriceLabel.text = "$ \(numberOfDays * 10)"
            wifiInfoLabel.text = "Yes"
            medianCalc += numberOfDays * 10
        } else {
            wifiPriceLabel.text = "$ 0"
            wifiInfoLabel.text = "No"
        }
        
        if roomType != nil {
            totalPriceLabel.text = "$ \(medianCalc)"
        } else {
            totalPriceLabel.text = "$ 0"
        }
    }
    
    //MARK: метод для включения кнопки DONE
    @objc func updateDoneButtonState() {
        guard let registration = registration,
              !registration.firstName.isEmpty,
              !registration.lastName.isEmpty,
              !registration.emailAddress.isEmpty,
              registration.numberOfAdults + registration.numberOfChildren > 0
        else {
            doneBarButton.isEnabled = false
            return
        }
        doneBarButton.isEnabled = true
    }
    
    
    //MARK: все для секции выбора дат
    //функция срабатывает при изменении значения первого пикера
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
        calculateCharges()
    }
    
    //для обновления данных в полях даты заезда и даты выезда
    func updateDateViews() {
        //присваиваем минимальную дату пикеру используя обращение к текущей дате и date(byAdding:value:to:) добавляя один день
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: checkInDatePicker.date)
        
        calculateCharges()
        
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
    
    //MARK: для секции с опциями
    @IBAction func wifiSwitchChanged(_ sender: UISwitch) {
        calculateCharges()
    }
    
    //MARK: для секции с выбором типа номера
    //функция для обновления типа номера
    func updateRoomType() {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.name
            
            //добавляем проверку доступности кнопки после обновления текста
            updateDoneButtonState()
            
            //так же пересчитаем сумму
            calculateCharges()
        } else {
            roomTypeLabel.text = "Not Set"
        }
    }
    
    //MARK: переход по нажатию на ячейку с выбором номера
    @IBSegueAction func selectRoomType(_ coder: NSCoder) -> SelectRoomTypeTableViewController? {
        //инициализируем переменную как SelectRoomTypeTableViewController(coder: coder)
        let selectRoomTypeController = SelectRoomTypeTableViewController(coder: coder)
        
        //назначаем ее делегатом
        selectRoomTypeController?.delegate = self
        //В этой строке кода значение свойства roomType объекта selectRoomTypeController устанавливается равным значению свойства roomType текущего объекта AddRegistrationTableViewController.
        //Это означает, что если в AddRegistrationTableViewController была уже сделана выборка типа номера, выбранное значение будет передано в SelectRoomTypeTableViewController, чтобы он мог отметить соответствующую ячейку в своем списке и отобразить выбранное значение.
        selectRoomTypeController?.roomType = roomType
        
        return selectRoomTypeController
    }
    
    @IBAction func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    // Реализуем метод протокола UITextFieldDelegate для скрытия клавиатуры
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //скрываем клавиатуру
        textField.resignFirstResponder()
        return true
    }
}



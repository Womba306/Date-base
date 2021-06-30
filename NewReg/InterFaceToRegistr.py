#импорт
from datetime import datetime
import PySimpleGUI as sg
import pyodbc
import guard


# настройки
connection = pyodbc.connect(("Driver={ODBC Driver 17 for SQL Server};Server=MGP5-SPG04;Database=RegWind;Trusted_Connection=yes;UID=sa;PWD=111qqqAAA"))
dbCursor = connection.cursor()
sg.theme('dark grey 9')
Datatime = datetime.now()
Datatime = Datatime.strftime("%Y-%m-%d %H:%M:%S")
LogErrors = open('LogErrors.txt', 'a')
LogLogIn = open('LogLogIn.txt', 'a')
LogSingUp = open('LogSingUp.txt', 'a')
print(datetime.now())


# Окно вход/регистрация
def LogInORSingUp():
    layout = [
        [sg.Text('Телефон'),sg.InputText(size=(8,3),key='-PhonNum-',)],
        [sg.Text('Пароль'),sg.InputText(size=(8,3),key='-Password-')],
        [sg.Button("Регистрация"), sg.Submit("Войти")]
    ]
    window = sg.Window('Вход', layout)
    event, values = window.read()
    while event not in (None,"Exit"):


    # если нажали вход
        if event == "Войти":
            window.close()
            TryGuard(values['-PhonNum-'])


    # если нажали регистрация
        if event == "Регистрация":
            window.close()
            SingUp1()


# проверка уникальности пользователя(номер)
def IsUserUnique(phoneNum, passW):
    sql='EXEC [dbo].[UsersCheckRegister] @phoneNum=?,@passW=?'
    params=phoneNum,passW
    dbCursor.execute(sql,params)
    data = dbCursor.fetchall()
    return data[0][0]

def ErrorsSingUp():
    layout = [
        [sg.Text('Случалась не предвиденная ошибка)')],
        [sg.Submit("Далее")]]
    window = sg.Window('Ошибка регирстрации(не делай так больше)', layout)
    event, values = window.read()
    if event == "Далее":
        window.close()
        LogInORSingUp()


def SingUp1():
    # окно регистрации 1
    layout = [
        [sg.Text('Телефон'), sg.InputText(size=(20, 3), key='-PhonNumReg-', )],
        [sg.Text('Пароль'), sg.InputText(size=(20, 3), key='-Password1Reg-')],
        [sg.Text('Повторите пароль'), sg.InputText(size=(20, 3), key='-Password2Reg-')],
        [sg.Text('Имя'), sg.InputText(size=(20, 3), key='-Name1Reg-')],
        [sg.Text('Фамилия'), sg.InputText(size=(20, 3), key='-Name2Reg-')],
        [sg.CalendarButton('Выберите дату рождения', target='_CALENDAR_', font=('MS Sans Serif', 10, 'bold'),button_color=('red', 'white'), key='_CALENDAR_', format=('%Y-%m-%d'))],
        [sg.Submit("Далее")]]
# страт окна регистрации 1
    window = sg.Window('Регистрация 1', layout)
    event, values = window.read()

    while event not in (None, "Exit"):
        print(values['_CALENDAR_'])

# если пользователь уникален
        if event == "Далее":
            sql = 'EXEC [dbo].[UsersRegister] @phoneNum=?,@userName1=?,@userName2=?,@passW1=?,@passW2=?,@BDay=?,@regDate=?'
            params = values['-PhonNumReg-'],values['-Name1Reg-'],values['-Name2Reg-'],values['-Password1Reg-'],values['-Password2Reg-'],values['_CALENDAR_'],datetime.now()
            dbCursor.execute(sql, params)
            data = dbCursor.fetchall()
            dbCursor.commit()


            # если пароль не совпадает
            if values['-Password1Reg-'] != values['-Password2Reg-']:
                LogErrors.write(
                    f"Пользователь {values['-PhonNumReg-']}, в {Datatime}. Пытался создать аккаунт, но не смог повторить пароль" + '\n')
                LogErrors.close()
                window.close()
                ErrorsSingUp()


            # если пользователь не уникален
            if  data[0][0] == 1:
                LogErrors.write(f"Пользователь {values['-PhonNumReg-']}, в {Datatime}. Пытался создать второй аккаунт "+'\n')
                LogErrors.close()
                window.close()
                ErrorsSingUp()

            LogSingUp.write(f"Пользователь {values['-PhonNumReg-']}, зарегестрировал в аккаунт в {Datatime}." + '\n')
            LogSingUp.close()
            window.close()
            TryGuard(values['-PhonNumReg-'])

def MainWindow():
    layout = [
        [sg.Image('cat.jpg', key="-IMAGE-")],
        [sg.Submit("Далее")]]
    window = sg.Window('Главная страница', layout)
    event, values = window.read()
    while event not in (None, "Exit"):
        window["-IMAGE-"].update(r'C:\Users\maksimov_dv\PycharmProjects\pythonProject\img\cat.jpg')
        if event == "Далее":
            window.close()



def TryGuard(phoneNum):
    if guard.GuardCode == 0:
        LogLogIn.write(f"Пользователь {phoneNum}, зашел в аккаунт в {Datatime}." + '\n')
        LogLogIn.close()
        MainWindow()
    else:
        LogErrors.write(
            f"Пользователь {phoneNum}, в {Datatime}. Пытался войти в аккаунт, но не смог пройти капчу" + '\n')
        LogErrors.close()
        ErrorsSingUp()



# запуск программы
LogInORSingUp()

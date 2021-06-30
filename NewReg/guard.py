from datetime import datetime
import PySimpleGUI as sg
import re
import time

sg.theme('dark grey 9')
Datetime = datetime.now()





def detect_special_characer(pass_string):
  regex= re.compile('[@_!#$%^&*()<>?/\|}{~:] ')
  if(regex.search(pass_string) == None):
    res = False
  else:
    res = True
  return(res)

def UpdateList(Datetime):
    new_list = []
    for word in str(Datetime):
        new_str = ''
        for w in word:
            if detect_special_characer(w)==False:
                new_str += w
        new_list.append(new_str)
    new_str = ''.join(w for w in new_list if w)
    for i in range(len(new_list)):
        new_list[i]=new_list[i].lower()
    return new_str

def Run():
    layout = [
        [sg.Text('Ваш код')],
        [sg.Output(size=(16, 4), key='-GuardCode-')],
        [sg.Cancel('Закрыть', size=(7, 2)), sg.Submit('Создать', size=(7, 2))]
    ]
    window = sg.Window('Получение кода', layout)
    event, values = window.read()
    while True:
        if event == "Закрыть":
            window.close()
            break
        if event == "Создать":
            print(UpdateList(Datetime)[-6:-1] + UpdateList(Datetime)[5:7])
            GuardCode=(UpdateList(Datetime)[-6:-1] + UpdateList(Datetime)[5:7])
            break

    layout = [
        [sg.Text('Полученный код')],
        [sg.InputText(size=(16, 4), key='-ReturnedGuardCode-')],
        [sg.Cancel('Закрыть', size=(7, 2)), sg.Submit('Проверить', size=(7, 2))]
    ]
    window = sg.Window('Проверка кода', layout)
    event, values = window.read()
    while event not in (None, "Exit"):
        if event == "Закрыть":
            window.close()
        if event == "Проверить":
            if values['-ReturnedGuardCode-'] == GuardCode:
                return 0
                print("Успех")
            else:
                print("Ошибка")
                return 1


GuardCode=Run()
print(GuardCode)
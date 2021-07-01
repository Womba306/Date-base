import os.path
import time
from datetime import datetime
import PySimpleGUI as sg
import pyodbc
import sys
from PIL import Image
from io import BytesIO


connection = pyodbc.connect(("Driver={ODBC Driver 17 for SQL Server};Server=MGP5-SPG04;Database=RegWind;Trusted_Connection=yes;UID=sa;PWD=111qqqAAA"))
dbCursor = connection.cursor()
sg.theme('dark grey 9')
Datetime = datetime.now()
Datetime = Datetime.strftime("%Y-%m-%d %H:%M:%S")

def ShowImage(DirectoryFile,CommentFile):

    layout = [
        [sg.In(DirectoryFile,key="-DirectoryFile-"),sg.FileBrowse(file_types=(("Image Files", ("*.jpg","*.png")),), key="-Img-")],
        [sg.InputText(CommentFile,key="-CommentFile-")],
        [sg.Button("Открыть из базы"),sg.Button("Обновить"),sg.Submit("Сохранить")]
        ]

    window = sg.Window('Получение файла', layout)
    event, values = window.read()

    while event not in (None, "Exit"):
        if event == "Обновить":
            im = Image.open(rf"{values['-DirectoryFile-']}")
            width, height = im.size
            newsize = (1080, 720)
            im.resize(newsize)
            im.show()
            window.close()
            ShowImage(values['-DirectoryFile-'],values['-CommentFile-'])

        if event == "Сохранить":
            sql = 'EXEC [dbo].[ShowImagesInsert] @Url=?,@Name=?,@Time=?,@Comment=?,@Img=?'
            im = Image.open(rf"{values['-DirectoryFile-']}")
            width, height = im.size
            newsize = (1080, 720)
            im.resize(newsize)
            im.show()
            with open(rf"{values['-DirectoryFile-']}", 'rb') as ImageFile:
                bindata=ImageFile.read()

            params = values['-DirectoryFile-'],os.path.basename(values['-DirectoryFile-']),Datetime,values['-CommentFile-'],bindata
            dbCursor.execute(sql, params)
            dbCursor.commit()
            window.close()
            ShowImage(None,None)
        if event == "Открыть из базы":
            window.close()
            ShowImageOutDataBase()

def ShowImageOutDataBase():
    sql = 'Select Img, Name From ShowImageTablet'
    dbCursor.execute(sql)
    data = dbCursor.fetchall()
    new_dict = {IMG: NAME for NAME, IMG in data}
    new_list=[]
    for FileName in data:
        new_list.append([FileName[1]])
    print(data[0][0])



    layout = [
        [sg.Combo(new_list,key="-BaseImg-",size=(10,3))],
        [sg.Cancel("Назад"), sg.Submit("Обновить")]
    ]

    window = sg.Window('Вывод файла из БД', layout)
    event, values = window.read()
    while event not in (None, "Exit"):
        if event == "Обновить":
            print(new_dict[values["-BaseImg-"][0]])
            stream = BytesIO(new_dict[values["-BaseImg-"][0]])
            image = Image.open(stream).convert("RGBA")
            stream.close()
            image.show()
            window.close()
            ShowImageOutDataBase()
        if event == "Назад":
            ShowImage(None, None)



ShowImage(None,None)
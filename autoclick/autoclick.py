import pyautogui
import time

procurar = "sim"
while procurar == "sim":
        try:
            img = pyautogui.locateCenterOnScreen('/home/pietroandrade/Documentos/scripts/autoclick/allow.png', confidence=0.7)
            #pyautogui.click(img.x, img.y)
            #procurar = "não"
            #time.sleep(2)
            #pyautogui.hotkey('ctrl', 'w')
            exit
        except:
                print("não encontrou")
                time.sleep(1)

import pyautogui
import time

procurar = "sim"
while procurar == "sim":
        try:
            img = pyautogui.locateCenterOnScreen('allow.png', confidence=0.7)
            pyautogui.click(img.x, img.y)
            procurar = "não"
            time.sleep(2)
            pyautogui.hotkey('ctrl', 'w')
            exit
        except:
                time.sleep(1)

import os
import uuid
from fastapi import FastAPI, Request, Response
from fastapi.responses import HTMLResponse, JSONResponse
from pydantic import BaseModel
import uvicorn
import socket
import sys
from remote_shutdown.port import check_tcp_connectivity
import tkinter
from tkinter import messagebox

# ポート番号
port: int = 50031

token_path: str = "token.txt"
dir: str = ""
if os.path.isdir("_internal"):
    dir = "_internal/"

if check_tcp_connectivity("127.0.0.1", port):
    print("ポート番号が使用されています。\n" \
          f"{port} ポートを使用してるアプリケーションを終了してください。")
    root: tkinter.Tk = tkinter.Tk()
    root.withdraw()
    root.iconbitmap(f"{dir}www/icon.ico")
    messagebox.showerror('起動エラー',
        "ポート番号が使用されています。\n" \
        f"{port} ポートを使用してるアプリケーションを終了してください。")
    
    ret: bool = messagebox.askyesno('アプリ', 'アプリを終了しますか?')
    if ret:
        os.system('taskkill /F /IM remote_shutdown.exe')

    sys.exit(False)
else:
    pass

# 標準出力を捨てる
sys.stdout = open(os.devnull, 'w')
app: FastAPI = FastAPI()

@app.get("/")
async def root():
    with open(f"{dir}www/index.html", "r", encoding="utf-8") as f:
        return HTMLResponse(content=f.read())
    
@app.get("/script")
async def script():
    with open(f"{dir}www/main.js", "r", encoding="utf-8") as f:
        return Response(content=f.read(), media_type="text/javascript")

@app.get("/style")
async def style():
    with open(f"{dir}www/main.css", "r", encoding="utf-8") as f:
        return Response(content=f.read(), media_type="text/css")
    
@app.get("/favicon.ico")
async def script():
    with open(f"{dir}www/icon.ico", "rb") as f:
        return Response(content=f.read(), media_type="image/x-icon")

def get_token_from_file(token_path: str):
    with open(token_path, "r", encoding="utf-8") as f:
        return f.read()

@app.get("/get_token")
async def get_token(request: Request):
    ip: str = request.client.host
    token: str = ""
    if(not os.path.exists(token_path)):
        token = str(uuid.uuid4())
        with open(token_path, "w", encoding="utf-8") as f:
            f.write(token)
    else:
        token = get_token_from_file(token_path)

    if ip == "127.0.0.1":
        return JSONResponse({"status": True, "token": token})
    else:
        return JSONResponse({"status": False, "message": "To obtain the token, access localhost from the PC running the service!"})

class Auth(BaseModel):
    token: str

@app.post("/shutdown")
async def shutdown(auth: Auth):
    if auth.token == get_token_from_file(token_path):
        os.system('shutdown -s -f -t 0')
        return {"status": True}
    else:
        return {"status": False}
    
@app.post("/reboot")
async def reboot(auth: Auth):
    if auth.token == get_token_from_file(token_path):
        os.system('shutdown -r -f -t 0')
        return {"status": True}
    else:
        return {"status": False}
    
@app.get("/ip")
async def ip():
    ip_addr: str = socket.gethostbyname(socket.gethostname())
    return {"ip": ip_addr}

if __name__ == "__main__":
    try:
        uvicorn.run(app, host="0.0.0.0", port=port)
    except Exception as ex:
        print(ex)

    # os.system('shutdown -s -f -t 0')
    # pass


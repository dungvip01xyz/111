import requests
import json
import subprocess
import time
import os

# Đường dẫn file lưu dữ liệu
data_file = "data.json"

# Kiểm tra nếu file dữ liệu không tồn tại, tạo mới
if not os.path.exists(data_file):
    with open(data_file, "w") as f:
        json.dump({"usernames": [], "device_ids": []}, f)

# Đọc dữ liệu từ file
def read_data():
    with open(data_file, "r") as f:
        return json.load(f)

# Lưu dữ liệu vào file
def save_data(data):
    with open(data_file, "w") as f:
        json.dump(data, f)

# Đếm ngược thời gian
def countdown_timer(seconds):
    for i in range(seconds, 0, -1):
        print(f"\rThời gian còn lại: {i} giây", end="")
        time.sleep(1)
    print("\nHết thời gian!")

# Mở BloxFruit
def openbloxfruit(device):
    command = [
        "adb", "-s", device, "shell", "am", "start", 
        "-n", "com.roblox.client/com.roblox.client.ActivityProtocolLaunch", 
        "-d", "roblox://placeID=2753915549"
    ]
    result = subprocess.run(command, capture_output=True, text=True)
    print(result.stdout)
    print(result.stderr)

# Đóng Roblox
def close_roblox(device):
    command = ["adb", "-s", device, "shell", "am", "force-stop", "com.roblox.client"]
    result = subprocess.run(command, capture_output=True, text=True)
    print(result.stdout)
    print(result.stderr)

# Lấy ID người dùng Roblox
def getid(username):
    url = "https://users.roblox.com/v1/usernames/users"
    payload = json.dumps({"usernames": [username]})
    headers = {'Content-Type': 'application/json'}

    response = requests.post(url, headers=headers, data=payload)
    data = response.json()

    if "data" in data and len(data["data"]) > 0:
        return data["data"][0]["id"]
    return None

# Kiểm tra trạng thái online của tài khoản
def checkonline(username, device):
    user_id = getid(username)
    if user_id is None:
        print(f"Không tìm thấy user: {username}")
        return

    url = "https://presence.roblox.com/v1/presence/users"
    payload = json.dumps({"userIds": [user_id]})
    headers = {'Content-Type': 'application/json'}

    response = requests.post(url, headers=headers, data=payload)
    data = response.json()

    for user in data.get("userPresences", []):
        user_id = user["userId"]
        presence = user["userPresenceType"]
        if presence == 2:
            print(f"User {user_id} is ONLINE")
        else:
            print(f"User {user_id} is OFFLINE")
            close_roblox(device)
            time.sleep(2)
            openbloxfruit(device)

# Hiển thị tài khoản và thiết bị
def list_accounts():
    data = read_data()
    print("\nDanh sách tài khoản và thiết bị:")
    if len(data["usernames"]) == 0:
        print("Không có tài khoản nào.")
    else:
        for idx, (username, device_id) in enumerate(zip(data["usernames"], data["device_ids"]), start=1):
            print(f"{idx}. Tài khoản: {username} - Thiết bị: {device_id}")

# Thêm tài khoản và thiết bị
def add_account():
    username = input("Nhập tên tài khoản Roblox: ")
    device_id = input("Nhập ID thiết bị (VD: 192.168.1.22:5555): ")

    data = read_data()
    data["usernames"].append(username)
    data["device_ids"].append(device_id)
    save_data(data)
    print(f"Đã thêm tài khoản {username} và thiết bị {device_id}")

# Xóa tài khoản và thiết bị
def remove_account():
    list_accounts()
    try:
        index = int(input("\nNhập số thứ tự của tài khoản muốn xóa: ")) - 1
        data = read_data()

        if 0 <= index < len(data["usernames"]):
            username = data["usernames"][index]
            device_id = data["device_ids"][index]
            data["usernames"].pop(index)
            data["device_ids"].pop(index)
            save_data(data)
            print(f"Đã xóa tài khoản {username} và thiết bị {device_id}")
        else:
            print("Số thứ tự không hợp lệ.")
    except ValueError:
        print("Vui lòng nhập một số hợp lệ.")

# Quản lý tài khoản và thiết bị
def menu():
    while True:
        print("\nChọn chức năng:")
        print("1. Thêm tài khoản và thiết bị")
        print("2. Xóa tài khoản và thiết bị")
        print("3. Hiển thị danh sách tài khoản")
        print("4. Chạy kiểm tra tất cả tài khoản")
        print("5. Thoát")

        choice = input("Nhập lựa chọn: ")

        if choice == "1":
            add_account()
        elif choice == "2":
            remove_account()
        elif choice == "3":
            list_accounts()
        elif choice == "4":
            check_all_accounts()  # Gọi hàm kiểm tra tất cả tài khoản
        elif choice == "5":
            break
        else:
            print("Lựa chọn không hợp lệ. Vui lòng thử lại.")

# Kiểm tra tất cả tài khoản
def check_all_accounts():
    data = read_data()
    while True:  # Lặp lại vô hạn
        for idx, (username, device_id) in enumerate(zip(data["usernames"], data["device_ids"]), start=1):
            print(f"Đang kiểm tra tài khoản {username} - Thiết bị {device_id}")
            checkonline(username, device_id)
        countdown_timer(60)  # Đếm ngược 60 giây sau mỗi lần kiểm tra

# Gọi menu và kiểm tra tài khoản
menu()

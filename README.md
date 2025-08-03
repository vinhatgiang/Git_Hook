# Git Hooks
Vi Vi Vi  vi viv vo
Bộ Git hooks tự động để bảo vệ repository và đảm bảo quy tắc phát triển.
VI VI Vi   

## Tính năng

**Chặn commit/push vào branch chính** (main, develop)  
**Chặn force push**  
**Chặn rebase operations**  
**Kiểm tra độ dài commit message** (tối thiểu 10 ký tự)  Vi VI Vi

## Cài đặt

### Windows (Git Bash)

1. Copy thư mục hook-win và file install_hooks.sh vào trong thư mục project (nới có file `.git`)
2. Mở **Git Bash** trong thư mục project (nới có file `.git`)
3. Chạy lệnh:
```bash
bash install_hooks.sh
```

### macOS (Terminal)

1. Copy thư mục hook-win và file install_hooks.sh vào trong thư mục project (nới có file `.git`)
2. Mở **Terminal** trong thư mục project (nơi có file `.git`)
3. Chạy script cài đặt:
   ```bash
   bash install_hooks.sh
   ```

### Trường hợp đã cài đặt thành công:
Sau khi cài đặt xong có thể xoá thư mục và file vừa copy vào thư mục project

### Trường hợp không muốn sử dụng các rules này:
Xoá các file trong thư mục `.git/hooks` để bỏ qua các rules vừa cài đặt xong.


## Quy tắc Commit Message

- Commit message phải có **ít nhất 10 ký tự**
- Viết rõ ràng, mô tả đúng nội dung thay đổi

**Ví dụ:**
```
Add user login feature
Fix navigation bug  
Update installation guide
```

## Lưu ý

- Hooks sẽ hiển thị thông báo lỗi và dialog cảnh báo
- Không thể commit trực tiếp vào `main` hoặc `develop`  
- Không thể force push
- Không thể thực hiện rebase
- Commit message phải có ít nhất 10 ký tự

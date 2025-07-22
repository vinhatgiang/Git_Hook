# Git Hooks Tùy Chỉnh

Bộ Git hooks này giúp đảm bảo quy tắc phát triển và chất lượng code cho dự án của bạn.

## Tính Năng

1. **Bảo Vệ Nhánh Chính**
   - Chặn commit trực tiếp vào nhánh `main` và `develop`
   - Chặn push trực tiếp vào nhánh `main` và `develop`
   - Hiển thị cảnh báo trên terminal và dialog

2. **Quy Tắc Commit Message**
   - Độ dài tối thiểu: 10 ký tự
   - Định dạng bắt buộc: `<type>: <description>`
   - Các type hợp lệ: feat, fix, docs, style, refactor, test, chore
   - Ví dụ: `feat: thêm tính năng đăng nhập`

3. **Bảo Vệ Lịch Sử Git**
   - Chặn force push
   - Chặn thao tác rebase trên nhánh được bảo vệ (main/develop)
   - Chặn rebase vào nhánh được bảo vệ
   - Hiển thị cảnh báo chi tiết với hướng dẫn thay thế

## Cài Đặt Git Hooks

### Yêu Cầu Hệ Thống
- **Windows**: Windows 10 trở lên
- **macOS**: macOS 10.15 trở lên
- **Git**: Phiên bản 2.30.0 trở lên

### Cài Đặt Trên Windows
1. Copy toàn bộ thư mục `hook-win` vào thư mục gốc của dự án Git
2. Mở Command Prompt hoặc PowerShell
3. Chạy lệnh:
   ```cmd
   cd đường-dẫn-tới-dự-án-git
   .\hook-win\install_hooks.bat
   ```

### Cài Đặt Trên macOS
1. Copy toàn bộ thư mục `hook-mac` vào thư mục gốc của dự án Git
2. Mở Terminal
3. Chạy các lệnh:
   ```bash
   cd đường-dẫn-tới-dự-án-git
   chmod +x ./hook-mac/install_hooks
   ./hook-mac/install_hooks
   ```

### Kiểm Tra Cài Đặt
Script sẽ tự động:
- ✓ Kiểm tra tất cả các file hook cần thiết
- ✓ Sao lưu hooks hiện có (nếu có)
- ✓ Cài đặt và cấp quyền cho các hook mới
- ✓ Hiển thị kết quả chi tiết

### Xử Lý Lỗi Thường Gặp

#### 1. "Not a Git repository"
- **Nguyên nhân**: Chưa khởi tạo Git repository
- **Cách xử lý**: Chạy `git init` trước khi cài đặt hooks

#### 2. "Missing required hook files"
- **Nguyên nhân**: Thiếu file hook trong thư mục
- **Cách xử lý**: Kiểm tra đã copy đầy đủ các file từ thư mục gốc

#### 3. "Permission denied"
- **Windows**: Chạy Command Prompt với quyền Administrator
- **macOS**: Chạy `chmod +x` cho file install_hooks

### Các Hook Được Cài Đặt
1. **pre-commit**: Chặn commit trực tiếp vào main/develop
2. **commit-msg**: Kiểm tra định dạng commit message
3. **pre-push**: Chặn push và force push vào main/develop
4. **pre-rebase**: Chặn mọi thao tác rebase

### Quy Trình Làm Việc Khuyến Nghị
1. Tạo nhánh mới: `git checkout -b feature/tên-tính-năng`
2. Thêm thay đổi: `git add .`
3. Commit với message đúng định dạng: `git commit -m "type: mô tả"`
4. Đẩy code lên: `git push origin feature/tên-tính-năng`
5. Tạo Pull Request để review và merge

### Hỗ Trợ
Nếu gặp vấn đề, vui lòng:
1. Kiểm tra log trong terminal
2. Đọc kỹ thông báo lỗi hiển thị
3. Liên hệ team lead để được hỗ trợ

## Xử Lý Khi Bị Chặn

1. **Khi Commit/Push vào Main/Develop**
   - Tạo nhánh feature mới
   - Commit/push vào nhánh feature
   - Tạo Pull Request để merge

2. **Khi Commit Message Bị Từ Chối**
   - Đảm bảo commit message có định dạng đúng
   - Sử dụng một trong các prefix: feat, fix, docs, style, refactor, test, chore
   - Viết mô tả rõ ràng sau dấu ':'

3. **Khi Force Push Bị Chặn**
   - Giải quyết conflict bằng merge
   - Tạo nhánh mới nếu cần
   - Phối hợp với team

## Lưu Ý
- Hooks sẽ hiển thị thông báo lỗi cả trên terminal và cửa sổ dialog
- Mọi thông báo lỗi đều kèm theo hướng dẫn khắc phục
- Nếu cần bỏ qua hooks (không khuyến khích), thêm `--no-verify` vào lệnh git

## Hỗ Trợ
Nếu bạn gặp vấn đề hoặc cần hỗ trợ, vui lòng:
1. Kiểm tra thông báo lỗi và làm theo hướng dẫn
2. Xem lại phần hướng dẫn trong README
3. Liên hệ với team lead hoặc maintainer dự án

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

## Cách Cài Đặt

### Windows
1. Copy thư mục `hook-win` vào dự án của bạn
2. Chạy file `install_hooks.bat`

### macOS
1. Copy thư mục `hook-mac` vào dự án của bạn
2. Mở terminal và chạy các lệnh:
   ```bash
   cd đường-dẫn-tới-dự-án
   chmod +x hook-mac/install_hooks
   ./hook-mac/install_hooks
   ```

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

# Capstone Project Report
## Report 3 – Software Requirement Specification
**Ho Chi Minh City, [Month, Year]**

---

# I. Record of Changes

---

# II. Software Requirement Specification

# 1. Overall Description

## 1.1 Product Overview

### Ngữ cảnh dự án (Context)

Khoa Khám bệnh Ngoại trú (OPD) tại các bệnh viện hiện đang đối mặt với cuộc khủng hoảng điểm nghẽn do quá tải và quy trình vận hành phân mảnh.

Vấn đề cốt lõi nằm ở **"Khoảng trống hành trình" (The Journey Gap)**, thiếu sự đồng bộ thời gian thực giữa phòng khám lâm sàng và các khu vực dịch vụ cận lâm sàng/thanh toán.

### Mục tiêu kinh doanh (Business Objectives)

- **BO-001:** Tối ưu hóa luồng vận hành, loại bỏ thời gian chết bằng hệ thống TriageFlow đóng vai trò là "Nguồn dữ liệu đáng tin cậy" (Source of Truth).
- **BO-002:** Ứng dụng LLM Engine để phân loại chuyên khoa thông minh và xếp hàng đợi tự động tại Kiosk.
- **BO-003:** Cung cấp kiến trúc Hybrid (App/Kiosk & Quầy Lễ tân/Thu ngân) để phục vụ cả nhóm dùng công nghệ và nhóm không dùng smartphone.
- **BO-004:** Áp dụng mô hình thanh toán Dynamic QR gộp chỉ định (All-or-Nothing Payment) để triệt tiêu "hàng đợi ảo" tại phòng Cận lâm sàng.

### Giả định & Ràng buộc (Assumptions & Constraints)

#### Giả định

- Mã QR trên CCCD/VNeID tuân theo chuẩn quốc gia.
- Mock-HIS cung cấp đủ API chuẩn REST.
- Hạ tầng mạng đảm bảo kết nối WebSocket thời gian thực.

#### Ràng buộc

- Hệ thống chỉ phục vụ luồng khám ngoại trú.
- Giả lập các tương tác phần cứng (máy in nhiệt).
- Giao diện bắt buộc dùng Unicode Tiếng Việt.

### Mô tả Context Diagram

Hệ thống **TriageFlow System** nằm ở trung tâm, tương tác với các External Entities sau:

#### Patient

**Cung cấp:**
- Thông tin định danh
- Triệu chứng
- Yêu cầu thanh toán

**Nhận:**
- Mã hàng đợi
- Lộ trình Wayfinding
- Kết quả
- Push Notification

#### Mock-HIS (External System)

**Cung cấp:**
- Dữ liệu bệnh nhân
- Quyền lợi BHYT

**Nhận:**
- Kết quả khám
- Đơn thuốc sau khi đóng phiên

#### LLM Engine (External API)

**Cung cấp:** Triệu chứng thô

**Nhận:** Specialty ID

#### Payment Gateway (External API)

**Cung cấp:** Yêu cầu thanh toán

**Nhận:** Trạng thái giao dịch Webhook

#### Doctor / Ancillary Staff / Receptionist / Admin

Tương tác 2 chiều:
- Cập nhật trạng thái
- Ra chỉ định
- Nhận log/heatmap

> [Hình ảnh Context Diagram sẽ được chèn vào đây]

---

## 1.2 Business Rules

| ID | Quy tắc (Rule) |
|------|------|
| BR-001 | Phân loại Hàng đợi: Mức độ ưu tiên của bệnh nhân: Cấp cứu (Emergency) > Khẩn (Urgent) > Thường (Routine). |
| BR-002 | Ưu tiên Bệnh nhân quay lại: Bệnh nhân quay lại phòng khám sau khi hoàn thành kết quả CLS phải được tự động xếp lên đầu hàng đợi. |
| BR-003 | Khóa Thanh toán Toàn phần: Hệ thống gộp mọi chỉ định của Bác sĩ thành một hóa đơn duy nhất. Bệnh nhân bắt buộc thanh toán 100% để được đưa vào hàng đợi CLS. |
| BR-004 | Thay đổi Chỉ định: Mọi chỉnh sửa, hủy bỏ dịch vụ trong hóa đơn CLS chưa thanh toán phải do Bác sĩ ra chỉ định thực hiện. |
| BR-005 | Xác nhận Không thực hiện Dịch vụ: Phí khám bệnh chỉ được xác nhận hủy tại Phòng khám gốc. Phí CLS chỉ được xác nhận tại Khoa/Đơn vị thực hiện kỹ thuật. |
| BR-006 | Hồ sơ Hoàn tiền: Bắt buộc đối soát hoàn tiền bằng CCCD thẻ cứng hoặc VNeID gốc (từ chối ảnh chụp màn hình). |
| BR-007 | Định tuyến Hoàn tiền: Hoàn tiền mặt áp dụng trong ngày. Hoàn qua App áp dụng cho giao dịch số còn hạn hủy (tự động 7–45 ngày). |
| BR-008 | Check-in BHYT: Bệnh nhân khám BHYT bắt buộc phải cung cấp và được xác thực thông tin thẻ BHYT, giấy tờ định danh và giấy chuyển tuyến. |
| BR-009 | Tính toán Đồng chi trả: Hệ thống tự động bóc tách chi phí Quỹ BHYT chi trả và Phần bệnh nhân đồng chi trả. Chỉ sinh mã QR thanh toán cho phần đồng chi trả. |

---

# 2. User Requirements

## 2.1 System Actors

| Actor Name | Description |
|------------|------------|
| Patient | Bệnh nhân tương tác qua App Mobile hoặc Kiosk tự phục vụ. |
| Receptionist | Lễ tân hỗ trợ check-in, phân loại thủ công và xác thực BHYT cho bệnh nhân. |
| Cashier | Thu ngân xử lý thanh toán tiền mặt và đối soát hồ sơ hoàn tiền. |
| Doctor | Bác sĩ khám lâm sàng, xem hồ sơ, ra chỉ định và quản lý hàng đợi. |
| Ancillary Staff | Kỹ thuật viên (Lab/X-quang) và Dược sĩ thực hiện kỹ thuật, phát thuốc, trả kết quả. |
| System Admin | Quản trị viên giám sát heatmap, điều hướng hàng đợi thủ công và cấu hình AI. |
| Mock-HIS | Tác nhân hệ thống bên ngoài (External System) cung cấp và nhận đồng bộ dữ liệu hồ sơ y tế. |

---

## 2.2 Use Cases

### Nhóm Patient & Kiosk (App/Kiosk)

- UC-01: Tự động đăng ký khám (Auto Check-in) bằng CCCD/VNeID.
- UC-02: Cung cấp triệu chứng qua Body Map (Interactive Triage).
- UC-03: Lựa chọn gói Khám sức khỏe & Xét nghiệm theo yêu cầu.
- UC-04: Thanh toán viện phí và đơn thuốc trực tuyến (Online Payment).
- UC-05: Xem lộ trình di chuyển đa tầng (Multi-floor Wayfinding).

### Nhóm Receptionist & Cashier

- UC-06: Tạo hồ sơ và đăng ký khám thủ công (Manual Check-in).
- UC-07: Xác thực quyền lợi Bảo hiểm Y tế (Verify BHYT).
- UC-08: Thu viện phí kết hợp (Hybrid Payment) và in phiếu Master QR.
- UC-09: Đối soát hồ sơ và thực thi hoàn tiền (Execute Refund).
- UC-10: Khôi phục vé Master QR (Ticket Recovery).

### Nhóm Clinical & Ancillary

- UC-11: Quản lý hàng đợi phòng khám ưu tiên (Manage Priority Queue).
- UC-12: Xem tóm tắt hồ sơ lâm sàng (View Clinical Summary).
- UC-13: Ra chỉ định và cập nhật dịch vụ cận lâm sàng (Manage Clinical Orders).
- UC-14: Cập nhật trạng thái hoàn thành dịch vụ CLS (Complete Services).
- UC-15: Xác nhận không thực hiện dịch vụ (Cancel Service).
- UC-16: Cấp phát thuốc qua mã xác nhận QR (Dispense Medication).

### Nhóm Admin & System

- UC-17: Giám sát biểu đồ nhiệt thời gian thực (Monitor Heatmap).
- UC-18: Cấu hình trọng số phân loại và Ghi đè lộ trình thủ công (Manual Override).
- UC-19: Đồng bộ dữ liệu HIS khi kết thúc phiên khám (Sync to Mock-HIS).

> [Để trống - Các đặc tả Use Case Specification chi tiết sẽ được bổ sung sau]

---

# 3. Functional Requirements

## 3.1 System Functional Overview

Hệ thống TriageFlow được kiến trúc theo 5 phân hệ (Modules) chính hoạt động xoay quanh một lõi điều phối tập trung (Central Core Flow).

- Module Patient/Kiosk đóng vai trò là cửa ngõ thu thập dữ liệu đầu vào.
- Module Reception/Cashier xử lý các ngoại lệ.
- Module Clinical Hub và Ancillary Hub trực tiếp phục vụ bác sĩ/nhân viên y tế.
- Module Admin/Core đảm bảo tính toàn vẹn tài chính, điều hướng Wayfinding tự động và đồng bộ với Mock-HIS.

---

## 3.2 Patient & Kiosk Module

| ID | Requirement |
|------|------|
| FR-PK-001 | Trích xuất dữ liệu từ QR CCCD/VNeID để khởi tạo hoặc đồng bộ hồ sơ qua Mock-HIS trong < 2 giây. |
| FR-PK-002 | Bắt buộc nhập/quét thẻ BHYT và đính kèm giấy chuyển tuyến khi chọn diện khám BHYT. |
| FR-PK-003 | Cung cấp giao diện đồ họa để chọn vùng đau và nhập triệu chứng thô. |
| FR-PK-004 | Gửi triệu chứng cho LLM và nhận về mã chuyên khoa chuẩn hóa. |
| FR-PK-005 | Vẽ bản đồ điều hướng đa tầng dựa trên tọa độ (Map_Node) khi thanh toán thành công. |
| FR-PK-006 | Sinh Dynamic QR thanh toán viện phí và hỗ trợ thanh toán đơn thuốc online. |

---

## 3.3 Receptionist & Cashier Hub

| ID | Requirement |
|------|------|
| FR-RC-001 | Kiểm tra tuyến BHYT, gán tỷ lệ hưởng và khởi tạo phiên khám thay cho bệnh nhân. |
| FR-RC-002 | Cho phép xác nhận thu tiền mặt và kích hoạt in phiếu Master QR. |
| FR-RC-003 | Tra cứu CCCD để in lại Master QR. |
| FR-RC-004 | Bắt buộc xác thực CCCD/VNeID gốc trước khi hoàn tiền. |

---

## 3.4 Clinical Hub

| ID | Requirement |
|------|------|
| FR-DH-001 | Tự động ưu tiên bệnh nhân Returned lên đầu hàng đợi. |
| FR-DH-002 | Gộp nhiều chỉ định CLS thành một hóa đơn tổng. |
| FR-DH-003 | Cho phép xác nhận "Không thực hiện dịch vụ". |
| FR-DH-004 | Hiển thị Body Map và lịch sử Mock-HIS trên Dashboard duy nhất. |

---

## 3.5 Ancillary & Pharmacy Module

| ID | Requirement |
|------|------|
| FR-AS-001 | Chỉ hiển thị bệnh nhân có hóa đơn Paid. |
| FR-AS-002 | Cho phép xác nhận không thực hiện kỹ thuật. |
| FR-AS-003 | Quét QR để xác nhận cấp phát thuốc. |
| FR-AS-004 | Trả kết quả xét nghiệm trực tiếp lên App. |

---

## 3.6 Admin Control Center & Core Flow

| ID | Requirement |
|------|------|
| FR-AD-001 | Giám sát heatmap thời gian thực. |
| FR-AD-002 | Ghi đè điều hướng hàng loạt khi có sự cố. |
| FR-SY-001 | Tự động tính đồng chi trả BHYT. |
| FR-SY-002 | Ghi log bất biến cho mọi thao tác hủy/hoàn tiền. |
| FR-SY-003 | Đồng bộ dữ liệu về Mock-HIS khi hoàn tất quy trình. |

---

# 4. Non-Functional Requirements

## 4.1 External Interfaces

- **Mock-HIS API:** REST (JSON).
- **LLM API:** Phân tích văn bản triệu chứng y khoa.
- **Payment Gateway API:** Webhook nhận trạng thái giao dịch.

## 4.2 Quality Attributes

### NFR-001 – Performance

Độ trễ phản hồi từ LLM Engine không vượt quá **5 giây**.

### NFR-002 – Concurrency

Backend (NodeJS/NestJS) phải hỗ trợ tối thiểu **500 kết nối WebSocket đồng thời** mà hiệu năng không suy giảm quá **10%**.

### NFR-003 – Security

Bảng `Audit_Log` và `Movement_Log` phải ở chế độ **Append-only**, cấm hoàn toàn thao tác `UPDATE` và `DELETE`.

---

# 5. Other Requirements

## 5.1 Appendix 1 - Messages List

| # | Message Code | Message Type | Context | Content |
|---|---|---|---|---|
| 1 | ERR_BHYT_01 | In line (Red) | Chưa nhập mã BHYT | Thông tin Thẻ BHYT là bắt buộc. Vui lòng nhập hoặc quét mã QR trên thẻ. |
| 2 | ERR_PAY_01 | Toast message | Thanh toán một phần | Lỗi: Không thể thanh toán lẻ. Vui lòng thanh toán toàn bộ hóa đơn. |
| 3 | ERR_REF_01 | Toast message | Hoàn tiền chưa xác thực CCCD | Lỗi xác thực: Vui lòng kiểm tra và xác nhận CCCD/VNeID bản gốc của bệnh nhân. |
| 4 | ERR_QR_01 | Toast message | Quét CCCD lỗi | Mã QR không hợp lệ. Vui lòng thử lại hoặc đến quầy Lễ tân để được hỗ trợ. |
| 5 | MSG_PAY_02 | Toast message | Thanh toán thành công | Thanh toán thành công. Lộ trình di chuyển của bạn đã được cập nhật. |
| 6 | MSG_MED_01 | Push Notification | Thuốc sẵn sàng | Đơn thuốc của bạn đã chuẩn bị xong. Vui lòng đến Quầy thuốc số {Quay_Thuoc} để nhận. |
| 7 | MSG_LAB_01 | Push Notification | Có kết quả xét nghiệm | Đã có kết quả xét nghiệm {Ten_Xet_Nghiem}. Vui lòng kiểm tra trong lịch sử khám. |
| 8 | MSG_SYS_01 | Toast message | Đồng bộ HIS thành công | Phiên khám kết thúc. Dữ liệu đã được đồng bộ thành công về hệ thống HIS. |

---

## 5.2 Appendix 2

> [Để trống]  
> Chưa có thông tin định nghĩa.

## 5.3 Appendix 3

> [Để trống]  ~
> Chưa có thông tin định nghĩa.
USE [Quan_Ly_Benh_Vien]
GO

-- quản trị
INSERT [dbo].[QUYEN] ([idQuyen], [TenQuyen]) VALUES (N'Q0001     ', N'Quản trị hệ thống')
INSERT [dbo].[QUYEN] ([idQuyen], [TenQuyen]) VALUES (N'Q0002     ', N'Bác sĩ')
INSERT [dbo].[QUYEN] ([idQuyen], [TenQuyen]) VALUES (N'Q0003     ', N'Y tá / Điều dưỡng')
INSERT [dbo].[QUYEN] ([idQuyen], [TenQuyen]) VALUES (N'Q0004     ', N'Lễ tân / Tiếp nhận')
INSERT [dbo].[QUYEN] ([idQuyen], [TenQuyen]) VALUES (N'Q0005     ', N'Dược sĩ')
GO
INSERT [dbo].[NHOM_NGUOIDUNG] ([idNhom], [TenNhom], [idQuyen]) VALUES (N'N0001     ', N'Ban Giám đốc', N'Q0001     ')
INSERT [dbo].[NHOM_NGUOIDUNG] ([idNhom], [TenNhom], [idQuyen]) VALUES (N'N0002     ', N'Bác sĩ', N'Q0002     ')
INSERT [dbo].[NHOM_NGUOIDUNG] ([idNhom], [TenNhom], [idQuyen]) VALUES (N'N0003     ', N'Điều dưỡng', N'Q0003     ')
INSERT [dbo].[NHOM_NGUOIDUNG] ([idNhom], [TenNhom], [idQuyen]) VALUES (N'N0004     ', N'Lễ tân', N'Q0004     ')
INSERT [dbo].[NHOM_NGUOIDUNG] ([idNhom], [TenNhom], [idQuyen]) VALUES (N'N0005     ', N'Dược sĩ', N'Q0005     ')
GO
INSERT [dbo].[NGUOIDUNG] ([idNguoiDung], [HoTen], [SDT], [TenDN], [MatKhau], [ChucVu], [idNhom], [GioiTinh], [NgaySinh], [Email], [HeSoLuong]) VALUES (N'ND0001    ', N'Nguyễn Văn An', N'905112233', N'doctor', N'123456', N'Bác sĩ Trưởng khoa', N'N0002     ', 1, CAST(N'1980-05-10' AS Date), N'annv@hospital.com', CAST(5.50 AS Decimal(5, 2)))
INSERT [dbo].[NGUOIDUNG] ([idNguoiDung], [HoTen], [SDT], [TenDN], [MatKhau], [ChucVu], [idNhom], [GioiTinh], [NgaySinh], [Email], [HeSoLuong]) VALUES (N'ND0002    ', N'Trần Thị Bích', N'905334455', N'bichtb', N'password123', N'Y tá trưởng', N'N0003     ', 0, CAST(N'1992-08-15' AS Date), N'bichtb@hospital.com', CAST(3.75 AS Decimal(5, 2)))
INSERT [dbo].[NGUOIDUNG] ([idNguoiDung], [HoTen], [SDT], [TenDN], [MatKhau], [ChucVu], [idNhom], [GioiTinh], [NgaySinh], [Email], [HeSoLuong]) VALUES (N'ND0003    ', N'Lê Minh Tuấn', N'918123456', N'tuanlm', N'password123', N'Dược sĩ', N'N0005     ', 1, CAST(N'1988-03-22' AS Date), N'tuanlm@hospital.com', CAST(4.10 AS Decimal(5, 2)))
INSERT [dbo].[NGUOIDUNG] ([idNguoiDung], [HoTen], [SDT], [TenDN], [MatKhau], [ChucVu], [idNhom], [GioiTinh], [NgaySinh], [Email], [HeSoLuong]) VALUES (N'ND0004    ', N'Phạm Thị Yến', N'979876543', N'yenpt', N'password123', N'Nhân viên tiếp nhận', N'N0004     ', 0, CAST(N'1998-12-01' AS Date), N'yenpt@hospital.com', CAST(2.85 AS Decimal(5, 2)))
INSERT [dbo].[NGUOIDUNG] ([idNguoiDung], [HoTen], [SDT], [TenDN], [MatKhau], [ChucVu], [idNhom], [GioiTinh], [NgaySinh], [Email], [HeSoLuong]) VALUES (N'ND0005    ', N'Hoàng Văn Hùng', N'925555666', N'admin', N'admin@123', N'Quản trị viên', N'N0001     ', 1, CAST(N'1985-01-01' AS Date), N'admin@hospital.com', CAST(6.00 AS Decimal(5, 2)))
GO

-- khoa, phòng
INSERT [dbo].[LOAIKHOA] ([idLoaiKhoa], [TenLoaiKhoa], [MoTa]) VALUES (N'LK0001    ', N'Khoa lâm sàng', N'Nhóm các khoa chuyên môn trực tiếp khám, chẩn đoán và điều trị bệnh nhân.')
INSERT [dbo].[LOAIKHOA] ([idLoaiKhoa], [TenLoaiKhoa], [MoTa]) VALUES (N'LK0002    ', N'Khoa cận lâm sàng', N'Nhóm các khoa thực hiện các kỹ thuật xét nghiệm, chẩn đoán hình ảnh để hỗ trợ khoa lâm sàng.')
INSERT [dbo].[LOAIKHOA] ([idLoaiKhoa], [TenLoaiKhoa], [MoTa]) VALUES (N'LK0003    ', N'Khối chức năng', N'Bao gồm các phòng ban hỗ trợ công tác quản lý, hành chính và vận hành của bệnh viện.')
INSERT [dbo].[LOAIKHOA] ([idLoaiKhoa], [TenLoaiKhoa], [MoTa]) VALUES (N'LK0004    ', N'Khối Dược - Vật tư', N'Quản lý việc cung ứng thuốc, vật tư y tế cho toàn bệnh viện.')
INSERT [dbo].[LOAIKHOA] ([idLoaiKhoa], [TenLoaiKhoa], [MoTa]) VALUES (N'LK0005    ', N'Trung tâm chuyên sâu', N'Các trung tâm, đơn vị được thành lập để tập trung vào một lĩnh vực y tế chuyên biệt.')
GO
INSERT [dbo].[KHOA] ([idKhoa], [TenKhoa], [ViTri], [MucTieu], [NgayThanhLap], [NgayHD], [TrangThai], [TruongKhoa], [idLoaiKhoa]) VALUES (N'K0001     ', N'Khoa Nội tổng hợp', N'Tầng 3, Tòa nhà A', N'Chẩn đoán, điều trị các bệnh lý nội khoa phổ biến và phức tạp.', CAST(N'2010-05-20' AS Date), CAST(N'2010-06-01' AS Date), N'Đang hoạt động', N'GS.TS. Nguyễn Văn Hùng', N'LK0001    ')
INSERT [dbo].[KHOA] ([idKhoa], [TenKhoa], [ViTri], [MucTieu], [NgayThanhLap], [NgayHD], [TrangThai], [TruongKhoa], [idLoaiKhoa]) VALUES (N'K0002     ', N'Khoa Cấp Cứu', N'Tầng 1, Tòa nhà A (Cổng chính)', N'Tiếp nhận, sàng lọc và xử trí ban đầu các trường hợp cấp cứu 24/7.', CAST(N'2012-01-10' AS Date), CAST(N'2012-01-15' AS Date), N'Đang hoạt động', N'BS.CKII. Trần Thị Mai', N'LK0001    ')
INSERT [dbo].[KHOA] ([idKhoa], [TenKhoa], [ViTri], [MucTieu], [NgayThanhLap], [NgayHD], [TrangThai], [TruongKhoa], [idLoaiKhoa]) VALUES (N'K0003     ', N'Khoa Xét nghiệm', N'Tầng 2, Tòa nhà B', N'Thực hiện các xét nghiệm sinh hóa, huyết học, vi sinh để hỗ trợ chẩn đoán.', CAST(N'2011-09-15' AS Date), CAST(N'2011-10-01' AS Date), N'Đang hoạt động', N'TS. Lê Văn Bình', N'LK0002    ')
INSERT [dbo].[KHOA] ([idKhoa], [TenKhoa], [ViTri], [MucTieu], [NgayThanhLap], [NgayHD], [TrangThai], [TruongKhoa], [idLoaiKhoa]) VALUES (N'K0004     ', N'Khoa Chẩn đoán Hình ảnh', N'Tầng 2, Tòa nhà B', N'Cung cấp các dịch vụ X-Quang, Siêu âm, CT-scan, MRI.', CAST(N'2013-03-01' AS Date), CAST(N'2013-03-15' AS Date), N'Đang hoạt động', N'BS.CKII. Phạm Anh Tuấn', N'LK0002    ')
INSERT [dbo].[KHOA] ([idKhoa], [TenKhoa], [ViTri], [MucTieu], [NgayThanhLap], [NgayHD], [TrangThai], [TruongKhoa], [idLoaiKhoa]) VALUES (N'K0005     ', N'Khoa Y học cổ truyền (cũ)', N'Tòa nhà C (Đã giải thể)', N'Khám và điều trị bằng các phương pháp y học cổ truyền. Đã sáp nhập vào khoa Phục hồi chức năng.', CAST(N'2015-01-01' AS Date), CAST(N'2015-02-01' AS Date), N'Ngừng hoạt động', N'BS. Hoàng Thị Lan', N'LK0001    ')
GO

-- cận lâm sàng
INSERT [dbo].[CANLAMSANG] ([idCanLamSang], [TenCLS], [TenLoaiCLS], [ChiPhi], [DVT], [KhoangThamChieuNam], [KhoangThamChieuNu], [ThuTuHienThi], [idCanLamSangCha], [idKhoa]) VALUES (N'CLS0001   ', N'Xét nghiệm Huyết học', N'Huyết học', CAST(0.00 AS Decimal(18, 2)), NULL, NULL, NULL, 1, NULL, N'K0003     ')
INSERT [dbo].[CANLAMSANG] ([idCanLamSang], [TenCLS], [TenLoaiCLS], [ChiPhi], [DVT], [KhoangThamChieuNam], [KhoangThamChieuNu], [ThuTuHienThi], [idCanLamSangCha], [idKhoa]) VALUES (N'CLS0002   ', N'Tổng phân tích tế bào máu ngoại vi (Công thức máu)', N'Huyết học', CAST(55000.00 AS Decimal(18, 2)), N'Lần', N'Hồng cầu: 4.5-5.9 T/L', N'Hồng cầu: 4.0-5.2 T/L', 1, N'CLS0001   ', N'K0003     ')
INSERT [dbo].[CANLAMSANG] ([idCanLamSang], [TenCLS], [TenLoaiCLS], [ChiPhi], [DVT], [KhoangThamChieuNam], [KhoangThamChieuNu], [ThuTuHienThi], [idCanLamSangCha], [idKhoa]) VALUES (N'CLS0003   ', N'Định nhóm máu hệ ABO, Rh(D)', N'Huyết học', CAST(60000.00 AS Decimal(18, 2)), N'Lần', N'A, B, O, AB, Rh(+) hoặc Rh(-)', N'A, B, O, AB, Rh(+) hoặc Rh(-)', 2, N'CLS0001   ', N'K0003     ')
INSERT [dbo].[CANLAMSANG] ([idCanLamSang], [TenCLS], [TenLoaiCLS], [ChiPhi], [DVT], [KhoangThamChieuNam], [KhoangThamChieuNu], [ThuTuHienThi], [idCanLamSangCha], [idKhoa]) VALUES (N'CLS0004   ', N'Xét nghiệm Sinh hóa máu', N'Sinh hóa', CAST(0.00 AS Decimal(18, 2)), NULL, NULL, NULL, 2, NULL, N'K0003     ')
INSERT [dbo].[CANLAMSANG] ([idCanLamSang], [TenCLS], [TenLoaiCLS], [ChiPhi], [DVT], [KhoangThamChieuNam], [KhoangThamChieuNu], [ThuTuHienThi], [idCanLamSangCha], [idKhoa]) VALUES (N'CLS0005   ', N'Định lượng Glucose (Đường máu lúc đói)', N'Sinh hóa', CAST(30000.00 AS Decimal(18, 2)), N'Lần', N'3.9 - 6.4 mmol/L', N'3.9 - 6.4 mmol/L', 1, N'CLS0004   ', N'K0003     ')
INSERT [dbo].[CANLAMSANG] ([idCanLamSang], [TenCLS], [TenLoaiCLS], [ChiPhi], [DVT], [KhoangThamChieuNam], [KhoangThamChieuNu], [ThuTuHienThi], [idCanLamSangCha], [idKhoa]) VALUES (N'CLS0006   ', N'Định lượng Creatinin', N'Sinh hóa', CAST(30000.00 AS Decimal(18, 2)), N'Lần', N'62 - 120 umol/L', N'45 - 90 umol/L', 2, N'CLS0004   ', N'K0003     ')
INSERT [dbo].[CANLAMSANG] ([idCanLamSang], [TenCLS], [TenLoaiCLS], [ChiPhi], [DVT], [KhoangThamChieuNam], [KhoangThamChieuNu], [ThuTuHienThi], [idCanLamSangCha], [idKhoa]) VALUES (N'CLS0007   ', N'Chẩn đoán Hình ảnh', N'Chẩn đoán hình ảnh', CAST(0.00 AS Decimal(18, 2)), NULL, NULL, NULL, 3, NULL, N'K0004     ')
INSERT [dbo].[CANLAMSANG] ([idCanLamSang], [TenCLS], [TenLoaiCLS], [ChiPhi], [DVT], [KhoangThamChieuNam], [KhoangThamChieuNu], [ThuTuHienThi], [idCanLamSangCha], [idKhoa]) VALUES (N'CLS0008   ', N'Siêu âm ổ bụng tổng quát', N'Siêu âm', CAST(150000.00 AS Decimal(18, 2)), N'Lần', N'Hình ảnh bình thường', N'Hình ảnh bình thường', 1, N'CLS0007   ', N'K0004     ')
INSERT [dbo].[CANLAMSANG] ([idCanLamSang], [TenCLS], [TenLoaiCLS], [ChiPhi], [DVT], [KhoangThamChieuNam], [KhoangThamChieuNu], [ThuTuHienThi], [idCanLamSangCha], [idKhoa]) VALUES (N'CLS0009   ', N'Chụp X-quang tim phổi thẳng', N'X-Quang', CAST(120000.00 AS Decimal(18, 2)), N'Lần', N'Không thấy hình ảnh bất thường', N'Không thấy hình ảnh bất thường', 2, N'CLS0007   ', N'K0004     ')
INSERT [dbo].[CANLAMSANG] ([idCanLamSang], [TenCLS], [TenLoaiCLS], [ChiPhi], [DVT], [KhoangThamChieuNam], [KhoangThamChieuNu], [ThuTuHienThi], [idCanLamSangCha], [idKhoa]) VALUES (N'CLS0010   ', N'Điện tâm đồ (ECG)', N'Thăm dò chức năng', CAST(80000.00 AS Decimal(18, 2)), N'Lần', N'Nhịp xoang, tần số bình thường', N'Nhịp xoang, tần số bình thường', 4, NULL, N'K0001     ')
GO

-- dịch vụ khám
INSERT [dbo].[LOAIKHAM] ([idLoaiKham], [TenLoaiKham], [ChiPhi]) VALUES (N'LKH0001   ', N'Khám sức khỏe tổng quát (dịch vụ)', CAST(300000 AS Decimal(18, 0)))
INSERT [dbo].[LOAIKHAM] ([idLoaiKham], [TenLoaiKham], [ChiPhi]) VALUES (N'LKH0002   ', N'Khám chuyên khoa Tim mạch', CAST(250000 AS Decimal(18, 0)))
INSERT [dbo].[LOAIKHAM] ([idLoaiKham], [TenLoaiKham], [ChiPhi]) VALUES (N'LKH0003   ', N'Khám bệnh thông thường (có BHYT)', CAST(150000 AS Decimal(18, 0)))
INSERT [dbo].[LOAIKHAM] ([idLoaiKham], [TenLoaiKham], [ChiPhi]) VALUES (N'LKH0004   ', N'Tái khám theo hẹn', CAST(100000 AS Decimal(18, 0)))
INSERT [dbo].[LOAIKHAM] ([idLoaiKham], [TenLoaiKham], [ChiPhi]) VALUES (N'LKH0005   ', N'Khám sức khỏe cấp giấy phép lái xe', CAST(450000 AS Decimal(18, 0)))
GO
INSERT [dbo].[LOAI_DV] ([idLoaiDV], [TenLoaiDV], [MoTa], [idKhoa]) VALUES (N'LDV0001   ', N'Dịch vụ Khám bệnh', N'Bao gồm các dịch vụ khám lâm sàng, khám tổng quát và khám chuyên khoa do bác sĩ thực hiện.', N'K0001     ')
INSERT [dbo].[LOAI_DV] ([idLoaiDV], [TenLoaiDV], [MoTa], [idKhoa]) VALUES (N'LDV0002   ', N'Dịch vụ Xét nghiệm', N'Các loại xét nghiệm máu, nước tiểu, sinh hóa, vi sinh... để hỗ trợ chẩn đoán.', N'K0003     ')
INSERT [dbo].[LOAI_DV] ([idLoaiDV], [TenLoaiDV], [MoTa], [idKhoa]) VALUES (N'LDV0003   ', N'Dịch vụ Chẩn đoán Hình ảnh', N'Bao gồm siêu âm, X-quang, CT-scan, MRI.', N'K0004     ')
INSERT [dbo].[LOAI_DV] ([idLoaiDV], [TenLoaiDV], [MoTa], [idKhoa]) VALUES (N'LDV0004   ', N'Dịch vụ Tiêm chủng', N'Các dịch vụ tiêm vắc-xin phòng bệnh theo chương trình hoặc theo yêu cầu.', N'K0001     ')
INSERT [dbo].[LOAI_DV] ([idLoaiDV], [TenLoaiDV], [MoTa], [idKhoa]) VALUES (N'LDV0005   ', N'Dịch vụ Thủ thuật', N'Các thủ thuật nhỏ có thể thực hiện tại phòng khám như thay băng, cắt chỉ, tiểu phẫu nhỏ.', N'K0002     ')
GO

-- mức hưởng BHYT
INSERT [dbo].[LOAI_BHYT] ([idLoaiBHYT], [TenLoaiBHYT], [MucHuong], [GhiChu]) VALUES (N'BHYT0001  ', N'Đúng tuyến', CAST(0.80 AS Decimal(5, 2)), N'Hưởng 80% chi phí')
INSERT [dbo].[LOAI_BHYT] ([idLoaiBHYT], [TenLoaiBHYT], [MucHuong], [GhiChu]) VALUES (N'BHYT0002  ', N'Trái tuyến', CAST(0.40 AS Decimal(5, 2)), N'Hưởng 40% chi phí')
INSERT [dbo].[LOAI_BHYT] ([idLoaiBHYT], [TenLoaiBHYT], [MucHuong], [GhiChu]) VALUES (N'BHYT0003  ', N'Thông tuyến', CAST(1.00 AS Decimal(5, 2)), N'Hưởng 100% tại tuyến huyện')
INSERT [dbo].[LOAI_BHYT] ([idLoaiBHYT], [TenLoaiBHYT], [MucHuong], [GhiChu]) VALUES (N'BHYT0004  ', N'5 năm liên tục', CAST(1.00 AS Decimal(5, 2)), N'Hưởng 100% chi phí')
INSERT [dbo].[LOAI_BHYT] ([idLoaiBHYT], [TenLoaiBHYT], [MucHuong], [GhiChu]) VALUES (N'BHYT0005  ', N'Không BHYT', CAST(0.00 AS Decimal(5, 2)), N'Tự chi trả')
GO

-- NCC
INSERT [dbo].[NCC] ([idNCC], [TenNCC], [DiaChi], [SDT], [QuocGia]) VALUES (N'NCC0001   ', N'Công ty Cổ phần Dược Hậu Giang', N'288 Bis Nguyễn Văn Cừ, An Hòa, Ninh Kiều, Cần Thơ', N'02923891433    ', N'Việt Nam')
INSERT [dbo].[NCC] ([idNCC], [TenNCC], [DiaChi], [SDT], [QuocGia]) VALUES (N'NCC0002   ', N'Công ty TNHH MTV Vắc xin và Sinh phẩm số 1 (VABIOTECH)', N'Số 1 Yersin, Phường Phạm Đình Hổ, Quận Hai Bà Trưng, Hà Nội', N'02438212327    ', N'Việt Nam')
INSERT [dbo].[NCC] ([idNCC], [TenNCC], [DiaChi], [SDT], [QuocGia]) VALUES (N'NCC0003   ', N'Pfizer Inc.', N'235 E 42nd St, New York, NY 10017, USA', N'+1 212-733-2323', N'Hoa Kỳ')
INSERT [dbo].[NCC] ([idNCC], [TenNCC], [DiaChi], [SDT], [QuocGia]) VALUES (N'NCC0004   ', N'GlaxoSmithKline (GSK)', N'980 Great West Rd, Brentford, TW8 9GS, United Kingdom', N'+44 2080475000 ', N'Vương quốc Anh')
INSERT [dbo].[NCC] ([idNCC], [TenNCC], [DiaChi], [SDT], [QuocGia]) VALUES (N'NCC0005   ', N'Sanofi S.A.', N'46 Avenue de la Grande Armée, 75017 Paris, France', N'+33 153774000  ', N'Pháp')
GO

-- dược phẩm
INSERT [dbo].[LOAI_DUOCPHAM] ([idLoaiDuocPham], [TenLoaiDuocPham], [GhiChu]) VALUES (N'LDP0001   ', N'Thuốc kháng sinh', N'Nhóm thuốc dùng để điều trị các bệnh nhiễm khuẩn do vi khuẩn gây ra.')
INSERT [dbo].[LOAI_DUOCPHAM] ([idLoaiDuocPham], [TenLoaiDuocPham], [GhiChu]) VALUES (N'LDP0002   ', N'Thuốc giảm đau, hạ sốt', N'Các loại thuốc có tác dụng giảm đau, hạ sốt và chống viêm không steroid (NSAID).')
INSERT [dbo].[LOAI_DUOCPHAM] ([idLoaiDuocPham], [TenLoaiDuocPham], [GhiChu]) VALUES (N'LDP0003   ', N'Thuốc tim mạch', N'Nhóm thuốc điều trị các bệnh lý liên quan đến tim và mạch máu như tăng huyết áp, suy tim.')
INSERT [dbo].[LOAI_DUOCPHAM] ([idLoaiDuocPham], [TenLoaiDuocPham], [GhiChu]) VALUES (N'LDP0004   ', N'Thuốc tiêu hóa', N'Các loại thuốc dùng để điều trị các vấn đề về dạ dày, đường ruột.')
INSERT [dbo].[LOAI_DUOCPHAM] ([idLoaiDuocPham], [TenLoaiDuocPham], [GhiChu]) VALUES (N'LDP0005   ', N'Vitamin và khoáng chất', N'Các loại thực phẩm chức năng, vitamin tổng hợp và khoáng chất bổ sung cho cơ thể.')
GO
INSERT [dbo].[DUOCPHAM] ([idDuocPham], [TenDuocPham], [DVT], [HanSuDung], [NhaSX], [SoLuong], [DonGiaMua], [DonGiaBan], [MoTa], [DonVi], [HoatChat], [idLoaiDuocPham], [idNCC]) VALUES (N'DP0001    ', N'Paracetamol 500mg', N'Vỉ', CAST(N'2026-10-31' AS Date), N'Dược Hậu Giang', 500, CAST(8000 AS Decimal(18, 0)), CAST(10000 AS Decimal(18, 0)), N'Thuốc giảm đau, hạ sốt dùng trong các trường hợp cảm cúm, đau đầu.', N'Viên', N'Paracetamol 500mg', N'LDP0002   ', N'NCC0001   ')
INSERT [dbo].[DUOCPHAM] ([idDuocPham], [TenDuocPham], [DVT], [HanSuDung], [NhaSX], [SoLuong], [DonGiaMua], [DonGiaBan], [MoTa], [DonVi], [HoatChat], [idLoaiDuocPham], [idNCC]) VALUES (N'DP0002    ', N'Amoxicillin 500mg', N'Hộp', CAST(N'2025-08-31' AS Date), N'Sanofi', 200, CAST(25000 AS Decimal(18, 0)), CAST(32000 AS Decimal(18, 0)), N'Kháng sinh nhóm Penicillin, điều trị nhiễm khuẩn.', N'Viên', N'Amoxicillin trihydrate 500mg', N'LDP0001   ', N'NCC0005   ')
INSERT [dbo].[DUOCPHAM] ([idDuocPham], [TenDuocPham], [DVT], [HanSuDung], [NhaSX], [SoLuong], [DonGiaMua], [DonGiaBan], [MoTa], [DonVi], [HoatChat], [idLoaiDuocPham], [idNCC]) VALUES (N'DP0003    ', N'Gaviscon Dual Action', N'Gói', CAST(N'2025-11-30' AS Date), N'Reckitt Benckiser', 300, CAST(9000 AS Decimal(18, 0)), CAST(12000 AS Decimal(18, 0)), N'Hỗn dịch uống giúp giảm trào ngược dạ dày, ợ nóng.', N'Gói 10ml', N'Natri alginat, Natri bicarbonat, Calci carbonat', N'LDP0004   ', N'NCC0004   ')
INSERT [dbo].[DUOCPHAM] ([idDuocPham], [TenDuocPham], [DVT], [HanSuDung], [NhaSX], [SoLuong], [DonGiaMua], [DonGiaBan], [MoTa], [DonVi], [HoatChat], [idLoaiDuocPham], [idNCC]) VALUES (N'DP0004    ', N'Amlodipine 5mg', N'Hộp', CAST(N'2026-05-31' AS Date), N'Pfizer', 150, CAST(45000 AS Decimal(18, 0)), CAST(60000 AS Decimal(18, 0)), N'Thuốc chẹn kênh canxi, dùng để điều trị tăng huyết áp và đau thắt ngực.', N'Viên', N'Amlodipine besylate 5mg', N'LDP0003   ', N'NCC0003   ')
INSERT [dbo].[DUOCPHAM] ([idDuocPham], [TenDuocPham], [DVT], [HanSuDung], [NhaSX], [SoLuong], [DonGiaMua], [DonGiaBan], [MoTa], [DonVi], [HoatChat], [idLoaiDuocPham], [idNCC]) VALUES (N'DP0005    ', N'Berocca Performance', N'Tuýp', CAST(N'2025-12-31' AS Date), N'Bayer', 100, CAST(95000 AS Decimal(18, 0)), CAST(125000 AS Decimal(18, 0)), N'Viên sủi bổ sung vitamin nhóm B, C, và khoáng chất, giúp tăng cường năng lượng.', N'Viên sủi', N'Vitamin B-complex, Vitamin C, Canxi, Magie, Kẽm', N'LDP0005   ', N'NCC0005   ')
GO

-- tên bệnh
INSERT [dbo].[ICD] ([idICD], [TenBenh], [GhiChu]) VALUES (N'A09       ', N'Tiêu chảy và viêm dạ dày-ruột do nhiễm trùng', NULL)
INSERT [dbo].[ICD] ([idICD], [TenBenh], [GhiChu]) VALUES (N'E11       ', N'Đái tháo đường týp 2', N'Bệnh nội tiết')
INSERT [dbo].[ICD] ([idICD], [TenBenh], [GhiChu]) VALUES (N'I10       ', N'Tăng huyết áp vô căn (nguyên phát)', N'Bệnh tim mạch')
INSERT [dbo].[ICD] ([idICD], [TenBenh], [GhiChu]) VALUES (N'J02.9     ', N'Viêm họng cấp, không xác định', N'Bệnh đường hô hấp trên')
INSERT [dbo].[ICD] ([idICD], [TenBenh], [GhiChu]) VALUES (N'J18.9     ', N'Viêm phổi, không xác định', N'Nhiễm trùng đường hô hấp dưới')
INSERT [dbo].[ICD] ([idICD], [TenBenh], [GhiChu]) VALUES (N'K29.7     ', N'Viêm dạ dày, không xác định', N'Bệnh đường tiêu hóa')
INSERT [dbo].[ICD] ([idICD], [TenBenh], [GhiChu]) VALUES (N'M54.5     ', N'Đau thắt lưng', N'Bệnh cơ xương khớp')
INSERT [dbo].[ICD] ([idICD], [TenBenh], [GhiChu]) VALUES (N'R51       ', N'Đau đầu', N'Triệu chứng thần kinh')
INSERT [dbo].[ICD] ([idICD], [TenBenh], [GhiChu]) VALUES (N'Z00.0     ', N'Khám sức khỏe tổng quát', N'Không phải bệnh lý')
INSERT [dbo].[ICD] ([idICD], [TenBenh], [GhiChu]) VALUES (N'Z09.0     ', N'Tái khám sau điều trị khối u ác tính', N'Chăm sóc theo dõi')
GO

-- bệnh nhân
INSERT [dbo].[BENHNHAN] ([idBenhNhan], [HoTen], [NgaySinh], [GioiTinh], [NgheNghiep], [DanToc], [SDT], [DiaChi], [CCCD], [BHYT], [ThoiHanBHYT], [DoiTuongUuTien], [HoTenThanNhan], [MoiQuanHe], [SDTThanNhan], [BenhManTinh], [DiUng], [PhauThuatDaLam], [TrangThai], [idLoaiBHYT]) VALUES (N'BN0001    ', N'Nguyễn Văn An', CAST(N'1985-03-15' AS Date), N'Nam', N'Nhân viên văn phòng', N'Kinh', N'0901234567', N'123 Đường Lê Lợi, Quận 1, TP.HCM', N'079085123456', N'DN4797912345678', CAST(N'2025-12-31' AS Date), NULL, N'Trần Thị Bình', N'Vợ', N'0987654321', N'Viêm xoang mãn tính', N'Không', N'Không', N'Đang điều trị', N'BHYT0001  ')
INSERT [dbo].[BENHNHAN] ([idBenhNhan], [HoTen], [NgaySinh], [GioiTinh], [NgheNghiep], [DanToc], [SDT], [DiaChi], [CCCD], [BHYT], [ThoiHanBHYT], [DoiTuongUuTien], [HoTenThanNhan], [MoiQuanHe], [SDTThanNhan], [BenhManTinh], [DiUng], [PhauThuatDaLam], [TrangThai], [idLoaiBHYT]) VALUES (N'BN0002    ', N'Trần Thị Cẩm', CAST(N'1992-07-22' AS Date), N'Nữ', N'Giáo viên', N'Kinh', N'0912345678', N'456 Đường Nguyễn Huệ, Quận 3, TP.HCM', N'079092234567', N'HN4797923456789', CAST(N'2024-12-31' AS Date), NULL, N'Trần Văn Dũng', N'Chồng', N'0912345679', N'Không', N'Dị ứng hải sản', N'Mổ ruột thừa năm 2015', N'Ổn định', N'BHYT0001  ')
INSERT [dbo].[BENHNHAN] ([idBenhNhan], [HoTen], [NgaySinh], [GioiTinh], [NgheNghiep], [DanToc], [SDT], [DiaChi], [CCCD], [BHYT], [ThoiHanBHYT], [DoiTuongUuTien], [HoTenThanNhan], [MoiQuanHe], [SDTThanNhan], [BenhManTinh], [DiUng], [PhauThuatDaLam], [TrangThai], [idLoaiBHYT]) VALUES (N'BN0003    ', N'Lê Hoàng Dũng', CAST(N'1970-01-30' AS Date), N'Nam', N'Kỹ sư xây dựng', N'Kinh', N'0934567890', N'789 Đường Pasteur, Quận 1, TP.HCM', N'079070345678', N'GD4797934567890', CAST(N'2025-06-30' AS Date), N'Người có công với cách mạng', N'Lê Thị Mai', N'Con gái', N'0934567891', N'Tăng huyết áp, tiểu đường type 2', N'Penicillin', N'Không', N'Đang điều trị', N'BHYT0002  ')
INSERT [dbo].[BENHNHAN] ([idBenhNhan], [HoTen], [NgaySinh], [GioiTinh], [NgheNghiep], [DanToc], [SDT], [DiaChi], [CCCD], [BHYT], [ThoiHanBHYT], [DoiTuongUuTien], [HoTenThanNhan], [MoiQuanHe], [SDTThanNhan], [BenhManTinh], [DiUng], [PhauThuatDaLam], [TrangThai], [idLoaiBHYT]) VALUES (N'BN0004    ', N'Phạm Thị Mai', CAST(N'2001-11-10' AS Date), N'Nữ', N'Sinh viên', N'Kinh', N'0945678901', N'KTX Khu B, Đại học Quốc gia, Thủ Đức', N'079101456789', N'SV4797945678901', CAST(N'2025-09-30' AS Date), NULL, N'Phạm Văn Nam', N'Bố', N'0945678902', N'Hen suyễn', N'Không', N'Không', N'Ổn định', N'BHYT0003  ')
INSERT [dbo].[BENHNHAN] ([idBenhNhan], [HoTen], [NgaySinh], [GioiTinh], [NgheNghiep], [DanToc], [SDT], [DiaChi], [CCCD], [BHYT], [ThoiHanBHYT], [DoiTuongUuTien], [HoTenThanNhan], [MoiQuanHe], [SDTThanNhan], [BenhManTinh], [DiUng], [PhauThuatDaLam], [TrangThai], [idLoaiBHYT]) VALUES (N'BN0005    ', N'Hoàng Văn Nam', CAST(N'1965-06-05' AS Date), N'Nam', N'Nghỉ hưu', N'Kinh', N'0967890123', N'55 Đường Võ Thị Sáu, Quận 3, TP.HCM', N'079065567890', N'HT3797956789012', CAST(N'2026-12-31' AS Date), N'Hưu trí', N'Hoàng Thị Lan', N'Vợ', N'0967890124', N'Bệnh mạch vành', N'Không', N'Đặt stent động mạch vành 2018', N'Tái khám định kỳ', N'BHYT0004  ')
GO

-- nhân viên
INSERT [dbo].[NHANVIEN] ([idNhanVien], [HoTen], [GioiTinh], [NgaySinh], [TrinhDo], [SDT], [Email], [HeSoLuong], [ChucVu], [idKhoa]) VALUES (N'NV0001    ', N'Nguyễn Văn Hùng', N'Nam', CAST(N'1975-08-20' AS Date), N'Giáo sư, Tiến sĩ Y khoa', N'0905111222', N'nv.hung@benhvien.com', 6.2, N'Trưởng khoa', N'K0001     ')
INSERT [dbo].[NHANVIEN] ([idNhanVien], [HoTen], [GioiTinh], [NgaySinh], [TrinhDo], [SDT], [Email], [HeSoLuong], [ChucVu], [idKhoa]) VALUES (N'NV0002    ', N'Lê Thị Thu Thảo', N'Nữ', CAST(N'1988-11-15' AS Date), N'Bác sĩ Chuyên khoa I', N'9102333444', N'lt.thao@benhvien.com', 4.98, N'Bác sĩ điều trị', N'K0001     ')
INSERT [dbo].[NHANVIEN] ([idNhanVien], [HoTen], [GioiTinh], [NgaySinh], [TrinhDo], [SDT], [Email], [HeSoLuong], [ChucVu], [idKhoa]) VALUES (N'NV0003    ', N'Trần Văn An', N'Nam', CAST(N'1985-02-10' AS Date), N'Cử nhân Điều dưỡng', N'0987654321', N'tv.an@benhvien.com', 4, N'Điều dưỡng trưởng', N'K0002     ')
INSERT [dbo].[NHANVIEN] ([idNhanVien], [HoTen], [GioiTinh], [NgaySinh], [TrinhDo], [SDT], [Email], [HeSoLuong], [ChucVu], [idKhoa]) VALUES (N'NV0004    ', N'Phạm Thị Lan', N'Nữ', CAST(N'1995-07-30' AS Date), N'Cử nhân Xét nghiệm Y học', N'0934555666', N'pt.lan@benhvien.com', 2.34, N'Kỹ thuật viên', N'K0003     ')
INSERT [dbo].[NHANVIEN] ([idNhanVien], [HoTen], [GioiTinh], [NgaySinh], [TrinhDo], [SDT], [Email], [HeSoLuong], [ChucVu], [idKhoa]) VALUES (N'NV0005    ', N'Hoàng Minh Nhật', N'Nam', CAST(N'1990-04-05' AS Date), N'Thạc sĩ, Bác sĩ Nội trú', N'0909888777', N'hm.nhat@benhvien.com', 5.5, N'Bác sĩ', N'K0002     ')
GO

-- vắc xin
INSERT [dbo].[LOAI_VACXIN] ([idLoaiVX], [TenLoai], [MoTa]) VALUES (N'LVX0001   ', N'Vắc-xin Tiêm chủng mở rộng', N'Nhóm các vắc-xin cơ bản thuộc Chương trình Tiêm chủng Mở rộng Quốc gia.')
INSERT [dbo].[LOAI_VACXIN] ([idLoaiVX], [TenLoai], [MoTa]) VALUES (N'LVX0002   ', N'Vắc-xin Dịch vụ', N'Nhóm các vắc-xin theo yêu cầu, không nằm trong chương trình tiêm chủng mở rộng.')
INSERT [dbo].[LOAI_VACXIN] ([idLoaiVX], [TenLoai], [MoTa]) VALUES (N'LVX0003   ', N'Vắc-xin Cúm mùa', N'Các loại vắc-xin phòng bệnh cúm, thường được cập nhật hàng năm.')
INSERT [dbo].[LOAI_VACXIN] ([idLoaiVX], [TenLoai], [MoTa]) VALUES (N'LVX0004   ', N'Vắc-xin Du lịch', N'Nhóm các vắc-xin phòng các bệnh đặc thù theo vùng địa lý như Sốt vàng da, Viêm não Nhật Bản.')
INSERT [dbo].[LOAI_VACXIN] ([idLoaiVX], [TenLoai], [MoTa]) VALUES (N'LVX0005   ', N'Vắc-xin kết hợp', N'Các loại vắc-xin đa giá, phòng được nhiều bệnh trong cùng một mũi tiêm (ví dụ: 5 trong 1, 6 trong 1).')
GO
INSERT [dbo].[VACXIN] ([idVacXin], [TenVacXin], [NgayNhap], [SoLuong], [HSD], [LieuTiem], [DonGiaMua], [DonGiaBan], [GhiChu], [idNCC], [idLoaiVX]) VALUES (N'VX0001    ', N'Vắc-xin 5 trong 1 Pentaxim', CAST(N'2023-10-01' AS Date), 150, CAST(N'2025-09-30' AS Date), N'Tiêm bắp, 1 liều 0.5ml', CAST(550000 AS Decimal(18, 0)), CAST(720000 AS Decimal(18, 0)), N'Bảo quản ở 2-8°C', N'NCC0005   ', N'LVX0005   ')
INSERT [dbo].[VACXIN] ([idVacXin], [TenVacXin], [NgayNhap], [SoLuong], [HSD], [LieuTiem], [DonGiaMua], [DonGiaBan], [GhiChu], [idNCC], [idLoaiVX]) VALUES (N'VX0002    ', N'Vắc-xin 6 trong 1 Infanrix Hexa', CAST(N'2023-09-15' AS Date), 200, CAST(N'2025-08-31' AS Date), N'Tiêm bắp, 1 liều 0.5ml', CAST(800000 AS Decimal(18, 0)), CAST(1050000 AS Decimal(18, 0)), N'Không đông băng', N'NCC0004   ', N'LVX0005   ')
INSERT [dbo].[VACXIN] ([idVacXin], [TenVacXin], [NgayNhap], [SoLuong], [HSD], [LieuTiem], [DonGiaMua], [DonGiaBan], [GhiChu], [idNCC], [idLoaiVX]) VALUES (N'VX0003    ', N'Vắc-xin Viêm gan B (TCMR)', CAST(N'2024-01-05' AS Date), 1000, CAST(N'2026-01-04' AS Date), N'Tiêm bắp, liều sơ sinh 0.5ml', CAST(15000 AS Decimal(18, 0)), CAST(25000 AS Decimal(18, 0)), N'Tiêm trong 24 giờ đầu sau sinh', N'NCC0002   ', N'LVX0001   ')
INSERT [dbo].[VACXIN] ([idVacXin], [TenVacXin], [NgayNhap], [SoLuong], [HSD], [LieuTiem], [DonGiaMua], [DonGiaBan], [GhiChu], [idNCC], [idLoaiVX]) VALUES (N'VX0004    ', N'Vắc-xin cúm mùa Vaxigrip Tetra', CAST(N'2023-11-20' AS Date), 500, CAST(N'2024-10-31' AS Date), N'Tiêm bắp hoặc tiêm dưới da sâu, 0.5ml', CAST(250000 AS Decimal(18, 0)), CAST(380000 AS Decimal(18, 0)), N'Tiêm nhắc lại hàng năm', N'NCC0005   ', N'LVX0003   ')
INSERT [dbo].[VACXIN] ([idVacXin], [TenVacXin], [NgayNhap], [SoLuong], [HSD], [LieuTiem], [DonGiaMua], [DonGiaBan], [GhiChu], [idNCC], [idLoaiVX]) VALUES (N'VX0005    ', N'Vắc-xin phòng dại Verorab', CAST(N'2023-08-01' AS Date), 80, CAST(N'2025-07-31' AS Date), N'Phác đồ tiêm bắp 5 mũi', CAST(300000 AS Decimal(18, 0)), CAST(450000 AS Decimal(18, 0)), N'Dùng cho cả dự phòng và sau phơi nhiễm', N'NCC0005   ', N'LVX0002   ')
GO
INSERT [dbo].[GOI_VACXIN] ([idGoiVX], [TenGoi]) VALUES (N'GVX0001   ', N'Gói vắc-xin cho trẻ từ 0-6 tháng tuổi')
INSERT [dbo].[GOI_VACXIN] ([idGoiVX], [TenGoi]) VALUES (N'GVX0002   ', N'Gói vắc-xin cho trẻ từ 6-12 tháng tuổi')
INSERT [dbo].[GOI_VACXIN] ([idGoiVX], [TenGoi]) VALUES (N'GVX0003   ', N'Gói vắc-xin cho phụ nữ chuẩn bị mang thai')
INSERT [dbo].[GOI_VACXIN] ([idGoiVX], [TenGoi]) VALUES (N'GVX0004   ', N'Gói vắc-xin cho trẻ vị thành niên và thanh niên')
INSERT [dbo].[GOI_VACXIN] ([idGoiVX], [TenGoi]) VALUES (N'GVX0005   ', N'Gói vắc-xin phòng bệnh cho người trưởng thành')
GO
INSERT [dbo].[CT_GOI_VACXIN] ([idGoiVX], [idVacXin]) VALUES (N'GVX0001   ', N'VX0002    ')
INSERT [dbo].[CT_GOI_VACXIN] ([idGoiVX], [idVacXin]) VALUES (N'GVX0001   ', N'VX0003    ')
INSERT [dbo].[CT_GOI_VACXIN] ([idGoiVX], [idVacXin]) VALUES (N'GVX0002   ', N'VX0002    ')
INSERT [dbo].[CT_GOI_VACXIN] ([idGoiVX], [idVacXin]) VALUES (N'GVX0002   ', N'VX0004    ')
INSERT [dbo].[CT_GOI_VACXIN] ([idGoiVX], [idVacXin]) VALUES (N'GVX0003   ', N'VX0001    ')
INSERT [dbo].[CT_GOI_VACXIN] ([idGoiVX], [idVacXin]) VALUES (N'GVX0003   ', N'VX0004    ')
INSERT [dbo].[CT_GOI_VACXIN] ([idGoiVX], [idVacXin]) VALUES (N'GVX0003   ', N'VX0005    ')
GO

-- giường
INSERT [dbo].[GIUONG] ([idGiuong], [TrangThai], [Kho], [GhiChu], [idKhoa], [idBenhNhan]) VALUES (N'G0001     ', N'Đang sử dụng', 0, N'Bệnh nhân Nguyễn Văn An', N'K0001     ', N'BN0001    ')
INSERT [dbo].[GIUONG] ([idGiuong], [TrangThai], [Kho], [GhiChu], [idKhoa], [idBenhNhan]) VALUES (N'G0002     ', N'Trống', 0, N'Sẵn sàng tiếp nhận bệnh nhân', N'K0001     ', NULL)
INSERT [dbo].[GIUONG] ([idGiuong], [TrangThai], [Kho], [GhiChu], [idKhoa], [idBenhNhan]) VALUES (N'G0003     ', N'Đang dọn dẹp', 0, N'Chờ khử khuẩn và thay ga mới', N'K0001     ', NULL)
INSERT [dbo].[GIUONG] ([idGiuong], [TrangThai], [Kho], [GhiChu], [idKhoa], [idBenhNhan]) VALUES (N'G0004     ', N'Đang sử dụng', 0, N'Bệnh nhân Lê Hoàng Dũng', N'K0002     ', N'BN0003    ')
INSERT [dbo].[GIUONG] ([idGiuong], [TrangThai], [Kho], [GhiChu], [idKhoa], [idBenhNhan]) VALUES (N'G0005     ', N'Bảo trì', 1, N'Đang sửa chữa hệ thống nâng hạ', N'K0002     ', NULL)
GO

-- thiết bị, vật tư
INSERT [dbo].[VATTU] ([idVatTu], [SoLuong], [TenVatTu], [DVT], [DonGiaMua], [TrangThai], [GhiChu], [NgayNhap], [idKhoa]) VALUES (N'VT0001    ', 100, N'Băng gạc y tế', N'Cuộn', CAST(15000 AS Decimal(18, 0)), N'Còn hàng', N'Băng gạc vô trùng 5cm x 5m', CAST(N'2025-06-15' AS Date), N'K0001     ')
INSERT [dbo].[VATTU] ([idVatTu], [SoLuong], [TenVatTu], [DVT], [DonGiaMua], [TrangThai], [GhiChu], [NgayNhap], [idKhoa]) VALUES (N'VT0002    ', 50, N'Kim tiêm 5ml', N'Cái', CAST(2500 AS Decimal(18, 0)), N'Còn hàng', N'Kim tiêm một lần dùng', CAST(N'2025-06-20' AS Date), N'K0002     ')
INSERT [dbo].[VATTU] ([idVatTu], [SoLuong], [TenVatTu], [DVT], [DonGiaMua], [TrangThai], [GhiChu], [NgayNhap], [idKhoa]) VALUES (N'VT0003    ', 200, N'Khẩu trang y tế', N'Cái', CAST(3000 AS Decimal(18, 0)), N'Còn hàng', N'Khẩu trang 3 lớp kháng khuẩn', CAST(N'2025-06-18' AS Date), N'K0001     ')
INSERT [dbo].[VATTU] ([idVatTu], [SoLuong], [TenVatTu], [DVT], [DonGiaMua], [TrangThai], [GhiChu], [NgayNhap], [idKhoa]) VALUES (N'VT0004    ', 25, N'Ống nghiệm', N'Bộ', CAST(45000 AS Decimal(18, 0)), N'Hết hàng', N'Ống nghiệm thủy tinh 10ml', CAST(N'2025-06-10' AS Date), N'K0003     ')
INSERT [dbo].[VATTU] ([idVatTu], [SoLuong], [TenVatTu], [DVT], [DonGiaMua], [TrangThai], [GhiChu], [NgayNhap], [idKhoa]) VALUES (N'VT0005    ', 80, N'Găng tay y tế', N'Đôi', CAST(8000 AS Decimal(18, 0)), N'Còn hàng', N'Găng tay cao su không bột', CAST(N'2025-06-22' AS Date), N'K0002     ')
GO
INSERT [dbo].[THIETBI] ([idThietBi], [TenTB], [LoaiTB], [DVT], [DonGiaMua]) VALUES (N'TB0001    ', N'Máy siêu âm Doppler màu 4D', N'Thiết bị chẩn đoán hình ảnh', N'Cái', CAST(1500000000.00 AS Decimal(18, 2)))
INSERT [dbo].[THIETBI] ([idThietBi], [TenTB], [LoaiTB], [DVT], [DonGiaMua]) VALUES (N'TB0002    ', N'Máy xét nghiệm huyết học tự động', N'Thiết bị xét nghiệm', N'Cái', CAST(850000000.00 AS Decimal(18, 2)))
INSERT [dbo].[THIETBI] ([idThietBi], [TenTB], [LoaiTB], [DVT], [DonGiaMua]) VALUES (N'TB0003    ', N'Máy tính để bàn Dell Vostro', N'Thiết bị văn phòng', N'Bộ', CAST(15500000.50 AS Decimal(18, 2)))
INSERT [dbo].[THIETBI] ([idThietBi], [TenTB], [LoaiTB], [DVT], [DonGiaMua]) VALUES (N'TB0004    ', N'Máy đo huyết áp điện tử Omron', N'Thiết bị y tế thông thường', N'Cái', CAST(1200000.00 AS Decimal(18, 2)))
INSERT [dbo].[THIETBI] ([idThietBi], [TenTB], [LoaiTB], [DVT], [DonGiaMua]) VALUES (N'TB0005    ', N'Giường bệnh đa năng', N'Nội thất y tế', N'Cái', CAST(25000000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[CAPPHAT_THIETBI] ([idCapPhat], [NgayCapPhat], [NguoiNhan], [NguoiLap], [SoLuong], [TinhTrang], [NguonCung], [GhiChu], [idThietBi], [idKhoa]) VALUES (N'CP0001    ', CAST(N'2023-10-26' AS Date), N'Nguyễn Văn An', N'Trần Thị Bích', 1, N'Mới 100%', N'Công ty ABC', N'Cấp phát cho nhân viên mới', N'TB0001    ', N'K0002     ')
INSERT [dbo].[CAPPHAT_THIETBI] ([idCapPhat], [NgayCapPhat], [NguoiNhan], [NguoiLap], [SoLuong], [TinhTrang], [NguonCung], [GhiChu], [idThietBi], [idKhoa]) VALUES (N'CP0002    ', CAST(N'2023-10-27' AS Date), N'Lê Thị Cẩm', N'Trần Thị Bích', 5, N'Mới 100%', N'Mua từ Phong Vũ', NULL, N'TB0002    ', N'K0004     ')
INSERT [dbo].[CAPPHAT_THIETBI] ([idCapPhat], [NgayCapPhat], [NguoiNhan], [NguoiLap], [SoLuong], [TinhTrang], [NguonCung], [GhiChu], [idThietBi], [idKhoa]) VALUES (N'CP0003    ', CAST(N'2023-11-01' AS Date), N'Phạm Văn Dũng', N'Hoàng Văn Hải', 1, N'Đã qua sử dụng', N'Điều chuyển từ kho', N'Màn hình cũ', N'TB0003    ', N'K0001     ')
INSERT [dbo].[CAPPHAT_THIETBI] ([idCapPhat], [NgayCapPhat], [NguoiNhan], [NguoiLap], [SoLuong], [TinhTrang], [NguonCung], [GhiChu], [idThietBi], [idKhoa]) VALUES (N'CP0004    ', CAST(N'2023-11-05' AS Date), N'Vũ Thị Lan', N'Hoàng Văn Hải', 10, N'Tốt', N'Kho tổng', N'Bàn phím cho phòng máy', N'TB0004    ', N'K0004     ')
INSERT [dbo].[CAPPHAT_THIETBI] ([idCapPhat], [NgayCapPhat], [NguoiNhan], [NguoiLap], [SoLuong], [TinhTrang], [NguonCung], [GhiChu], [idThietBi], [idKhoa]) VALUES (N'CP0005    ', CAST(N'2023-11-10' AS Date), N'Đặng Thái Sơn', N'Trần Thị Bích', 2, N'Mới 100%', N'Nhà cung cấp XYZ', N'RAM nâng cấp máy', N'TB0005    ', N'K0003     ')
GO

-- quyết định, đề xuất
INSERT [dbo].[DEXUAT] ([idDX], [NgayDeXuat], [TenKhoa], [File], [GhiChu], [TrangThai], [idKhoa], [idNguoiDung]) VALUES (N'DX0001    ', CAST(N'2023-10-20T09:30:00.000' AS DateTime), N'Khoa Công nghệ thông tin', N'dexuat_muamaychu.pdf', N'Đề xuất mua máy chủ mới cho dự án', N'Chờ duyệt', N'K0002     ', N'NV0001    ')
INSERT [dbo].[DEXUAT] ([idDX], [NgayDeXuat], [TenKhoa], [File], [GhiChu], [TrangThai], [idKhoa], [idNguoiDung]) VALUES (N'DX0002    ', CAST(N'2023-10-22T14:00:00.000' AS DateTime), N'Khoa Kế toán', N'dexuat_phanmemMISA.docx', N'Nâng cấp phần mềm kế toán', N'Đã duyệt', N'K0001     ', N'NV0002    ')
INSERT [dbo].[DEXUAT] ([idDX], [NgayDeXuat], [TenKhoa], [File], [GhiChu], [TrangThai], [idKhoa], [idNguoiDung]) VALUES (N'DX0003    ', CAST(N'2023-11-01T11:15:00.000' AS DateTime), N'Phòng Hành chính', NULL, N'Mua sắm văn phòng phẩm quý 4', N'Chờ duyệt', N'K0004     ', N'NV0003    ')
INSERT [dbo].[DEXUAT] ([idDX], [NgayDeXuat], [TenKhoa], [File], [GhiChu], [TrangThai], [idKhoa], [idNguoiDung]) VALUES (N'DX0004    ', CAST(N'2023-11-05T08:00:00.000' AS DateTime), N'Khoa Cơ khí', N'dexuat_baotri_maymoc.xls', N'Bảo trì định kỳ hệ thống máy CNC', N'Từ chối', N'K0003     ', N'NV0004    ')
INSERT [dbo].[DEXUAT] ([idDX], [NgayDeXuat], [TenKhoa], [File], [GhiChu], [TrangThai], [idKhoa], [idNguoiDung]) VALUES (N'DX0005    ', CAST(N'2023-11-10T16:45:00.000' AS DateTime), N'Khoa Công nghệ thông tin', N'dexuat_muachuot.pdf', NULL, N'Đã duyệt', N'K0002     ', N'NV0001    ')
GO
INSERT [dbo].[QUYETDINH] ([idQD], [NgayBanHanh], [NgayHieuLuc], [File], [idKhoa]) VALUES (N'QD0001    ', CAST(N'2023-01-15' AS Date), CAST(N'2023-02-01' AS Date), N'QD_BoNhiem_TruongKhoa.pdf', N'K0001     ')
INSERT [dbo].[QUYETDINH] ([idQD], [NgayBanHanh], [NgayHieuLuc], [File], [idKhoa]) VALUES (N'QD0002    ', CAST(N'2023-03-20' AS Date), CAST(N'2023-03-25' AS Date), N'QD_MuaSam_TrangThietBi.pdf', N'K0002     ')
INSERT [dbo].[QUYETDINH] ([idQD], [NgayBanHanh], [NgayHieuLuc], [File], [idKhoa]) VALUES (N'QD0003    ', CAST(N'2023-06-10' AS Date), CAST(N'2023-06-10' AS Date), N'QD_QuyTrinh_KhamBenhMoi.docx', N'K0003     ')
INSERT [dbo].[QUYETDINH] ([idQD], [NgayBanHanh], [NgayHieuLuc], [File], [idKhoa]) VALUES (N'QD0004    ', CAST(N'2023-09-01' AS Date), CAST(N'2023-09-01' AS Date), N'QD_DieuChinh_VienPhi.pdf', N'K0004     ')
INSERT [dbo].[QUYETDINH] ([idQD], [NgayBanHanh], [NgayHieuLuc], [File], [idKhoa]) VALUES (N'QD0005    ', CAST(N'2023-11-05' AS Date), CAST(N'2023-11-15' AS Date), N'QD_ThanhLap_DonViMoi.pdf', N'K0001     ')
GO

-- tiêm chủng
INSERT [dbo].[PDK_TIEMCHUNG] ([idDKTiemChung], [NgayLap], [NgayTiem], [HoTenNguoiTiem], [GioiTinh], [NgaySinh], [DiaChi], [SDT], [HoTenNguoiLienHe], [QuanHe], [SDT_LienHe], [Email], [ThoiGianTiem], [LieuTiem], [GhiChu], [TrangThai], [idVacXin], [idNguoiDung], [idBenhNhan]) VALUES (N'DKTC0001  ', CAST(N'2023-11-20' AS Date), CAST(N'2023-12-05' AS Date), N'Trần Bảo An', N'Nữ', CAST(N'2022-05-10' AS Date), N'123 Nguyễn Trãi, Hà Nội', 987654321, N'Trần Văn Bình', N'Bố', N'0987654321', N'binhtran@email.com', N'Sáng (9:00 - 10:00)', N'Mũi 6 trong 1 (Lần 1)', N'Bé có tiền sử sốt nhẹ sau tiêm', N'Đã đặt lịch', N'VX0001    ', N'ND0001    ', N'BN0006    ')
INSERT [dbo].[PDK_TIEMCHUNG] ([idDKTiemChung], [NgayLap], [NgayTiem], [HoTenNguoiTiem], [GioiTinh], [NgaySinh], [DiaChi], [SDT], [HoTenNguoiLienHe], [QuanHe], [SDT_LienHe], [Email], [ThoiGianTiem], [LieuTiem], [GhiChu], [TrangThai], [idVacXin], [idNguoiDung], [idBenhNhan]) VALUES (N'DKTC0002  ', CAST(N'2023-10-15' AS Date), CAST(N'2023-10-20' AS Date), N'Lê Thị Mai', N'Nữ', CAST(N'1990-02-20' AS Date), N'45 Lê Lợi, TP.HCM', 912345678, N'Lê Thị Mai', N'Bản thân', N'0912345678', N'maile@email.com', N'Chiều (14:00 - 15:00)', N'Cúm mùa 2023', NULL, N'Đã tiêm', N'VX0002    ', N'ND0002    ', N'BN0003    ')
INSERT [dbo].[PDK_TIEMCHUNG] ([idDKTiemChung], [NgayLap], [NgayTiem], [HoTenNguoiTiem], [GioiTinh], [NgaySinh], [DiaChi], [SDT], [HoTenNguoiLienHe], [QuanHe], [SDT_LienHe], [Email], [ThoiGianTiem], [LieuTiem], [GhiChu], [TrangThai], [idVacXin], [idNguoiDung], [idBenhNhan]) VALUES (N'DKTC0003  ', CAST(N'2023-11-21' AS Date), CAST(N'2023-11-28' AS Date), N'Phạm Hùng Dũng', N'Nam', CAST(N'1985-08-15' AS Date), N'789 Hùng Vương, Đà Nẵng', 905112233, N'Phạm Hùng Dũng', N'Bản thân', N'0905112233', N'dungpham@email.com', N'Sáng (10:00 - 11:00)', N'Mũi tăng cường (Mũi 4)', N'Dị ứng nhẹ với hải sản', N'Đã đặt lịch', N'VX0003    ', N'ND0001    ', N'BN0001    ')
INSERT [dbo].[PDK_TIEMCHUNG] ([idDKTiemChung], [NgayLap], [NgayTiem], [HoTenNguoiTiem], [GioiTinh], [NgaySinh], [DiaChi], [SDT], [HoTenNguoiLienHe], [QuanHe], [SDT_LienHe], [Email], [ThoiGianTiem], [LieuTiem], [GhiChu], [TrangThai], [idVacXin], [idNguoiDung], [idBenhNhan]) VALUES (N'DKTC0004  ', CAST(N'2023-11-10' AS Date), CAST(N'2023-11-15' AS Date), N'Nguyễn Văn Toàn', N'Nam', CAST(N'1995-04-12' AS Date), N'321 Trần Phú, Cần Thơ', 939887766, N'Nguyễn Văn Toàn', N'Bản thân', N'0939887766', N'toannguyen@email.com', N'Sáng (8:00 - 9:00)', N'Viêm gan B - Mũi 2', N'Bệnh nhân báo bận đột xuất', N'Đã hủy', N'VX0004    ', N'ND0002    ', N'BN0004    ')
INSERT [dbo].[PDK_TIEMCHUNG] ([idDKTiemChung], [NgayLap], [NgayTiem], [HoTenNguoiTiem], [GioiTinh], [NgaySinh], [DiaChi], [SDT], [HoTenNguoiLienHe], [QuanHe], [SDT_LienHe], [Email], [ThoiGianTiem], [LieuTiem], [GhiChu], [TrangThai], [idVacXin], [idNguoiDung], [idBenhNhan]) VALUES (N'DKTC0005  ', CAST(N'2023-11-01' AS Date), CAST(N'2023-11-10' AS Date), N'Võ Thị Thu Hà', N'Nữ', CAST(N'1998-11-30' AS Date), N'55 Tôn Đức Thắng, TP.HCM', 945678123, N'Võ Thị Thu Hà', N'Bản thân', N'0945678123', NULL, N'Chiều (15:00 - 16:00)', N'HPV - Mũi 2', NULL, N'Đã tiêm', N'VX0005    ', N'ND0002    ', N'BN0007    ')
GO

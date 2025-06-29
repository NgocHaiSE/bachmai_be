USE [Quan_Ly_Benh_Vien]
GO

-- Tú: đơn thuốc, 

-- đơn thuốc, ct đơn thuốc
INSERT [dbo].[DON_THUOC] ([idDonThuoc], [NgayLap], [TrangThai], [GhiChu], [idNguoiDung], [idKhamBenh], [SuDungBHYT]) VALUES (N'DT0001    ', CAST(N'2023-11-20' AS Date), N'Đã cấp phát', N'Uống thuốc trong 5 ngày', N'ND0001    ', N'KB0001    ', NULL)
INSERT [dbo].[DON_THUOC] ([idDonThuoc], [NgayLap], [TrangThai], [GhiChu], [idNguoiDung], [idKhamBenh], [SuDungBHYT]) VALUES (N'DT0002    ', CAST(N'2023-11-21' AS Date), N'Chờ thanh toán', N'Kê thuốc điều trị H.Pylori và viêm loét', N'ND0001    ', N'KB0002    ', NULL)
INSERT [dbo].[DON_THUOC] ([idDonThuoc], [NgayLap], [TrangThai], [GhiChu], [idNguoiDung], [idKhamBenh], [SuDungBHYT]) VALUES (N'DT0003    ', CAST(N'2023-11-22' AS Date), N'Đã cấp phát', N'Thuốc bôi chống sẹo', N'ND0003    ', N'KB0005    ', NULL)
INSERT [dbo].[DON_THUOC] ([idDonThuoc], [NgayLap], [TrangThai], [GhiChu], [idNguoiDung], [idKhamBenh], [SuDungBHYT]) VALUES (N'DT0004    ', CAST(N'2023-11-22' AS Date), N'Phát tại khoa', N'Đơn thuốc điều trị tích cực, theo dõi tại giường', N'ND0001    ', N'KB0005    ', NULL)
INSERT [dbo].[DON_THUOC] ([idDonThuoc], [NgayLap], [TrangThai], [GhiChu], [idNguoiDung], [idKhamBenh], [SuDungBHYT]) VALUES (N'DT0006    ', CAST(N'2025-06-23' AS Date), N'Chờ thanh toán', N'Tái khám sau 2 tuần.
', N'ND0001    ', N'KB0003    ', NULL)
GO
INSERT [dbo].[CT_DONTHUOC] ([idDonThuoc], [idDuocPham], [LieuDung], [DuongDung], [SoLuong], [GhiChu]) VALUES (N'DT0001    ', N'DP0001    ', N'Uống 1 viên khi sốt trên 38.5 độ', N'Đường uống', 10, N'Paracetamol 500mg')
INSERT [dbo].[CT_DONTHUOC] ([idDonThuoc], [idDuocPham], [LieuDung], [DuongDung], [SoLuong], [GhiChu]) VALUES (N'DT0001    ', N'DP0002    ', N'Sáng 1 viên, tối 1 viên sau ăn', N'Đường uống', 10, N'Kháng sinh Amoxicillin')
INSERT [dbo].[CT_DONTHUOC] ([idDonThuoc], [idDuocPham], [LieuDung], [DuongDung], [SoLuong], [GhiChu]) VALUES (N'DT0002    ', N'DP0001    ', N'Sáng 1 viên, tối 1 viên sau ăn', N'Đường uống', 28, N'Clarithromycin 500mg')
INSERT [dbo].[CT_DONTHUOC] ([idDonThuoc], [idDuocPham], [LieuDung], [DuongDung], [SoLuong], [GhiChu]) VALUES (N'DT0002    ', N'DP0002    ', N'Sáng 1 viên trước ăn 30 phút', N'Đường uống', 14, N'Omeprazol 20mg')
INSERT [dbo].[CT_DONTHUOC] ([idDonThuoc], [idDuocPham], [LieuDung], [DuongDung], [SoLuong], [GhiChu]) VALUES (N'DT0002    ', N'DP0005    ', N'Sáng 2 viên, tối 2 viên sau ăn', N'Đường uống', 56, N'Amoxicillin 500mg')
INSERT [dbo].[CT_DONTHUOC] ([idDonThuoc], [idDuocPham], [LieuDung], [DuongDung], [SoLuong], [GhiChu]) VALUES (N'DT0003    ', N'DP0003    ', N'Bôi lên vết mổ 2 lần/ngày', N'Uống', 1, NULL)
INSERT [dbo].[CT_DONTHUOC] ([idDonThuoc], [idDuocPham], [LieuDung], [DuongDung], [SoLuong], [GhiChu]) VALUES (N'DT0003    ', N'DP0004    ', N'', N'Uống', 1, NULL)
INSERT [dbo].[CT_DONTHUOC] ([idDonThuoc], [idDuocPham], [LieuDung], [DuongDung], [SoLuong], [GhiChu]) VALUES (N'DT0004    ', N'DP0003    ', N'1g mỗi 8 giờ', N'Uống', 21, NULL)
INSERT [dbo].[CT_DONTHUOC] ([idDonThuoc], [idDuocPham], [LieuDung], [DuongDung], [SoLuong], [GhiChu]) VALUES (N'DT0006    ', N'DP0005    ', N'', N'Uống', 1, NULL)
GO

-- cấp giường
INSERT [dbo].[PYC_CAPGIUONG] ([idYeuCauCapGiuong], [NgayLap], [PheDuyet], [NgayPheDuyet], [SoLuong], [LyDo], [idNguoiDung], [idKhoa]) VALUES (N'YCCG0001  ', CAST(N'2024-10-26T09:15:00.000' AS DateTime), 1, CAST(N'2024-10-26T10:00:00.000' AS DateTime), 2, N'Có 2 bệnh nhân cần nhập viện theo dõi', N'ND0002    ', N'K0001     ')
INSERT [dbo].[PYC_CAPGIUONG] ([idYeuCauCapGiuong], [NgayLap], [PheDuyet], [NgayPheDuyet], [SoLuong], [LyDo], [idNguoiDung], [idKhoa]) VALUES (N'YCCG0002  ', CAST(N'2024-10-27T08:30:00.000' AS DateTime), 0, NULL, 1, N'Bệnh nhân nặng từ phòng cấp cứu chuyển lên', N'ND0002    ', N'K0001     ')
INSERT [dbo].[PYC_CAPGIUONG] ([idYeuCauCapGiuong], [NgayLap], [PheDuyet], [NgayPheDuyet], [SoLuong], [LyDo], [idNguoiDung], [idKhoa]) VALUES (N'YCCG0003  ', CAST(N'2024-10-27T11:00:00.000' AS DateTime), 0, NULL, 3, N'Dự kiến tiếp nhận bệnh nhân tai nạn hàng loạt', N'ND0003    ', N'K0002     ')
INSERT [dbo].[PYC_CAPGIUONG] ([idYeuCauCapGiuong], [NgayLap], [PheDuyet], [NgayPheDuyet], [SoLuong], [LyDo], [idNguoiDung], [idKhoa]) VALUES (N'YCCG0004  ', CAST(N'2024-10-25T14:00:00.000' AS DateTime), 0, CAST(N'2024-10-25T14:30:00.000' AS DateTime), 1, N'Xin thêm giường cho bệnh nhân theo dõi sau tiểu phẫu', N'ND0005    ', N'K0002     ')
INSERT [dbo].[PYC_CAPGIUONG] ([idYeuCauCapGiuong], [NgayLap], [PheDuyet], [NgayPheDuyet], [SoLuong], [LyDo], [idNguoiDung], [idKhoa]) VALUES (N'YCCG0005  ', CAST(N'2024-10-27T02:00:00.000' AS DateTime), 1, CAST(N'2024-10-27T02:05:00.000' AS DateTime), 1, N'Cấp cứu bệnh nhân nhồi máu cơ tim', N'ND0003    ', N'K0002     ')
GO

-- hoá đơn tiêm chủng
INSERT [dbo].[HOADON_TIEMCHUNG] ([idHoaDonTiemChung], [NgayLap], [HinhThucThanhToan], [TrangThai], [idDKTiemChung], [idBenhNhan], [idNguoiDung]) VALUES (N'HDTC0001  ', CAST(N'2023-12-05' AS Date), N'Tiền mặt', N'Đã thanh toán', N'DKTC0001  ', N'BN0006    ', N'ND0001    ')
INSERT [dbo].[HOADON_TIEMCHUNG] ([idHoaDonTiemChung], [NgayLap], [HinhThucThanhToan], [TrangThai], [idDKTiemChung], [idBenhNhan], [idNguoiDung]) VALUES (N'HDTC0002  ', CAST(N'2023-10-20' AS Date), N'Chuyển khoản', N'Đã thanh toán', N'DKTC0002  ', N'BN0003    ', N'ND0002    ')
INSERT [dbo].[HOADON_TIEMCHUNG] ([idHoaDonTiemChung], [NgayLap], [HinhThucThanhToan], [TrangThai], [idDKTiemChung], [idBenhNhan], [idNguoiDung]) VALUES (N'HDTC0003  ', CAST(N'2023-11-28' AS Date), NULL, N'Chưa thanh toán', N'DKTC0003  ', N'BN0001    ', N'ND0001    ')
INSERT [dbo].[HOADON_TIEMCHUNG] ([idHoaDonTiemChung], [NgayLap], [HinhThucThanhToan], [TrangThai], [idDKTiemChung], [idBenhNhan], [idNguoiDung]) VALUES (N'HDTC0004  ', CAST(N'2023-11-10' AS Date), NULL, N'Đã hủy', N'DKTC0004  ', N'BN0004    ', N'ND0002    ')
INSERT [dbo].[HOADON_TIEMCHUNG] ([idHoaDonTiemChung], [NgayLap], [HinhThucThanhToan], [TrangThai], [idDKTiemChung], [idBenhNhan], [idNguoiDung]) VALUES (N'HDTC0005  ', CAST(N'2023-11-10' AS Date), N'Thẻ tín dụng', N'Đã thanh toán', N'DKTC0005  ', N'ND0007    ', N'ND0001    ')
GO
INSERT [dbo].[CT_HOADONTIEMCHUNG] ([idHoaDonTiemChung], [idVacxin], [SoLuong], [GhiChu]) VALUES (N'HDTC0001  ', N'VX0001    ', 1, N'Phí vắc-xin 6 trong 1')
INSERT [dbo].[CT_HOADONTIEMCHUNG] ([idHoaDonTiemChung], [idVacxin], [SoLuong], [GhiChu]) VALUES (N'HDTC0002  ', N'VX0002    ', 1, N'Phí vắc-xin cúm mùa 2023')
INSERT [dbo].[CT_HOADONTIEMCHUNG] ([idHoaDonTiemChung], [idVacxin], [SoLuong], [GhiChu]) VALUES (N'HDTC0003  ', N'VX0003    ', 1, N'Phí vắc-xin COVID-19 mũi 4')
INSERT [dbo].[CT_HOADONTIEMCHUNG] ([idHoaDonTiemChung], [idVacxin], [SoLuong], [GhiChu]) VALUES (N'HDTC0005  ', N'VX0001    ', 1, N'Phí tiêm 6 trong 1 cho trẻ')
INSERT [dbo].[CT_HOADONTIEMCHUNG] ([idHoaDonTiemChung], [idVacxin], [SoLuong], [GhiChu]) VALUES (N'HDTC0005  ', N'VX0002    ', 2, N'Phí tiêm cúm cho 2 người lớn')
GO

-- hoá đơn điện nước
INSERT [dbo].[HOADON_DIENNUOC] ([idDienNuoc], [NgayLap], [TuNgay], [DenNgay], [NhaCungCap], [DonGia], [SanLuong], [TrangThai], [GhiChu], [idKhoa], [idNguoiDung]) VALUES (N'HDDN0001  ', CAST(N'2023-11-05T10:00:00.000' AS DateTime), CAST(N'2023-10-01T00:00:00.000' AS DateTime), CAST(N'2023-10-31T00:00:00.000' AS DateTime), N'Tổng Công ty Điện lực TP.HCM', CAST(1800 AS Decimal(18, 0)), 5250, N'Đã thanh toán', N'Thanh toán qua chuyển khoản ngày 10/11/2023', N'K0001     ', N'ND0001    ')
INSERT [dbo].[HOADON_DIENNUOC] ([idDienNuoc], [NgayLap], [TuNgay], [DenNgay], [NhaCungCap], [DonGia], [SanLuong], [TrangThai], [GhiChu], [idKhoa], [idNguoiDung]) VALUES (N'HDDN0002  ', CAST(N'2023-11-06T11:30:00.000' AS DateTime), CAST(N'2023-10-01T00:00:00.000' AS DateTime), CAST(N'2023-10-31T00:00:00.000' AS DateTime), N'Tổng Công ty Cấp nước Sài Gòn (SAWACO)', CAST(7500 AS Decimal(18, 0)), 310, N'Chưa thanh toán', NULL, N'K0001     ', N'ND0001    ')
INSERT [dbo].[HOADON_DIENNUOC] ([idDienNuoc], [NgayLap], [TuNgay], [DenNgay], [NhaCungCap], [DonGia], [SanLuong], [TrangThai], [GhiChu], [idKhoa], [idNguoiDung]) VALUES (N'HDDN0003  ', CAST(N'2023-12-05T09:15:00.000' AS DateTime), CAST(N'2023-11-01T00:00:00.000' AS DateTime), CAST(N'2023-11-30T00:00:00.000' AS DateTime), N'Tổng Công ty Điện lực TP.HCM', CAST(1850 AS Decimal(18, 0)), 7800, N'Chưa thanh toán', N'Sản lượng tăng do sử dụng thiết bị mới', N'K0002     ', N'ND0002    ')
INSERT [dbo].[HOADON_DIENNUOC] ([idDienNuoc], [NgayLap], [TuNgay], [DenNgay], [NhaCungCap], [DonGia], [SanLuong], [TrangThai], [GhiChu], [idKhoa], [idNguoiDung]) VALUES (N'HDDN0004  ', CAST(N'2023-10-05T15:00:00.000' AS DateTime), CAST(N'2023-09-01T00:00:00.000' AS DateTime), CAST(N'2023-09-30T00:00:00.000' AS DateTime), N'Tổng Công ty Cấp nước Sài Gòn (SAWACO)', CAST(7500 AS Decimal(18, 0)), 1500, N'Quá hạn', N'Hạn thanh toán 25/10/2023', N'K0003     ', N'ND0001    ')
INSERT [dbo].[HOADON_DIENNUOC] ([idDienNuoc], [NgayLap], [TuNgay], [DenNgay], [NhaCungCap], [DonGia], [SanLuong], [TrangThai], [GhiChu], [idKhoa], [idNguoiDung]) VALUES (N'HDDN0005  ', CAST(N'2023-12-05T10:00:00.000' AS DateTime), CAST(N'2023-11-01T00:00:00.000' AS DateTime), CAST(N'2023-11-30T00:00:00.000' AS DateTime), N'Tổng Công ty Điện lực TP.HCM', CAST(1850 AS Decimal(18, 0)), 4500, N'Đã thanh toán', NULL, N'K0004     ', N'ND0002    ')
GO

-- thu chi
INSERT [dbo].[KH_THUCHITAICHINH] ([idKeHoachTaiChinh], [NgayLap], [PheDuyet], [NgayPheDuyet], [NamKeHoach], [idKhoa], [idNguoiDung]) VALUES (N'KHTC0001  ', CAST(N'2023-01-15T09:00:00.000' AS DateTime), 1, CAST(N'2023-01-20T14:30:00.000' AS DateTime), 2023, N'K0001     ', N'ND0001    ')
INSERT [dbo].[KH_THUCHITAICHINH] ([idKeHoachTaiChinh], [NgayLap], [PheDuyet], [NgayPheDuyet], [NamKeHoach], [idKhoa], [idNguoiDung]) VALUES (N'KHTC0002  ', CAST(N'2023-10-25T11:20:00.000' AS DateTime), 0, NULL, 2024, N'K0002     ', N'ND0002    ')
INSERT [dbo].[KH_THUCHITAICHINH] ([idKeHoachTaiChinh], [NgayLap], [PheDuyet], [NgayPheDuyet], [NamKeHoach], [idKhoa], [idNguoiDung]) VALUES (N'KHTC0003  ', CAST(N'2023-02-10T16:00:00.000' AS DateTime), 1, CAST(N'2023-02-15T10:00:00.000' AS DateTime), 2023, N'K0003     ', N'ND0003    ')
INSERT [dbo].[KH_THUCHITAICHINH] ([idKeHoachTaiChinh], [NgayLap], [PheDuyet], [NgayPheDuyet], [NamKeHoach], [idKhoa], [idNguoiDung]) VALUES (N'KHTC0004  ', CAST(N'2023-11-01T08:45:00.000' AS DateTime), 0, NULL, 2024, N'K0001     ', N'ND0001    ')
INSERT [dbo].[KH_THUCHITAICHINH] ([idKeHoachTaiChinh], [NgayLap], [PheDuyet], [NgayPheDuyet], [NamKeHoach], [idKhoa], [idNguoiDung]) VALUES (N'KHTC0005  ', CAST(N'2022-12-20T15:00:00.000' AS DateTime), 1, CAST(N'2022-12-28T11:00:00.000' AS DateTime), 2023, N'K0005     ', N'ND0004    ')
GO
INSERT [dbo].[CT_KHTHUCHI] ([idCT], [idKeHoachTaiChinh], [NoiDung], [SoTienThu], [SoTienChi]) VALUES (N'CT0001    ', N'KHTC0001  ', N'Chi trả lương nhân viên tháng 10', NULL, CAST(1500000000 AS Decimal(18, 0)))
INSERT [dbo].[CT_KHTHUCHI] ([idCT], [idKeHoachTaiChinh], [NoiDung], [SoTienThu], [SoTienChi]) VALUES (N'CT0002    ', N'KHTC0001  ', N'Chi mua vật tư y tế tiêu hao', NULL, CAST(350000000 AS Decimal(18, 0)))
INSERT [dbo].[CT_KHTHUCHI] ([idCT], [idKeHoachTaiChinh], [NoiDung], [SoTienThu], [SoTienChi]) VALUES (N'CT0003    ', N'KHTC0001  ', N'Thu từ dịch vụ khám chữa bệnh', CAST(2500000000 AS Decimal(18, 0)), NULL)
INSERT [dbo].[CT_KHTHUCHI] ([idCT], [idKeHoachTaiChinh], [NoiDung], [SoTienThu], [SoTienChi]) VALUES (N'CT0004    ', N'KHTC0001  ', N'Thu từ thanh toán BHYT', CAST(800000000 AS Decimal(18, 0)), NULL)
INSERT [dbo].[CT_KHTHUCHI] ([idCT], [idKeHoachTaiChinh], [NoiDung], [SoTienThu], [SoTienChi]) VALUES (N'CT0005    ', N'KHTC0002  ', N'Chi mua máy siêu âm mới', NULL, CAST(1200000000 AS Decimal(18, 0)))
GO

-- chấm công
INSERT [dbo].[CHAMCONG] ([idChamCong], [NgayCong], [NgayNghi], [CoPhep], [LyDoNghi], [NgayChamCong], [idKhoa], [idNguoiDung], [idNhanVien]) VALUES (N'CC00001   ', 22, 0, 0, NULL, CAST(N'2024-10-31' AS Date), N'K0001     ', N'ND00001   ', N'NV0001    ')
INSERT [dbo].[CHAMCONG] ([idChamCong], [NgayCong], [NgayNghi], [CoPhep], [LyDoNghi], [NgayChamCong], [idKhoa], [idNguoiDung], [idNhanVien]) VALUES (N'CC0002    ', 20, 2, 2, N'Nghỉ ốm có giấy xác nhận', CAST(N'2024-10-31' AS Date), N'K0001     ', N'ND0001    ', N'NV0002    ')
INSERT [dbo].[CHAMCONG] ([idChamCong], [NgayCong], [NgayNghi], [CoPhep], [LyDoNghi], [NgayChamCong], [idKhoa], [idNguoiDung], [idNhanVien]) VALUES (N'CC0003    ', 21, 1, 0, N'Nghỉ không lương (việc riêng)', CAST(N'2024-10-31' AS Date), N'K0002     ', N'ND0001    ', N'NV0003    ')
INSERT [dbo].[CHAMCONG] ([idChamCong], [NgayCong], [NgayNghi], [CoPhep], [LyDoNghi], [NgayChamCong], [idKhoa], [idNguoiDung], [idNhanVien]) VALUES (N'CC0004    ', 22, 0, 0, NULL, CAST(N'2024-10-31' AS Date), N'K0002     ', N'ND0001    ', N'NV0005    ')
INSERT [dbo].[CHAMCONG] ([idChamCong], [NgayCong], [NgayNghi], [CoPhep], [LyDoNghi], [NgayChamCong], [idKhoa], [idNguoiDung], [idNhanVien]) VALUES (N'CC0005    ', 21, 1, 1, N'Nghỉ phép năm', CAST(N'2024-09-30' AS Date), N'K0001     ', N'ND0001    ', N'NV0001    ')
INSERT [dbo].[CHAMCONG] ([idChamCong], [NgayCong], [NgayNghi], [CoPhep], [LyDoNghi], [NgayChamCong], [idKhoa], [idNguoiDung], [idNhanVien]) VALUES (N'CC0006    ', 22, 0, 0, NULL, CAST(N'2024-09-30' AS Date), N'K0001     ', N'ND0001    ', N'NV0002    ')
INSERT [dbo].[CHAMCONG] ([idChamCong], [NgayCong], [NgayNghi], [CoPhep], [LyDoNghi], [NgayChamCong], [idKhoa], [idNguoiDung], [idNhanVien]) VALUES (N'CC0007    ', 24, 0, 0, NULL, CAST(N'2024-09-30' AS Date), N'K0002     ', N'ND0001    ', N'NV0003    ')
GO
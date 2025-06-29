CREATE DATABASE Quan_Ly_Benh_Vien
USE [Quan_Ly_Benh_Vien]
GO
/****** Object:  Table [dbo].[BENHNHAN]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BENHNHAN](
	[idBenhNhan] [char](10) NOT NULL,
	[HoTen] [nvarchar](100) NULL,
	[NgaySinh] [date] NULL,
	[GioiTinh] [nvarchar](10) NULL,
	[NgheNghiep] [nvarchar](50) NULL,
	[DanToc] [nvarchar](50) NULL,
	[SDT] [varchar](15) NULL,
	[DiaChi] [nvarchar](200) NULL,
	[CCCD] [varchar](20) NULL,
	[BHYT] [varchar](20) NULL,
	[ThoiHanBHYT] [date] NULL,
	[DoiTuongUuTien] [nvarchar](50) NULL,
	[HoTenThanNhan] [nvarchar](100) NULL,
	[MoiQuanHe] [nvarchar](20) NULL,
	[SDTThanNhan] [varchar](15) NULL,
	[BenhManTinh] [nvarchar](200) NULL,
	[DiUng] [nvarchar](200) NULL,
	[PhauThuatDaLam] [nvarchar](200) NULL,
	[TrangThai] [nvarchar](50) NULL,
	[idLoaiBHYT] [char](10) NULL,
 CONSTRAINT [PK__BENHNHAN__516E1F69AB9378DD] PRIMARY KEY CLUSTERED 
(
	[idBenhNhan] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CALAMVIEC]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CALAMVIEC](
	[idCaLamViec] [char](10) NOT NULL,
	[NgayLamViec] [date] NULL,
	[LoaiCa] [nvarchar](50) NULL,
	[GioBD] [time](7) NULL,
	[GioKT] [time](7) NULL,
	[TrangThai] [nvarchar](50) NULL,
	[ThoiGianPheDuyet] [datetime] NULL,
	[LoaiCongViec] [nvarchar](50) NULL,
	[GhiChu] [nvarchar](200) NULL,
	[idNhanVien] [char](10) NULL,
	[idNguoiDung] [char](10) NULL,
	[idKhoa] [char](10) NULL,
	[idLichTongThe] [char](10) NULL,
	[idNguoiPheDuyet] [char](10) NULL,
 CONSTRAINT [PK_CALAMVIEC1] PRIMARY KEY CLUSTERED 
(
	[idCaLamViec] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CANLAMSANG]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CANLAMSANG](
	[idCanLamSang] [char](10) NOT NULL,
	[TenCLS] [nvarchar](100) NULL,
	[TenLoaiCLS] [nvarchar](100) NULL,
	[ChiPhi] [decimal](18, 2) NULL,
	[DVT] [nvarchar](20) NULL,
	[KhoangThamChieuNam] [nvarchar](100) NULL,
	[KhoangThamChieuNu] [nvarchar](100) NULL,
	[ThuTuHienThi] [int] NULL,
	[idCanLamSangCha] [char](10) NULL,
	[idKhoa] [char](10) NULL,
 CONSTRAINT [PK__PHAUTHUA__C15628A51B15D09E] PRIMARY KEY CLUSTERED 
(
	[idCanLamSang] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CAPPHAT_THIETBI]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CAPPHAT_THIETBI](
	[idCapPhat] [char](10) NOT NULL,
	[NgayCapPhat] [date] NULL,
	[NguoiNhan] [nvarchar](50) NULL,
	[NguoiLap] [nvarchar](50) NULL,
	[SoLuong] [int] NULL,
	[TinhTrang] [nvarchar](50) NULL,
	[NguonCung] [nvarchar](50) NULL,
	[GhiChu] [nvarchar](50) NULL,
	[idThietBi] [char](10) NULL,
	[idKhoa] [char](10) NULL,
 CONSTRAINT [PK_THIETBIBIENCHE] PRIMARY KEY CLUSTERED 
(
	[idCapPhat] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CHAMCONG]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHAMCONG](
	[idChamCong] [char](10) NOT NULL,
	[NgayCong] [int] NULL,
	[NgayNghi] [int] NULL,
	[CoPhep] [int] NULL,
	[LyDoNghi] [nvarchar](50) NULL,
	[NgayChamCong] [date] NULL,
	[idKhoa] [char](10) NULL,
	[idNguoiDung] [char](10) NULL,
	[idNhanVien] [char](10) NULL,
 CONSTRAINT [PK_ChamCong] PRIMARY KEY CLUSTERED 
(
	[idChamCong] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CT_DONTHUOC]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CT_DONTHUOC](
	[idDonThuoc] [char](10) NOT NULL,
	[idDuocPham] [char](10) NOT NULL,
	[LieuDung] [nvarchar](50) NULL,
	[DuongDung] [nvarchar](20) NULL,
	[SoLuong] [int] NULL,
	[GhiChu] [nvarchar](50) NULL,
 CONSTRAINT [PK_CT_DONTHUOC] PRIMARY KEY CLUSTERED 
(
	[idDonThuoc] ASC,
	[idDuocPham] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CT_GOI_VACXIN]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CT_GOI_VACXIN](
	[idGoiVX] [char](10) NOT NULL,
	[idVacXin] [char](10) NOT NULL,
 CONSTRAINT [PK_Table_2_1] PRIMARY KEY CLUSTERED 
(
	[idGoiVX] ASC,
	[idVacXin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CT_HOADONTIEMCHUNG]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CT_HOADONTIEMCHUNG](
	[idHoaDonTiemChung] [char](10) NOT NULL,
	[idVacxin] [char](10) NOT NULL,
	[SoLuong] [int] NULL,
	[GhiChu] [nvarchar](50) NULL,
 CONSTRAINT [PK_CT_HOADONTIEMCHUNG_1] PRIMARY KEY CLUSTERED 
(
	[idHoaDonTiemChung] ASC,
	[idVacxin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CT_HOADONVIENPHI]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CT_HOADONVIENPHI](
	[idCTVienPhi] [char](10) NOT NULL,
	[idVienPhi] [char](10) NULL,
	[idCanLamSang] [char](10) NULL,
	[idNoiTru] [char](10) NULL,
 CONSTRAINT [PK_CT_HOADONVIENPHI] PRIMARY KEY CLUSTERED 
(
	[idCTVienPhi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CT_KHTHUCHI]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CT_KHTHUCHI](
	[idCT] [char](10) NOT NULL,
	[idKeHoachTaiChinh] [char](10) NULL,
	[NoiDung] [nvarchar](50) NULL,
	[SoTienThu] [decimal](18, 0) NULL,
	[SoTienChi] [decimal](18, 0) NULL,
 CONSTRAINT [PK_Table_2] PRIMARY KEY CLUSTERED 
(
	[idCT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CT_NHAPKHODUOCPHAM]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CT_NHAPKHODUOCPHAM](
	[idNhapKhoDuocPham] [char](10) NOT NULL,
	[idDuocPham] [char](10) NOT NULL,
	[HanSuDung] [date] NULL,
	[NhaSX] [nvarchar](50) NULL,
	[SoLuong] [int] NULL,
	[DonGiaMua] [decimal](18, 2) NULL,
	[GhiChu] [nvarchar](50) NULL,
 CONSTRAINT [PK__CT_NHAPK__918DB222FD10A579] PRIMARY KEY CLUSTERED 
(
	[idNhapKhoDuocPham] ASC,
	[idDuocPham] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CT_YEUCAUDUOCPHAM]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CT_YEUCAUDUOCPHAM](
	[idChiTietYeuCau] [char](10) NOT NULL,
	[TenDuocPham] [nvarchar](50) NULL,
	[LieuDung] [nvarchar](50) NULL,
	[GhiChu] [nvarchar](50) NULL,
	[SoLuong] [int] NULL,
	[LaThuocMoi] [bit] NULL,
	[idYeuCauDuocPham] [char](10) NULL,
	[idDuocPham] [char](10) NULL,
	[idLoaiDuocPham] [char](10) NULL,
 CONSTRAINT [PK_CT_YEUCAUDUOCPHAM_1] PRIMARY KEY CLUSTERED 
(
	[idChiTietYeuCau] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DEXUAT]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DEXUAT](
	[idDX] [char](10) NOT NULL,
	[NgayDeXuat] [datetime] NULL,
	[TenKhoa] [nvarchar](100) NULL,
	[File] [varchar](50) NULL,
	[GhiChu] [nvarchar](50) NULL,
	[TrangThai] [nvarchar](50) NULL,
	[idKhoa] [char](10) NULL,
	[idNguoiDung] [char](10) NULL,
 CONSTRAINT [PK_DeXuat] PRIMARY KEY CLUSTERED 
(
	[idDX] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DICHVU]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DICHVU](
	[idDichVu] [char](10) NOT NULL,
	[TenDV] [nvarchar](100) NULL,
	[ChiPhi] [decimal](18, 0) NULL,
	[Anh] [nvarchar](255) NULL,
	[DVT] [nvarchar](50) NULL,
	[MoTa] [nvarchar](200) NULL,
	[idLoaiDV] [char](10) NULL,
	[idKhoa] [char](10) NULL,
 CONSTRAINT [PK_DichVuKhamBenh] PRIMARY KEY CLUSTERED 
(
	[idDichVu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DON_NGHIPHEP]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DON_NGHIPHEP](
	[idNghiPhep] [char](10) NOT NULL,
	[LoaiPhep] [nvarchar](50) NULL,
	[NgayBD] [date] NULL,
	[NgayKT] [date] NULL,
	[GioBD] [time](7) NULL,
	[GioKT] [time](7) NULL,
	[NghiCaNgay] [bit] NULL,
	[TongNgayNghi] [float] NULL,
	[LyDo] [nvarchar](200) NULL,
	[TrangThai] [nvarchar](50) NULL,
	[NgayLap] [date] NULL,
	[NgayPheDuyet] [datetime] NULL,
	[GhiChuPheDuyet] [nvarchar](200) NULL,
	[HoTenNguoiLienHe] [nvarchar](100) NULL,
	[SDTNguoiLienHe] [varchar](50) NULL,
	[MoiQuanHe] [nvarchar](50) NULL,
	[GhiChu] [nvarchar](200) NULL,
	[idNhanVien] [char](10) NULL,
	[idNguoiDung] [char](10) NULL,
	[idNguoiPheDuyet] [char](10) NULL,
	[idNhanVienThayThe] [char](10) NULL,
 CONSTRAINT [PK_DON_XINNGHI] PRIMARY KEY CLUSTERED 
(
	[idNghiPhep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DON_THUOC]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DON_THUOC](
	[idDonThuoc] [char](10) NOT NULL,
	[NgayLap] [date] NULL,
	[TrangThai] [nvarchar](50) NULL,
	[GhiChu] [nvarchar](200) NULL,
	[idNguoiDung] [char](10) NULL,
	[idKhamBenh] [char](10) NULL,
	[SuDungBHYT] [bit] NULL,
 CONSTRAINT [PK_DONTHUOC] PRIMARY KEY CLUSTERED 
(
	[idDonThuoc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DUOCPHAM]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DUOCPHAM](
	[idDuocPham] [char](10) NOT NULL,
	[TenDuocPham] [nvarchar](50) NULL,
	[DVT] [nvarchar](50) NULL,
	[HanSuDung] [date] NULL,
	[NhaSX] [nvarchar](50) NULL,
	[SoLuong] [int] NULL,
	[DonGiaMua] [decimal](18, 0) NULL,
	[DonGiaBan] [decimal](18, 0) NULL,
	[MoTa] [nvarchar](200) NULL,
	[DonVi] [nvarchar](50) NULL,
	[HoatChat] [nvarchar](200) NULL,
	[idLoaiDuocPham] [char](10) NULL,
	[idNCC] [char](10) NULL,
 CONSTRAINT [PK_DuocPham] PRIMARY KEY CLUSTERED 
(
	[idDuocPham] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GIUONG]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GIUONG](
	[idGiuong] [char](10) NOT NULL,
	[TrangThai] [nvarchar](50) NULL,
	[Kho] [bit] NULL,
	[GhiChu] [nvarchar](50) NULL,
	[idKhoa] [char](10) NULL,
	[idBenhNhan] [char](10) NULL,
 CONSTRAINT [PK__GIUONG__2F4CE982EED6EBF8] PRIMARY KEY CLUSTERED 
(
	[idGiuong] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GOI_VACXIN]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GOI_VACXIN](
	[idGoiVX] [char](10) NOT NULL,
	[TenGoi] [nvarchar](100) NULL,
 CONSTRAINT [PK_GOI_VACXIN] PRIMARY KEY CLUSTERED 
(
	[idGoiVX] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HOADON_DIENNUOC]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HOADON_DIENNUOC](
	[idDienNuoc] [char](10) NOT NULL,
	[NgayLap] [datetime] NULL,
	[TuNgay] [datetime] NULL,
	[DenNgay] [datetime] NULL,
	[NhaCungCap] [nvarchar](50) NULL,
	[DonGia] [decimal](18, 0) NULL,
	[SanLuong] [int] NULL,
	[TrangThai] [nvarchar](50) NULL,
	[GhiChu] [nvarchar](50) NULL,
	[idKhoa] [char](10) NULL,
	[idNguoiDung] [char](10) NULL,
 CONSTRAINT [PK_HoaDon_DienNuoc] PRIMARY KEY CLUSTERED 
(
	[idDienNuoc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HOADON_TAMUNGVIENPHI]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HOADON_TAMUNGVIENPHI](
	[idTamUngVienPhi] [char](10) NOT NULL,
	[NgayLap] [date] NULL,
	[HinhThucThanhToan] [nvarchar](50) NULL,
	[SoTienTamUng] [decimal](18, 0) NULL,
	[TrangThai] [nvarchar](50) NULL,
	[GhiChu] [nvarchar](50) NULL,
	[idBenhNhan] [char](10) NULL,
	[idNguoiDung] [char](10) NULL,
 CONSTRAINT [PK_HOADON_TAMUNGVIENPHI] PRIMARY KEY CLUSTERED 
(
	[idTamUngVienPhi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HOADON_TIEMCHUNG]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HOADON_TIEMCHUNG](
	[idHoaDonTiemChung] [char](10) NOT NULL,
	[NgayLap] [date] NULL,
	[HinhThucThanhToan] [nvarchar](50) NULL,
	[TrangThai] [nvarchar](50) NULL,
	[idDKTiemChung] [char](10) NULL,
	[idBenhNhan] [char](10) NULL,
	[idNguoiDung] [char](10) NULL,
 CONSTRAINT [PK_HOADON_TIEMCHUNG] PRIMARY KEY CLUSTERED 
(
	[idHoaDonTiemChung] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HOADON_VIENPHI]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HOADON_VIENPHI](
	[idVienPhi] [char](10) NOT NULL,
	[NgayLap] [date] NULL,
	[HinhThucThanhToan] [nvarchar](50) NULL,
	[GhiChu] [nvarchar](50) NULL,
	[TrangThai] [nvarchar](50) NULL,
	[idKhamBenh] [char](10) NULL,
	[idTamUngVienPhi] [char](10) NULL,
	[idNguoiDung] [char](10) NULL,
 CONSTRAINT [PK_HOADON_VIENPHI_1] PRIMARY KEY CLUSTERED 
(
	[idVienPhi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HOSOBENHAN]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HOSOBENHAN](
	[idHoSo] [char](10) NOT NULL,
	[NgayLap] [date] NULL,
	[NoiChuyenDen] [nvarchar](255) NULL,
	[GhiChu] [nvarchar](max) NULL,
	[idNguoiDung] [char](10) NULL,
	[idBenhNhan] [char](10) NOT NULL,
 CONSTRAINT [PK_HOSOBENHAN] PRIMARY KEY CLUSTERED 
(
	[idHoSo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ICD]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ICD](
	[idICD] [char](10) NOT NULL,
	[TenBenh] [nvarchar](100) NULL,
	[GhiChu] [nvarchar](50) NULL,
 CONSTRAINT [PK_ICD] PRIMARY KEY CLUSTERED 
(
	[idICD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KH_THUCHITAICHINH]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KH_THUCHITAICHINH](
	[idKeHoachTaiChinh] [char](10) NOT NULL,
	[NgayLap] [datetime] NULL,
	[PheDuyet] [bit] NULL,
	[NgayPheDuyet] [datetime] NULL,
	[NamKeHoach] [int] NULL,
	[idKhoa] [char](10) NULL,
	[idNguoiDung] [char](10) NULL,
 CONSTRAINT [PK_KH_ThuChiTaiChinh] PRIMARY KEY CLUSTERED 
(
	[idKeHoachTaiChinh] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KHOA]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KHOA](
	[idKhoa] [char](10) NOT NULL,
	[TenKhoa] [nvarchar](100) NULL,
	[ViTri] [nvarchar](200) NULL,
	[MucTieu] [nvarchar](200) NULL,
	[NgayThanhLap] [date] NULL,
	[NgayHD] [date] NULL,
	[TrangThai] [nvarchar](50) NULL,
	[TruongKhoa] [nvarchar](50) NULL,
	[idLoaiKhoa] [char](10) NULL,
 CONSTRAINT [PK__KHOA__C30A683D16699904] PRIMARY KEY CLUSTERED 
(
	[idKhoa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LICH_TONGTHE]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LICH_TONGTHE](
	[idLichTongThe] [char](10) NOT NULL,
	[TenLich] [nvarchar](100) NULL,
	[TuNgay] [date] NULL,
	[DenNgay] [date] NULL,
	[TrangThai] [nvarchar](50) NULL,
 CONSTRAINT [PK_LICH_TONGTHE] PRIMARY KEY CLUSTERED 
(
	[idLichTongThe] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LICHSUTRUYCAP]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LICHSUTRUYCAP](
	[idLichSu] [char](10) NOT NULL,
	[ThoiDiemDN] [datetime] NOT NULL,
	[ThoiDiemDX] [datetime] NOT NULL,
	[idNguoiDung] [char](10) NOT NULL,
 CONSTRAINT [PK_LichSuTruyCap] PRIMARY KEY CLUSTERED 
(
	[idLichSu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOAI_BHYT]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOAI_BHYT](
	[idLoaiBHYT] [char](10) NOT NULL,
	[TenLoaiBHYT] [nvarchar](50) NULL,
	[MucHuong] [decimal](5, 2) NULL,
	[GhiChu] [nvarchar](50) NULL,
 CONSTRAINT [PK__LOAI_BHY__3E37F9DF3EE4A752] PRIMARY KEY CLUSTERED 
(
	[idLoaiBHYT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOAI_DUOCPHAM]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOAI_DUOCPHAM](
	[idLoaiDuocPham] [char](10) NOT NULL,
	[TenLoaiDuocPham] [nvarchar](100) NULL,
	[GhiChu] [nvarchar](200) NULL,
 CONSTRAINT [PK__LOAIDUOC__6334B80B5AF2358F] PRIMARY KEY CLUSTERED 
(
	[idLoaiDuocPham] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOAI_DV]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOAI_DV](
	[idLoaiDV] [char](10) NOT NULL,
	[TenLoaiDV] [nvarchar](100) NULL,
	[MoTa] [nvarchar](200) NULL,
	[idKhoa] [char](10) NULL,
 CONSTRAINT [PK_Loai_DVKhamBenh] PRIMARY KEY CLUSTERED 
(
	[idLoaiDV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOAI_VACXIN]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOAI_VACXIN](
	[idLoaiVX] [char](10) NOT NULL,
	[TenLoai] [nvarchar](100) NULL,
	[MoTa] [nvarchar](200) NULL,
 CONSTRAINT [PK_LOAI_VACXIN] PRIMARY KEY CLUSTERED 
(
	[idLoaiVX] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOAIKHAM]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOAIKHAM](
	[idLoaiKham] [char](10) NOT NULL,
	[TenLoaiKham] [nvarchar](100) NULL,
	[ChiPhi] [decimal](18, 0) NULL,
 CONSTRAINT [PK_LoaiKham] PRIMARY KEY CLUSTERED 
(
	[idLoaiKham] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOAIKHOA]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOAIKHOA](
	[idLoaiKhoa] [char](10) NOT NULL,
	[TenLoaiKhoa] [nvarchar](100) NULL,
	[MoTa] [nvarchar](200) NULL,
 CONSTRAINT [PK__LOAIKHOA__CF77FDF033676186] PRIMARY KEY CLUSTERED 
(
	[idLoaiKhoa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MAU_LICHLAMVIEC]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MAU_LICHLAMVIEC](
	[idMauLich] [char](10) NOT NULL,
	[TenMauLich] [nvarchar](100) NULL,
	[MoTa] [nvarchar](200) NULL,
	[TrangThai] [bit] NULL,
	[HieuLucTuNgay] [datetime] NULL,
	[HieuLucDenNgay] [datetime] NULL,
	[NgayLap] [date] NULL,
	[idKhoa] [char](10) NULL,
	[idNguoiDung] [char](10) NULL,
 CONSTRAINT [PK_MAU_LICHLAMVIEC] PRIMARY KEY CLUSTERED 
(
	[idMauLich] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MAUCT_LICH]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MAUCT_LICH](
	[idMauLichCT] [char](10) NOT NULL,
	[ThuTrongTuan] [nvarchar](50) NULL,
	[LoaiCa] [nvarchar](50) NULL,
	[GioBD] [time](7) NULL,
	[GioKT] [time](7) NULL,
	[SoLuongNhanVien] [int] NULL,
	[VaiTroYeuCau] [nvarchar](500) NULL,
	[idMauLich] [char](10) NULL,
 CONSTRAINT [PK_MAUCT_LICH] PRIMARY KEY CLUSTERED 
(
	[idMauLichCT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NCC]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NCC](
	[idNCC] [char](10) NOT NULL,
	[TenNCC] [nvarchar](100) NULL,
	[DiaChi] [nvarchar](100) NULL,
	[SDT] [nchar](15) NULL,
	[QuocGia] [nvarchar](50) NULL,
 CONSTRAINT [PK_NCC] PRIMARY KEY CLUSTERED 
(
	[idNCC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NGHIPHEP_ANHHUONGCA]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NGHIPHEP_ANHHUONGCA](
	[idNghiPhep] [char](10) NOT NULL,
	[idCaLamViec] [char](10) NOT NULL,
 CONSTRAINT [PK_NGHIPHEP_ANHHUONGCA] PRIMARY KEY CLUSTERED 
(
	[idNghiPhep] ASC,
	[idCaLamViec] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NGUOIDUNG]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NGUOIDUNG](
	[idNguoiDung] [char](10) NOT NULL,
	[HoTen] [nvarchar](50) NULL,
	[SDT] [varchar](15) NULL,
	[TenDN] [varchar](50) NULL,
	[MatKhau] [varchar](50) NULL,
	[ChucVu] [nvarchar](50) NULL,
	[idNhom] [char](10) NULL,
	[GioiTinh] [bit] NULL,
	[NgaySinh] [date] NULL,
	[Email] [nvarchar](100) NULL,
	[HeSoLuong] [decimal](5, 2) NULL,
 CONSTRAINT [PK_NguoiDung] PRIMARY KEY CLUSTERED 
(
	[idNguoiDung] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NHANVIEN]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NHANVIEN](
	[idNhanVien] [char](10) NOT NULL,
	[HoTen] [nvarchar](100) NULL,
	[GioiTinh] [nvarchar](20) NULL,
	[NgaySinh] [date] NULL,
	[TrinhDo] [nvarchar](50) NULL,
	[SDT] [varchar](15) NULL,
	[Email] [nvarchar](100) NULL,
	[HeSoLuong] [float] NULL,
	[ChucVu] [nvarchar](50) NULL,
	[idKhoa] [char](10) NULL,
 CONSTRAINT [PK_NHANVIEN] PRIMARY KEY CLUSTERED 
(
	[idNhanVien] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NHATKYTHAYDOI]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NHATKYTHAYDOI](
	[idNhatKy] [char](10) NOT NULL,
	[ThoiDiem] [datetime] NULL,
	[NoiDung] [nvarchar](max) NULL,
	[ThongTinCu] [nvarchar](max) NULL,
	[ThongTinMoi] [nvarchar](max) NULL,
	[idLichSu] [char](10) NULL,
 CONSTRAINT [PK_NhatKyThayDoi] PRIMARY KEY CLUSTERED 
(
	[idNhatKy] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NHOM_NGUOIDUNG]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NHOM_NGUOIDUNG](
	[idNhom] [char](10) NOT NULL,
	[TenNhom] [nvarchar](50) NOT NULL,
	[idQuyen] [char](10) NULL,
 CONSTRAINT [PK_Nhom_NguoiDung] PRIMARY KEY CLUSTERED 
(
	[idNhom] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NOITRU]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NOITRU](
	[idNoiTru] [char](10) NOT NULL,
	[NgayNhapVien] [date] NULL,
	[NgayRaVien] [date] NULL,
	[DonGiaNgay] [decimal](18, 0) NULL,
	[GhiChu] [nvarchar](50) NULL,
	[idBenhNhan] [char](10) NULL,
 CONSTRAINT [PK_NOITRU] PRIMARY KEY CLUSTERED 
(
	[idNoiTru] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[P_CHUYENVIEN]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[P_CHUYENVIEN](
	[idChuyenVien] [char](10) NOT NULL,
	[NgayLap] [date] NULL,
	[NgayChuyen] [date] NULL,
	[ThoiGianDuKien] [time](7) NULL,
	[SDT_CoSoYTe] [varchar](20) NULL,
	[YThuc] [nvarchar](200) NULL,
	[GhiChu] [nvarchar](200) NULL,
	[TrangThai] [nvarchar](50) NULL,
	[NgayPheDuyet] [date] NULL,
	[idYeuCauChuyenVien] [char](10) NULL,
	[idNguoiDiKem] [char](10) NULL,
	[idNguoiPheDuyet] [char](10) NULL,
	[idNguoiDung] [char](10) NULL,
	[Phuongtien] [nvarchar](50) NULL,
 CONSTRAINT [PK_P_CHUYENVIEN] PRIMARY KEY CLUSTERED 
(
	[idChuyenVien] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[P_KHAMBENH]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[P_KHAMBENH](
	[idKhamBenh] [char](10) NOT NULL,
	[NgayKham] [datetime] NULL,
	[QuaTrinhBenhLy] [nvarchar](100) NULL,
	[TrieuChungDiKem] [nvarchar](100) NULL,
	[ToanTrang] [nvarchar](100) NULL,
	[ChiSoMach] [int] NULL,
	[ChiSoNhietDo] [int] NULL,
	[ChiSoHuyetAp] [nchar](10) NULL,
	[ChiSoNhipTho] [int] NULL,
	[ChiSoSpO2] [int] NULL,
	[TieuHoa] [nvarchar](100) NULL,
	[TimMach] [nvarchar](100) NULL,
	[HoHap] [nvarchar](100) NULL,
	[HuyetAp] [nvarchar](100) NULL,
	[ThanTietNieu] [nvarchar](100) NULL,
	[ThanKinh] [nvarchar](100) NULL,
	[Khac] [nvarchar](100) NULL,
	[TienLuong] [nvarchar](100) NULL,
	[DieuTriNgoaiTru] [bit] NULL,
	[NhapVien] [bit] NULL,
	[ChuyenKhamChuyenKhoaKhac] [bit] NULL,
	[ChanDoanPhanBiet] [nvarchar](100) NULL,
	[GhiChu] [nvarchar](100) NULL,
	[NhanXet] [nvarchar](100) NULL,
	[LoiDan] [nvarchar](100) NULL,
	[NgayTaiKham] [date] NULL,
	[LyDoTaiKham] [nvarchar](100) NULL,
	[idHoSo] [char](10) NULL,
	[idDKKhamBenh] [char](10) NULL,
	[idCanLamSang] [char](10) NULL,
	[idVacxin] [char](10) NULL,
	[idICDChanDoan] [char](10) NULL,
	[idICDKetLuan] [char](10) NULL,
	[idNguoiDung] [char](10) NULL,
	[idLoaiKham] [char](10) NULL,
 CONSTRAINT [PK_P_KHAMBENH_1] PRIMARY KEY CLUSTERED 
(
	[idKhamBenh] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[P_XETNGHIEM]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[P_XETNGHIEM](
	[idXetNghiem] [char](10) NOT NULL,
	[NgayLap] [datetime] NULL,
	[GiaTriKetQua_So] [decimal](18, 4) NULL,
	[GiaTriKetQua_Text] [nvarchar](100) NULL,
	[DVTKetQua] [nvarchar](50) NULL,
	[KhoangThamChieuApDung] [nvarchar](100) NULL,
	[idNguoiDung] [char](10) NULL,
	[idKhamBenh] [char](10) NULL,
	[idCanLamSang] [char](10) NULL,
 CONSTRAINT [PK_P_XETNGHIEM] PRIMARY KEY CLUSTERED 
(
	[idXetNghiem] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PDK_KHAMBENH]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PDK_KHAMBENH](
	[idDKKhambenh] [char](10) NOT NULL,
	[NgayLap] [datetime] NULL,
	[LyDoKham] [nvarchar](200) NULL,
	[ThoiGianBatDauTrieuChung] [date] NULL,
	[PhongKhamSo] [nvarchar](10) NULL,
	[TienSuBenhLyBanThan] [nvarchar](200) NULL,
	[TienSuBenhLyGiaDinh] [nvarchar](200) NULL,
	[ThuocDangSuDung] [nvarchar](200) NULL,
	[KhamBHYT] [bit] NULL,
	[TrangThai] [nvarchar](50) NULL,
	[idBenhNhan] [char](10) NULL,
	[idKhoa] [char](10) NULL,
	[idNguoiDung] [char](10) NULL,
 CONSTRAINT [PK__PDK_KHAM__957E87FC9EC35477] PRIMARY KEY CLUSTERED 
(
	[idDKKhambenh] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PDK_TIEMCHUNG]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PDK_TIEMCHUNG](
	[idDKTiemChung] [char](10) NOT NULL,
	[NgayLap] [date] NULL,
	[NgayTiem] [date] NULL,
	[HoTenNguoiTiem] [nvarchar](50) NULL,
	[GioiTinh] [nvarchar](50) NULL,
	[NgaySinh] [date] NULL,
	[DiaChi] [nvarchar](50) NULL,
	[SDT] [int] NULL,
	[HoTenNguoiLienHe] [nvarchar](50) NULL,
	[QuanHe] [nvarchar](50) NULL,
	[SDT_LienHe] [nvarchar](20) NULL,
	[Email] [nvarchar](50) NULL,
	[ThoiGianTiem] [nvarchar](50) NULL,
	[LieuTiem] [nvarchar](50) NULL,
	[GhiChu] [nvarchar](50) NULL,
	[TrangThai] [nvarchar](50) NULL,
	[idVacXin] [char](10) NULL,
	[idNguoiDung] [char](10) NULL,
	[idBenhNhan] [char](10) NULL,
 CONSTRAINT [PK_PKD_TIEMCHUNG] PRIMARY KEY CLUSTERED 
(
	[idDKTiemChung] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PNK_DUOCPHAM]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PNK_DUOCPHAM](
	[idNhapKhoDuocPham] [char](10) NOT NULL,
	[NgayLap] [date] NULL,
	[NgayNhapKho] [date] NULL,
	[TrangThai] [nvarchar](50) NULL,
	[NgayPheDuyet] [date] NULL,
	[idNguoiPheDuyet] [char](10) NULL,
	[idNCC] [char](10) NULL,
	[idNguoiDung] [char](10) NULL,
 CONSTRAINT [PK__PNK_DUOC__A5B4E43332351B80] PRIMARY KEY CLUSTERED 
(
	[idNhapKhoDuocPham] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PYC_CAPGIUONG]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PYC_CAPGIUONG](
	[idYeuCauCapGiuong] [char](10) NOT NULL,
	[NgayLap] [datetime] NULL,
	[PheDuyet] [bit] NULL,
	[NgayPheDuyet] [datetime] NULL,
	[SoLuong] [int] NULL,
	[LyDo] [nvarchar](200) NULL,
	[idNguoiDung] [char](10) NULL,
	[idKhoa] [char](10) NULL,
 CONSTRAINT [PK_PYC_CapGiuong] PRIMARY KEY CLUSTERED 
(
	[idYeuCauCapGiuong] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PYC_CHUYENCA]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PYC_CHUYENCA](
	[idYeuCauChuyenCa] [char](10) NOT NULL,
	[NgayChuyen] [date] NULL,
	[LyDo] [nvarchar](200) NULL,
	[TrangThai] [nvarchar](50) NULL,
	[NgayYeuCau] [date] NULL,
	[NgayPheDuyet] [datetime] NULL,
	[GhiChuPheDuyet] [nvarchar](50) NULL,
	[CanBuCa] [bit] NULL,
	[GhiChu] [nvarchar](50) NULL,
	[idNhanVienCu] [char](10) NULL,
	[idNhanVienMoi] [char](10) NULL,
	[idCaLamViecGoc] [char](10) NULL,
	[idCaLamViecMoi] [char](10) NULL,
	[idCaLamViecBu] [char](10) NULL,
	[idNguoiDung] [char](10) NULL,
	[idNguoiPheDuyet] [char](10) NULL,
 CONSTRAINT [PK_CHUYENCA] PRIMARY KEY CLUSTERED 
(
	[idYeuCauChuyenCa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PYC_CHUYENVIEN]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PYC_CHUYENVIEN](
	[idYeuCauChuyenVien] [char](10) NOT NULL,
	[NgayLap] [date] NULL,
	[LyDo] [nvarchar](200) NULL,
	[CoSoChuyenDen] [nvarchar](200) NULL,
	[DiaChi] [nvarchar](200) NULL,
	[NgayChuyen] [date] NULL,
	[TrangThai] [nvarchar](50) NULL,
	[NgayPheDuyet] [date] NULL,
	[GhiChu] [nvarchar](200) NULL,
	[MucDo] [nvarchar](50) NULL,
	[YkienPheDuyet] [nvarchar](200) NULL,
	[idBacSiPhuTrach] [char](10) NULL,
	[idNguoiPheDuyet] [char](10) NULL,
	[idBenhNhan] [char](10) NULL,
	[idNguoiDung] [char](10) NULL,
 CONSTRAINT [PK__PYC_CHUY__DA60153823B5F7E4] PRIMARY KEY CLUSTERED 
(
	[idYeuCauChuyenVien] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PYC_DUOCPHAM]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PYC_DUOCPHAM](
	[idYeuCauDuocPham] [char](10) NOT NULL,
	[NgayLap] [date] NULL,
	[NgayYeuCau] [date] NULL,
	[TrangThai] [nvarchar](50) NULL,
	[NgayPheDuyet] [char](10) NULL,
	[idNguoiDung] [char](10) NULL,
	[idNguoiPheDuyet] [char](10) NULL,
 CONSTRAINT [PK_PYC_DUOCpHAM] PRIMARY KEY CLUSTERED 
(
	[idYeuCauDuocPham] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QUYEN]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QUYEN](
	[idQuyen] [char](10) NOT NULL,
	[TenQuyen] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Quyen] PRIMARY KEY CLUSTERED 
(
	[idQuyen] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QUYETDINH]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QUYETDINH](
	[idQD] [char](10) NOT NULL,
	[NgayBanHanh] [date] NULL,
	[NgayHieuLuc] [date] NULL,
	[File] [varchar](50) NULL,
	[idKhoa] [char](10) NULL,
 CONSTRAINT [PK__QUYETDIN__9DB82094DBAD6EA5] PRIMARY KEY CLUSTERED 
(
	[idQD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[THIETBI]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[THIETBI](
	[idThietBi] [char](10) NOT NULL,
	[TenTB] [nvarchar](100) NULL,
	[LoaiTB] [nvarchar](100) NULL,
	[DVT] [nvarchar](20) NULL,
	[DonGiaMua] [decimal](18, 2) NULL,
 CONSTRAINT [PK__THIETBI__920D1504935AB0D6] PRIMARY KEY CLUSTERED 
(
	[idThietBi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VACXIN]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VACXIN](
	[idVacXin] [char](10) NOT NULL,
	[TenVacXin] [nvarchar](100) NULL,
	[NgayNhap] [date] NULL,
	[SoLuong] [int] NULL,
	[HSD] [date] NULL,
	[LieuTiem] [nvarchar](50) NULL,
	[DonGiaMua] [decimal](18, 0) NULL,
	[DonGiaBan] [decimal](18, 0) NULL,
	[GhiChu] [nvarchar](50) NULL,
	[idNCC] [char](10) NULL,
	[idLoaiVX] [char](10) NULL,
 CONSTRAINT [PK_VACXIN] PRIMARY KEY CLUSTERED 
(
	[idVacXin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VATTU]    Script Date: 28/06/2025 9:42:21 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VATTU](
	[idVatTu] [char](10) NOT NULL,
	[SoLuong] [int] NULL,
	[TenVatTu] [nvarchar](50) NULL,
	[DVT] [nvarchar](50) NULL,
	[DonGiaMua] [decimal](18, 0) NULL,
	[TrangThai] [nvarchar](50) NULL,
	[GhiChu] [nvarchar](50) NULL,
	[NgayNhap] [date] NULL,
	[idKhoa] [char](10) NULL,
 CONSTRAINT [PK_VATTU] PRIMARY KEY CLUSTERED 
(
	[idVatTu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BENHNHAN]  WITH CHECK ADD  CONSTRAINT [FK_BENHNHAN_LOAI_BHYT] FOREIGN KEY([idLoaiBHYT])
REFERENCES [dbo].[LOAI_BHYT] ([idLoaiBHYT])
GO
ALTER TABLE [dbo].[BENHNHAN] CHECK CONSTRAINT [FK_BENHNHAN_LOAI_BHYT]
GO
ALTER TABLE [dbo].[CALAMVIEC]  WITH CHECK ADD  CONSTRAINT [FK_CALAMVIEC_CALAMVIEC] FOREIGN KEY([idCaLamViec])
REFERENCES [dbo].[CALAMVIEC] ([idCaLamViec])
GO
ALTER TABLE [dbo].[CALAMVIEC] CHECK CONSTRAINT [FK_CALAMVIEC_CALAMVIEC]
GO
ALTER TABLE [dbo].[CALAMVIEC]  WITH CHECK ADD  CONSTRAINT [FK_CALAMVIEC_KHOA] FOREIGN KEY([idKhoa])
REFERENCES [dbo].[KHOA] ([idKhoa])
GO
ALTER TABLE [dbo].[CALAMVIEC] CHECK CONSTRAINT [FK_CALAMVIEC_KHOA]
GO
ALTER TABLE [dbo].[CALAMVIEC]  WITH CHECK ADD  CONSTRAINT [FK_CALAMVIEC_LICH_TONGTHE] FOREIGN KEY([idLichTongThe])
REFERENCES [dbo].[LICH_TONGTHE] ([idLichTongThe])
GO
ALTER TABLE [dbo].[CALAMVIEC] CHECK CONSTRAINT [FK_CALAMVIEC_LICH_TONGTHE]
GO
ALTER TABLE [dbo].[CANLAMSANG]  WITH CHECK ADD  CONSTRAINT [FK_CANLAMSANG_CANLAMSANG] FOREIGN KEY([idCanLamSangCha])
REFERENCES [dbo].[CANLAMSANG] ([idCanLamSang])
GO
ALTER TABLE [dbo].[CANLAMSANG] CHECK CONSTRAINT [FK_CANLAMSANG_CANLAMSANG]
GO
ALTER TABLE [dbo].[CAPPHAT_THIETBI]  WITH CHECK ADD  CONSTRAINT [FK_CAPPHAT_THIETBI_KHOA] FOREIGN KEY([idKhoa])
REFERENCES [dbo].[KHOA] ([idKhoa])
GO
ALTER TABLE [dbo].[CAPPHAT_THIETBI] CHECK CONSTRAINT [FK_CAPPHAT_THIETBI_KHOA]
GO
ALTER TABLE [dbo].[CAPPHAT_THIETBI]  WITH CHECK ADD  CONSTRAINT [FK_CAPPHAT_THIETBI_THIETBI] FOREIGN KEY([idThietBi])
REFERENCES [dbo].[THIETBI] ([idThietBi])
GO
ALTER TABLE [dbo].[CAPPHAT_THIETBI] CHECK CONSTRAINT [FK_CAPPHAT_THIETBI_THIETBI]
GO
ALTER TABLE [dbo].[CHAMCONG]  WITH CHECK ADD  CONSTRAINT [FK_CHAMCONG_KHOA] FOREIGN KEY([idKhoa])
REFERENCES [dbo].[KHOA] ([idKhoa])
GO
ALTER TABLE [dbo].[CHAMCONG] CHECK CONSTRAINT [FK_CHAMCONG_KHOA]
GO
ALTER TABLE [dbo].[CHAMCONG]  WITH CHECK ADD  CONSTRAINT [FK_CHAMCONG_NHANVIEN] FOREIGN KEY([idNhanVien])
REFERENCES [dbo].[NHANVIEN] ([idNhanVien])
GO
ALTER TABLE [dbo].[CHAMCONG] CHECK CONSTRAINT [FK_CHAMCONG_NHANVIEN]
GO
ALTER TABLE [dbo].[CT_DONTHUOC]  WITH CHECK ADD  CONSTRAINT [FK_CT_DONTHUOC_DONTHUOC] FOREIGN KEY([idDonThuoc])
REFERENCES [dbo].[DON_THUOC] ([idDonThuoc])
GO
ALTER TABLE [dbo].[CT_DONTHUOC] CHECK CONSTRAINT [FK_CT_DONTHUOC_DONTHUOC]
GO
ALTER TABLE [dbo].[CT_DONTHUOC]  WITH CHECK ADD  CONSTRAINT [FK_CT_DONTHUOC_DUOCPHAM] FOREIGN KEY([idDuocPham])
REFERENCES [dbo].[DUOCPHAM] ([idDuocPham])
GO
ALTER TABLE [dbo].[CT_DONTHUOC] CHECK CONSTRAINT [FK_CT_DONTHUOC_DUOCPHAM]
GO
ALTER TABLE [dbo].[CT_GOI_VACXIN]  WITH CHECK ADD  CONSTRAINT [FK_CT_GOI_VACXIN_GOI_VACXIN] FOREIGN KEY([idGoiVX])
REFERENCES [dbo].[GOI_VACXIN] ([idGoiVX])
GO
ALTER TABLE [dbo].[CT_GOI_VACXIN] CHECK CONSTRAINT [FK_CT_GOI_VACXIN_GOI_VACXIN]
GO
ALTER TABLE [dbo].[CT_GOI_VACXIN]  WITH CHECK ADD  CONSTRAINT [FK_CT_GOI_VACXIN_VACXIN] FOREIGN KEY([idVacXin])
REFERENCES [dbo].[VACXIN] ([idVacXin])
GO
ALTER TABLE [dbo].[CT_GOI_VACXIN] CHECK CONSTRAINT [FK_CT_GOI_VACXIN_VACXIN]
GO
ALTER TABLE [dbo].[CT_HOADONTIEMCHUNG]  WITH CHECK ADD  CONSTRAINT [FK_CT_HOADONTIEMCHUNG_HOADON_TIEMCHUNG] FOREIGN KEY([idHoaDonTiemChung])
REFERENCES [dbo].[HOADON_TIEMCHUNG] ([idHoaDonTiemChung])
GO
ALTER TABLE [dbo].[CT_HOADONTIEMCHUNG] CHECK CONSTRAINT [FK_CT_HOADONTIEMCHUNG_HOADON_TIEMCHUNG]
GO
ALTER TABLE [dbo].[CT_HOADONTIEMCHUNG]  WITH CHECK ADD  CONSTRAINT [FK_CT_HOADONTIEMCHUNG_VACXIN] FOREIGN KEY([idVacxin])
REFERENCES [dbo].[VACXIN] ([idVacXin])
GO
ALTER TABLE [dbo].[CT_HOADONTIEMCHUNG] CHECK CONSTRAINT [FK_CT_HOADONTIEMCHUNG_VACXIN]
GO
ALTER TABLE [dbo].[CT_HOADONVIENPHI]  WITH CHECK ADD  CONSTRAINT [FK_CT_HOADONVIENPHI_CANLAMSANG] FOREIGN KEY([idCanLamSang])
REFERENCES [dbo].[CANLAMSANG] ([idCanLamSang])
GO
ALTER TABLE [dbo].[CT_HOADONVIENPHI] CHECK CONSTRAINT [FK_CT_HOADONVIENPHI_CANLAMSANG]
GO
ALTER TABLE [dbo].[CT_HOADONVIENPHI]  WITH CHECK ADD  CONSTRAINT [FK_CT_HOADONVIENPHI_NOITRU] FOREIGN KEY([idNoiTru])
REFERENCES [dbo].[NOITRU] ([idNoiTru])
GO
ALTER TABLE [dbo].[CT_HOADONVIENPHI] CHECK CONSTRAINT [FK_CT_HOADONVIENPHI_NOITRU]
GO
ALTER TABLE [dbo].[CT_KHTHUCHI]  WITH CHECK ADD  CONSTRAINT [FK_CT_KHTHUCHI_KH_THUCHITAICHINH] FOREIGN KEY([idKeHoachTaiChinh])
REFERENCES [dbo].[KH_THUCHITAICHINH] ([idKeHoachTaiChinh])
GO
ALTER TABLE [dbo].[CT_KHTHUCHI] CHECK CONSTRAINT [FK_CT_KHTHUCHI_KH_THUCHITAICHINH]
GO
ALTER TABLE [dbo].[CT_NHAPKHODUOCPHAM]  WITH CHECK ADD  CONSTRAINT [FK_CT_NHAPKHODUOCPHAM_PNK_DUOCPHAM] FOREIGN KEY([idNhapKhoDuocPham])
REFERENCES [dbo].[PNK_DUOCPHAM] ([idNhapKhoDuocPham])
GO
ALTER TABLE [dbo].[CT_NHAPKHODUOCPHAM] CHECK CONSTRAINT [FK_CT_NHAPKHODUOCPHAM_PNK_DUOCPHAM]
GO
ALTER TABLE [dbo].[CT_YEUCAUDUOCPHAM]  WITH CHECK ADD  CONSTRAINT [FK_CT_YEUCAUDUOCPHAM_DUOCPHAM] FOREIGN KEY([idDuocPham])
REFERENCES [dbo].[DUOCPHAM] ([idDuocPham])
GO
ALTER TABLE [dbo].[CT_YEUCAUDUOCPHAM] CHECK CONSTRAINT [FK_CT_YEUCAUDUOCPHAM_DUOCPHAM]
GO
ALTER TABLE [dbo].[CT_YEUCAUDUOCPHAM]  WITH CHECK ADD  CONSTRAINT [FK_CT_YEUCAUDUOCPHAM_LOAI_DUOCPHAM] FOREIGN KEY([idLoaiDuocPham])
REFERENCES [dbo].[LOAI_DUOCPHAM] ([idLoaiDuocPham])
GO
ALTER TABLE [dbo].[CT_YEUCAUDUOCPHAM] CHECK CONSTRAINT [FK_CT_YEUCAUDUOCPHAM_LOAI_DUOCPHAM]
GO
ALTER TABLE [dbo].[CT_YEUCAUDUOCPHAM]  WITH CHECK ADD  CONSTRAINT [FK_CT_YEUCAUDUOCPHAM_PYC_DUOCPHAM] FOREIGN KEY([idYeuCauDuocPham])
REFERENCES [dbo].[PYC_DUOCPHAM] ([idYeuCauDuocPham])
GO
ALTER TABLE [dbo].[CT_YEUCAUDUOCPHAM] CHECK CONSTRAINT [FK_CT_YEUCAUDUOCPHAM_PYC_DUOCPHAM]
GO
ALTER TABLE [dbo].[DEXUAT]  WITH CHECK ADD  CONSTRAINT [FK_DEXUAT_KHOA] FOREIGN KEY([idKhoa])
REFERENCES [dbo].[KHOA] ([idKhoa])
GO
ALTER TABLE [dbo].[DEXUAT] CHECK CONSTRAINT [FK_DEXUAT_KHOA]
GO
ALTER TABLE [dbo].[DICHVU]  WITH CHECK ADD  CONSTRAINT [FK_DICHVU_KHOA] FOREIGN KEY([idKhoa])
REFERENCES [dbo].[KHOA] ([idKhoa])
GO
ALTER TABLE [dbo].[DICHVU] CHECK CONSTRAINT [FK_DICHVU_KHOA]
GO
ALTER TABLE [dbo].[DICHVU]  WITH CHECK ADD  CONSTRAINT [FK_DICHVU_LOAI_DV] FOREIGN KEY([idKhoa])
REFERENCES [dbo].[LOAI_DV] ([idLoaiDV])
GO
ALTER TABLE [dbo].[DICHVU] CHECK CONSTRAINT [FK_DICHVU_LOAI_DV]
GO
ALTER TABLE [dbo].[DON_NGHIPHEP]  WITH CHECK ADD  CONSTRAINT [FK_DON_NGHIPHEP_NHANVIEN2] FOREIGN KEY([idNhanVienThayThe])
REFERENCES [dbo].[NHANVIEN] ([idNhanVien])
GO
ALTER TABLE [dbo].[DON_NGHIPHEP] CHECK CONSTRAINT [FK_DON_NGHIPHEP_NHANVIEN2]
GO
ALTER TABLE [dbo].[DON_NGHIPHEP]  WITH CHECK ADD  CONSTRAINT [FK_DON_NGHIPHEP_NHANVIEN3] FOREIGN KEY([idNhanVien])
REFERENCES [dbo].[NHANVIEN] ([idNhanVien])
GO
ALTER TABLE [dbo].[DON_NGHIPHEP] CHECK CONSTRAINT [FK_DON_NGHIPHEP_NHANVIEN3]
GO
ALTER TABLE [dbo].[DON_THUOC]  WITH CHECK ADD  CONSTRAINT [FK_DON_THUOC_P_KHAMBENH] FOREIGN KEY([idKhamBenh])
REFERENCES [dbo].[P_KHAMBENH] ([idKhamBenh])
GO
ALTER TABLE [dbo].[DON_THUOC] CHECK CONSTRAINT [FK_DON_THUOC_P_KHAMBENH]
GO
ALTER TABLE [dbo].[DUOCPHAM]  WITH CHECK ADD  CONSTRAINT [FK_DUOCPHAM_LOAI_DUOCPHAM] FOREIGN KEY([idLoaiDuocPham])
REFERENCES [dbo].[LOAI_DUOCPHAM] ([idLoaiDuocPham])
GO
ALTER TABLE [dbo].[DUOCPHAM] CHECK CONSTRAINT [FK_DUOCPHAM_LOAI_DUOCPHAM]
GO
ALTER TABLE [dbo].[DUOCPHAM]  WITH CHECK ADD  CONSTRAINT [FK_DUOCPHAM_NCC] FOREIGN KEY([idNCC])
REFERENCES [dbo].[NCC] ([idNCC])
GO
ALTER TABLE [dbo].[DUOCPHAM] CHECK CONSTRAINT [FK_DUOCPHAM_NCC]
GO
ALTER TABLE [dbo].[GIUONG]  WITH CHECK ADD  CONSTRAINT [FK_GIUONG_BENHNHAN] FOREIGN KEY([idBenhNhan])
REFERENCES [dbo].[BENHNHAN] ([idBenhNhan])
GO
ALTER TABLE [dbo].[GIUONG] CHECK CONSTRAINT [FK_GIUONG_BENHNHAN]
GO
ALTER TABLE [dbo].[HOADON_DIENNUOC]  WITH CHECK ADD  CONSTRAINT [FK_HOADON_DIENNUOC_KHOA] FOREIGN KEY([idKhoa])
REFERENCES [dbo].[KHOA] ([idKhoa])
GO
ALTER TABLE [dbo].[HOADON_DIENNUOC] CHECK CONSTRAINT [FK_HOADON_DIENNUOC_KHOA]
GO
ALTER TABLE [dbo].[HOADON_TAMUNGVIENPHI]  WITH CHECK ADD  CONSTRAINT [FK_HOADON_TAMUNGVIENPHI_BENHNHAN] FOREIGN KEY([idBenhNhan])
REFERENCES [dbo].[BENHNHAN] ([idBenhNhan])
GO
ALTER TABLE [dbo].[HOADON_TAMUNGVIENPHI] CHECK CONSTRAINT [FK_HOADON_TAMUNGVIENPHI_BENHNHAN]
GO
ALTER TABLE [dbo].[HOADON_VIENPHI]  WITH CHECK ADD  CONSTRAINT [FK_HOADON_VIENPHI_P_KHAMBENH] FOREIGN KEY([idKhamBenh])
REFERENCES [dbo].[P_KHAMBENH] ([idKhamBenh])
GO
ALTER TABLE [dbo].[HOADON_VIENPHI] CHECK CONSTRAINT [FK_HOADON_VIENPHI_P_KHAMBENH]
GO
ALTER TABLE [dbo].[HOSOBENHAN]  WITH CHECK ADD  CONSTRAINT [FK_HOSOBENHAN_BENHNHAN] FOREIGN KEY([idBenhNhan])
REFERENCES [dbo].[BENHNHAN] ([idBenhNhan])
GO
ALTER TABLE [dbo].[HOSOBENHAN] CHECK CONSTRAINT [FK_HOSOBENHAN_BENHNHAN]
GO
ALTER TABLE [dbo].[KH_THUCHITAICHINH]  WITH CHECK ADD  CONSTRAINT [FK_KH_THUCHITAICHINH_KHOA] FOREIGN KEY([idKhoa])
REFERENCES [dbo].[KHOA] ([idKhoa])
GO
ALTER TABLE [dbo].[KH_THUCHITAICHINH] CHECK CONSTRAINT [FK_KH_THUCHITAICHINH_KHOA]
GO
ALTER TABLE [dbo].[KHOA]  WITH CHECK ADD  CONSTRAINT [FK_KHOA_LOAIKHOA] FOREIGN KEY([idLoaiKhoa])
REFERENCES [dbo].[LOAIKHOA] ([idLoaiKhoa])
GO
ALTER TABLE [dbo].[KHOA] CHECK CONSTRAINT [FK_KHOA_LOAIKHOA]
GO
ALTER TABLE [dbo].[LICHSUTRUYCAP]  WITH CHECK ADD  CONSTRAINT [FK_LICHSUTRUYCAP_NGUOIDUNG] FOREIGN KEY([idNguoiDung])
REFERENCES [dbo].[NGUOIDUNG] ([idNguoiDung])
GO
ALTER TABLE [dbo].[LICHSUTRUYCAP] CHECK CONSTRAINT [FK_LICHSUTRUYCAP_NGUOIDUNG]
GO
ALTER TABLE [dbo].[LOAI_DV]  WITH CHECK ADD  CONSTRAINT [FK_LOAI_DVKHAMBENH_KHOA] FOREIGN KEY([idKhoa])
REFERENCES [dbo].[KHOA] ([idKhoa])
GO
ALTER TABLE [dbo].[LOAI_DV] CHECK CONSTRAINT [FK_LOAI_DVKHAMBENH_KHOA]
GO
ALTER TABLE [dbo].[MAU_LICHLAMVIEC]  WITH CHECK ADD  CONSTRAINT [FK_MAU_LICHLAMVIEC_KHOA1] FOREIGN KEY([idKhoa])
REFERENCES [dbo].[KHOA] ([idKhoa])
GO
ALTER TABLE [dbo].[MAU_LICHLAMVIEC] CHECK CONSTRAINT [FK_MAU_LICHLAMVIEC_KHOA1]
GO
ALTER TABLE [dbo].[MAUCT_LICH]  WITH CHECK ADD  CONSTRAINT [FK_MAUCT_LICH_MAU_LICHLAMVIEC] FOREIGN KEY([idMauLich])
REFERENCES [dbo].[MAU_LICHLAMVIEC] ([idMauLich])
GO
ALTER TABLE [dbo].[MAUCT_LICH] CHECK CONSTRAINT [FK_MAUCT_LICH_MAU_LICHLAMVIEC]
GO
ALTER TABLE [dbo].[NGHIPHEP_ANHHUONGCA]  WITH CHECK ADD  CONSTRAINT [FK_NGHIPHEP_ANHHUONGCA_CALAMVIEC] FOREIGN KEY([idCaLamViec])
REFERENCES [dbo].[CALAMVIEC] ([idCaLamViec])
GO
ALTER TABLE [dbo].[NGHIPHEP_ANHHUONGCA] CHECK CONSTRAINT [FK_NGHIPHEP_ANHHUONGCA_CALAMVIEC]
GO
ALTER TABLE [dbo].[NGHIPHEP_ANHHUONGCA]  WITH CHECK ADD  CONSTRAINT [FK_NGHIPHEP_ANHHUONGCA_DON_NGHIPHEP] FOREIGN KEY([idNghiPhep])
REFERENCES [dbo].[DON_NGHIPHEP] ([idNghiPhep])
GO
ALTER TABLE [dbo].[NGHIPHEP_ANHHUONGCA] CHECK CONSTRAINT [FK_NGHIPHEP_ANHHUONGCA_DON_NGHIPHEP]
GO
ALTER TABLE [dbo].[NGUOIDUNG]  WITH CHECK ADD  CONSTRAINT [FK_NGUOIDUNG_NHOM_NGUOIDUNG] FOREIGN KEY([idNhom])
REFERENCES [dbo].[NHOM_NGUOIDUNG] ([idNhom])
GO
ALTER TABLE [dbo].[NGUOIDUNG] CHECK CONSTRAINT [FK_NGUOIDUNG_NHOM_NGUOIDUNG]
GO
ALTER TABLE [dbo].[NHANVIEN]  WITH CHECK ADD  CONSTRAINT [FK_NHANVIEN_NHANVIEN] FOREIGN KEY([idNhanVien])
REFERENCES [dbo].[NHANVIEN] ([idNhanVien])
GO
ALTER TABLE [dbo].[NHANVIEN] CHECK CONSTRAINT [FK_NHANVIEN_NHANVIEN]
GO
ALTER TABLE [dbo].[NHATKYTHAYDOI]  WITH CHECK ADD  CONSTRAINT [FK_NHATKYTHAYDOI_LICHSUTRUYCAP] FOREIGN KEY([idLichSu])
REFERENCES [dbo].[LICHSUTRUYCAP] ([idLichSu])
GO
ALTER TABLE [dbo].[NHATKYTHAYDOI] CHECK CONSTRAINT [FK_NHATKYTHAYDOI_LICHSUTRUYCAP]
GO
ALTER TABLE [dbo].[NHOM_NGUOIDUNG]  WITH CHECK ADD  CONSTRAINT [FK_NHOM_NGUOIDUNG_QUYEN] FOREIGN KEY([idQuyen])
REFERENCES [dbo].[QUYEN] ([idQuyen])
GO
ALTER TABLE [dbo].[NHOM_NGUOIDUNG] CHECK CONSTRAINT [FK_NHOM_NGUOIDUNG_QUYEN]
GO
ALTER TABLE [dbo].[P_CHUYENVIEN]  WITH CHECK ADD  CONSTRAINT [FK_P_CHUYENVIEN_PYC_CHUYENVIEN] FOREIGN KEY([idYeuCauChuyenVien])
REFERENCES [dbo].[PYC_CHUYENVIEN] ([idYeuCauChuyenVien])
GO
ALTER TABLE [dbo].[P_CHUYENVIEN] CHECK CONSTRAINT [FK_P_CHUYENVIEN_PYC_CHUYENVIEN]
GO
ALTER TABLE [dbo].[P_KHAMBENH]  WITH CHECK ADD  CONSTRAINT [FK_P_KHAMBENH_ICD] FOREIGN KEY([idICDChanDoan])
REFERENCES [dbo].[ICD] ([idICD])
GO
ALTER TABLE [dbo].[P_KHAMBENH] CHECK CONSTRAINT [FK_P_KHAMBENH_ICD]
GO
ALTER TABLE [dbo].[P_KHAMBENH]  WITH CHECK ADD  CONSTRAINT [FK_P_KHAMBENH_ICD1] FOREIGN KEY([idICDKetLuan])
REFERENCES [dbo].[ICD] ([idICD])
GO
ALTER TABLE [dbo].[P_KHAMBENH] CHECK CONSTRAINT [FK_P_KHAMBENH_ICD1]
GO
ALTER TABLE [dbo].[P_KHAMBENH]  WITH CHECK ADD  CONSTRAINT [FK_P_KHAMBENH_LOAIKHAM] FOREIGN KEY([idLoaiKham])
REFERENCES [dbo].[LOAIKHAM] ([idLoaiKham])
GO
ALTER TABLE [dbo].[P_KHAMBENH] CHECK CONSTRAINT [FK_P_KHAMBENH_LOAIKHAM]
GO
ALTER TABLE [dbo].[P_KHAMBENH]  WITH CHECK ADD  CONSTRAINT [FK_P_KHAMBENH_PDK_KHAMBENH] FOREIGN KEY([idDKKhamBenh])
REFERENCES [dbo].[PDK_KHAMBENH] ([idDKKhambenh])
GO
ALTER TABLE [dbo].[P_KHAMBENH] CHECK CONSTRAINT [FK_P_KHAMBENH_PDK_KHAMBENH]
GO
ALTER TABLE [dbo].[P_KHAMBENH]  WITH CHECK ADD  CONSTRAINT [FK_P_KHAMBENH_VACXIN] FOREIGN KEY([idVacxin])
REFERENCES [dbo].[VACXIN] ([idVacXin])
GO
ALTER TABLE [dbo].[P_KHAMBENH] CHECK CONSTRAINT [FK_P_KHAMBENH_VACXIN]
GO
ALTER TABLE [dbo].[P_XETNGHIEM]  WITH CHECK ADD  CONSTRAINT [FK_P_XETNGHIEM_CANLAMSANG] FOREIGN KEY([idCanLamSang])
REFERENCES [dbo].[CANLAMSANG] ([idCanLamSang])
GO
ALTER TABLE [dbo].[P_XETNGHIEM] CHECK CONSTRAINT [FK_P_XETNGHIEM_CANLAMSANG]
GO
ALTER TABLE [dbo].[P_XETNGHIEM]  WITH CHECK ADD  CONSTRAINT [FK_P_XETNGHIEM_P_KHAMBENH] FOREIGN KEY([idKhamBenh])
REFERENCES [dbo].[P_KHAMBENH] ([idKhamBenh])
GO
ALTER TABLE [dbo].[P_XETNGHIEM] CHECK CONSTRAINT [FK_P_XETNGHIEM_P_KHAMBENH]
GO
ALTER TABLE [dbo].[PDK_KHAMBENH]  WITH CHECK ADD  CONSTRAINT [FK_PDK_KHAMBENH_BENHNHAN] FOREIGN KEY([idBenhNhan])
REFERENCES [dbo].[BENHNHAN] ([idBenhNhan])
GO
ALTER TABLE [dbo].[PDK_KHAMBENH] CHECK CONSTRAINT [FK_PDK_KHAMBENH_BENHNHAN]
GO
ALTER TABLE [dbo].[PDK_KHAMBENH]  WITH CHECK ADD  CONSTRAINT [FK_PDK_KHAMBENH_KHOA] FOREIGN KEY([idKhoa])
REFERENCES [dbo].[KHOA] ([idKhoa])
GO
ALTER TABLE [dbo].[PDK_KHAMBENH] CHECK CONSTRAINT [FK_PDK_KHAMBENH_KHOA]
GO
ALTER TABLE [dbo].[PDK_TIEMCHUNG]  WITH CHECK ADD  CONSTRAINT [FK_PDK_TIEMCHUNG_VACXIN] FOREIGN KEY([idVacXin])
REFERENCES [dbo].[VACXIN] ([idVacXin])
GO
ALTER TABLE [dbo].[PDK_TIEMCHUNG] CHECK CONSTRAINT [FK_PDK_TIEMCHUNG_VACXIN]
GO
ALTER TABLE [dbo].[PYC_CAPGIUONG]  WITH CHECK ADD  CONSTRAINT [FK_PYC_CAPGIUONG_KHOA] FOREIGN KEY([idKhoa])
REFERENCES [dbo].[KHOA] ([idKhoa])
GO
ALTER TABLE [dbo].[PYC_CAPGIUONG] CHECK CONSTRAINT [FK_PYC_CAPGIUONG_KHOA]
GO
ALTER TABLE [dbo].[PYC_CHUYENCA]  WITH CHECK ADD  CONSTRAINT [FK_PYC_CHUYENCA_CALAMVIEC] FOREIGN KEY([idCaLamViecGoc])
REFERENCES [dbo].[CALAMVIEC] ([idCaLamViec])
GO
ALTER TABLE [dbo].[PYC_CHUYENCA] CHECK CONSTRAINT [FK_PYC_CHUYENCA_CALAMVIEC]
GO
ALTER TABLE [dbo].[PYC_CHUYENCA]  WITH CHECK ADD  CONSTRAINT [FK_PYC_CHUYENCA_CALAMVIEC1] FOREIGN KEY([idCaLamViecMoi])
REFERENCES [dbo].[CALAMVIEC] ([idCaLamViec])
GO
ALTER TABLE [dbo].[PYC_CHUYENCA] CHECK CONSTRAINT [FK_PYC_CHUYENCA_CALAMVIEC1]
GO
ALTER TABLE [dbo].[PYC_CHUYENCA]  WITH CHECK ADD  CONSTRAINT [FK_PYC_CHUYENCA_CALAMVIEC2] FOREIGN KEY([idCaLamViecBu])
REFERENCES [dbo].[CALAMVIEC] ([idCaLamViec])
GO
ALTER TABLE [dbo].[PYC_CHUYENCA] CHECK CONSTRAINT [FK_PYC_CHUYENCA_CALAMVIEC2]
GO
ALTER TABLE [dbo].[PYC_CHUYENCA]  WITH CHECK ADD  CONSTRAINT [FK_PYC_CHUYENCA_NHANVIEN] FOREIGN KEY([idNhanVienCu])
REFERENCES [dbo].[NHANVIEN] ([idNhanVien])
GO
ALTER TABLE [dbo].[PYC_CHUYENCA] CHECK CONSTRAINT [FK_PYC_CHUYENCA_NHANVIEN]
GO
ALTER TABLE [dbo].[PYC_CHUYENCA]  WITH CHECK ADD  CONSTRAINT [FK_PYC_CHUYENCA_NHANVIEN1] FOREIGN KEY([idNhanVienMoi])
REFERENCES [dbo].[NHANVIEN] ([idNhanVien])
GO
ALTER TABLE [dbo].[PYC_CHUYENCA] CHECK CONSTRAINT [FK_PYC_CHUYENCA_NHANVIEN1]
GO
ALTER TABLE [dbo].[PYC_CHUYENVIEN]  WITH CHECK ADD  CONSTRAINT [FK_PYC_CHUYENVIEN_BENHNHAN] FOREIGN KEY([idBenhNhan])
REFERENCES [dbo].[BENHNHAN] ([idBenhNhan])
GO
ALTER TABLE [dbo].[PYC_CHUYENVIEN] CHECK CONSTRAINT [FK_PYC_CHUYENVIEN_BENHNHAN]
GO
ALTER TABLE [dbo].[QUYETDINH]  WITH CHECK ADD  CONSTRAINT [FK_QUYETDINH_KHOA] FOREIGN KEY([idKhoa])
REFERENCES [dbo].[KHOA] ([idKhoa])
GO
ALTER TABLE [dbo].[QUYETDINH] CHECK CONSTRAINT [FK_QUYETDINH_KHOA]
GO
ALTER TABLE [dbo].[VACXIN]  WITH CHECK ADD  CONSTRAINT [FK_VACXIN_LOAI_VACXIN] FOREIGN KEY([idLoaiVX])
REFERENCES [dbo].[LOAI_VACXIN] ([idLoaiVX])
GO
ALTER TABLE [dbo].[VACXIN] CHECK CONSTRAINT [FK_VACXIN_LOAI_VACXIN]
GO
ALTER TABLE [dbo].[VACXIN]  WITH CHECK ADD  CONSTRAINT [FK_VACXIN_NCC] FOREIGN KEY([idNCC])
REFERENCES [dbo].[NCC] ([idNCC])
GO
ALTER TABLE [dbo].[VACXIN] CHECK CONSTRAINT [FK_VACXIN_NCC]
GO
ALTER TABLE [dbo].[VATTU]  WITH CHECK ADD  CONSTRAINT [FK_VATTU_KHOA] FOREIGN KEY([idKhoa])
REFERENCES [dbo].[KHOA] ([idKhoa])
GO
ALTER TABLE [dbo].[VATTU] CHECK CONSTRAINT [FK_VATTU_KHOA]
GO

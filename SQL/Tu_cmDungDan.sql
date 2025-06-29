--MB01. PHIẾU YÊU CẦU CẤP GIƯỜNG
SELECT 
    PYC.idYeuCauCapGiuong,
    K.TenKhoa AS KhoaYeuCau,
    PYC.SoLuong,
    PYC.LyDo,
    ND.HoTen AS NguoiYeuCau,
    ND.ChucVu,
    PYC.NgayLap
FROM 
    PYC_CAPGIUONG PYC
    INNER JOIN KHOA K ON PYC.idKhoa = K.idKhoa
    INNER JOIN NGUOIDUNG ND ON PYC.idNguoiDung = ND.idNguoiDung
WHERE 
    PYC.idYeuCauCapGiuong='YCCG0001'
ORDER BY 
    PYC.NgayLap DESC;

--MB02. BÁO CÁO THỐNG KÊ TỔNG SỐ GIƯỜNG BỆNH THEO KHOA
SELECT 
    G.idGiuong,
    G.TrangThai,
    G.GhiChu
FROM 
    GIUONG G
    INNER JOIN KHOA K ON G.idKhoa = K.idKhoa
WHERE 
    K.TenKhoa = N'Khoa Cấp cứu'
ORDER BY 
    G.idGiuong;

 
SELECT 
    COUNT(*) AS TongSoGiuong,
    SUM(CASE WHEN G.TrangThai = N'Trống' THEN 1 ELSE 0 END) AS SoGiuongTrong,
    SUM(CASE WHEN G.TrangThai = N'Đang sử dụng' THEN 1 ELSE 0 END) AS SoGiuongDaDung,
    SUM(CASE WHEN G.TrangThai = N'Bảo trì' THEN 1 ELSE 0 END) AS SoGiuongDangSuaChua,

    K.TenKhoa,
    GETDATE() AS NgayLap 
FROM 
    GIUONG G
    INNER JOIN KHOA K ON G.idKhoa = K.idKhoa
WHERE 
    K.TenKhoa = N'Khoa Cấp cứu'
GROUP BY 
    K.TenKhoa; 

--MB04: BÁO CÁO THỐNG KÊ GIƯỜNG BỆNH DỰ TRỮ TRONG KHO
SELECT 
    G.idGiuong AS MaGiuong,
    G.TrangThai,
    G.GhiChu
FROM 
    GIUONG G
WHERE 
    G.Kho = 1  
ORDER BY 
    G.idGiuong

SELECT 
    COUNT(*) AS TongSoGiuongDuTru,
    SUM(CASE WHEN G.TrangThai = N'Sẵn sàng' THEN 1 ELSE 0 END) AS SoGiuongSanSang,
    SUM(CASE WHEN G.TrangThai = N'Bảo trì' THEN 1 ELSE 0 END) AS SoGiuongDangSuaChua,
    GETDATE() AS NgayLap
FROM 
    GIUONG G
WHERE 
    G.Kho = 1

--MB5: PHIẾU KÊ ĐƠN THUỐC

SELECT 
    DT.idDonThuoc AS SoPhieu,
    DT.NgayLap,
    BN.HoTen AS TenBenhNhan,
    BN.DiaChi,
    BN.BHYT AS SoTheBHYT,
    KETLUAN.TenBenh AS ChanDoan,
    PKB.TrieuChungDiKem AS BenhKemTheo,
    ND.HoTen AS BacSyKeDon
FROM 
    DON_THUOC DT
    INNER JOIN P_KHAMBENH PKB ON DT.idKhamBenh = PKB.idKhamBenh
    INNER JOIN PDK_KHAMBENH PDKKB ON PKB.idDKKhamBenh = PDKKB.idDKKhambenh
    INNER JOIN BENHNHAN BN ON PDKKB.idBenhNhan = BN.idBenhNhan
    INNER JOIN NGUOIDUNG ND ON DT.idNguoiDung = ND.idNguoiDung
    LEFT JOIN ICD KETLUAN ON PKB.idICDKetLuan = KETLUAN.idICD
WHERE 
    DT.idDonThuoc = 'DT0001';

SELECT 
    DP.TenDuocPham AS TenThuoc,
    DP.HoatChat AS HoatChat,
    DP.DonVi AS DonVi,
    CT.SoLuong,
    CT.LieuDung AS CachUong
FROM 
    CT_DONTHUOC CT
    INNER JOIN DUOCPHAM DP ON CT.idDuocPham = DP.idDuocPham
WHERE 
    CT.idDonThuoc = 'DT0001';

--MB6: HÓA ĐƠN THANH TOÁN CHO BỆNH NHÂN CÓ BHYT
SELECT 
    DT.idDonThuoc AS SoPhieu,
    DT.NgayLap,
    BN.HoTen AS NguoiMua,
    BN.DiaChi,
    BN.SDT,
    BN.BHYT AS SoTheBHYT,
    PKB.ChanDoanPhanBiet AS Chandoan,
    ND.HoTen AS BacSyKeDon,
    CASE 
        WHEN BN.BHYT IS NOT NULL AND BN.BHYT != '' AND PDKKB.KhamBHYT = 0 
        THEN N'Khám BHYT'
        ELSE N'Không khám BHYT'
    END AS TrangThaiBHYT
FROM 
    DON_THUOC DT
    INNER JOIN P_KHAMBENH PKB ON DT.idKhamBenh = PKB.idKhamBenh
    INNER JOIN PDK_KHAMBENH PDKKB ON PKB.idDKKhamBenh = PDKKB.idDKKhambenh
    INNER JOIN BENHNHAN BN ON PDKKB.idBenhNhan = BN.idBenhNhan
    INNER JOIN NGUOIDUNG ND ON DT.idNguoiDung = ND.idNguoiDung
    LEFT JOIN ICD KETLUAN ON PKB.idICDKetLuan = KETLUAN.idICD
WHERE 
    DT.idDonThuoc = 'DT0001';

SELECT 
    DP.TenDuocPham AS TenHangHoa,
    DP.DonVi AS DonVi, 
    CT.SoLuong,
    DP.DonGiaBan AS DonGia,
    (CT.SoLuong * DP.DonGiaBan) AS ThanhTien
FROM 
    CT_DONTHUOC CT
    INNER JOIN DUOCPHAM DP ON CT.idDuocPham = DP.idDuocPham
WHERE 
    CT.idDonThuoc = 'DT0001';

WITH TONG_TIEN AS (
    SELECT 
        BN.idBenhNhan,
        SUM(CT.SoLuong * DP.DonGiaBan) AS TongTien
    FROM 
        DON_THUOC DT
        INNER JOIN P_KHAMBENH PKB ON DT.idKhamBenh = PKB.idKhamBenh
        INNER JOIN PDK_KHAMBENH PDKKB ON PKB.idDKKhamBenh = PDKKB.idDKKhambenh
        INNER JOIN BENHNHAN BN ON PDKKB.idBenhNhan = BN.idBenhNhan
        INNER JOIN CT_DONTHUOC CT ON DT.idDonThuoc = CT.idDonThuoc
        INNER JOIN DUOCPHAM DP ON CT.idDuocPham = DP.idDuocPham
    WHERE 
        DT.idDonThuoc = 'DT0001'
    GROUP BY BN.idBenhNhan
),
TYLE AS (
    SELECT 
        BN.idBenhNhan,
        CAST(LB.MucHuong AS DECIMAL(5,2)) AS TyLe
    FROM BENHNHAN BN
    LEFT JOIN LOAI_BHYT LB ON BN.idLoaiBHYT = LB.idLoaiBHYT
)
SELECT 
    TT.TongTien,
    TT.TongTien * ISNULL(TY.TyLe, 0) AS SoTienBHYTChiTra,
    TT.TongTien - TT.TongTien * ISNULL(TY.TyLe, 0) AS SoTienBenhNhanTra
FROM TONG_TIEN TT
LEFT JOIN TYLE TY ON TT.idBenhNhan = TY.idBenhNhan;

--MB7: HÓA ĐƠN THANH TOÁN CHO BỆNH NHÂN KHÔNG BHYT
SELECT 
    DT.idDonThuoc AS SoPhieu,
    DT.NgayLap,
    BN.HoTen AS NguoiMua,
    BN.DiaChi,
    BN.SDT,
    BN.BHYT AS SoTheBHYT,
    PKB.ChanDoanPhanBiet AS Chandoan,
    ND.HoTen AS BacSyKeDon,
    CASE 
        WHEN BN.BHYT IS NOT NULL AND BN.BHYT != '' AND PDKKB.KhamBHYT = 0 
        THEN N'Khám BHYT'
        ELSE N'Không khám BHYT'
    END AS TrangThaiBHYT
FROM 
    DON_THUOC DT
    INNER JOIN P_KHAMBENH PKB ON DT.idKhamBenh = PKB.idKhamBenh
    INNER JOIN PDK_KHAMBENH PDKKB ON PKB.idDKKhamBenh = PDKKB.idDKKhambenh
    INNER JOIN BENHNHAN BN ON PDKKB.idBenhNhan = BN.idBenhNhan
    INNER JOIN NGUOIDUNG ND ON DT.idNguoiDung = ND.idNguoiDung
    LEFT JOIN ICD KETLUAN ON PKB.idICDKetLuan = KETLUAN.idICD
WHERE 
    DT.idDonThuoc = 'DT0003';

SELECT 
    DP.TenDuocPham AS TenHangHoa,
    DP.DonVi AS DonVi, 
    CT.SoLuong,
    DP.DonGiaBan AS DonGia,
    (CT.SoLuong * DP.DonGiaBan) AS ThanhTien
FROM 
    CT_DONTHUOC CT
    INNER JOIN DUOCPHAM DP ON CT.idDuocPham = DP.idDuocPham
WHERE 
    CT.idDonThuoc = 'DT0003';

SELECT 
    SUM(CT.SoLuong * DP.DonGiaBan) AS TongTien
FROM 
    CT_DONTHUOC CT
    INNER JOIN DUOCPHAM DP ON CT.idDuocPham = DP.idDuocPham
WHERE 
    CT.idDonThuoc = 'DT0003';


--MB8: BÁO CÁO THU CHI TÀI CHÍNH GỬI BỘ PHÂN KẾ TOÁN KIỂM TRA
WITH Thu AS (

    SELECT N'Nội trú' AS NoiDung,
           SUM(DATEDIFF(DAY, NT.NgayNhapVien, NT.NgayRaVien) * NT.DonGiaNgay) AS SoTien
    FROM HOADON_VIENPHI HV
    JOIN CT_HOADONVIENPHI CT ON HV.idVienPhi = CT.idVienPhi
    JOIN NOITRU NT ON CT.idNoiTru = NT.idNoiTru
    WHERE YEAR(HV.NgayLap) = 2025 
      AND NT.NgayRaVien IS NOT NULL

    UNION ALL

    SELECT LK.TenLoaiKham AS NoiDung,
           SUM(LK.ChiPhi) AS SoTien
    FROM P_KHAMBENH PKB
    JOIN LOAIKHAM LK ON PKB.idLoaiKham = LK.idLoaiKham
    WHERE YEAR(PKB.NgayKham) = 2025
    GROUP BY LK.TenLoaiKham

    UNION ALL

    SELECT CLS.TenCLS + N' (' + CLS.TenLoaiCLS + N')' AS NoiDung,
           SUM(CLS.ChiPhi) AS SoTien
    FROM HOADON_VIENPHI HV
    JOIN CT_HOADONVIENPHI CT ON HV.idVienPhi = CT.idVienPhi
    JOIN CANLAMSANG CLS ON CT.idCanLamSang = CLS.idCanLamSang
    WHERE YEAR(HV.NgayLap) = 2025 
    GROUP BY CLS.TenCLS, CLS.TenLoaiCLS

    UNION ALL

    SELECT N'Tiêm chủng' AS NoiDung,
           SUM(V.DonGiaBan * CT.SoLuong) AS SoTien
    FROM HOADON_TIEMCHUNG TC
    JOIN CT_HOADONTIEMCHUNG CT ON TC.idHoaDonTiemChung = CT.idHoaDonTiemChung
    JOIN VACXIN V ON CT.idVacxin = V.idVacXin
    WHERE YEAR(TC.NgayLap) = 2025 

    UNION ALL

    SELECT N'Thuốc' AS NoiDung,
           SUM(DP.DonGiaBan * CT.SoLuong) AS SoTien
    FROM DON_THUOC DT
    JOIN CT_DONTHUOC CT ON DT.idDonThuoc = CT.idDonThuoc
    JOIN DUOCPHAM DP ON CT.idDuocPham = DP.idDuocPham
    WHERE YEAR(DT.NgayLap) = 2025
),

Chi AS (

    SELECT N'Thuốc' AS NoiDung,
           SUM(CT.DonGiaMua * CT.SoLuong) AS SoTien
    FROM CT_NHAPKHODUOCPHAM CT
    JOIN PNK_DUOCPHAM PNK ON CT.idNhapKhoDuocPham = PNK.idNhapKhoDuocPham
    WHERE YEAR(PNK.NgayLap) = 2025

    UNION ALL

    SELECT N'Chi mua vật tư y tế' AS NoiDung,
           SUM(VT.DonGiaMua * VT.SoLuong) AS SoTien
    FROM VATTU VT
    WHERE YEAR(VT.NgayNhap) = 2025

    UNION ALL

    SELECT N'Chi tiền điện nước' AS NoiDung,
           SUM(DN.DonGia * DN.SanLuong) AS SoTien
    FROM HOADON_DIENNUOC DN
    WHERE YEAR(DN.NgayLap) = 2025

    UNION ALL

    SELECT N'Chi lương nhân viên' AS NoiDung,
           SUM(ROUND(((NV.HeSoLuong * 2340000) / 24.0) * (CC.NgayCong + CC.CoPhep), 0)) AS SoTien
    FROM CHAMCONG CC
    JOIN NHANVIEN NV ON CC.idNhanVien = NV.idNhanVien
    WHERE YEAR(CC.NgayChamCong) = 2025
),

KetQua AS (
    
	SELECT 
        COALESCE(Thu.NoiDung, Chi.NoiDung) AS NoiDung,
        ISNULL(Thu.SoTien, 0) AS Thu,
        ISNULL(Chi.SoTien, 0) AS Chi,
        ISNULL(Thu.SoTien, 0) - ISNULL(Chi.SoTien, 0) AS ChenhLech,
        0 AS ThuTu 
    FROM Thu
    FULL OUTER JOIN Chi ON Thu.NoiDung = Chi.NoiDung

    UNION ALL

    SELECT 
        N'TỔNG CỘNG' AS NoiDung,
        SUM(ISNULL(Thu.SoTien, 0)) AS Thu,
        SUM(ISNULL(Chi.SoTien, 0)) AS Chi,
        SUM(ISNULL(Thu.SoTien, 0)) - SUM(ISNULL(Chi.SoTien, 0)) AS ChenhLech,
        1 AS ThuTu -- Để đưa xuống cuối
    FROM Thu
    FULL OUTER JOIN Chi ON Thu.NoiDung = Chi.NoiDung
)

SELECT 
    NoiDung,
    Thu,
    Chi,
    ChenhLech
FROM KetQua
ORDER BY ThuTu, NoiDung;

--BM9: KẾ HOẠCH THU CHI TÀI CHÍNH GỬI PHÊ DUYỆT
SELECT 
    KH.idKeHoachTaiChinh AS MaKeHoach,
    KH.NamKeHoach,
    ND.HoTen AS NguoiLap,
    CONVERT(varchar, KH.NgayLap, 103) AS NgayLap,
    CT.NoiDung,
    ISNULL(CT.SoTienThu, 0) AS Thu,
    ISNULL(CT.SoTienChi, 0) AS Chi,
    ISNULL(CT.SoTienThu, 0) - ISNULL(CT.SoTienChi, 0) AS ChenhLech
FROM KH_THUCHITAICHINH KH
LEFT JOIN CT_KHTHUCHI CT ON KH.idKeHoachTaiChinh = CT.idKeHoachTaiChinh
LEFT JOIN NGUOIDUNG ND ON KH.idNguoiDung = ND.idNguoiDung
WHERE KH.idKeHoachTaiChinh = 'KHTC0001' AND CT.NoiDung IS NOT NULL

UNION ALL

SELECT 
    KH.idKeHoachTaiChinh AS MaKeHoach,
    KH.NamKeHoach,
    ND.HoTen AS NguoiLap,
    CONVERT(varchar, KH.NgayLap, 103) AS NgayLap,
    N'TỔNG CỘNG' AS NoiDung,
    SUM(ISNULL(CT.SoTienThu, 0)) AS Thu,
    SUM(ISNULL(CT.SoTienChi, 0)) AS Chi,
    SUM(ISNULL(CT.SoTienThu, 0)) - SUM(ISNULL(CT.SoTienChi, 0)) AS ChenhLech
FROM KH_THUCHITAICHINH KH
LEFT JOIN CT_KHTHUCHI CT ON KH.idKeHoachTaiChinh = CT.idKeHoachTaiChinh
LEFT JOIN NGUOIDUNG ND ON KH.idNguoiDung = ND.idNguoiDung
WHERE KH.idKeHoachTaiChinh = 'KHTC0001' AND CT.NoiDung IS NOT NULL
GROUP BY KH.idKeHoachTaiChinh, KH.NamKeHoach, ND.HoTen, KH.NgayLap;



--BM10:BẢNG CHẤM CÔNG NHÂN VIÊN
SELECT 
    ROW_NUMBER() OVER (ORDER BY NV.idNhanVien) AS STT,
    NV.idNhanVien AS MaNhanVien,
    NV.HoTen AS TenNhanVien,
    NV.ChucVu,
    CC.NgayCong AS SoNgayLamViec,
    CC.NgayNghi AS SoNgayNghi,
    CASE 
        WHEN CC.CoPhep = 1 THEN N'Có phép'
        ELSE N'Không phép'
    END AS TrangThaiNghi,
    CC.LyDoNghi AS LyDo
FROM CHAMCONG CC
JOIN NHANVIEN NV ON CC.idNhanVien = NV.idNhanVien
WHERE MONTH(CC.NgayChamCong) = 10 AND YEAR(CC.NgayChamCong) = 2024
ORDER BY NV.idNhanVien;

--BM11: PHIẾU THU VIỆN PHÍ (Bộ phận Tiếp nhận Bệnh nhân)
SELECT 
    HV.idVienPhi AS MaPhieu,           
    BN.HoTen AS HoTenNguoiNop,         
    BN.idBenhNhan AS MaBenhNhan,       
    HS.idHoSo AS SoHoSo,               
    HV.NgayLap AS NgayThu,             
    HV.HinhThucThanhToan AS HinhThucThanhToan, 
    ND.HoTen AS NguoiThuTien           
FROM HOADON_VIENPHI HV
JOIN P_KHAMBENH PKB ON HV.idKhamBenh = PKB.idKhamBenh
JOIN HOSOBENHAN HS ON PKB.idHoSo = HS.idHoSo
JOIN BENHNHAN BN ON HS.idBenhNhan = BN.idBenhNhan
LEFT JOIN NGUOIDUNG ND ON HV.idNguoiDung = ND.idNguoiDung
WHERE HV.idVienPhi = 'HDVP0001';

DECLARE @idVienPhi CHAR(10) = 'HDVP0001';
DECLARE @HinhThucThanhToan NVARCHAR(50);
DECLARE @SoTienTamUng MONEY;

SELECT @HinhThucThanhToan = HinhThucThanhToan
FROM HOADON_VIENPHI
WHERE idVienPhi = @idVienPhi;

SELECT 
    @SoTienTamUng = ISNULL(TU.SoTienTamUng, 0)
FROM HOADON_VIENPHI VP
LEFT JOIN HOADON_TAMUNGVIENPHI TU ON VP.idTamUngVienPhi = TU.idTamUngVienPhi
WHERE VP.idVienPhi = @idVienPhi;

SELECT 
    N'Nội trú' AS NoiDung,
    N'Ngày' AS DonVi,
    ISNULL(DATEDIFF(DAY, NT.NgayNhapVien, NT.NgayRaVien), 0) AS SoLuong,
    ISNULL(NT.DonGiaNgay, 0) AS DonGia,
    ISNULL(DATEDIFF(DAY, NT.NgayNhapVien, NT.NgayRaVien) * NT.DonGiaNgay, 0) AS ThanhTien,
    @HinhThucThanhToan AS HinhThucThanhToan,
    CAST(NULL AS MONEY) AS SoTienTamUng,
    CAST(NULL AS MONEY) AS SoTienThu
FROM CT_HOADONVIENPHI CT
JOIN NOITRU NT ON CT.idNoiTru = NT.idNoiTru
WHERE CT.idVienPhi = @idVienPhi
  AND CT.idNoiTru IS NOT NULL

UNION ALL

SELECT 
    N'Khám bệnh' AS NoiDung,
    N'Lần' AS DonVi,
    1 AS SoLuong,
    ISNULL(LK.ChiPhi, 0) AS DonGia,
    ISNULL(LK.ChiPhi, 0) AS ThanhTien,
    @HinhThucThanhToan AS HinhThucThanhToan,
    CAST(NULL AS MONEY) AS SoTienTamUng,
    CAST(NULL AS MONEY) AS SoTienThu
FROM HOADON_VIENPHI HV
JOIN P_KHAMBENH KB ON HV.idKhamBenh = KB.idKhamBenh
JOIN LOAIKHAM LK ON KB.idLoaiKham = LK.idLoaiKham
WHERE HV.idVienPhi = @idVienPhi

UNION ALL

SELECT 
    ISNULL(CLS.TenCLS + N' (' + CLS.TenLoaiCLS + N')', N'Cận lâm sàng') AS NoiDung,
    N'Lần' AS DonVi,
    1 AS SoLuong,
    ISNULL(CLS.ChiPhi, 0) AS DonGia,
    ISNULL(CLS.ChiPhi, 0) AS ThanhTien,
    @HinhThucThanhToan AS HinhThucThanhToan,
    CAST(NULL AS MONEY) AS SoTienTamUng,
    CAST(NULL AS MONEY) AS SoTienThu
FROM CT_HOADONVIENPHI CT
JOIN CANLAMSANG CLS ON CT.idCanLamSang = CLS.idCanLamSang
WHERE CT.idVienPhi = @idVienPhi
  AND CT.idCanLamSang IS NOT NULL

UNION ALL

SELECT 
    N'Tổng cộng' AS NoiDung,
    N'' AS DonVi,
    CAST(NULL AS INT) AS SoLuong,
    CAST(NULL AS MONEY) AS DonGia,
    (
        ISNULL((
            SELECT SUM(DATEDIFF(DAY, NT.NgayNhapVien, NT.NgayRaVien) * NT.DonGiaNgay)
            FROM CT_HOADONVIENPHI CT
            JOIN NOITRU NT ON CT.idNoiTru = NT.idNoiTru
            WHERE CT.idVienPhi = @idVienPhi AND CT.idNoiTru IS NOT NULL
        ), 0)
        +
        ISNULL((
            SELECT LK.ChiPhi
            FROM HOADON_VIENPHI HV
            JOIN P_KHAMBENH KB ON HV.idKhamBenh = KB.idKhamBenh
            JOIN LOAIKHAM LK ON KB.idLoaiKham = LK.idLoaiKham
            WHERE HV.idVienPhi = @idVienPhi
        ), 0)
        +
        ISNULL((
            SELECT SUM(CLS.ChiPhi)
            FROM CT_HOADONVIENPHI CT
            JOIN CANLAMSANG CLS ON CT.idCanLamSang = CLS.idCanLamSang
            WHERE CT.idVienPhi = @idVienPhi AND CT.idCanLamSang IS NOT NULL
        ), 0)
    ) AS ThanhTien,
    @HinhThucThanhToan AS HinhThucThanhToan,
    @SoTienTamUng AS SoTienTamUng,
    (
        ISNULL((
            SELECT SUM(DATEDIFF(DAY, NT.NgayNhapVien, NT.NgayRaVien) * NT.DonGiaNgay)
            FROM CT_HOADONVIENPHI CT
            JOIN NOITRU NT ON CT.idNoiTru = NT.idNoiTru
            WHERE CT.idVienPhi = @idVienPhi AND CT.idNoiTru IS NOT NULL
        ), 0)
        +
        ISNULL((
            SELECT LK.ChiPhi
            FROM HOADON_VIENPHI HV
            JOIN P_KHAMBENH KB ON HV.idKhamBenh = KB.idKhamBenh
            JOIN LOAIKHAM LK ON KB.idLoaiKham = LK.idLoaiKham
            WHERE HV.idVienPhi = @idVienPhi
        ), 0)
        +
        ISNULL((
            SELECT SUM(CLS.ChiPhi)
            FROM CT_HOADONVIENPHI CT
            JOIN CANLAMSANG CLS ON CT.idCanLamSang = CLS.idCanLamSang
            WHERE CT.idVienPhi = @idVienPhi AND CT.idCanLamSang IS NOT NULL
        ), 0)
        - ISNULL(@SoTienTamUng, 0)
    ) AS SoTienThu


--BM12: BẢNG TỔNG HỢP CHI VẬT TƯ Y TẾ
DECLARE @Thang INT = 6; 
DECLARE @Nam INT = 2025;

SELECT 
    ROW_NUMBER() OVER (ORDER BY VT.TenVatTu) AS STT,
    VT.TenVatTu AS [Tên vật tư],
    VT.DVT AS [Đơn vị],
    SUM(VT.SoLuong) AS [Số lượng],
    ISNULL(AVG(VT.DonGiaMua), 0) AS [Đơn giá],
    SUM(VT.SoLuong * VT.DonGiaMua) AS [Thành tiền]
FROM VATTU VT
WHERE MONTH(VT.NgayNhap) = @Thang AND YEAR(VT.NgayNhap) = @Nam
GROUP BY VT.TenVatTu, VT.DVT

UNION ALL

SELECT 
    NULL AS STT,
    N'Tổng cộng',
    '',
    NULL,
    NULL,
    SUM(VT.SoLuong * VT.DonGiaMua)
FROM VATTU VT
WHERE MONTH(VT.NgayNhap) = @Thang AND YEAR(VT.NgayNhap) = @Nam;

--BM13: HÓA ĐƠN THU ĐIỆN/NƯỚC
SELECT 
    HDN.idDienNuoc AS [Mã số],

    N'Bệnh viện Đa khoa Bạch Mai' AS [Tên doanh nghiệp],
    N'123 Phố Giải Phóng, Phường Mai, Đống Đa, Hà Nội' AS [Địa chỉ],
    N'0100100200' AS [Mã số thuế],

    N'Bệnh viện Đa khoa Bạch Mai' AS [Tên chủ sở hữu cho thuê địa điểm],
    N'123 Phố Giải Phóng, Phường Mai, Đống Đa, Hà Nội' AS [Địa chỉ thuê],

    FORMAT(HDN.TuNgay, 'dd/MM/yyyy') AS [Ngày đầu kỳ],
    FORMAT(HDN.DenNgay, 'dd/MM/yyyy') AS [Ngày cuối kỳ],

    HDN.NhaCungCap AS [Đơn vị cung cấp],

    HDN.SanLuong AS [Sản lượng],
    HDN.DonGia AS [Đơn giá],
    (HDN.SanLuong * HDN.DonGia) AS [Thành tiền],

    ROUND(HDN.SanLuong * HDN.DonGia * 1.1, 0) AS [Thành tiền gồm GTGT],

    HDN.NgayLap AS [Ngày lập]

FROM HOADON_DIENNUOC HDN
WHERE HDN.idDienNuoc = 'HDDN0001';

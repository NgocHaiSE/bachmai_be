--===== QUẢN LÝ DƯỢC PHẨM =====
--  ====================================================== PHIEU YEU CAU =============================================
DECLARE @MaPhieuYeuCau CHAR(10) = 'YCDP0001'
SELECT
    pyc.idYeuCauDuocPham         AS SoLuuTru,
    pyc.idYeuCauDuocPham         AS MaPhieuYeuCau,
    pyc.NgayYeuCau               AS NgayYeuCau,
    nguoiyeucau.HoTen            AS NguoiYeuCau,
    ncc.TenNCC					 AS NhaCungCap,

    ct.idDuocPham,
    ISNULL(dp.TenDuocPham, ct.TenDuocPham) AS TenDuocPham,
    ISNULL(ld.TenLoaiDuocPham, N'Thuốc mới') AS LoaiDuocPham,
    ct.SoLuong,
    ct.GhiChu,
	pyc.NgayYeuCau               AS NgayLap,
	pyc.NgayPheDuyet			 AS NgayPheDuyet,
    truongkhoa.HoTen             AS TruongKhoaPheDuyet

FROM PYC_DUOCPHAM pyc
JOIN NGUOIDUNG nguoiyeucau ON pyc.idNguoiDung = nguoiyeucau.idNguoiDung
LEFT JOIN NGUOIDUNG truongkhoa ON pyc.idNguoiPheDuyet = truongkhoa.idNguoiDung
JOIN CT_YEUCAUDUOCPHAM ct ON pyc.idYeuCauDuocPham = ct.idYeuCauDuocPham
LEFT JOIN DUOCPHAM dp ON ct.idDuocPham = dp.idDuocPham
LEFT JOIN LOAI_DUOCPHAM ld ON ct.idLoaiDuocPham = ld.idLoaiDuocPham
LEFT JOIN NCC ncc ON dp.idNCC = ncc.idNCC
WHERE pyc.idYeuCauDuocPham = @MaPhieuYeuCau;

SELECT 
    SUM(SoLuong) AS TongSoLuong
FROM CT_YEUCAUDUOCPHAM
WHERE idYeuCauDuocPham = 'YCDP0001'


--  ====================================================== PHIẾU NHẬP =============================================
DECLARE @MaPhieuNhap CHAR(10)
SET @MaPhieuNhap = 'NKDP0001'

SELECT 
    pnk.idNhapKhoDuocPham AS SoLuuTru,
    pnk.NgayNhapKho AS NgayNhap,
    pnk.idNhapKhoDuocPham AS MaPhieuNhap,  
    ncc.TenNCC AS NhaCungCap,
    nd.HoTen AS NguoiNhap,
    ct.idDuocPham AS MaDuocPham,
    dp.TenDuocPham AS TenDuocPham,
    ct.SoLuong AS SoLuongNhap,
    ct.DonGiaMua AS DonGia,
    (ct.SoLuong * ct.DonGiaMua) AS ThanhTien,
    ldp.TenLoaiDuocPham AS LoaiDuocPham,
    ct.HanSuDung AS HanSuDung,
    ct.GhiChu AS GhiChu,
    pnk.TrangThai AS TrangThai,
    pnk.NgayLap AS NgayLap,
    pnk.NgayPheDuyet AS NgayPheDuyet,
    pd.HoTen AS NguoiPheDuyet
FROM PNK_DUOCPHAM pnk
JOIN CT_NHAPKHODUOCPHAM ct ON pnk.idNhapKhoDuocPham = ct.idNhapKhoDuocPham
LEFT JOIN DUOCPHAM dp ON ct.idDuocPham = dp.idDuocPham
LEFT JOIN LOAI_DUOCPHAM ldp ON dp.idLoaiDuocPham = ldp.idLoaiDuocPham
LEFT JOIN NCC ncc ON pnk.idNCC = ncc.idNCC
LEFT JOIN NGUOIDUNG nd ON pnk.idNguoiDung = nd.idNguoiDung
LEFT JOIN NGUOIDUNG pd ON pnk.idNguoiPheDuyet = pd.idNguoiDung
WHERE pnk.idNhapKhoDuocPham = @MaPhieuNhap

SELECT 
    SUM(ct.SoLuong) AS TongSoLuong,
    SUM(ct.SoLuong * ct.DonGiaMua) AS TongTien
FROM CT_NHAPKHODUOCPHAM ct
WHERE ct.idNhapKhoDuocPham = 'NKDP0001'; 


--  ====================================================== THỐNG KÊ DƯỢC PHẨM NHẬP =============================================
DECLARE @TuNgay DATE = '2023-11-01';
DECLARE @DenNgay DATE = '2023-11-30';
DECLARE @NguoiLap CHAR(10) = 'ND0001';

SELECT 
    CONVERT(date, GETDATE()) AS NgayLapBaoCao,
    nd.HoTen AS NguoiLapBaoCao,
    ct.idDuocPham AS MaDuocPham,
    dp.TenDuocPham AS TenDuocPham,
    ct.SoLuong AS SoLuongNhap,
    ct.NhaSX AS NhaSanXuat,
	pnk.NgayNhapKho AS NgayNhap,
    ldp.TenLoaiDuocPham AS LoaiDuocPham,
    ct.GhiChu AS GhiChu
FROM PNK_DUOCPHAM pnk
JOIN CT_NHAPKHODUOCPHAM ct ON pnk.idNhapKhoDuocPham = ct.idNhapKhoDuocPham
LEFT JOIN DUOCPHAM dp ON ct.idDuocPham = dp.idDuocPham
LEFT JOIN LOAI_DUOCPHAM ldp ON dp.idLoaiDuocPham = ldp.idLoaiDuocPham
CROSS JOIN NGUOIDUNG nd
WHERE pnk.NgayNhapKho BETWEEN @TuNgay AND @DenNgay
  AND nd.idNguoiDung = @NguoiLap;

DECLARE @TuNgay_ DATE = '2023-11-01';
DECLARE @DenNgay_ DATE = '2023-11-30';

SELECT 
    SUM(ct.SoLuong) AS TongSoLuongNhap
FROM PNK_DUOCPHAM pnk
JOIN CT_NHAPKHODUOCPHAM ct ON pnk.idNhapKhoDuocPham = ct.idNhapKhoDuocPham
WHERE pnk.NgayNhapKho BETWEEN @TuNgay_ AND @DenNgay_;


--  ====================================================== THỐNG KÊ DƯỢC PHẨM TRONG KHO =============================================
SELECT 
    CONVERT(date, GETDATE()) AS NgayLapBaoCao, 
    nd.HoTen AS NguoiLapBaoCao,                 
    dp.idDuocPham AS MaDuocPham,
    dp.TenDuocPham AS TenDuocPham,
    dp.SoLuong AS SoLuong,
    dp.NhaSX AS NhaSanXuat,
    dp.HanSuDung AS HanSuDung,
    ldp.TenLoaiDuocPham AS LoaiDuocPham,
    CASE 
        WHEN dp.HanSuDung < GETDATE() THEN N'Hết hạn'
        WHEN dp.HanSuDung BETWEEN GETDATE() AND DATEADD(DAY, 30, GETDATE()) THEN N'Gần hết hạn'
        ELSE N'Còn hạn'
    END AS TinhTrang,
    dp.MoTa AS GhiChu
FROM DUOCPHAM dp
LEFT JOIN LOAI_DUOCPHAM ldp ON dp.idLoaiDuocPham = ldp.idLoaiDuocPham
CROSS JOIN NGUOIDUNG nd  
WHERE nd.idNguoiDung = 'ND0001'; 

SELECT 
    SUM(dp.SoLuong) AS TongSoLuong
FROM DUOCPHAM dp;


--===== QUẢN LÝ HÓA ĐƠN THANH TOÁN =====
--  ====================================================== HÓA ĐƠN THANH TOÁN =============================================
DECLARE @idVienPhi CHAR(10) = 'HDVP0001';

WITH ChiPhiCT AS (
    -- 1. Khám bệnh (LOAIKHAM)
    SELECT lk.ChiPhi AS ThanhTien
    FROM HOADON_VIENPHI h
    JOIN P_KHAMBENH kb ON h.idKhamBenh = kb.idKhamBenh
    JOIN LOAIKHAM lk ON kb.idLoaiKham = lk.idLoaiKham
    WHERE h.idVienPhi = @idVienPhi

    UNION ALL
    -- 2. Cận lâm sàng từ CANLAMSANG 
    SELECT cls.ChiPhi
    FROM CT_HOADONVIENPHI ct
    JOIN CANLAMSANG cls ON ct.idCanLamSang = cls.idCanLamSang
    WHERE ct.idVienPhi = @idVienPhi

    UNION ALL
    -- 3. Thuốc 
    SELECT ct2.SoLuong * dp.DonGiaBan
    FROM HOADON_VIENPHI h
    JOIN P_KHAMBENH kb ON h.idKhamBenh = kb.idKhamBenh
    JOIN DON_THUOC dt ON dt.idKhamBenh = kb.idKhamBenh
    JOIN CT_DONTHUOC ct2 ON dt.idDonThuoc = ct2.idDonThuoc
    JOIN DUOCPHAM dp ON ct2.idDuocPham = dp.idDuocPham
    WHERE h.idVienPhi = @idVienPhi

    UNION ALL
    -- 4. Nội trú
    SELECT DATEDIFF(DAY, nt.NgayNhapVien, ISNULL(nt.NgayRaVien, GETDATE())) * nt.DonGiaNgay
    FROM CT_HOADONVIENPHI ct
    JOIN NOITRU nt ON ct.idNoiTru = nt.idNoiTru
    WHERE ct.idVienPhi = @idVienPhi
)

SELECT
    h.idVienPhi AS SoLuuTru,
    CONVERT(NVARCHAR(10), h.NgayLap, 103) AS NgayLapHoaDon,
    k.TenKhoa AS TenKhoa,
    ISNULL(g.idGiuong, N'') AS Giuong,
    bn.HoTen AS HoVaTen,
    DATEDIFF(YEAR, bn.NgaySinh, GETDATE()) AS Tuoi,
    bn.GioiTinh,
    bn.idBenhNhan AS MaBenhNhan,
    bn.BHYT AS SoTheBHYT,
    k.TenKhoa AS KhoaDieuTri,
    CONVERT(NVARCHAR(10), h.NgayLap, 103) AS NgayDieuTri,
    -- Tổng chi phí 
    (SELECT SUM(ThanhTien) FROM ChiPhiCT) AS TongChiPhiDieuTri,
    (SELECT SUM(ThanhTien) FROM ChiPhiCT) * ISNULL(lb.MucHuong, 0) AS BHYTThanhToan,
    ISNULL(tu.SoTienTamUng, 0) AS TamUngDaNop,
    (SELECT SUM(ThanhTien) FROM ChiPhiCT) 
      - (SELECT SUM(ThanhTien) FROM ChiPhiCT) * ISNULL(lb.MucHuong, 0)
      - ISNULL(tu.SoTienTamUng, 0) AS VienPhiPhaiNop
FROM HOADON_VIENPHI h
JOIN P_KHAMBENH kb ON kb.idKhamBenh = h.idKhamBenh
JOIN HOSOBENHAN hsbn ON hsbn.idHoSo = kb.idHoSo  
JOIN PDK_KHAMBENH pdk ON pdk.idDKKhambenh = kb.idDKKhamBenh  
JOIN BENHNHAN bn ON pdk.idBenhNhan = bn.idBenhNhan  
LEFT JOIN GIUONG g ON g.idBenhNhan = bn.idBenhNhan
LEFT JOIN KHOA k ON k.idKhoa = pdk.idKhoa
LEFT JOIN LOAI_BHYT lb ON lb.idLoaiBHYT = bn.idLoaiBHYT
LEFT JOIN HOADON_TAMUNGVIENPHI tu ON tu.idTamUngVienPhi = h.idTamUngVienPhi
WHERE h.idVienPhi = 'HDVP0001';

SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 0)) AS STT,
       NoiDung, DonGia, SoLuong, ThanhTien
FROM (
    -- Khám bệnh
    SELECT lk.TenLoaiKham AS NoiDung,
           lk.ChiPhi AS DonGia,
           1 AS SoLuong,
           lk.ChiPhi AS ThanhTien
    FROM HOADON_VIENPHI h
    JOIN P_KHAMBENH kb ON h.idKhamBenh = kb.idKhamBenh
    JOIN LOAIKHAM lk ON kb.idLoaiKham = lk.idLoaiKham
    WHERE h.idVienPhi = @idVienPhi

    UNION ALL
    -- Cận lâm sàng 
    SELECT cls.TenCLS,
           cls.ChiPhi,
           1,
           cls.ChiPhi
    FROM CT_HOADONVIENPHI ct
    JOIN CANLAMSANG cls ON ct.idCanLamSang = cls.idCanLamSang
    WHERE ct.idVienPhi = @idVienPhi

    UNION ALL
    -- Nội trú 
    SELECT N'Nội trú – ' + nt.idNoiTru,
           nt.DonGiaNgay,
           DATEDIFF(DAY, nt.NgayNhapVien, ISNULL(nt.NgayRaVien, GETDATE())),
           DATEDIFF(DAY, nt.NgayNhapVien, ISNULL(nt.NgayRaVien, GETDATE())) * nt.DonGiaNgay
    FROM CT_HOADONVIENPHI ct
    JOIN NOITRU nt ON ct.idNoiTru = nt.idNoiTru
    WHERE ct.idVienPhi = @idVienPhi

    UNION ALL
    -- Thuốc
    SELECT dp.TenDuocPham,
           dp.DonGiaBan,
           ct2.SoLuong,
           ct2.SoLuong * dp.DonGiaBan
    FROM HOADON_VIENPHI h
    JOIN P_KHAMBENH kb ON h.idKhamBenh = kb.idKhamBenh
    JOIN DON_THUOC dt ON dt.idKhamBenh = kb.idKhamBenh
    JOIN CT_DONTHUOC ct2 ON dt.idDonThuoc = ct2.idDonThuoc
    JOIN DUOCPHAM dp ON ct2.idDuocPham = dp.idDuocPham
    WHERE h.idVienPhi = 'HDVP0001'
) X
ORDER BY STT;


--===== QUẢN LÝ PHIẾU CHUYỂN VIỆN =====
--  ====================================================== PHIEU YÊU CẦU CHUYỂN VIỆN =============================================

SELECT
    yc.idYeuCauChuyenVien                       AS SoLuuTru,
    bn.HoTen                                    AS HoTen,
    DATEDIFF(YEAR, bn.NgaySinh, GETDATE())
      - CASE WHEN DATEADD(YEAR,
                          DATEDIFF(YEAR, bn.NgaySinh, GETDATE()),
                          bn.NgaySinh) > GETDATE() THEN 1 ELSE 0 END          AS Tuoi,
    bn.GioiTinh                                 AS GioiTinh,
    bn.idBenhNhan                               AS MaBenhNhan,
    bn.BHYT                                     AS SoTheBHYT,

    k.TenKhoa                                   AS KhoaDieuTri,
    kb.NgayKham                                 AS NgayDieuTri,            
    yc.LyDo                                     AS LyDoChuyenVien,
    yc.CoSoChuyenDen                            AS CoSoYTeChuyenDen,
    yc.DiaChi                                   AS DiaChiCoSo,
    yc.NgayLap                                  AS NgayYeuCauChuyenVien,

    nd_bs.HoTen                                 AS BacSiPhuTrach,
    yc.GhiChu,

    nd_lap.HoTen                                AS NguoiLapPhieu,
    CONVERT(date, yc.NgayLap)                   AS NgayLapPhieu,
    nd_pd.HoTen                                 AS NguoiPheDuyet,
    yc.NgayPheDuyet,
    yc.YkienPheDuyet

FROM     PYC_CHUYENVIEN  AS yc
JOIN     BENHNHAN        AS bn  ON bn.idBenhNhan = yc.idBenhNhan
-- lần khám gần nhất
OUTER APPLY (
    SELECT TOP (1) dk_i.*
    FROM   PDK_KHAMBENH AS dk_i
    WHERE  dk_i.idBenhNhan = bn.idBenhNhan 
    ORDER BY dk_i.NgayLap DESC
) AS dk

OUTER APPLY (
    SELECT TOP (1) kb_i.*
    FROM   P_KHAMBENH AS kb_i
    WHERE  kb_i.idDKKhamBenh = dk.idDKKhamBenh
    ORDER BY kb_i.NgayKham DESC
) AS kb
LEFT JOIN KHOA        AS k
       ON k.idKhoa = dk.idKhoa
LEFT JOIN NGUOIDUNG   AS nd_bs  ON nd_bs.idNguoiDung = yc.idBacSiPhuTrach   
LEFT JOIN NGUOIDUNG   AS nd_lap ON nd_lap.idNguoiDung = yc.idNguoiDung    
LEFT JOIN NGUOIDUNG   AS nd_pd  ON nd_pd.idNguoiDung = yc.idNguoiPheDuyet  
WHERE    yc.idYeuCauChuyenVien = 'YCCV0001';


--  ====================================================== PHIEU CHUYỂN VIỆN =============================================
SELECT
    pcv.idChuyenVien       AS SoPhieu,
    pcv.NgayLap,
    pcv.NgayChuyen,
    pcv.ThoiGianDuKien,
    pcv.SDT_CoSoYTe,
    pcv.Phuongtien         AS PhuongTien,
    pcv.YThuc,
    pcv.GhiChu,
    pcv.TrangThai,
    pcv.NgayPheDuyet,

    -- THÔNG TIN BỆNH NHÂN
    bn.HoTen,
    DATEDIFF(YEAR, bn.NgaySinh,GETDATE())          AS Tuoi,
    bn.GioiTinh,
    bn.NgheNghiep,
    bn.DiaChi             AS DiaChiBenhNhan,
    bn.CCCD,
    bn.BHYT,
    bn.SDT               AS SDTBenhNhan,

    k.TenKhoa            AS KhoaDieuTri,

     --PHẦN CHUYÊN MÔN  
    pkb.ChanDoanPhanBiet AS ChanDoan,
    icd.TenBenh          AS TenChanDoan,
    icd.idICD            AS MaICD10,

    pkb.ChiSoMach        AS Mach,
    pkb.ChiSoHuyetAp     AS HuyetAp,
    pkb.ChiSoNhipTho     AS NhipTho,
    pkb.ChiSoNhietDo     AS NhietDo,
    pkb.QuaTrinhBenhLy   AS DienBienLamSang,

    -- ĐIỀU TRỊ ĐÃ THỰC HIỆN 
    LTRIM(RTRIM(
        ISNULL(t.DieuTriThuoc, '') +
        CASE WHEN t.DieuTriThuoc IS NOT NULL AND c.DieuTriCLS IS NOT NULL THEN '; ' ELSE '' END +
        ISNULL(c.DieuTriCLS, '')
    ))                       AS DieuTriDaThucHien,

    -- NGƯỜI LIÊN QUAN 
    nd_lap.HoTen            AS NguoiLap,
    nd_lap.ChucVu           AS ChucVuNguoiLap,
    nd_duyet.HoTen          AS NguoiPheDuyet,
    nd_duyet.ChucVu         AS ChucVuNguoiPheDuyet,
    nd_dikem.HoTen          AS NguoiDiKem,
    nd_dikem.ChucVu         AS ChucVuNguoiDiKem,

    -- TÀI LIỆU KÈM THEO 
    CONCAT(
        CASE WHEN clsXE.slXE > 0  THEN N'Kết quả xét nghiệm; '                        ELSE '' END,
        CASE WHEN clsHA.slHA > 0  THEN N'Phim chụp (X-quang, CT, MRI…); '             ELSE '' END,
        CASE WHEN hs.chk   > 0    THEN N'Hồ sơ bệnh án tóm tắt; '                     ELSE '' END,
        CASE WHEN clsKH.slKH > 0  THEN N'Tài liệu khác: ' + clsKH.danhSach + '; '     ELSE '' END
    )                          AS TaiLieuKemTheo

FROM  P_CHUYENVIEN pcv
JOIN  PYC_CHUYENVIEN pyc    ON pyc.idYeuCauChuyenVien = pcv.idYeuCauChuyenVien
JOIN  BENHNHAN bn           ON bn.idBenhNhan = pyc.idBenhNhan

  -- LẦN KHÁM GẦN NHẤT CỦA BN
OUTER APPLY (
    SELECT  TOP 1 pkb.*
    FROM    P_KHAMBENH pkb
    JOIN    PDK_KHAMBENH pdk ON pdk.idDKKhambenh = pkb.idDKKhamBenh
    WHERE   pdk.idBenhNhan = bn.idBenhNhan     
    ORDER BY pkb.NgayKham DESC
) pkb

LEFT JOIN ICD          icd ON icd.idICD      = pkb.idICDChanDoan
LEFT JOIN PDK_KHAMBENH dkk ON dkk.idDKKhambenh = pkb.idDKKhamBenh
LEFT JOIN KHOA         k   ON k.idKhoa       = dkk.idKhoa

 -- NGƯỜI DÙNG
LEFT JOIN NGUOIDUNG nd_lap   ON nd_lap.idNguoiDung   = pcv.idNguoiDung
LEFT JOIN NGUOIDUNG nd_duyet ON nd_duyet.idNguoiDung = pcv.idNguoiPheDuyet
LEFT JOIN NGUOIDUNG nd_dikem ON nd_dikem.idNguoiDung = pcv.idNguoiDiKem

 -- ĐƠN THUỐC
OUTER APPLY (
    SELECT STRING_AGG(dp.TenDuocPham + ' (' + ISNULL(ct.LieuDung, N'không rõ') + ')', '; ') AS DieuTriThuoc
    FROM   DON_THUOC dt
    JOIN   CT_DONTHUOC ct ON ct.idDonThuoc = dt.idDonThuoc
    JOIN   DUOCPHAM dp ON dp.idDuocPham   = ct.idDuocPham
    WHERE  dt.idKhamBenh = pkb.idKhamBenh
) t

 -- CLS CAN THIỆP
OUTER APPLY (
    SELECT STRING_AGG(c.TenCLS + ' (' + c.TenLoaiCLS + ')', '; ') AS DieuTriCLS
    FROM   CANLAMSANG c
    WHERE  c.idCanLamSang = pkb.idCanLamSang
      AND (c.TenLoaiCLS LIKE N'%nội soi%' 
           OR c.TenLoaiCLS LIKE N'%can thiệp%'
           OR c.TenLoaiCLS LIKE N'%phẫu thuật%'
           OR c.TenLoaiCLS LIKE N'%điều trị%')
) c


-- CLS KIỂM TRA TÀI LIỆU KÈM THEO  
OUTER APPLY (
    SELECT COUNT(*) AS slXE
    FROM   CANLAMSANG c1
    WHERE  c1.idCanLamSang = pkb.idCanLamSang
      AND  (c1.TenLoaiCLS IN (N'Huyết học', N'Sinh hóa') 
            OR c1.TenCLS LIKE N'%xét nghiệm%')
) clsXE

OUTER APPLY (
    SELECT COUNT(*) AS slHA
    FROM   CANLAMSANG c2
    WHERE  c2.idCanLamSang = pkb.idCanLamSang
      AND  (c2.TenLoaiCLS IN (N'Chẩn đoán hình ảnh', N'Siêu âm', N'X-Quang') 
            OR c2.TenCLS LIKE N'%chụp%' 
            OR c2.TenCLS LIKE N'%siêu âm%'
            OR c2.TenCLS LIKE N'%X-quang%')
) clsHA

OUTER APPLY (
    SELECT COUNT(*)      AS slKH,
           STRING_AGG(c3.TenCLS, '; ') AS danhSach
    FROM   CANLAMSANG c3
    WHERE  c3.idCanLamSang = pkb.idCanLamSang
      AND  c3.TenLoaiCLS NOT IN (N'Huyết học', N'Sinh hóa', N'Chẩn đoán hình ảnh', N'Siêu âm', N'X-Quang')
      AND  c3.TenCLS NOT LIKE N'%xét nghiệm%'
      AND  c3.TenCLS NOT LIKE N'%chụp%'
      AND  c3.TenCLS NOT LIKE N'%siêu âm%'
      AND  c3.TenCLS NOT LIKE N'%X-quang%'
) clsKH


-- Hồ sơ bệnh án tồn tại?  
OUTER APPLY (
    SELECT  CASE WHEN EXISTS (
                SELECT 1 FROM HOSOBENHAN hs 
                WHERE  hs.idBenhNhan = bn.idBenhNhan
            ) THEN 1 ELSE 0 END AS chk
) hs

WHERE pcv.idChuyenVien = 'CV0001'


--  ====================================================== DANH SÁCH HỒ SƠ CHUYỂN VIỆN =============================================
DECLARE @Thang INT = 10;
DECLARE @Nam INT = 2023;

SELECT 
    bn.HoTen AS HoTenBenhNhan,
    bn.idBenhNhan AS MaBenhNhan,
    k.TenKhoa AS KhoaDieuTri,
    kb.ChanDoanPhanBiet AS ChanDoan,
    pyc.CoSoChuyenDen AS BenhVienChuyenDen,
    pcv.NgayChuyen AS NgayChuyenVien,
    pcv.TrangThai AS TrangThai,
    pcv.GhiChu AS GhiChu,
    nd.HoTen AS NguoiLap
FROM P_CHUYENVIEN pcv
JOIN PYC_CHUYENVIEN pyc ON pcv.idYeuCauChuyenVien = pyc.idYeuCauChuyenVien
JOIN BENHNHAN bn ON pyc.idBenhNhan = bn.idBenhNhan
JOIN HOSOBENHAN hsba ON bn.idBenhNhan = hsba.idBenhNhan
JOIN P_KHAMBENH kb ON hsba.idHoSo = kb.idHoSo
JOIN PDK_KHAMBENH pdk ON kb.idDKKhamBenh = pdk.idDKKhambenh
JOIN KHOA k ON pdk.idKhoa = k.idKhoa
LEFT JOIN NGUOIDUNG nd ON nd.idNguoiDung = pcv.idNguoiDung

WHERE MONTH(pcv.NgayChuyen) = @Thang 
  AND YEAR(pcv.NgayChuyen) = @Nam

SELECT 
    COUNT(*) AS TongSoHoSo
FROM P_CHUYENVIEN
WHERE MONTH(NgayChuyen) = 10 AND YEAR(NgayChuyen) = 2023;


-------------------------------------------------------------------- H1.1. PHIẾU ĐĂNG KÝ KHÁM BỆNH
DECLARE @TargetIdDKKhamBenh CHAR(10); 
--SET @TargetIdDKKhamBenh = 'DKKB0001'; -- <<< THAY MÃ ĐKKB
SELECT
    PDK.idDKKhamBenh AS SoPhieuDangKy, 
    GETDATE() AS NgayTaoPhieu, 
    BN.HoTen AS HoTenBenhNhan,
    DATEDIFF(YEAR, BN.NgaySinh, GETDATE()) -
        CASE
            WHEN MONTH(BN.NgaySinh) > MONTH(GETDATE()) OR
                 (MONTH(BN.NgaySinh) = MONTH(GETDATE()) AND DAY(BN.NgaySinh) > DAY(GETDATE()))
            THEN 1
            ELSE 0
        END AS Tuoi,
    BN.GioiTinh,
    BN.CCCD,
    BN.BHYT AS SoTheBHYT,
    BN.NgheNghiep,
    BN.DiaChi,
    BN.SDT AS SDTBenhNhan,
    PDK.LyDoKham,
    PDK.ThoiGianBatDauTrieuChung,
	CASE
            WHEN PDK.KhamBHYT = 1 THEN N'Khám Bảo hiểm Y tế'
            WHEN PDK.KhamBHYT = 0 THEN N'Khám Dịch vụ' 
    END AS DichVuDangKyKham,
    PDK.TienSuBenhLyBanThan,
    PDK.TienSuBenhLyGiaDinh,
    PDK.ThuocDangSuDung, 
    BN.HoTenThanNhan,
    BN.MoiQuanHe,
    BN.SDTThanNhan,
    
	PDK.NgayLap AS NgayDangKy

FROM
    dbo.PDK_KHAMBENH AS PDK
INNER JOIN
    dbo.BENHNHAN AS BN ON PDK.idBenhNhan = BN.idBenhNhan
WHERE
    PDK.idDKKhamBenh = @TargetIdDKKhamBenh 

-------------------------------------------------------------------- H1.2. HỒ SƠ BỆNH ÁN
DECLARE @TargetIdHoSo CHAR(10); 
--SET @TargetIdHoSo = 'HS0001'; -- <<< THAY MÃ HSBA

SELECT
    k.TenKhoa AS KhoaDieuTri,
    hsb.IdHoSo AS MaHoSo,

    -- Thông tin bệnh nhân
    bn.HoTen AS HoTenBenhNhan,
    bn.NgaySinh,
    DATEDIFF(YEAR, bn.NgaySinh, GETDATE()) -
        CASE
            WHEN (MONTH(bn.NgaySinh) > MONTH(GETDATE())) OR
                 (MONTH(bn.NgaySinh) = MONTH(GETDATE()) AND DAY(bn.NgaySinh) > DAY(GETDATE()))
            THEN 1
            ELSE 0
        END AS Tuoi,
    bn.GioiTinh,
    bn.NgheNghiep,
    bn.DanToc,
    bn.DiaChi,
    bn.DoiTuongUuTien,
    bn.BHYT AS SoTheBHYT,
    bn.ThoiHanBHYT AS BHYT_GiaTriDenNgay,
    bn.HoTenThanNhan,
    bn.SDTThanNhan,

    -- A- BỆNH ÁN
    pdk.LyDoKham AS LyDoVaoVien,
    pk.QuaTrinhBenhLy,
    pdk.TienSuBenhLyBanThan,
    bn.BenhManTinh,
    bn.DiUng,
    bn.PhauThuatDaLam,
    pdk.TienSuBenhLyGiaDinh,

    -- B- KHÁM BỆNH
    pk.TieuHoa,
    pk.ThanTietNieu,
    pk.ThanKinh,
    pk.HoHap,
    pk.TimMach, 
    pk.ToanTrang, 
    pk.ChiSoMach, 
    pk.ChiSoNhietDo,
    pk.ChiSoHuyetAp, 
    pk.ChiSoNhipTho, 
    pk.Khac AS NoiTietDinhDuongKhac, 
    
    pk.NhanXet AS TomTatBenhAn, 

    -- C- CHẨN ĐOÁN VÀ ĐIỀU TRỊ
    icd_chinh.TenBenh AS ChanDoan_BenhChinh,
    pk.IdICDChanDoan AS ChanDoan_ICD, 
    pk.TrieuChungDiKem AS ChanDoan_BenhKemTheo, 
    pk.ChanDoanPhanBiet AS ChanDoan_PhanBiet,
    pk.TienLuong, 

    CASE
        WHEN pk.NhapVien = 1 THEN N'Nhập viện điều trị nội trú. '
        ELSE ''
    END +
    CASE
        WHEN pk.DieuTriNgoaiTru = 1 THEN N'Điều trị ngoại trú. '
        ELSE ''
    END +
    CASE
        WHEN pk.ChuyenKhamChuyenKhoaKhac = 1 THEN N'Chuyển khám chuyên khoa khác. ' 
        ELSE ''
    END
    AS HuongDieuTri,
    pk.NgayKham,
    nd.HoTen AS HoTenBacSi 
FROM
    dbo.HOSOBENHAN hsb
JOIN
    dbo.BENHNHAN bn ON hsb.IdBenhNhan = bn.IdBenhNhan
LEFT JOIN
    dbo.P_KHAMBENH pk ON hsb.IdHoSo = pk.IdHoSo
LEFT JOIN
    dbo.PDK_KHAMBENH pdk ON pk.IdDKKhamBenh = pdk.IdDKKhamBenh
LEFT JOIN
    dbo.KHOA k ON pdk.IdKhoa = k.IdKhoa
LEFT JOIN
    dbo.ICD icd_chinh ON pk.idICDChanDoan = icd_chinh.IdICD 
LEFT JOIN
    dbo.NguoiDung nd ON nd.idNguoiDung = pk.idNguoiDung
WHERE
    hsb.IdHoSo = @TargetIdHoSo;

SELECT
    cls.TenCLS AS TenXetNghiem,
    pxn.GiaTriKetQua_So AS KetQua,
    pxn.GiaTriKetQua_Text AS NhanXet,
	pxn.DVTKetQua AS DVT,
	pxn.KhoangThamChieuApDung 
FROM
    dbo.P_XETNGHIEM pxn
JOIN
    dbo.CANLAMSANG cls ON pxn.IdCanLamSang = cls.IdCanLamSang
JOIN
    dbo.P_KHAMBENH pk ON pxn.IdKhamBenh = pk.IdKhamBenh
-- Lọc theo mã hồ sơ bệnh án mục tiêu
WHERE
    pk.IdHoSo = @TargetIdHoSo
ORDER BY
    cls.TenCLS

-------------------------------------------------------------------- H1.3. ĐƠN THUỐC
DECLARE @TargetIdDonThuoc CHAR(10);
--SET @TargetIdDonThuoc = 'DT0001'; -- <<< THAY MÃ ĐƠN THUỐC

SELECT
    dt.IdDonThuoc AS MaDonThuoc,
    bn.HoTen AS HoTenBenhNhan,
    bn.NgaySinh,
    bn.GioiTinh,
    bn.BHYT AS SoTheBHYT,
    bn.DiaChi,
    icd.TenBenh AS ChanDoan,
    pk.LoiDan, 
    dt.NgayLap,
    nd.HoTen AS HoTenBacSi,
    nd.SDT AS SDT_BacSi
FROM
    dbo.DON_THUOC dt
LEFT JOIN
    dbo.P_KHAMBENH pk ON dt.IdKhamBenh = pk.IdKhamBenh
LEFT JOIN
    dbo.HOSOBENHAN hsb ON pk.IdHoSo = hsb.IdHoSo 
LEFT JOIN
    dbo.BENHNHAN bn ON hsb.IdBenhNhan = bn.IdBenhNhan
LEFT JOIN
    dbo.NGUOIDUNG nd ON dt.IdNguoiDung = nd.IdNguoiDung 
LEFT JOIN
    dbo.ICD icd ON pk.IdICDKetLuan = icd.IdICD 
WHERE
    dt.IdDonThuoc = @TargetIdDonThuoc;

SELECT
    dp.TenDuocPham,
    dp.DVT AS DonViTinh,
    ctdt.SoLuong,
    ctdt.LieuDung,
    ctdt.DuongDung,
    ctdt.GhiChu
FROM
    dbo.CT_DONTHUOC ctdt
JOIN
    dbo.DUOCPHAM dp ON ctdt.IdDuocPham = dp.IdDuocPham
WHERE
    ctdt.IdDonThuoc = @TargetIdDonThuoc
ORDER BY
    dp.TenDuocPham

-------------------------------------------------------------------- H1.4. PHIẾU THANH TOÁN ĐƠN THUỐC
DECLARE @TargetIdDonThuoc CHAR(10);
--SET @TargetIdDonThuoc = 'DT0001'; -- <<< THAY MÃ ĐƠN THUỐC 

SELECT
    -- Thông tin chung
    k.TenKhoa AS KhoaDieuTri,
    hsb.IdHoSo AS MaHSBA,
    dt.IdDonThuoc AS MaDonThuoc,
    dt.NgayLap, 
    
    -- Thông tin bệnh nhân
    bn.HoTen,
    bn.IdBenhNhan AS MaBenhNhan,
    DATEDIFF(YEAR, bn.NgaySinh, GETDATE()) -
        CASE WHEN (MONTH(bn.NgaySinh) > MONTH(GETDATE())) OR (MONTH(bn.NgaySinh) = MONTH(GETDATE()) AND DAY(bn.NgaySinh) > DAY(GETDATE())) THEN 1 ELSE 0 END
    AS Tuoi,
    bn.GioiTinh,
    bn.BHYT AS SoTheBHYT,
    
    -- Thông tin thanh toán (Lấy từ bảng tạm 'tcp' bên dưới)
    tcp.TongChiPhi AS TongCong,
    (tcp.TongChiPhi * ISNULL(CAST(REPLACE(lbhyt.MucHuong, '%', '') AS DECIMAL(5,2)) / 100.0, 0)) AS BHYTThanhToan,
    (tcp.TongChiPhi - (tcp.TongChiPhi * ISNULL(CAST(REPLACE(lbhyt.MucHuong, '%', '') AS DECIMAL(5,2)) / 100.0, 0))) AS BenhNhanPhaiTra,
    
    -- Người lập phiếu
    nd.HoTen AS NguoiLapPhieu
FROM
    dbo.DON_THUOC dt
LEFT JOIN
    -- Bảng tạm (Derived Table) để tính tổng chi phí, thay thế cho CTE 'TongChiPhiThanhToan'
    (
        SELECT
            ctdt.IdDonThuoc,
            SUM(ctdt.SoLuong * dp.DonGiaBan) AS TongChiPhi
        FROM
            dbo.CT_DONTHUOC ctdt
        JOIN
            dbo.DUOCPHAM dp ON ctdt.IdDuocPham = dp.IdDuocPham
        WHERE 
            ctdt.IdDonThuoc = @TargetIdDonThuoc -- Lọc ngay trong này để tăng hiệu quả
        GROUP BY
            ctdt.IdDonThuoc
    ) AS tcp ON dt.IdDonThuoc = tcp.IdDonThuoc
LEFT JOIN
    dbo.P_KHAMBENH pk ON dt.IdKhamBenh = pk.IdKhamBenh
LEFT JOIN
    dbo.HOSOBENHAN hsb ON pk.IdHoSo = hsb.IdHoSo
LEFT JOIN
    dbo.PDK_KHAMBENH pdk ON pdk.idDKKhambenh = pk.idDKKhamBenh
LEFT JOIN
    dbo.BENHNHAN bn ON pdk.IdBenhNhan = bn.IdBenhNhan
LEFT JOIN
    dbo.KHOA k ON pdk.IdKhoa = k.IdKhoa 
LEFT JOIN
    dbo.LOAI_BHYT lbhyt ON bn.IdLoaiBHYT = lbhyt.IdLoaiBHYT
LEFT JOIN
    dbo.NGUOIDUNG nd ON dt.idNguoiDung = nd.IdNguoiDung
WHERE
    dt.IdDonThuoc = @TargetIdDonThuoc;

SELECT
    dp.TenDuocPham AS TenThuoc,
    dp.DVT,
    ctdt.SoLuong,
    dp.DonGiaBan AS DonGia,
    (ctdt.SoLuong * dp.DonGiaBan) AS ThanhTien
FROM
    dbo.CT_DONTHUOC ctdt
JOIN
    dbo.DUOCPHAM dp ON ctdt.IdDuocPham = dp.IdDuocPham
WHERE
    ctdt.IdDonThuoc = @TargetIdDonThuoc
ORDER BY
    dp.TenDuocPham


-------------------------------------------------------------------- H1.5. PHIẾU THANH TOÁN VIỆN PHÍ
DECLARE @TargetIdVienPhi CHAR(10);
SET @TargetIdVienPhi = 'HDVP0001'; -- <<< THAY MÃ HÓA ĐƠN VIỆN PHÍ CỤ THỂ VÀO ĐÂY

SELECT
    -- Thông tin hóa đơn và bệnh nhân
    hvp.IdVienPhi AS MaVienPhi,
    k_pk.TenKhoa,
    bn.HoTen AS HoTenBenhNhan,
    DATEDIFF(YEAR, bn.NgaySinh, GETDATE()) -
        CASE WHEN (MONTH(bn.NgaySinh) > MONTH(GETDATE())) OR (MONTH(bn.NgaySinh) = MONTH(GETDATE()) AND DAY(bn.NgaySinh) > DAY(GETDATE())) THEN 1 ELSE 0 END
    AS Tuoi,
    bn.GioiTinh,
    bn.IdBenhNhan AS MaBenhNhan,
    bn.BHYT AS SoTheBHYT,
    k_pk.TenKhoa AS KhoaDieuTri,
    hvp.NgayLap,

    -- Thông tin thanh toán (tính toán trong bảng tạm 'tcp_dt' bên dưới)
    ISNULL(tcp_dt.TongPhi, 0) AS TongChiPhiDieuTri,
    (ISNULL(tcp_dt.TongPhi, 0) * ISNULL(CAST(REPLACE(lbhyt.MucHuong, '%', '') AS DECIMAL(5,2)) / 100.0, 0)) AS BHYTThanhToan,
    ISNULL(htuvp.SoTienTamUng, 0) AS TamUngDaNop,
    (ISNULL(tcp_dt.TongPhi, 0) - (ISNULL(tcp_dt.TongPhi, 0) * ISNULL(CAST(REPLACE(lbhyt.MucHuong, '%', '') AS DECIMAL(5,2)) / 100.0, 0)) - ISNULL(htuvp.SoTienTamUng,0) ) AS VienPhiPhaiNop,

    -- Thông tin cuối phiếu
    GETDATE() AS NgayThanhToan,
    nd.HoTen AS ThuNgan
FROM
    dbo.HOADON_VIENPHI hvp
LEFT JOIN
    (
        SELECT IdVienPhi, SUM(ThanhTien) AS TongPhi FROM (
            -- Source 1: Chi phí Cận lâm sàng và Nội trú
            SELECT
                cthvp.IdVienPhi,
                (CASE
                    WHEN cthvp.IdCanLamSang IS NOT NULL THEN 1
                    WHEN cthvp.IdNoiTru IS NOT NULL THEN GREATEST(1, DATEDIFF(day, nt.NgayNhapVien, ISNULL(nt.NgayRaVien, GETDATE())))
                    ELSE 1
                 END) *
                (CASE
                    WHEN cthvp.IdCanLamSang IS NOT NULL THEN ISNULL(cls.ChiPhi, 0)
                    WHEN cthvp.IdNoiTru IS NOT NULL THEN ISNULL(nt.DonGiaNgay, 0)
                    ELSE 0
                 END) AS ThanhTien
            FROM dbo.CT_HOADONVIENPHI cthvp
            LEFT JOIN dbo.CANLAMSANG cls ON cthvp.IdCanLamSang = cls.IdCanLamSang
            LEFT JOIN dbo.NOITRU nt ON cthvp.IdNoiTru = nt.IdNoiTru
            WHERE cthvp.IdVienPhi = @TargetIdVienPhi

            UNION ALL

            -- Source 2: Thêm phí khám vào danh sách
            SELECT hvp_sub.IdVienPhi, ISNULL(lk.ChiPhi, 0)
            FROM dbo.HOADON_VIENPHI hvp_sub
            JOIN dbo.P_KHAMBENH pk_fee ON hvp_sub.IdKhamBenh = pk_fee.IdKhamBenh
            JOIN dbo.LOAIKHAM lk ON pk_fee.IdLoaiKham = lk.IdLoaiKham
            WHERE hvp_sub.IdVienPhi = @TargetIdVienPhi AND ISNULL(lk.ChiPhi, 0) > 0
        ) AS AllCharges
        GROUP BY IdVienPhi
    ) AS tcp_dt ON hvp.IdVienPhi = tcp_dt.IdVienPhi
LEFT JOIN dbo.P_KHAMBENH pk ON hvp.IdKhamBenh = pk.IdKhamBenh
LEFT JOIN dbo.HOSOBENHAN hsb ON pk.IdHoSo = hsb.IdHoSo
LEFT JOIN dbo.PDK_KHAMBENH pdk_pk ON pk.IdDKKhamBenh = pdk_pk.IdDKKhamBenh
LEFT JOIN dbo.BENHNHAN bn ON pdk_pk.IdBenhNhan = bn.IdBenhNhan
LEFT JOIN dbo.KHOA k_pk ON pdk_pk.IdKhoa = k_pk.IdKhoa
LEFT JOIN dbo.LOAI_BHYT lbhyt ON bn.IdLoaiBHYT = lbhyt.IdLoaiBHYT
LEFT JOIN dbo.HOADON_TAMUNGVIENPHI htuvp ON hvp.IdTamUngVienPhi = htuvp.IdTamUngVienPhi
LEFT JOIN dbo.NGUOIDUNG nd ON hvp.IdNguoiDung = nd.IdNguoiDung
WHERE
    hvp.IdVienPhi = @TargetIdVienPhi;

SELECT
    NoiDungPhi,
    SoLuong,
    DonGia,
    ThanhTien
FROM
    -- LOGIC TÍNH PHÍ ĐƯỢC LẶP LẠI LẦN 2 Ở ĐÂY.
    (
        -- Source 1: Chi phí Cận lâm sàng và Nội trú
        SELECT
            CASE
                WHEN cthvp.IdCanLamSang IS NOT NULL THEN N'Xét nghiệm : ' + ISNULL(cls.TenCLS, 'N/A')
                WHEN cthvp.IdNoiTru IS NOT NULL THEN N'Chi phí nội trú từ ' + FORMAT(nt.NgayNhapVien, 'dd/MM/yyyy') +
                                                    ISNULL(N' đến ' + FORMAT(nt.NgayRaVien, 'dd/MM/yyyy'), N' đến nay')
                ELSE N'Dịch vụ không xác định'
            END AS NoiDungPhi,
            CASE
                WHEN cthvp.IdCanLamSang IS NOT NULL THEN 1
                WHEN cthvp.IdNoiTru IS NOT NULL THEN GREATEST(1, DATEDIFF(day, nt.NgayNhapVien, ISNULL(nt.NgayRaVien, GETDATE())))
                ELSE 1
            END AS SoLuong,
            CASE
                WHEN cthvp.IdCanLamSang IS NOT NULL THEN ISNULL(cls.ChiPhi, 0)
                WHEN cthvp.IdNoiTru IS NOT NULL THEN ISNULL(nt.DonGiaNgay, 0)
                ELSE 0
            END AS DonGia,
            (CASE
                WHEN cthvp.IdCanLamSang IS NOT NULL THEN 1
                WHEN cthvp.IdNoiTru IS NOT NULL THEN GREATEST(1, DATEDIFF(day, nt.NgayNhapVien, ISNULL(nt.NgayRaVien, GETDATE())))
                ELSE 1
             END) *
            (CASE
                WHEN cthvp.IdCanLamSang IS NOT NULL THEN ISNULL(cls.ChiPhi, 0)
                WHEN cthvp.IdNoiTru IS NOT NULL THEN ISNULL(nt.DonGiaNgay, 0)
                ELSE 0
             END) AS ThanhTien,
            1 AS LoaiSapXep
        FROM dbo.CT_HOADONVIENPHI cthvp
        LEFT JOIN dbo.CANLAMSANG cls ON cthvp.IdCanLamSang = cls.IdCanLamSang
        LEFT JOIN dbo.NOITRU nt ON cthvp.IdNoiTru = nt.IdNoiTru
        WHERE cthvp.IdVienPhi = @TargetIdVienPhi

        UNION ALL

        -- Source 2: Thêm phí khám vào danh sách
        SELECT
            N'Phí khám: ' + ISNULL(lk.TenLoaiKham, 'Không rõ loại khám'), 1, ISNULL(lk.ChiPhi, 0), ISNULL(lk.ChiPhi, 0), 2 AS LoaiSapXep
        FROM dbo.HOADON_VIENPHI hvp
        JOIN dbo.P_KHAMBENH pk_fee ON hvp.IdKhamBenh = pk_fee.IdKhamBenh
        JOIN dbo.LOAIKHAM lk ON pk_fee.IdLoaiKham = lk.IdLoaiKham
        WHERE hvp.IdVienPhi = @TargetIdVienPhi AND ISNULL(lk.ChiPhi, 0) > 0
    ) AS AllCharges

-------------------------------------------------------------------- H2.2. PHIẾU XÉT NGHIỆM
DECLARE @TargetKhamBenhID CHAR(10);
--SET @TargetKhamBenhID = 'KB0001'; -- <<< THAY MÃ PHIẾU KHÁM BỆNH 

SELECT DISTINCT 
    PKB.idKhamBenh AS SoPhieuKhamBenh,
    BN.HoTen AS TenBenhNhan,
    BN.GioiTinh,
    DATEDIFF(YEAR, BN.NgaySinh, GETDATE()) AS Tuoi,
    PDK.NgayLap AS NgayChiDinh
FROM
    dbo.P_KHAMBENH AS PKB
JOIN
    dbo.PDK_KHAMBENH AS PDK ON PKB.idDKKhamBenh = PDK.idDKKhambenh
JOIN
    dbo.BENHNHAN AS BN ON PDK.idBenhNhan = BN.idBenhNhan
WHERE
    PKB.idKhamBenh = @TargetKhamBenhID;

WITH KetQuaXetNghiem AS (

    SELECT
        ParentCLS.ThuTuHienThi AS SortOrder1,
        1 AS SortOrder2,                     
        ParentCLS.TenCLS AS TenXetNghiem,     
        NULL AS GiaTriKetQua_So,               
        '' AS GiaTriKetQua_Text,
        '' AS DonViTinh,
        '' AS KhoangThamChieu,
        '' AS BacSiXetNghiem
    FROM dbo.P_XETNGHIEM AS PXN
    JOIN dbo.CANLAMSANG AS CLS ON PXN.idCanLamSang = CLS.idCanLamSang
    JOIN dbo.CANLAMSANG AS ParentCLS ON CLS.idCanLamSangCha = ParentCLS.idCanLamSang
    WHERE PXN.idKhamBenh = @TargetKhamBenhID
    GROUP BY ParentCLS.TenCLS, ParentCLS.ThuTuHienThi

    UNION ALL

    SELECT
        ParentCLS.ThuTuHienThi AS SortOrder1,
        2 AS SortOrder2,
        + CLS.TenCLS AS TenXetNghiem, -- Thụt vào đầu dòng để phân biệt
        PXN.GiaTriKetQua_So,
        PXN.GiaTriKetQua_Text,
        PXN.DVTKetQua AS DonViTinh,
        CASE
            WHEN BN.GioiTinh = N'Nam' THEN CLS.KhoangThamChieuNam
            WHEN BN.GioiTinh = N'Nữ' THEN CLS.KhoangThamChieuNu
            ELSE COALESCE(CLS.KhoangThamChieuNam, CLS.KhoangThamChieuNu) -- Mặc định
        END AS KhoangThamChieu,
        nd.HoTen AS BacSiXetNghiem
    FROM
        dbo.P_XETNGHIEM AS PXN
    JOIN dbo.CANLAMSANG AS CLS ON PXN.idCanLamSang = CLS.idCanLamSang
    LEFT JOIN dbo.CANLAMSANG AS ParentCLS ON CLS.idCanLamSangCha = ParentCLS.idCanLamSang
    JOIN dbo.P_KHAMBENH AS PKB ON PXN.idKhamBenh = PKB.idKhamBenh
    JOIN dbo.PDK_KHAMBENH AS PDK ON PKB.idDKKhamBenh = PDK.idDKKhambenh
    JOIN dbo.BENHNHAN AS BN ON PDK.idBenhNhan = BN.idBenhNhan
    LEFT JOIN dbo.NGUOIDUNG AS nd ON PXN.idNguoiDung = nd.idNguoiDung
    WHERE
        PXN.idKhamBenh = @TargetKhamBenhID
)

SELECT
    TenXetNghiem,
    GiaTriKetQua_So AS KetQua,
    GiaTriKetQua_Text AS NhanXet,
    DonViTinh AS DVT,
    KhoangThamChieu,
    BacSiXetNghiem
FROM KetQuaXetNghiem
ORDER BY
    SortOrder1,  
    SortOrder2;  

-------------------------------------------------------------------- H2.2. PHIẾU XÉT NGHIỆM

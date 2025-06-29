
-- Mẫu biểu “Đơn xin nghỉ phép”
DECLARE @TargetIdNghiPhep VARCHAR(20) = 'NP0001';

WITH SoNgayDaNghi AS (
    SELECT 
        dnp.idNhanVien,
        SUM(CASE 
            WHEN dnp.NghiCaNgay = 1 THEN dnp.TongNgayNghi
            ELSE dnp.TongNgayNghi
        END) AS TongNgayDaNghi
    FROM DON_NGHIPHEP dnp
    WHERE YEAR(dnp.NgayBD) = YEAR(GETDATE())
      AND dnp.TrangThai = N'Đã duyệt'  
    GROUP BY dnp.idNhanVien
)

SELECT 
    k.TenKhoa,

    dnp.idNghiPhep AS MaDonXinNghiPhep,
    dnp.NgayLap,

	nv.idNhanVien AS MaNhanVien,
    nv.HoTen AS HoTenNhanVien,
    nv.ChucVu,
    nv.SDT,
    nv.NgaySinh,
    nv.GioiTinh,

    dnp.LoaiPhep,
    dnp.NgayBD AS NghiTuNgay,
    dnp.NgayKT AS NghiDenNgay,
    DATEDIFF(DAY, dnp.NgayBD, dnp.NgayKT) + 1 AS SoNgayNghiPhep,
    CASE 
        WHEN dnp.NghiCaNgay = 1 THEN N'Nghỉ cả ngày'
        ELSE N'Nghỉ nửa ngày'
    END AS HinhThuc,
    dnp.LyDo,
    
    nv_thaythe.HoTen AS NhanVienThayThe,
    nv_thaythe.ChucVu AS ChucVuNhanVienThayThe,
    nv_thaythe.SDT AS SDTNhanVienThayThe,
    
    dnp.HoTenNguoiLienHe AS HoTenThanNhan,
    dnp.SDTNguoiLienHe AS SDTThanNhan,
    dnp.MoiQuanHe,
    
    ISNULL(sndn.TongNgayDaNghi, 0) AS TongSoNgayDaNghi,
    
    dnp.TrangThai,
    
    nv_duyet.HoTen AS NguoiDuyet,
    nv_duyet.ChucVu AS ChucVuNguoiDuyet,
    dnp.NgayPheDuyet AS NgayDuyet,
    dnp.GhiChuPheDuyet AS GhiChuPheDuyet,

    k.TenKhoa,
    k.ViTri AS DiaChi,  -- Sử dụng ViTri thay cho DiaChi
    
    dnp.GhiChu AS GhiChuNghiPhep

FROM DON_NGHIPHEP dnp
JOIN NHANVIEN nv ON dnp.idNhanVien = nv.idNhanVien
JOIN KHOA k ON nv.idKhoa = k.idKhoa  
LEFT JOIN NHANVIEN nv_thaythe ON dnp.idNhanVienThayThe = nv_thaythe.idNhanVien
LEFT JOIN NGUOIDUNG nv_duyet ON dnp.idNguoiPheDuyet = nv_duyet.idNguoiDung
LEFT JOIN SoNgayDaNghi sndn ON nv.idNhanVien = sndn.idNhanVien

WHERE dnp.idNghiPhep = @TargetIdNghiPhep;

--Mẫu biểu “Đơn xin chuyển ca”

DECLARE @TargetIdChuyenCa VARCHAR(20) = 'YCCC0001';

SELECT 
    k.TenKhoa,
    
    pyc.idYeuCauChuyenCa AS MaYeuCauChuyenCa,
    pyc.NgayYeuCau AS NgayLap,
    
    nv_cu.idNhanVien AS MaNhanVienCu,
	nv_cu.HoTen AS HoTenNhanVienCu,
    nv_cu.ChucVu AS ChucVuNhanVienCu,
    nv_cu.SDT AS SDTNhanVienCu,
    
    ca_cu.NgayLamViec AS NgayLamViecCaCu,
    ca_cu.LoaiCa AS LoaiCaCu,
    ca_cu.GioBD AS GioBatDauCaCu,
    ca_cu.GioKT AS GioKetThucCaCu,

    ca_moi.NgayLamViec AS NgayLamViecCaMoi,
    ca_moi.LoaiCa AS LoaiCaMoi,
    ca_moi.GioBD AS GioBatDauCaMoi,
    ca_moi.GioKT AS GioKetThucCaMoi,

	nv_moi.idNhanVien AS MaNhanVienMoi,
    nv_moi.HoTen AS HoTenNhanVienMoi,
    nv_moi.ChucVu AS ChucVuNhanVienMoi,
    nv_moi.SDT AS SDTNhanVienMoi,

    pyc.LyDo AS LyDoChuyenCa,
    pyc.GhiChu AS GhiChu,
    CASE 
        WHEN pyc.CanBuCa = 1 THEN N'Có yêu cầu ca bù'
        ELSE N'Không yêu cầu ca bù'
    END AS Don_YeuCauCaBu,
    
    pyc.TrangThai AS TrangThai,
    
    nv_duyet.HoTen AS HoTenNguoiDuyet,
    nv_duyet.ChucVu AS ChucVuNguoiDuyet,
    pyc.NgayPheDuyet AS NgayDuyet,
    pyc.GhiChuPheDuyet AS GhiChuPheDuyet,
    
    k.TenKhoa,
    k.ViTri AS DiaChi,  -- Sử dụng ViTri thay cho DiaChi

    -- Thông tin ca bù (nếu có)
    ca_bu.NgayLamViec AS NgayLamViecCaBu,
    ca_bu.LoaiCa AS LoaiCaBu,
    ca_bu.GioBD AS GioBatDauCaBu,
    ca_bu.GioKT AS GioKetThucCaBu,
    
    pyc.NgayChuyen AS Don_NgayChuyen

FROM PYC_CHUYENCA pyc
JOIN NHANVIEN nv_cu ON pyc.idNhanVienCu = nv_cu.idNhanVien
JOIN KHOA k ON nv_cu.idKhoa = k.idKhoa  -- Lấy khoa từ nhân viên cũ
LEFT JOIN CALAMVIEC ca_cu ON pyc.idCaLamViecGoc = ca_cu.idCaLamViec
LEFT JOIN CALAMVIEC ca_moi ON pyc.idCaLamViecMoi = ca_moi.idCaLamViec
LEFT JOIN CALAMVIEC ca_bu ON pyc.idCaLamViecBu = ca_bu.idCaLamViec
LEFT JOIN NHANVIEN nv_moi ON pyc.idNhanVienMoi = nv_moi.idNhanVien
LEFT JOIN NGUOIDUNG nv_duyet ON pyc.idNguoiPheDuyet = nv_duyet.idNguoiDung

WHERE pyc.idYeuCauChuyenCa = @TargetIdChuyenCa;


--Mẫu “Bệnh án” 
DECLARE @TargetIdHoSo CHAR(10); 
SET @TargetIdHoSo = 'HS0001'; -- <<< THAY MÃ HSBA

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
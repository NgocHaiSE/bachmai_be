USE [Quan_Ly_Benh_Vien]
GO
/****** Object:  StoredProcedure [dbo].[sp_BaoCaoDoanhThuTiemChung]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 16. Báo cáo doanh thu tiêm chủng theo thời gian
CREATE PROCEDURE [dbo].[sp_BaoCaoDoanhThuTiemChung]
    @TuNgay DATE,
    @DenNgay DATE,
    @GroupBy NVARCHAR(10) = 'NGAY' -- NGAY, THANG, NAM
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @GroupBy = 'NGAY'
    BEGIN
        SELECT 
            PDK.NgayTiem as ThoiGian,
            COUNT(PDK.idDKTiemChung) as SoLuongDangKy,
            COUNT(CASE WHEN PDK.TrangThai = N'Đã tiêm' THEN 1 END) as SoLuongDaTiem,
            SUM(CASE WHEN PDK.TrangThai = N'Đã tiêm' THEN VX.DonGiaBan ELSE 0 END) as DoanhThu
        FROM PDK_TIEMCHUNG PDK
        INNER JOIN VACXIN VX ON PDK.idVacXin = VX.idVacXin
        WHERE PDK.NgayTiem BETWEEN @TuNgay AND @DenNgay
        GROUP BY PDK.NgayTiem
        ORDER BY PDK.NgayTiem;
    END
    ELSE IF @GroupBy = 'THANG'
    BEGIN
        SELECT 
            YEAR(PDK.NgayTiem) as Nam,
            MONTH(PDK.NgayTiem) as Thang,
            CAST(YEAR(PDK.NgayTiem) AS VARCHAR(4)) + '-' + 
            RIGHT('0' + CAST(MONTH(PDK.NgayTiem) AS VARCHAR(2)), 2) as ThoiGian,
            COUNT(PDK.idDKTiemChung) as SoLuongDangKy,
            COUNT(CASE WHEN PDK.TrangThai = N'Đã tiêm' THEN 1 END) as SoLuongDaTiem,
            SUM(CASE WHEN PDK.TrangThai = N'Đã tiêm' THEN VX.DonGiaBan ELSE 0 END) as DoanhThu
        FROM PDK_TIEMCHUNG PDK
        INNER JOIN VACXIN VX ON PDK.idVacXin = VX.idVacXin
        WHERE PDK.NgayTiem BETWEEN @TuNgay AND @DenNgay
        GROUP BY YEAR(PDK.NgayTiem), MONTH(PDK.NgayTiem)
        ORDER BY YEAR(PDK.NgayTiem), MONTH(PDK.NgayTiem);
    END
    ELSE IF @GroupBy = 'NAM'
    BEGIN
        SELECT 
            YEAR(PDK.NgayTiem) as ThoiGian,
            COUNT(PDK.idDKTiemChung) as SoLuongDangKy,
            COUNT(CASE WHEN PDK.TrangThai = N'Đã tiêm' THEN 1 END) as SoLuongDaTiem,
            SUM(CASE WHEN PDK.TrangThai = N'Đã tiêm' THEN VX.DonGiaBan ELSE 0 END) as DoanhThu
        FROM PDK_TIEMCHUNG PDK
        INNER JOIN VACXIN VX ON PDK.idVacXin = VX.idVacXin
        WHERE PDK.NgayTiem BETWEEN @TuNgay AND @DenNgay
        GROUP BY YEAR(PDK.NgayTiem)
        ORDER BY YEAR(PDK.NgayTiem);
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_CapNhatBenhNhan]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 14. Cập nhật thông tin bệnh nhân
CREATE PROCEDURE [dbo].[sp_CapNhatBenhNhan]
    @idBenhNhan CHAR(10),
    @HoTen NVARCHAR(100) = NULL,
    @NgaySinh DATE = NULL,
    @GioiTinh NVARCHAR(10) = NULL,
    @NgheNghiep NVARCHAR(50) = NULL,
    @DanToc NVARCHAR(50) = NULL,
    @SDT INT = NULL,
    @DiaChi NVARCHAR(200) = NULL,
    @CCCD VARCHAR(20) = NULL,
    @BHYT VARCHAR(20) = NULL,
    @HoTenThanNhan NVARCHAR(100) = NULL,
    @MoiQuanHe NVARCHAR(20) = NULL,
    @SDTThanNhan VARCHAR(15) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Kiểm tra bệnh nhân tồn tại
        IF NOT EXISTS (SELECT 1 FROM BENHNHAN WHERE idBenhNhan = @idBenhNhan)
        BEGIN
            RAISERROR(N'Bệnh nhân không tồn tại', 16, 1);
            RETURN;
        END
        
        -- Cập nhật thông tin
        UPDATE BENHNHAN SET
            HoTen = ISNULL(@HoTen, HoTen),
            NgaySinh = ISNULL(@NgaySinh, NgaySinh),
            GioiTinh = ISNULL(@GioiTinh, GioiTinh),
            NgheNghiep = ISNULL(@NgheNghiep, NgheNghiep),
            DanToc = ISNULL(@DanToc, DanToc),
            SDT = ISNULL(@SDT, SDT),
            DiaChi = ISNULL(@DiaChi, DiaChi),
            CCCD = ISNULL(@CCCD, CCCD),
            BHYT = ISNULL(@BHYT, BHYT),
            HoTenThanNhan = ISNULL(@HoTenThanNhan, HoTenThanNhan),
            MoiQuanHe = ISNULL(@MoiQuanHe, MoiQuanHe),
            SDTThanNhan = ISNULL(@SDTThanNhan, SDTThanNhan)
        WHERE idBenhNhan = @idBenhNhan;
        
        COMMIT TRANSACTION;
        
        SELECT N'Cập nhật thông tin bệnh nhân thành công' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_CapNhatDangKyTiemChung]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 4. Cập nhật đăng ký tiêm chủng
CREATE PROCEDURE [dbo].[sp_CapNhatDangKyTiemChung]
    @idDKTiemChung CHAR(10),
    @idBenhNhan CHAR(10) = NULL,
    @HoTenNguoiLienHe NVARCHAR(50) = NULL,
    @QuanHe NVARCHAR(50) = NULL,
    @SDT_LienHe NVARCHAR(20) = NULL,
    @Email NVARCHAR(50) = NULL,
    @idVacXin CHAR(10) = NULL,
    @NgayTiem DATE = NULL,
    @ThoiGianTiem NVARCHAR(50) = NULL,
    @LieuTiem NVARCHAR(50) = NULL,
    @GhiChu NVARCHAR(50) = NULL,
    @TrangThai NVARCHAR(50) = NULL,
    @idNguoiDung CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Kiểm tra đăng ký tồn tại
        IF NOT EXISTS (SELECT 1 FROM PDK_TIEMCHUNG WHERE idDKTiemChung = @idDKTiemChung)
        BEGIN
            RAISERROR(N'Đăng ký tiêm chủng không tồn tại', 16, 1);
            RETURN;
        END
        
        -- Kiểm tra trạng thái có thể sửa
        DECLARE @TrangThaiHienTai NVARCHAR(50);
        SELECT @TrangThaiHienTai = TrangThai 
        FROM PDK_TIEMCHUNG 
        WHERE idDKTiemChung = @idDKTiemChung;
        
        IF @TrangThaiHienTai = N'Đã hủy'
        BEGIN
            RAISERROR(N'Không thể sửa đăng ký đã bị hủy', 16, 1);
            RETURN;
        END
        
        -- Kiểm tra vắc xin nếu có thay đổi
        IF @idVacXin IS NOT NULL
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM VACXIN WHERE idVacXin = @idVacXin AND SoLuong > 0 AND (HSD IS NULL OR HSD > GETDATE()))
            BEGIN
                RAISERROR(N'Vắc xin không tồn tại, đã hết hàng hoặc hết hạn', 16, 1);
                RETURN;
            END
        END
        
        -- Cập nhật đăng ký
        UPDATE PDK_TIEMCHUNG SET
            idBenhNhan = ISNULL(@idBenhNhan, idBenhNhan),
            HoTenNguoiLienHe = ISNULL(@HoTenNguoiLienHe, HoTenNguoiLienHe),
            QuanHe = ISNULL(@QuanHe, QuanHe),
            SDT_LienHe = ISNULL(@SDT_LienHe, SDT_LienHe),
            Email = ISNULL(@Email, Email),
            idVacXin = ISNULL(@idVacXin, idVacXin),
            NgayTiem = ISNULL(@NgayTiem, NgayTiem),
            ThoiGianTiem = ISNULL(@ThoiGianTiem, ThoiGianTiem),
            LieuTiem = ISNULL(@LieuTiem, LieuTiem),
            GhiChu = ISNULL(@GhiChu, GhiChu),
            TrangThai = ISNULL(@TrangThai, TrangThai)
        WHERE idDKTiemChung = @idDKTiemChung;
        
        COMMIT TRANSACTION;
        
        SELECT N'Cập nhật đăng ký tiêm chủng thành công' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_CapNhatDonThuoc]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CapNhatDonThuoc]
    @idDonThuoc CHAR(10),
    @idKhamBenh CHAR(10) = NULL,
    @idBenhNhan CHAR(10) = NULL,
    @idNguoiDung CHAR(10) = NULL,
    @ChanDoan NVARCHAR(500) = NULL,
    @GhiChu NVARCHAR(200) = NULL,
    @DanhSachThuoc NVARCHAR(MAX) = NULL -- JSON format
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Cập nhật bảng DON_THUOC nếu có GhiChu, idKhamBenh, idNguoiDung
        UPDATE DON_THUOC
        SET 
            GhiChu = ISNULL(@GhiChu, GhiChu),
            idKhamBenh = ISNULL(@idKhamBenh, idKhamBenh),
            idNguoiDung = ISNULL(@idNguoiDung, idNguoiDung)
        WHERE idDonThuoc = @idDonThuoc;

        -- Cập nhật ChanDoan trong P_KHAMBENH nếu có
        IF @ChanDoan IS NOT NULL
        BEGIN
            DECLARE @idKB CHAR(10);
            SELECT @idKB = ISNULL(@idKhamBenh, idKhamBenh) 
            FROM DON_THUOC 
            WHERE idDonThuoc = @idDonThuoc;

            IF @idKB IS NOT NULL
            BEGIN
                UPDATE P_KHAMBENH 
                SET ChanDoanPhanBiet = @ChanDoan
                WHERE idKhamBenh = @idKB;
            END
        END

        -- Nếu cần cập nhật idBenhNhan, cập nhật qua bảng PDK_KHAMBENH (nếu có)
        IF @idBenhNhan IS NOT NULL AND @idKhamBenh IS NOT NULL
        BEGIN
            UPDATE pdk
            SET pdk.idBenhNhan = @idBenhNhan
            FROM PDK_KHAMBENH pdk
            INNER JOIN P_KHAMBENH pk ON pk.idDKKhamBenh = pdk.idDKKhambenh
            WHERE pk.idKhamBenh = @idKhamBenh;
        END

        -- Cập nhật chi tiết đơn thuốc nếu có
        IF @DanhSachThuoc IS NOT NULL AND @DanhSachThuoc != ''
        BEGIN
            DELETE FROM CT_DONTHUOC WHERE idDonThuoc = @idDonThuoc;

            INSERT INTO CT_DONTHUOC (idDonThuoc, idDuocPham, SoLuong, LieuDung, DuongDung)
            SELECT 
                @idDonThuoc,
                JSON_VALUE(value, '$.idDuocPham'),
                CAST(JSON_VALUE(value, '$.SoLuong') AS INT),
                JSON_VALUE(value, '$.LieuDung'),
                JSON_VALUE(value, '$.DuongDung')
            FROM OPENJSON(@DanhSachThuoc);
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CapNhatTrangThaiChuyenVien]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- cập nhật trạng thái phiếu
CREATE PROCEDURE [dbo].[sp_CapNhatTrangThaiChuyenVien]
    @idChuyenVien CHAR(10),
    @TrangThaiMoi NVARCHAR(50),
    @GhiChuCapNhat NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @current_user_id CHAR(10);
    SET @current_user_id = CAST(SESSION_CONTEXT(N'UserID') AS CHAR(10));
    IF @current_user_id IS NULL
    BEGIN; 
	THROW 51000, N'Lỗi: Không thể xác định người dùng đang đăng nhập.', 1; RETURN; END;
    
    IF @TrangThaiMoi NOT IN (N'Hoàn thành', N'Đã hủy')
    BEGIN; 
	THROW 52005, N'Lỗi: Trạng thái cập nhật không hợp lệ.', 1; RETURN; END;

    UPDATE [dbo].[P_CHUYENVIEN]
    SET 
        [TrangThai] = @TrangThaiMoi,
        [idNguoiPheDuyet] = @current_user_id, -- Người xác nhận/hủy chính là người đang đăng nhập
        [NgayPheDuyet] = GETDATE(),
        [GhiChu] = ISNULL(@GhiChuCapNhat, GhiChu) -- Cập nhật ghi chú nếu có
    WHERE 
        idChuyenVien = @idChuyenVien AND TrangThai = N'Đang chuyển viện';

    IF @@ROWCOUNT = 0
    BEGIN; THROW 52004, N'Lỗi: Phiếu không tồn tại hoặc không ở trạng thái "Đang chuyển viện".', 1; RETURN; END;

    PRINT N'Đã cập nhật trạng thái phiếu chuyển viện ' + @idChuyenVien + N' thành "' + @TrangThaiMoi + N'".';
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CapNhatTrangThaiPhieuKham]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- cập nhật trạng thái phiếu khám
CREATE PROCEDURE [dbo].[sp_CapNhatTrangThaiPhieuKham]
    @idDKKhambenh CHAR(10),
    @TrangThaiMoi NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- Các trạng thái hợp lệ có thể chuyển đến
    IF @TrangThaiMoi NOT IN (N'Đang khám', N'Đã khám', N'Đã hủy')
    BEGIN; THROW 53002, N'Lỗi: Trạng thái mới không hợp lệ.', 1; RETURN; END;
    
    UPDATE [dbo].[PDK_KHAMBENH]
    SET [TrangThai] = @TrangThaiMoi
    WHERE idDKKhambenh = @idDKKhambenh 
      -- Chỉ cho phép cập nhật khi phiếu chưa ở trạng thái cuối cùng
      AND TrangThai NOT IN (N'Đã khám', N'Đã hủy');

    IF @@ROWCOUNT = 0
    BEGIN; THROW 53003, N'Lỗi: Phiếu không tồn tại hoặc đã ở trạng thái cuối cùng (Đã khám/Đã hủy).', 1; RETURN; END;

    PRINT N'Đã cập nhật trạng thái phiếu ' + @idDKKhambenh + N' thành "' + @TrangThaiMoi + N'".';
END
GO
/****** Object:  StoredProcedure [dbo].[sp_KiemTraTonKhoThuoc]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedure kiểm tra tồn kho thuốc (CORRECTED)
CREATE   PROCEDURE [dbo].[sp_KiemTraTonKhoThuoc]
    @DanhSachThuoc NVARCHAR(MAX) -- JSON format: [{"idDuocPham":"DP001","SoLuong":10}]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        t.idDuocPham,
        dp.TenDuocPham,
        t.SoLuongYeuCau,
        dp.SoLuong as SoLuongTon,
        CASE 
            WHEN dp.SoLuong >= t.SoLuongYeuCau THEN N'Đủ hàng'
            WHEN dp.SoLuong > 0 THEN N'Không đủ hàng'
            ELSE N'Hết hàng'
        END as TrangThai,
        dp.HanSuDung,
        CASE 
            WHEN dp.HanSuDung < GETDATE() THEN N'Đã hết hạn'
            WHEN dp.HanSuDung <= DATEADD(MONTH, 1, GETDATE()) THEN N'Sắp hết hạn'
            ELSE N'Còn hạn'
        END as TrangThaiHanSuDung
    FROM (
        SELECT 
            JSON_VALUE(value, '$.idDuocPham') as idDuocPham,
            CAST(JSON_VALUE(value, '$.SoLuong') AS INT) as SoLuongYeuCau
        FROM OPENJSON(@DanhSachThuoc)
    ) t
    LEFT JOIN DUOCPHAM dp ON t.idDuocPham = dp.idDuocPham;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_KiemTraTonKhoVacXin]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 8. Kiểm tra tồn kho vắc xin (sử dụng XML thay vì JSON cho SQL Server cũ)
CREATE PROCEDURE [dbo].[sp_KiemTraTonKhoVacXin]
    @DanhSachVacXin NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Tạo bảng tạm để parse dữ liệu
    CREATE TABLE #TempVaccines (
        idVacXin CHAR(10),
        SoLuongYeuCau INT
    );
    
    -- Parse JSON thủ công (cho SQL Server không hỗ trợ JSON)
    -- Giả sử format: [{"idVacXin":"VX001","SoLuong":1},{"idVacXin":"VX002","SoLuong":2}]
    -- Hoặc có thể truyền dưới dạng XML
    
    -- Ví dụ parse đơn giản (cần điều chỉnh theo format thực tế)
    DECLARE @xml XML = CAST('<root>' + REPLACE(REPLACE(REPLACE(@DanhSachVacXin, '[', ''), ']', ''), '},{', '}</item><item>{') + '</root>' AS XML);
    
    -- Nếu dữ liệu được truyền dưới dạng "VX001:1,VX002:2"
    IF CHARINDEX(':', @DanhSachVacXin) > 0
    BEGIN
        DECLARE @pos INT = 1;
        DECLARE @nextpos INT;
        DECLARE @item NVARCHAR(50);
        DECLARE @idVacXin CHAR(10);
        DECLARE @soLuong INT;
        
        WHILE @pos <= LEN(@DanhSachVacXin)
        BEGIN
            SET @nextpos = CHARINDEX(',', @DanhSachVacXin, @pos);
            IF @nextpos = 0 SET @nextpos = LEN(@DanhSachVacXin) + 1;
            
            SET @item = SUBSTRING(@DanhSachVacXin, @pos, @nextpos - @pos);
            SET @idVacXin = LEFT(@item, CHARINDEX(':', @item) - 1);
            SET @soLuong = CAST(RIGHT(@item, LEN(@item) - CHARINDEX(':', @item)) AS INT);
            
            INSERT INTO #TempVaccines VALUES (@idVacXin, @soLuong);
            
            SET @pos = @nextpos + 1;
        END
    END
    
    -- Trả về kết quả
    SELECT 
        VX.idVacXin,
        VX.TenVacXin,
        VX.SoLuong as SoLuongTon,
        TV.SoLuongYeuCau,
        CASE 
            WHEN VX.SoLuong >= TV.SoLuongYeuCau THEN N'Đủ hàng'
            WHEN VX.SoLuong > 0 THEN N'Không đủ hàng'
            ELSE N'Hết hàng'
        END as TrangThai,
        VX.HSD,
        CASE 
            WHEN VX.HSD IS NOT NULL AND VX.HSD <= GETDATE() THEN N'Đã hết hạn'
            WHEN VX.HSD IS NOT NULL AND VX.HSD <= DATEADD(DAY, 30, GETDATE()) THEN N'Sắp hết hạn'
            ELSE N'Còn hạn'
        END as TrangThaiHSD
    FROM #TempVaccines TV
    INNER JOIN VACXIN VX ON VX.idVacXin = TV.idVacXin
    ORDER BY VX.TenVacXin;
    
    DROP TABLE #TempVaccines;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_KiemTraVacXinSapHetHan]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 17. Kiểm tra vắc xin sắp hết hạn
CREATE PROCEDURE [dbo].[sp_KiemTraVacXinSapHetHan]
    @SoNgayCanBao INT = 30
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        VX.idVacXin,
        VX.TenVacXin,
        LVX.TenLoai as LoaiVacXin,
        VX.SoLuong,
        VX.HSD,
        DATEDIFF(DAY, GETDATE(), VX.HSD) as SoNgayConLai,
        VX.DonGiaBan,
        VX.SoLuong * VX.DonGiaBan as GiaTriTonKho,
        CASE 
            WHEN VX.HSD <= GETDATE() THEN N'Đã hết hạn'
            WHEN VX.HSD <= DATEADD(DAY, 7, GETDATE()) THEN N'Hết hạn trong tuần'
            WHEN VX.HSD <= DATEADD(DAY, @SoNgayCanBao, GETDATE()) THEN N'Sắp hết hạn'
            ELSE N'Còn hạn'
        END as TrangThaiHSD
    FROM VACXIN VX
    LEFT JOIN LOAI_VACXIN LVX ON VX.idLoaiVX = LVX.idLoaiVX
    WHERE VX.HSD IS NOT NULL 
      AND VX.HSD <= DATEADD(DAY, @SoNgayCanBao, GETDATE())
      AND VX.SoLuong > 0
    ORDER BY VX.HSD ASC;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_LayBenhNhanTheoID]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- xem
CREATE PROCEDURE [dbo].[sp_LayBenhNhanTheoID]
    @idBenhNhan CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        bn.*, -- Tất cả các cột từ bảng BENHNHAN
        lb.TenLoaiBHYT,
        lb.MucHuong
    FROM [dbo].[BENHNHAN] bn
    LEFT JOIN [dbo].[LOAI_BHYT] lb ON bn.idLoaiBHYT = lb.idLoaiBHYT
    WHERE bn.idBenhNhan = @idBenhNhan;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_LayCacCaBiAnhHuongBoiDonNghi]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- danh sách ca bị ảnh hưởng
CREATE PROCEDURE [dbo].[sp_LayCacCaBiAnhHuongBoiDonNghi]
    @idNghiPhep CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        clv.idCaLamViec,
        clv.NgayLamViec,
        clv.LoaiCa,
        clv.GioBD,
        clv.GioKT
    FROM [dbo].[CALAMVIEC] clv
    INNER JOIN [dbo].[NGHIPHEP_ANHHUONGCA] anhhuong ON clv.idCaLamViec = anhhuong.idCaLamViec
    WHERE anhhuong.idNghiPhep = @idNghiPhep
    ORDER BY clv.NgayLamViec;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_LayChiTietCaLamViec]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_LayChiTietCaLamViec]
    @idCaLamViec CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        clv.idCaLamViec AS _id,
        clv.NgayLamViec AS date,
        clv.LoaiCa AS shiftType,
        CONVERT(VARCHAR(5), clv.GioBD, 108) AS startTime,
        CONVERT(VARCHAR(5), clv.GioKT, 108) AS endTime,
        clv.TrangThai AS status,
        clv.LoaiCongViec AS workType,
        clv.GhiChu AS notes,
        clv.ThoiGianPheDuyet AS approvedAt,
        
        -- Thông tin nhân viên (separate columns)
        nv.idNhanVien AS staffId,
        SUBSTRING(nv.HoTen, 1, CHARINDEX(' ', nv.HoTen + ' ') - 1) AS staffFirstName,
        SUBSTRING(nv.HoTen, CHARINDEX(' ', nv.HoTen + ' '), LEN(nv.HoTen)) AS staffLastName,
        nv.HoTen AS staffFullName,
        nv.ChucVu AS staffPosition,
        nv.SDT AS staffPhone,
        nv.Email AS staffEmail,
        
        -- Thông tin khoa (separate columns)
        k.idKhoa AS departmentId,
        k.TenKhoa AS departmentName,
        k.ViTri AS departmentLocation,
        
        -- Thông tin lịch tổng thể (separate columns)
        lt.idLichTongThe AS scheduleId,
        lt.TenLich AS scheduleName,
        lt.TuNgay AS scheduleStartDate,
        lt.DenNgay AS scheduleEndDate,
        lt.TrangThai AS scheduleStatus,
        
        -- Tính toán thời gian
        CASE 
            WHEN clv.GioBD IS NOT NULL AND clv.GioKT IS NOT NULL
            THEN DATEDIFF(MINUTE, clv.GioBD, clv.GioKT) / 60.0
            ELSE NULL
        END AS workHours,
        
        DATENAME(WEEKDAY, clv.NgayLamViec) AS dayOfWeek,
        
        -- Thông tin người phê duyệt
        CASE 
            WHEN clv.idNguoiPheDuyet IS NOT NULL 
            THEN (SELECT HoTen FROM NGUOIDUNG WHERE idNguoiDung = clv.idNguoiPheDuyet)
            ELSE NULL
        END AS approvedBy
        
    FROM CALAMVIEC clv
    LEFT JOIN NHANVIEN nv ON clv.idNhanVien = nv.idNhanVien
    LEFT JOIN KHOA k ON clv.idKhoa = k.idKhoa
    LEFT JOIN LICH_TONGTHE lt ON clv.idLichTongThe = lt.idLichTongThe
    
    WHERE clv.idCaLamViec = @idCaLamViec;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_LayChiTietDangKyTiemChungDay]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 2. Lấy chi tiết đăng ký tiêm chủng đầy đủ
CREATE PROCEDURE [dbo].[sp_LayChiTietDangKyTiemChungDay]
    @idDKTiemChung CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        PDK.idDKTiemChung,
        PDK.NgayLap,
        PDK.NgayTiem,
        PDK.HoTenNguoiLienHe,
        PDK.QuanHe,
        PDK.SDT_LienHe,
        PDK.Email,
        PDK.ThoiGianTiem,
        PDK.LieuTiem,
        PDK.GhiChu,
        PDK.TrangThai,
        -- Thông tin bệnh nhân
        BN.idBenhNhan,
        BN.HoTen AS BenhNhan_HoTen,
        BN.NgaySinh AS BenhNhan_NgaySinh,
        BN.GioiTinh AS BenhNhan_GioiTinh,
        BN.DiaChi AS BenhNhan_DiaChi,
        BN.SDT AS BenhNhan_SDT,
        BN.CCCD AS BenhNhan_CCCD,
        BN.BHYT AS BenhNhan_BHYT,
        BN.DanToc AS BenhNhan_DanToc,
        BN.NgheNghiep AS BenhNhan_NgheNghiep,
        BN.HoTenThanNhan AS BenhNhan_ThanNhan,
        BN.MoiQuanHe AS BenhNhan_QuanHe,
        BN.SDTThanNhan AS BenhNhan_SDTThanNhan,
        -- Thông tin vắc xin
        VX.idVacXin,
        VX.TenVacXin AS VacXin_TenVacXin,
        ISNULL(LVX.TenLoai, N'Chưa phân loại') AS VacXin_LoaiVacXin,
        VX.DonGiaBan AS VacXin_DonGiaBan,
        VX.LieuTiem AS VacXin_LieuTiem,
        VX.SoLuong AS VacXin_SoLuong,
        VX.HSD AS VacXin_HSD,
        VX.NgayNhap AS VacXin_NgayNhap,
        VX.GhiChu AS VacXin_GhiChu,
        -- Thông tin người dùng
        ND.idNguoiDung,
        ND.HoTen AS NguoiDung_HoTen,
        ND.ChucVu AS NguoiDung_ChucVu,
        ND.Email AS NguoiDung_Email,
        -- Thông tin nhà cung cấp
        NCC.TenNCC AS NhaCungCap_Ten,
        NCC.DiaChi AS NhaCungCap_DiaChi,
        NCC.SDT AS NhaCungCap_SDT
    FROM 
        PDK_TIEMCHUNG PDK
    INNER JOIN 
        BENHNHAN BN ON PDK.idBenhNhan = BN.idBenhNhan
    INNER JOIN 
        VACXIN VX ON PDK.idVacXin = VX.idVacXin
    LEFT JOIN 
        LOAI_VACXIN LVX ON VX.idLoaiVX = LVX.idLoaiVX
    LEFT JOIN 
        NGUOIDUNG ND ON PDK.idNguoiDung = ND.idNguoiDung
    LEFT JOIN 
        NCC ON VX.idNCC = NCC.idNCC
    WHERE 
        PDK.idDKTiemChung = @idDKTiemChung;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_LayChiTietDonNghiPhep]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- xem
CREATE PROCEDURE [dbo].[sp_LayChiTietDonNghiPhep]
    @idNghiPhep CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        dnp.*,
        nv.HoTen AS TenNhanVien,
        nd_duyet.HoTen AS TenNguoiPheDuyet,
        nv_thaythe.HoTen AS TenNhanVienThayThe
    FROM [dbo].[DON_NGHIPHEP] dnp
    LEFT JOIN [dbo].[NGUOIDUNG] nv ON dnp.idNhanVien = nv.idNguoiDung
    LEFT JOIN [dbo].[NGUOIDUNG] nd_duyet ON dnp.idNguoiPheDuyet = nd_duyet.idNguoiDung
    LEFT JOIN [dbo].[NGUOIDUNG] nv_thaythe ON dnp.idNhanVienThayThe = nv_thaythe.idNguoiDung
    WHERE dnp.idNghiPhep = @idNghiPhep;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_LayChiTietDonThuoc]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedure lấy chi tiết đơn thuốc (danh sách thuốc) (CORRECTED)  
CREATE   PROCEDURE [dbo].[sp_LayChiTietDonThuoc]
    @idDonThuoc CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        ct.idDuocPham as code,
        dp.TenDuocPham as name,
        ct.SoLuong as quantity,
        dp.HanSuDung as expiryDate,
        ct.LieuDung as dosage,
        ct.DuongDung,
        dp.DonGiaBan as unitPrice,
        (ct.SoLuong * dp.DonGiaBan) as totalPrice,
        ct.GhiChu
        
    FROM CT_DONTHUOC ct
    INNER JOIN DUOCPHAM dp ON ct.idDuocPham = dp.idDuocPham
    
    WHERE ct.idDonThuoc = @idDonThuoc
    
    ORDER BY dp.TenDuocPham;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_LayChiTietDonThuocDay]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedure lấy chi tiết một đơn thuốc (CORRECTED)
CREATE   PROCEDURE [dbo].[sp_LayChiTietDonThuocDay]
    @idDonThuoc CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Thông tin đơn thuốc
    SELECT 
        dt.idDonThuoc,
        dt.NgayLap,
        dt.TrangThai,
        dt.GhiChu,
        
        -- Thông tin bệnh nhân
        bn.idBenhNhan,
        bn.HoTen as BenhNhan_HoTen,
        CAST(bn.SDT AS VARCHAR(15)) as BenhNhan_SDT,
        bn.DiaChi as BenhNhan_DiaChi,
        bn.BHYT as SoBHYT,
        CASE WHEN bn.BHYT IS NOT NULL AND bn.BHYT != '' THEN 1 ELSE 0 END as HasInsurance,
        
        -- Thông tin bác sĩ
        bs.idNguoiDung as BacSi_Id,
        bs.HoTen as BacSi_HoTen,
        bs.ChucVu as BacSi_ChucVu,
        
        -- Thông tin khám bệnh
        COALESCE(
            kb.ChanDoanPhanBiet,
            CASE 
                WHEN kb.idICDChanDoan IS NOT NULL THEN (SELECT TOP 1 TenBenh FROM ICD WHERE idICD = kb.idICDChanDoan)
                WHEN kb.idICDKetLuan IS NOT NULL THEN (SELECT TOP 1 TenBenh FROM ICD WHERE idICD = kb.idICDKetLuan)
                ELSE N'Chưa có chẩn đoán'
            END
        ) as ChanDoan
        
    FROM DON_THUOC dt
    LEFT JOIN P_KHAMBENH kb ON dt.idKhamBenh = kb.idKhamBenh
    LEFT JOIN PDK_KHAMBENH pdk ON kb.idDKKhamBenh = pdk.idDKKhambenh
    LEFT JOIN BENHNHAN bn ON pdk.idBenhNhan = bn.idBenhNhan
    LEFT JOIN NGUOIDUNG bs ON dt.idNguoiDung = bs.idNguoiDung
    
    WHERE dt.idDonThuoc = @idDonThuoc;
    
    -- Danh sách thuốc trong đơn
    SELECT 
        ct.idDuocPham as code,
        dp.TenDuocPham as name,
        ct.SoLuong as quantity,
        dp.HanSuDung as expiryDate,
        ct.LieuDung as dosage,
        ct.DuongDung,
        dp.DonGiaBan as unitPrice,
        (ct.SoLuong * dp.DonGiaBan) as totalPrice,
        ct.GhiChu
        
    FROM CT_DONTHUOC ct
    INNER JOIN DUOCPHAM dp ON ct.idDuocPham = dp.idDuocPham
    
    WHERE ct.idDonThuoc = @idDonThuoc
    
    ORDER BY dp.TenDuocPham;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_LayChiTietDuocPham]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 3. DUOCPHAM
	-- xem
CREATE PROCEDURE [dbo].[sp_LayChiTietDuocPham]
    @idDuocPham CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        dp.idDuocPham,
        dp.TenDuocPham,
        dp.DVT,
        dp.HanSuDung,
        dp.NhaSX,
        dp.SoLuong,
        dp.DonGiaMua,
        dp.DonGiaBan,
        dp.MoTa,
        dp.DonVi,
        dp.HoatChat,
        -- Lấy thông tin từ các bảng liên quan
        ldp.TenLoaiDuocPham,
        ncc.TenNCC AS TenNhaCungCap,
        -- Giữ lại các ID khóa ngoại để tiện xử lý ở phía ứng dụng nếu cần
        dp.idLoaiDuocPham,
        dp.idNCC
    FROM 
        [dbo].[DUOCPHAM] dp
    -- Nối với bảng Loại Dược Phẩm
    LEFT JOIN 
        [dbo].[LOAI_DUOCPHAM] ldp ON dp.idLoaiDuocPham = ldp.idLoaiDuocPham
    -- Nối với bảng Nhà Cung Cấp (giả sử tên bảng là NHACUNGCAP)
    LEFT JOIN 
        [dbo].[NCC] ncc ON dp.idNCC = ncc.idNCC
    WHERE 
        dp.idDuocPham = @idDuocPham;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_LayChiTietPhieuChuyenVien]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_LayChiTietPhieuChuyenVien]
    @idChuyenVien CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        pcv.idChuyenVien,
        pcv.idChuyenVien as transferCode,
        pcv.NgayLap as createdDate,
        pcv.NgayChuyen as transferDate,
        pcv.ThoiGianDuKien as estimatedTime,
        pcv.SDT_CoSoYTe as destinationPhone,
        pcv.YThuc as consciousness,
        pcv.GhiChu as notes,
        pcv.TrangThai as status,
        pcv.NgayPheDuyet as approvalDate,
        pcv.idYeuCauChuyenVien as idYeuCauChuyenVien,
        
        -- Thông tin từ yêu cầu chuyển viện
        pyc.idYeuCauChuyenVien as requestId,
        pyc.LyDo as reason,
        pyc.CoSoChuyenDen as destinationFacility,
        pyc.DiaChi as destinationAddress,
        pyc.MucDo as priority,
        
        -- Thông tin bệnh nhân
        bn.idBenhNhan as patientId,
        bn.HoTen as patientName,
        PARSENAME(REPLACE(bn.HoTen, ' ', '.'), 1) as lastName,
        STUFF(bn.HoTen, CHARINDEX(' ' + PARSENAME(REPLACE(bn.HoTen, ' ', '.'), 1), bn.HoTen), LEN(PARSENAME(REPLACE(bn.HoTen, ' ', '.'), 1)) + 1, '') as firstName,
        bn.NgaySinh as dateOfBirth,
        bn.GioiTinh as gender,
        bn.SDT as phone,
        bn.DiaChi as address,
        bn.CCCD as idNumber,
        bn.BHYT as insuranceNumber,
        bn.DoiTuongUuTien as priorityType,
       
        
        -- Thông tin người phê duyệt
        pd.idNguoiDung as approverId,
        pd.HoTen as approverName,
        
        -- Thông tin người tạo
        nd.idNguoiDung as createdById,
        nd.HoTen as createdByName,
        
        pyc.NgayLap as treatmentDate
    FROM P_CHUYENVIEN pcv
    LEFT JOIN PYC_CHUYENVIEN pyc ON pcv.idYeuCauChuyenVien = pyc.idYeuCauChuyenVien
    LEFT JOIN BENHNHAN bn ON pyc.idBenhNhan = bn.idBenhNhan
    LEFT JOIN NGUOIDUNG pd ON pcv.idNguoiPheDuyet = pd.idNguoiDung
    LEFT JOIN NGUOIDUNG nd ON pcv.idNguoiDung = nd.idNguoiDung
    WHERE pcv.idChuyenVien = @idChuyenVien;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_LayChiTietPhieuKham]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 4. P_KHAMBENH
	-- lấy thông tin
CREATE PROCEDURE [dbo].[sp_LayChiTietPhieuKham]
    @idKhamBenh CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        -- Thông tin chính từ P_KHAMBENH
        pkb.*,

        -- Thông tin từ Bệnh nhân (qua Phiếu Đăng Ký)
        bn.HoTen AS TenBenhNhan,
        bn.NgaySinh,
        bn.GioiTinh,
        bn.SDT,
        bn.BHYT,
        bn.DiaChi,

        -- Thông tin từ ICD
        icd_cd.TenBenh AS TenICDChanDoan,
        icd_kl.TenBenh AS TenICDKetLuan,

        -- Thông tin từ các bảng khác
        lk.TenLoaiKham,
        nd.HoTen AS TenBacSiKham -- Giả sử bảng NGUOIDUNG có cột HoTen

    FROM
        [dbo].[P_KHAMBENH] pkb
    -- Nối để lấy thông tin Bệnh Nhân
    LEFT JOIN [dbo].[PDK_KHAMBENH] pdk ON pkb.idDKKhamBenh = pdk.idDKKhambenh
    LEFT JOIN [dbo].[BENHNHAN] bn ON pdk.idBenhNhan = bn.idBenhNhan

    -- Nối để lấy tên chẩn đoán ICD
    LEFT JOIN [dbo].[ICD] icd_cd ON pkb.idICDChanDoan = icd_cd.idICD
    LEFT JOIN [dbo].[ICD] icd_kl ON pkb.idICDKetLuan = icd_kl.idICD

    -- Nối để lấy các thông tin khác
    LEFT JOIN [dbo].[LOAIKHAM] lk ON pkb.idLoaiKham = lk.idLoaiKham
    LEFT JOIN [dbo].[VACXIN] vx ON pkb.idVacxin = vx.idVacXin
    LEFT JOIN [dbo].[NGUOIDUNG] nd ON pkb.idNguoiDung = nd.idNguoiDung

    WHERE
        pkb.idKhamBenh = @idKhamBenh;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_LayChiTietVacXin]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- xem
CREATE PROCEDURE [dbo].[sp_LayChiTietVacXin]
    @idVacXin CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        -- Tất cả các cột từ bảng VACXIN
        vx.idVacXin,
        vx.TenVacXin,
        vx.NgayNhap,
        vx.SoLuong,
        vx.HSD,
        vx.LieuTiem,
        vx.DonGiaMua,
        vx.DonGiaBan,
        vx.GhiChu,
        
        -- Thông tin lấy từ các bảng liên quan
        lvx.TenLoai AS TenLoaiVacXin,
        ncc.TenNCC AS TenNhaCungCap, -- Giả sử bảng Nhà Cung Cấp là NHACUNGCAP và có cột TenNCC
        
        -- Giữ lại các ID khóa ngoại để tiện xử lý ở phía ứng dụng nếu cần
        vx.idNCC,
        vx.idLoaiVX
    FROM 
        [dbo].[VACXIN] vx
    -- Nối với bảng Loại Vắc-xin
    LEFT JOIN 
        [dbo].[LOAI_VACXIN] lvx ON vx.idLoaiVX = lvx.idLoaiVX
    -- Nối với bảng Nhà Cung Cấp
    LEFT JOIN 
        [dbo].[NCC] ncc ON vx.idNCC = ncc.idNCC
    WHERE 
        vx.idVacXin = @idVacXin;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_LayChiTietYeuCauChuyenCa]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- xem
CREATE PROCEDURE [dbo].[sp_LayChiTietYeuCauChuyenCa]
    @idYeuCauChuyenCa CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT
        -- Thông tin chính của yêu cầu
        pyc.idYeuCauChuyenCa, pyc.NgayYeuCau, pyc.TrangThai, pyc.LyDo, pyc.GhiChu,
        pyc.CanBuCa, pyc.NgayPheDuyet, pyc.GhiChuPheDuyet,

        -- Thông tin nhân viên cũ
        pyc.idNhanVienCu, nv_cu.HoTen AS TenNhanVienCu,
        
        -- Thông tin nhân viên mới
        pyc.idNhanVienMoi, nv_moi.HoTen AS TenNhanVienMoi,
        
        -- Thông tin ca gốc
        pyc.idCaLamViecGoc, ca_goc.NgayLamViec AS NgayCaGoc, ca_goc.LoaiCa AS LoaiCaGoc,
        ca_goc.GioBD AS GioBD_Goc, ca_goc.GioKT AS GioKT_Goc,
        
        -- Thông tin ca mới (nếu có)
        pyc.idCaLamViecMoi, ca_moi.NgayLamViec AS NgayCaMoi, ca_moi.LoaiCa AS LoaiCaMoi,
        
        -- Thông tin ca bù (nếu có)
        pyc.idCaLamViecBu, ca_bu.NgayLamViec AS NgayCaBu, ca_bu.LoaiCa AS LoaiCaBu,

        -- Thông tin người tạo và người phê duyệt
        pyc.idNguoiDung AS idNguoiTao, nd_tao.HoTen AS TenNguoiTao,
        pyc.idNguoiPheDuyet, nd_duyet.HoTen AS TenNguoiPheDuyet

    FROM [dbo].[PYC_CHUYENCA] pyc
    -- Nối để lấy tên các nhân viên
    LEFT JOIN [dbo].[NGUOIDUNG] nv_cu ON pyc.idNhanVienCu = nv_cu.idNguoiDung
    LEFT JOIN [dbo].[NGUOIDUNG] nv_moi ON pyc.idNhanVienMoi = nv_moi.idNguoiDung
    LEFT JOIN [dbo].[NGUOIDUNG] nd_tao ON pyc.idNguoiDung = nd_tao.idNguoiDung
    LEFT JOIN [dbo].[NGUOIDUNG] nd_duyet ON pyc.idNguoiPheDuyet = nd_duyet.idNguoiDung
    
    -- Nối để lấy thông tin các ca làm việc
    LEFT JOIN [dbo].[CALAMVIEC] ca_goc ON pyc.idCaLamViecGoc = ca_goc.idCaLamViec
    LEFT JOIN [dbo].[CALAMVIEC] ca_moi ON pyc.idCaLamViecMoi = ca_moi.idCaLamViec
    LEFT JOIN [dbo].[CALAMVIEC] ca_bu ON pyc.idCaLamViecBu = ca_bu.idCaLamViec
    
    WHERE pyc.idYeuCauChuyenCa = @idYeuCauChuyenCa;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_LayChiTietYeuCauChuyenVien]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_LayChiTietYeuCauChuyenVien]
    @idYeuCauChuyenVien CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        pyc.idYeuCauChuyenVien,
        pyc.idYeuCauChuyenVien AS requestCode,
        pyc.NgayLap AS requestDate,
        pyc.LyDo AS reason,
        pyc.CoSoChuyenDen AS destinationFacility,
        pyc.DiaChi AS destinationAddress,
        pyc.NgayChuyen AS transferDate,
        pyc.TrangThai AS status,
        pyc.NgayPheDuyet AS approvalDate,
        pyc.MucDo AS priority,
        pyc.GhiChu AS notes,
        pyc.YkienPheDuyet AS approvalNotes,
		pyc.idBacSiPhuTrach AS doctorId,

        -- Bệnh nhân
        bn.idBenhNhan AS patientId,
        bn.HoTen AS patientName,
        PARSENAME(REPLACE(bn.HoTen, ' ', '.'), 1) AS lastName,
        STUFF(bn.HoTen, CHARINDEX(' ' + PARSENAME(REPLACE(bn.HoTen, ' ', '.'), 1), bn.HoTen), LEN(PARSENAME(REPLACE(bn.HoTen, ' ', '.'), 1)) + 1, '') AS firstName,
        bn.NgaySinh AS dateOfBirth,
        bn.GioiTinh AS gender,
        bn.SDT AS phone,
        bn.DiaChi AS address,
        bn.CCCD AS idNumber,
        bn.BHYT AS insuranceNumber,
        bn.DoiTuongUuTien AS priorityType,
        lbh.MucHuong AS mucHuong,  -- Lấy từ bảng LOAI_BHYT thông qua BENHNHAN.idLoaiBHYT

        -- Bác sĩ phụ trách
        
        bs.HoTen AS doctorName,

        -- Người phê duyệt
        pd.idNguoiDung AS approverId,
        pd.HoTen AS approverName,

        -- Người tạo phiếu
        nd.idNguoiDung AS createdById,
        nd.HoTen AS createdByName,

        pyc.NgayLap AS treatmentDate
    FROM PYC_CHUYENVIEN pyc
    LEFT JOIN BENHNHAN bn ON pyc.idBenhNhan = bn.idBenhNhan
    LEFT JOIN LOAI_BHYT lbh ON bn.idLoaiBHYT = lbh.idLoaiBHYT
    LEFT JOIN NGUOIDUNG bs ON pyc.idBacSiPhuTrach = bs.idNguoiDung
    LEFT JOIN NGUOIDUNG pd ON pyc.idNguoiPheDuyet = pd.idNguoiDung
    LEFT JOIN NGUOIDUNG nd ON pyc.idNguoiDung = nd.idNguoiDung
    WHERE RTRIM(pyc.idYeuCauChuyenVien) = RTRIM(@idYeuCauChuyenVien);
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_LayDanhSachBacSi]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedure lấy danh sách bác sĩ (CORRECTED)
CREATE   PROCEDURE [dbo].[sp_LayDanhSachBacSi]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        idNguoiDung as _id,
        CASE 
            WHEN CHARINDEX(' ', HoTen) > 0 
            THEN SUBSTRING(HoTen, 1, CHARINDEX(' ', HoTen) - 1)
            ELSE HoTen
        END as firstName,
        CASE 
            WHEN CHARINDEX(' ', HoTen) > 0 
            THEN LTRIM(SUBSTRING(HoTen, CHARINDEX(' ', HoTen) + 1, LEN(HoTen)))
            ELSE ''
        END as lastName,
        ChucVu as department
    FROM NGUOIDUNG 

    ORDER BY HoTen;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_LayDanhSachBenhNhan]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedure lấy danh sách bệnh nhân (CORRECTED)
CREATE   PROCEDURE [dbo].[sp_LayDanhSachBenhNhan]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        idBenhNhan as _id,
        CASE 
            WHEN CHARINDEX(' ', HoTen) > 0 
            THEN SUBSTRING(HoTen, 1, CHARINDEX(' ', HoTen) - 1)
            ELSE HoTen
        END as firstName,
        CASE 
            WHEN CHARINDEX(' ', HoTen) > 0 
            THEN LTRIM(SUBSTRING(HoTen, CHARINDEX(' ', HoTen) + 1, LEN(HoTen)))
            ELSE ''
        END as lastName,
        CAST(SDT AS VARCHAR(15)) as phone,
        DiaChi as address,
        BHYT as insuranceNumber
    FROM BENHNHAN 
    WHERE TrangThai IS NULL OR TrangThai != N'Đã xóa'
    ORDER BY HoTen;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_LayDanhSachDangKyTiemChungChiTiet]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Tạo lại stored procedure
CREATE PROCEDURE [dbo].[sp_LayDanhSachDangKyTiemChungChiTiet]
    @TuNgay DATE = NULL,
    @DenNgay DATE = NULL,
    @TrangThai NVARCHAR(50) = NULL,
    @Keyword NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        dk.idDKTiemChung,
        dk.NgayLap,
        dk.NgayTiem,
        dk.ThoiGianTiem,
        dk.TrangThai,
        dk.HoTenNguoiLienHe,
        dk.QuanHe,
        dk.SDT_LienHe,
        dk.Email,
        dk.LieuTiem,
        dk.GhiChu,
        -- Thông tin bệnh nhân
        bn.idBenhNhan,
        bn.HoTen as BenhNhan_HoTen,
        bn.NgaySinh as BenhNhan_NgaySinh,
        bn.GioiTinh as BenhNhan_GioiTinh,
        bn.SDT as BenhNhan_SDT,
        bn.DiaChi as BenhNhan_DiaChi,
        bn.CCCD as BenhNhan_CCCD,
        bn.BHYT as BenhNhan_BHYT,
        bn.DanToc as BenhNhan_DanToc,
        -- Thông tin vắc xin
        vx.idVacXin,
        vx.TenVacXin as VacXin_TenVacXin,
        vx.idLoaiVX as VacXin_LoaiVacXin,
        vx.DonGiaBan as VacXin_DonGiaBan,
        vx.LieuTiem as VacXin_LieuTiem,
        vx.SoLuong as VacXin_SoLuong,
        vx.HSD as VacXin_HSD,
        -- Thông tin người dùng
        nd.idNguoiDung,
        nd.HoTen as NguoiDung_HoTen,
        nd.ChucVu as NguoiDung_ChucVu
    FROM PDK_TIEMCHUNG dk
    INNER JOIN BENHNHAN bn ON dk.idBenhNhan = bn.idBenhNhan
    INNER JOIN VACXIN vx ON dk.idVacXin = vx.idVacXin
    INNER JOIN NGUOIDUNG nd ON dk.idNguoiDung = nd.idNguoiDung
    WHERE 1=1
        AND (@TuNgay IS NULL OR dk.NgayTiem >= @TuNgay)
        AND (@DenNgay IS NULL OR dk.NgayTiem <= @DenNgay)
        AND (@TrangThai IS NULL OR dk.TrangThai = @TrangThai)
        AND (@Keyword IS NULL OR 
             bn.HoTen LIKE '%' + @Keyword + '%' OR
             vx.TenVacXin LIKE '%' + @Keyword + '%' OR
             dk.idDKTiemChung LIKE '%' + @Keyword + '%')
    ORDER BY dk.NgayLap DESC, dk.NgayTiem DESC;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_LayDanhSachDonThuocChiTiet]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_LayDanhSachDonThuocChiTiet]
    @TuNgay DATE = NULL,
    @DenNgay DATE = NULL,
    @TrangThai NVARCHAR(50) = NULL,
    @Keyword NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        dt.idDonThuoc,
        dt.NgayLap,
        dt.TrangThai,
        dt.GhiChu,
        dt.idKhamBenh as idKhamBenh,
        pdk.KhamBHYT as KhamBHYT,

        -- Thông tin bệnh nhân
        bn.idBenhNhan,
        bn.HoTen as BenhNhan_HoTen,
        bn.SDT as BenhNhan_SDT,
        bn.DiaChi as BenhNhan_DiaChi,
        bn.BHYT as SoBHYT,
        lb.MucHuong as MucHuong,  -- Lấy mức hưởng BHYT

        -- Bác sĩ
        bs.idNguoiDung as BacSi_Id,
        bs.HoTen as BacSi_HoTen,
        bs.ChucVu as BacSi_ChucVu,

        -- Chẩn đoán
        COALESCE(
            kb.ChanDoanPhanBiet,
            CASE 
                WHEN kb.idICDChanDoan IS NOT NULL THEN (SELECT TOP 1 TenBenh FROM ICD WHERE idICD = kb.idICDChanDoan)
                WHEN kb.idICDKetLuan IS NOT NULL THEN (SELECT TOP 1 TenBenh FROM ICD WHERE idICD = kb.idICDKetLuan)
                ELSE N'Chưa có chẩn đoán'
            END
        ) as ChanDoan,

        -- Tổng tiền
        ISNULL(SUM(ct.SoLuong * dp.DonGiaBan), 0) as TotalAmount,

        -- Tính phần BHYT và phần người bệnh trả
        CASE 
            WHEN bn.BHYT IS NOT NULL AND bn.BHYT != '' 
            THEN ISNULL(SUM(ct.SoLuong * dp.DonGiaBan), 0) * ISNULL(lb.MucHuong, 0) 
            ELSE 0 
        END as InsuranceAmount,

        CASE 
            WHEN bn.BHYT IS NOT NULL AND bn.BHYT != '' 
            THEN ISNULL(SUM(ct.SoLuong * dp.DonGiaBan), 0) * (1 - ISNULL(lb.MucHuong, 0) ) 
            ELSE ISNULL(SUM(ct.SoLuong * dp.DonGiaBan), 0) 
        END as FinalAmount

    FROM DON_THUOC dt
    LEFT JOIN P_KHAMBENH kb ON dt.idKhamBenh = kb.idKhamBenh
    LEFT JOIN PDK_KHAMBENH pdk ON kb.idDKKhamBenh = pdk.idDKKhambenh
    LEFT JOIN BENHNHAN bn ON pdk.idBenhNhan = bn.idBenhNhan
    LEFT JOIN LOAI_BHYT lb ON bn.idLoaiBHYT = lb.idLoaiBHYT  -- JOIN bảng LOAI_BHYT
    LEFT JOIN NGUOIDUNG bs ON dt.idNguoiDung = bs.idNguoiDung
    LEFT JOIN CT_DONTHUOC ct ON dt.idDonThuoc = ct.idDonThuoc
    LEFT JOIN DUOCPHAM dp ON ct.idDuocPham = dp.idDuocPham

    WHERE (@TuNgay IS NULL OR dt.NgayLap >= @TuNgay)
        AND (@DenNgay IS NULL OR dt.NgayLap <= @DenNgay)
        AND (@TrangThai IS NULL OR dt.TrangThai = @TrangThai)
        AND (@Keyword IS NULL OR 
             dt.idDonThuoc LIKE '%' + @Keyword + '%' OR
             bn.HoTen LIKE '%' + @Keyword + '%' OR
             CAST(bn.SDT AS VARCHAR(15)) LIKE '%' + @Keyword + '%' OR
             kb.ChanDoanPhanBiet LIKE '%' + @Keyword + '%')

    GROUP BY 
        dt.idDonThuoc, dt.NgayLap, dt.TrangThai, dt.GhiChu, dt.idKhamBenh,
        pdk.KhamBHYT,
        bn.idBenhNhan, bn.HoTen, bn.SDT, bn.DiaChi, bn.BHYT, bn.idLoaiBHYT,
        bs.idNguoiDung, bs.HoTen, bs.ChucVu,
        kb.ChanDoanPhanBiet, kb.idICDChanDoan, kb.idICDKetLuan,
        lb.MucHuong

    ORDER BY dt.NgayLap DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_LayDanhSachLoaiVacXin]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 18. Lấy danh sách loại vắc xin
CREATE PROCEDURE [dbo].[sp_LayDanhSachLoaiVacXin]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        idLoaiVX as id,
        TenLoai as name,
        MoTa as description
    FROM LOAI_VACXIN
    ORDER BY TenLoai;
END;


GO
/****** Object:  StoredProcedure [dbo].[sp_LayDanhSachNhaCungCap]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 19. Lấy danh sách nhà cung cấp
CREATE PROCEDURE [dbo].[sp_LayDanhSachNhaCungCap]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        idNCC as id,
        TenNCC as name,
        DiaChi as address,
        LTRIM(RTRIM(SDT)) as phone,
        QuocGia as country
    FROM NCC
    ORDER BY TenNCC;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_LayDanhSachPhieuChuyenVien]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_LayDanhSachPhieuChuyenVien]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        pcv.idChuyenVien,
        pcv.idChuyenVien as transferCode,
        pcv.NgayLap as createdDate,
        pcv.NgayChuyen as transferDate,
        pcv.ThoiGianDuKien as estimatedTime,
        pcv.SDT_CoSoYTe as destinationPhone,
        pcv.YThuc as consciousness,
        pcv.GhiChu as notes,
        pcv.TrangThai as status,
        pcv.NgayPheDuyet as approvalDate,
        pcv.idYeuCauChuyenVien as idYeuCauChuyenVien,
        
        -- Thông tin từ yêu cầu chuyển viện
        pyc.LyDo as reason,
        pyc.CoSoChuyenDen as destinationFacility,
        pyc.DiaChi as destinationAddress,
        pyc.MucDo as priority,
        
        -- Thông tin bệnh nhân
        bn.idBenhNhan as patientId,
        bn.HoTen as patientName,
        PARSENAME(REPLACE(bn.HoTen, ' ', '.'), 1) as lastName,
        STUFF(bn.HoTen, CHARINDEX(' ' + PARSENAME(REPLACE(bn.HoTen, ' ', '.'), 1), bn.HoTen), LEN(PARSENAME(REPLACE(bn.HoTen, ' ', '.'), 1)) + 1, '') as firstName,
        bn.NgaySinh as dateOfBirth,
        bn.GioiTinh as gender,
        bn.SDT as phone,
        bn.DiaChi as address,
        bn.CCCD as idNumber,
        bn.BHYT as insuranceNumber,
        bn.DoiTuongUuTien as priorityType,
        
        
        -- Thông tin người phê duyệt
        pd.idNguoiDung as approverId,
        pd.HoTen as approverName,
        
        -- Thông tin người tạo
        nd.idNguoiDung as createdById,
        nd.HoTen as createdByName,
        
        pyc.NgayLap as treatmentDate
    FROM P_CHUYENVIEN pcv
    LEFT JOIN PYC_CHUYENVIEN pyc ON pcv.idYeuCauChuyenVien = pyc.idYeuCauChuyenVien
    LEFT JOIN BENHNHAN bn ON pyc.idBenhNhan = bn.idBenhNhan
    LEFT JOIN NGUOIDUNG pd ON pcv.idNguoiPheDuyet = pd.idNguoiDung
    LEFT JOIN NGUOIDUNG nd ON pcv.idNguoiDung = nd.idNguoiDung
    ORDER BY pcv.NgayLap DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_LayDanhSachVacXin]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 7. Lấy danh sách vắc xin có sẵn
CREATE PROCEDURE [dbo].[sp_LayDanhSachVacXin]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        VX.idVacXin as id,
        VX.TenVacXin as name,
        ISNULL(LVX.TenLoai, N'Chưa phân loại') as type,
        VX.DonGiaBan as price,
        VX.GhiChu as description,
        VX.SoLuong as quantity,
        VX.HSD as expiryDate,
        VX.LieuTiem as dosage,
        VX.NgayNhap as importDate,
        NCC.TenNCC as supplierName,
        CASE 
            WHEN VX.SoLuong <= 0 THEN N'Hết hàng'
            WHEN VX.HSD IS NOT NULL AND VX.HSD <= GETDATE() THEN N'Hết hạn'
            WHEN VX.HSD IS NOT NULL AND VX.HSD <= DATEADD(DAY, 30, GETDATE()) THEN N'Sắp hết hạn'
            ELSE N'Còn hàng'
        END as status
    FROM VACXIN VX
    LEFT JOIN LOAI_VACXIN LVX ON VX.idLoaiVX = LVX.idLoaiVX
    LEFT JOIN NCC ON VX.idNCC = NCC.idNCC
    ORDER BY VX.TenVacXin;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_LayDanhSachYeuCauChuyenVien]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_LayDanhSachYeuCauChuyenVien]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        pyc.idYeuCauChuyenVien,
        pyc.idYeuCauChuyenVien as requestCode,
        pyc.NgayLap as requestDate,
        pyc.LyDo as reason,
        pyc.CoSoChuyenDen as destinationFacility,
        pyc.DiaChi as destinationAddress,
        pyc.NgayChuyen as transferDate,
        pyc.TrangThai as status,
        pyc.NgayPheDuyet as approvalDate,
        pyc.MucDo as priority,
        pyc.GhiChu as notes,
        pyc.YkienPheDuyet as approvalNotes,
		pyc.idBacSiPhuTrach as doctorId,
        
        -- Thông tin bệnh nhân
        bn.idBenhNhan as patientId,
        bn.HoTen as patientName,
        PARSENAME(REPLACE(bn.HoTen, ' ', '.'), 1) as lastName,
        STUFF(bn.HoTen, CHARINDEX(' ' + PARSENAME(REPLACE(bn.HoTen, ' ', '.'), 1), bn.HoTen), LEN(PARSENAME(REPLACE(bn.HoTen, ' ', '.'), 1)) + 1, '') as firstName,
        bn.NgaySinh as dateOfBirth,
        bn.GioiTinh as gender,
        bn.SDT as phone,
        bn.DiaChi as address,
        bn.CCCD as idNumber,
        bn.BHYT as insuranceNumber,
        bn.DoiTuongUuTien as priorityType,
        
        -- Thông tin bác sĩ phụ trách
 
        bs.HoTen as doctorName,
        
        -- Thông tin người phê duyệt
        pd.idNguoiDung as approverId,
        pd.HoTen as approverName,
        
        -- Thông tin người tạo
        nd.idNguoiDung as createdById,
        nd.HoTen as createdByName,
        
        pyc.NgayLap as treatmentDate
    FROM PYC_CHUYENVIEN pyc
    LEFT JOIN BENHNHAN bn ON pyc.idBenhNhan = bn.idBenhNhan
    LEFT JOIN NGUOIDUNG bs ON pyc.idBacSiPhuTrach = bs.idNguoiDung
    LEFT JOIN NGUOIDUNG pd ON pyc.idNguoiPheDuyet = pd.idNguoiDung
    LEFT JOIN NGUOIDUNG nd ON pyc.idNguoiDung = nd.idNguoiDung
    ORDER BY pyc.NgayLap DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_LayDonThuocTheoID]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- xem
CREATE PROCEDURE [dbo].[sp_LayDonThuocTheoID]
    @idDonThuoc CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        dt.idDonThuoc,
        dt.NgayLap,
        dt.TrangThai,
        dt.GhiChu,
        dt.idKhamBenh,
        bn.HoTen AS TenBenhNhan,
        bn.NgaySinh AS NgaySinhBenhNhan,
        nd.HoTen AS TenBacSi
    FROM [dbo].[DON_THUOC] dt
    -- Nối các bảng để lấy thông tin chi tiết hơn
    INNER JOIN [dbo].[PDK_KHAMBENH] pdk ON dt.idKhamBenh = pdk.idDKKhambenh
    INNER JOIN [dbo].[BENHNHAN] bn ON pdk.idBenhNhan = bn.idBenhNhan
    LEFT JOIN [dbo].[NGUOIDUNG] nd ON dt.idNguoiDung = nd.idNguoiDung
    WHERE dt.idDonThuoc = @idDonThuoc;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_LayKhamBenh_TheoIdBenhNhan]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_LayKhamBenh_TheoIdBenhNhan]
    @idBenhNhan CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        pkb.idKhamBenh,
        pkb.ChanDoanPhanBiet,
        pdk.KhamBHYT,
        lbh.MucHuong
    FROM P_KHAMBENH pkb
    INNER JOIN PDK_KHAMBENH pdk ON pkb.idDKKhamBenh = pdk.idDKKhambenh
    INNER JOIN BENHNHAN bn ON pdk.idBenhNhan = bn.idBenhNhan
    LEFT JOIN LOAI_BHYT lbh ON bn.idLoaiBHYT = lbh.idLoaiBHYT
    WHERE pdk.idBenhNhan = @idBenhNhan
    ORDER BY pkb.NgayKham DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_LayLichLamViecTuan]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_LayLichLamViecTuan]
    @TuNgay DATE,
    @DenNgay DATE,
    @idKhoa CHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        clv.idCaLamViec AS _id,
        clv.NgayLamViec AS date,
        clv.LoaiCa AS shiftType,
        CONVERT(VARCHAR(5), clv.GioBD, 108) AS startTime,
        CONVERT(VARCHAR(5), clv.GioKT, 108) AS endTime,
        clv.TrangThai AS status,
        clv.LoaiCongViec AS workType,
        clv.GhiChu AS notes,
        
        -- Thông tin nhân viên (separate columns)
        nv.idNhanVien AS staffId,
        SUBSTRING(nv.HoTen, 1, CHARINDEX(' ', nv.HoTen + ' ') - 1) AS staffFirstName,
        SUBSTRING(nv.HoTen, CHARINDEX(' ', nv.HoTen + ' '), LEN(nv.HoTen)) AS staffLastName,
        nv.HoTen AS staffFullName,
        nv.ChucVu AS staffPosition,
        nv.SDT AS staffPhone,
        nv.Email AS staffEmail,
        
        -- Thông tin khoa
        k.TenKhoa AS department,
        k.idKhoa AS departmentId,
        
        -- Thông tin lịch tổng thể
        lt.TenLich AS scheduleName,
        
        -- Thời gian tạo và phê duyệt
        clv.ThoiGianPheDuyet AS approvedAt,
        
        -- Tính toán thời gian làm việc (số giờ)
        CASE 
            WHEN clv.GioBD IS NOT NULL AND clv.GioKT IS NOT NULL
            THEN DATEDIFF(MINUTE, clv.GioBD, clv.GioKT) / 60.0
            ELSE NULL
        END AS workHours,
        
        -- Thông tin về ngày trong tuần
        DATENAME(WEEKDAY, clv.NgayLamViec) AS dayOfWeek,
        DATEPART(WEEKDAY, clv.NgayLamViec) AS dayOfWeekNumber
        
    FROM CALAMVIEC clv
    LEFT JOIN NHANVIEN nv ON clv.idNhanVien = nv.idNhanVien
    LEFT JOIN KHOA k ON clv.idKhoa = k.idKhoa
    LEFT JOIN LICH_TONGTHE lt ON clv.idLichTongThe = lt.idLichTongThe
    
    WHERE clv.NgayLamViec >= @TuNgay 
      AND clv.NgayLamViec <= @DenNgay
      AND (@idKhoa IS NULL OR clv.idKhoa = @idKhoa)
    
    ORDER BY clv.NgayLamViec, clv.GioBD, nv.HoTen;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_LayLichSuTiemChungBenhNhan]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 15. Lấy lịch sử tiêm chủng của bệnh nhân
CREATE PROCEDURE [dbo].[sp_LayLichSuTiemChungBenhNhan]
    @idBenhNhan CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        PDK.idDKTiemChung,
        PDK.NgayLap,
        PDK.NgayTiem,
        PDK.TrangThai,
        VX.TenVacXin,
        LVX.TenLoai as LoaiVacXin,
        PDK.LieuTiem,
        VX.DonGiaBan,
        PDK.GhiChu,
        ND.HoTen as NguoiThucHien
    FROM PDK_TIEMCHUNG PDK
    INNER JOIN VACXIN VX ON PDK.idVacXin = VX.idVacXin
    LEFT JOIN LOAI_VACXIN LVX ON VX.idLoaiVX = LVX.idLoaiVX
    LEFT JOIN NGUOIDUNG ND ON PDK.idNguoiDung = ND.idNguoiDung
    WHERE PDK.idBenhNhan = @idBenhNhan
    ORDER BY PDK.NgayTiem DESC, PDK.NgayLap DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_LayLichTheoNgay]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_LayLichTheoNgay]
    @NgayLamViec DATE,
    @idKhoa CHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        clv.idCaLamViec AS _id,
        clv.NgayLamViec AS date,
        clv.LoaiCa AS shiftType,
        CONVERT(VARCHAR(5), clv.GioBD, 108) AS startTime,
        CONVERT(VARCHAR(5), clv.GioKT, 108) AS endTime,
        clv.TrangThai AS status,
        clv.LoaiCongViec AS workType,
        clv.GhiChu AS notes,
        
        -- Thông tin nhân viên
        nv.HoTen AS staffName,
        nv.ChucVu AS staffPosition,
        k.TenKhoa AS departmentName,
        
        -- Sắp xếp theo thời gian
        ROW_NUMBER() OVER (ORDER BY clv.GioBD, nv.HoTen) AS sortOrder
        
    FROM CALAMVIEC clv
    LEFT JOIN NHANVIEN nv ON clv.idNhanVien = nv.idNhanVien
    LEFT JOIN KHOA k ON clv.idKhoa = k.idKhoa
    
    WHERE clv.NgayLamViec = @NgayLamViec
      AND (@idKhoa IS NULL OR clv.idKhoa = @idKhoa)
    
    ORDER BY clv.GioBD, nv.HoTen;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_LayLichTheoNhanVien]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_LayLichTheoNhanVien]
    @idNhanVien CHAR(10),
    @TuNgay DATE = NULL,
    @DenNgay DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Nếu không truyền ngày, lấy 30 ngày từ hôm nay
    IF @TuNgay IS NULL
        SET @TuNgay = GETDATE();
    IF @DenNgay IS NULL
        SET @DenNgay = DATEADD(DAY, 30, @TuNgay);
    
    SELECT 
        clv.idCaLamViec AS _id,
        clv.NgayLamViec AS date,
        clv.LoaiCa AS shiftType,
        CONVERT(VARCHAR(5), clv.GioBD, 108) AS startTime,
        CONVERT(VARCHAR(5), clv.GioKT, 108) AS endTime,
        clv.TrangThai AS status,
        clv.LoaiCongViec AS workType,
        clv.GhiChu AS notes,
        k.TenKhoa AS departmentName,
        
        CASE 
            WHEN clv.GioBD IS NOT NULL AND clv.GioKT IS NOT NULL
            THEN DATEDIFF(MINUTE, clv.GioBD, clv.GioKT) / 60.0
            ELSE NULL
        END AS workHours,
        
        DATENAME(WEEKDAY, clv.NgayLamViec) AS dayOfWeek
        
    FROM CALAMVIEC clv
    LEFT JOIN KHOA k ON clv.idKhoa = k.idKhoa
    
    WHERE clv.idNhanVien = @idNhanVien
      AND clv.NgayLamViec >= @TuNgay 
      AND clv.NgayLamViec <= @DenNgay
    
    ORDER BY clv.NgayLamViec, clv.GioBD;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_LayPhieuChuyenVienTheoID]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- xem
CREATE PROCEDURE [dbo].[sp_LayPhieuChuyenVienTheoID]
    @idChuyenVien CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        pcv.*,
        bn.HoTen AS TenBenhNhan,
        pyc.CoSoChuyenDen, -- Lấy từ phiếu yêu cầu
        nd_lap.HoTen AS NguoiLapPhieu,
        nd_kem.HoTen AS NguoiDiKem,
        nd_duyet.HoTen AS NguoiPheDuyet
    FROM [dbo].[P_CHUYENVIEN] pcv
    LEFT JOIN [dbo].[PYC_CHUYENVIEN] pyc ON pcv.idYeuCauChuyenVien = pyc.idYeuCauChuyenVien
    LEFT JOIN [dbo].[BENHNHAN] bn ON pyc.idBenhNhan = bn.idBenhNhan
    LEFT JOIN [dbo].[NGUOIDUNG] nd_lap ON pcv.idNguoiDung = nd_lap.idNguoiDung
    LEFT JOIN [dbo].[NGUOIDUNG] nd_kem ON pcv.idNguoiDiKem = nd_kem.idNguoiDung
    LEFT JOIN [dbo].[NGUOIDUNG] nd_duyet ON pcv.idNguoiPheDuyet = nd_duyet.idNguoiDung
    WHERE pcv.idChuyenVien = @idChuyenVien;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_LayPhieuDangKyKhamTheoID]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- xem
CREATE PROCEDURE [dbo].[sp_LayPhieuDangKyKhamTheoID]
    @idDKKhambenh CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        pdk.*,
        bn.HoTen AS TenBenhNhan,
        k.TenKhoa,
        nd.HoTen AS TenNhanVienLapPhieu
    FROM [dbo].[PDK_KHAMBENH] pdk
    LEFT JOIN [dbo].[BENHNHAN] bn ON pdk.idBenhNhan = bn.idBenhNhan
    LEFT JOIN [dbo].[KHOA] k ON pdk.idKhoa = k.idKhoa
    LEFT JOIN [dbo].[NGUOIDUNG] nd ON pdk.idNguoiDung = nd.idNguoiDung
    WHERE pdk.idDKKhambenh = @idDKKhambenh;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_LayPhieuYeuCauChuyenVienTheoID]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- xem
CREATE PROCEDURE [dbo].[sp_LayPhieuYeuCauChuyenVienTheoID]
    @idYeuCauChuyenVien CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        pyc.*,
        bn.HoTen AS TenBenhNhan,
        bs.HoTen AS TenBacSiPhuTrach,
        nd_lap.HoTen AS NguoiLapPhieu,
        nd_duyet.HoTen AS NguoiPheDuyet
    FROM [dbo].[PYC_CHUYENVIEN] pyc
    LEFT JOIN [dbo].[BENHNHAN] bn ON pyc.idBenhNhan = bn.idBenhNhan
    LEFT JOIN [dbo].[NGUOIDUNG] bs ON pyc.idBacSiPhuTrach = bs.idNguoiDung
    LEFT JOIN [dbo].[NGUOIDUNG] nd_lap ON pyc.idNguoiDung = nd_lap.idNguoiDung
    LEFT JOIN [dbo].[NGUOIDUNG] nd_duyet ON pyc.idNguoiPheDuyet = nd_duyet.idNguoiDung
    WHERE pyc.idYeuCauChuyenVien = @idYeuCauChuyenVien;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_LayTatCaBenhNhan]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_LayTatCaBenhNhan]
AS
BEGIN
    SET NOCOUNT ON;

    -- Chỉ chọn những cột cần thiết cho việc hiển thị danh sách
    SELECT 
        bn.idBenhNhan,
        bn.HoTen,
        bn.NgaySinh,
        bn.GioiTinh,
		bn.NgheNghiep,
		bn.DanToc,
        bn.SDT,
		bn.DiaChi,
		bn.CCCD,
		bn.BHYT,
		bn.ThoiHanBHYT,
		bn.DoiTuongUuTien,
		bn.HoTenThanNhan,
		bn.MoiQuanHe,
		bn.SDTThanNhan,
		bn.BenhManTinh,
		bn.DiUng,
		bn.PhauThuatDaLam,
        bn.TrangThai
    FROM 
        [dbo].[BENHNHAN] bn
    ORDER BY 
        bn.HoTen, bn.idBenhNhan; -- Sắp xếp theo tên để dễ theo dõi
END

GO
/****** Object:  StoredProcedure [dbo].[sp_LayTatCaNhanVien]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  CREATE PROCEDURE [dbo].[sp_LayTatCaNhanVien]
AS
BEGIN
	-- SET NOCOUNT ON để ngăn SQL Server gửi lại thông báo về số dòng bị ảnh hưởng.
	-- Điều này giúp tăng hiệu suất một chút.
	SET NOCOUNT ON;

    -- Câu lệnh SELECT để lấy tất cả các cột từ bảng NHANVIEN
	-- Liệt kê tường minh các cột là một thói quen tốt hơn là dùng SELECT *
	SELECT 
		[idNhanVien],
		[HoTen],
		[GioiTinh],
		[NgaySinh],
		[TrinhDo],
		[SDT],
		[Email],
		[HeSoLuong],
		[ChucVu],
		[idKhoa]
	FROM 
		[dbo].[NHANVIEN]
	-- Bạn có thể thêm ORDER BY để sắp xếp kết quả, ví dụ sắp xếp theo tên hoặc mã nhân viên
	ORDER BY 
		[HoTen] ASC;

END
GO
/****** Object:  StoredProcedure [dbo].[sp_LayThongKeLichLamViec]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_LayThongKeLichLamViec]
    @Thang VARCHAR(7) = NULL -- Format: YYYY-MM
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @NgayBatDau DATE, @NgayKetThuc DATE;
    
    -- Nếu không truyền tháng, lấy tháng hiện tại
    IF @Thang IS NULL
        SET @Thang = FORMAT(GETDATE(), 'yyyy-MM');
    
    SET @NgayBatDau = CAST(@Thang + '-01' AS DATE);
    SET @NgayKetThuc = EOMONTH(@NgayBatDau);
    
    SELECT 
        -- Tổng số ca làm việc
        (SELECT COUNT(*) 
         FROM CALAMVIEC 
         WHERE NgayLamViec >= @NgayBatDau AND NgayLamViec <= @NgayKetThuc) AS totalSchedules,
        
        -- Ca đã xác nhận
        (SELECT COUNT(*) 
         FROM CALAMVIEC 
         WHERE NgayLamViec >= @NgayBatDau AND NgayLamViec <= @NgayKetThuc 
           AND TrangThai = N'Đã xác nhận') AS confirmedSchedules,
        
        -- Ca đang chờ
        (SELECT COUNT(*) 
         FROM CALAMVIEC 
         WHERE NgayLamViec >= @NgayBatDau AND NgayLamViec <= @NgayKetThuc 
           AND TrangThai = N'Chờ xác nhận') AS pendingSchedules,
        
        -- Ca đã hủy
        (SELECT COUNT(*) 
         FROM CALAMVIEC 
         WHERE NgayLamViec >= @NgayBatDau AND NgayLamViec <= @NgayKetThuc 
           AND TrangThai = N'Đã hủy') AS cancelledSchedules,
        
        -- Thống kê theo loại ca
        (SELECT COUNT(*) 
         FROM CALAMVIEC 
         WHERE NgayLamViec >= @NgayBatDau AND NgayLamViec <= @NgayKetThuc 
           AND LoaiCa = N'Sáng') AS morningShifts,
        
        (SELECT COUNT(*) 
         FROM CALAMVIEC 
         WHERE NgayLamViec >= @NgayBatDau AND NgayLamViec <= @NgayKetThuc 
           AND LoaiCa = N'Chiều') AS afternoonShifts,
        
        (SELECT COUNT(*) 
         FROM CALAMVIEC 
         WHERE NgayLamViec >= @NgayBatDau AND NgayLamViec <= @NgayKetThuc 
           AND LoaiCa = N'Đêm') AS nightShifts,
        
        (SELECT COUNT(*) 
         FROM CALAMVIEC 
         WHERE NgayLamViec >= @NgayBatDau AND NgayLamViec <= @NgayKetThuc 
           AND LoaiCa = N'Cả ngày') AS fullDayShifts,
        
        -- Tổng giờ làm việc
        (SELECT ISNULL(SUM(DATEDIFF(MINUTE, GioBD, GioKT)), 0) / 60.0
         FROM CALAMVIEC 
         WHERE NgayLamViec >= @NgayBatDau AND NgayLamViec <= @NgayKetThuc 
           AND GioBD IS NOT NULL AND GioKT IS NOT NULL) AS totalWorkHours;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_PDK_KhamBenh_GetAll]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_PDK_KhamBenh_GetAll]
    -- Khai báo các tham số đầu vào để lọc, mặc định là NULL (không lọc)
    @FromDate DATETIME = NULL,          -- Lọc từ ngày
    @ToDate DATETIME = NULL,            -- Lọc đến ngày
    @TrangThai NVARCHAR(50) = NULL,     -- Lọc theo trạng thái (ví dụ: 'Chờ khám', 'Đã khám'...)
    @idKhoa CHAR(10) = NULL,             -- Lọc theo khoa cụ thể
    @idBenhNhan CHAR(10) = NULL         -- Lọc theo một bệnh nhân cụ thể
AS
BEGIN
    -- Thiết lập để không trả về số lượng bản ghi bị ảnh hưởng bởi câu lệnh T-SQL
    SET NOCOUNT ON;

    -- Câu lệnh SELECT chính để lấy dữ liệu
    SELECT 
        PDK.idDKKhambenh,
        PDK.NgayLap,
        BN.HoTen AS HoTenBenhNhan,
        BN.NgaySinh,
        BN.GioiTinh,
        PDK.LyDoKham,
        K.TenKhoa,
        PDK.PhongKhamSo,
		PDK.KhamBHYT as KhamBHYT,
        CASE 
            WHEN PDK.KhamBHYT = 1 THEN N'Có BHYT'
            WHEN PDK.KhamBHYT = 0 THEN N'Dịch vụ'
            ELSE N'Chưa xác định'
        END AS LoaiHinhKham,
        PDK.TrangThai,
        ND.HoTen AS NhanVienTiepNhan,
        PDK.idBenhNhan,
        PDK.idKhoa,
        PDK.idNguoiDung
    FROM 
        dbo.PDK_KHAMBENH AS PDK
    -- Dùng LEFT JOIN để nếu có phiếu đăng ký bị thiếu thông tin người dùng hoặc khoa thì vẫn hiển thị
    LEFT JOIN 
        dbo.BENHNHAN AS BN ON PDK.idBenhNhan = BN.idBenhNhan
    LEFT JOIN 
        dbo.KHOA AS K ON PDK.idKhoa = K.idKhoa
    LEFT JOIN 
        dbo.NGUOIDUNG AS ND ON PDK.idNguoiDung = ND.idNguoiDung
    WHERE
        -- Logic lọc linh hoạt: nếu tham số là NULL thì bỏ qua điều kiện lọc đó
        (@idBenhNhan IS NULL OR PDK.idBenhNhan = @idBenhNhan)
        AND (@idKhoa IS NULL OR PDK.idKhoa = @idKhoa)
        AND (@TrangThai IS NULL OR PDK.TrangThai = @TrangThai)
        -- Lọc ngày lập phải lớn hơn hoặc bằng @FromDate (nếu @FromDate không NULL)
        AND (@FromDate IS NULL OR PDK.NgayLap >= @FromDate)
        -- Lọc ngày lập phải nhỏ hơn ngày kế tiếp của @ToDate (để lấy trọn vẹn ngày @ToDate)
        AND (@ToDate IS NULL OR PDK.NgayLap < DATEADD(day, 1, @ToDate))
    ORDER BY 
        PDK.NgayLap DESC; -- Sắp xếp theo ngày lập gần nhất lên trên cùng

END
GO
/****** Object:  StoredProcedure [dbo].[sp_SuaCaLamViec]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- sửa
CREATE PROCEDURE [dbo].[sp_SuaCaLamViec]
    @idCaLamViec CHAR(10),
    @idNhanVien CHAR(10),
    @NgayLamViec DATE,
    @LoaiCa NVARCHAR(50),
    @GioBD TIME(7),
    @GioKT TIME(7),
    @LoaiCongViec NVARCHAR(50),
    @GhiChu NVARCHAR(200),
    @idKhoa CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra trạng thái của Lịch Tổng Thể cha
    DECLARE @TrangThaiLich NVARCHAR(50);
    SELECT @TrangThaiLich = ltt.TrangThai FROM [dbo].[CALAMVIEC] clv
    JOIN [dbo].[LICH_TONGTHE] ltt ON clv.idLichTongThe = ltt.idLichTongThe
    WHERE clv.idCaLamViec = @idCaLamViec;
    
    IF @TrangThaiLich IS NULL BEGIN; THROW 50004, N'Lỗi: Ca làm việc không tồn tại.', 1; RETURN; END;
    IF @TrangThaiLich <> N'Bản nháp' BEGIN; THROW 58004, N'Lỗi: Chỉ có thể sửa ca trong lịch đang ở trạng thái "Bản nháp".', 1; RETURN; END;

    UPDATE [dbo].[CALAMVIEC]
    SET idNhanVien = @idNhanVien, NgayLamViec = @NgayLamViec, LoaiCa = @LoaiCa, GioBD = @GioBD, GioKT = @GioKT,
        LoaiCongViec = @LoaiCongViec, GhiChu = @GhiChu, idKhoa = @idKhoa
    WHERE idCaLamViec = @idCaLamViec;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_SuaChiTietDonThuoc]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- sửa
CREATE PROCEDURE [dbo].[sp_SuaChiTietDonThuoc]
    @idDonThuoc CHAR(10),
    @idDuocPham CHAR(10),
    @SoLuong INT,
    @LieuDung NVARCHAR(50),
    @DuongDung NVARCHAR(20),
    @GhiChu NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra trạng thái của đơn thuốc cha
    DECLARE @TrangThaiDonThuoc NVARCHAR(50);
    SELECT @TrangThaiDonThuoc = TrangThai FROM [dbo].[DON_THUOC] WHERE idDonThuoc = @idDonThuoc;
    IF @TrangThaiDonThuoc IS NULL
    BEGIN; THROW 50004, N'Lỗi: Đơn thuốc không tồn tại.', 1; RETURN; END;
    IF @TrangThaiDonThuoc <> N'Chưa thanh toán'
    BEGIN; THROW 56001, N'Lỗi: Không thể sửa thuốc trong đơn đã được thanh toán hoặc đã hủy.', 1; RETURN; END;

    -- Thực hiện cập nhật
    UPDATE [dbo].[CT_DONTHUOC]
    SET [SoLuong] = @SoLuong, [LieuDung] = @LieuDung, [DuongDung] = @DuongDung, [GhiChu] = @GhiChu
    WHERE idDonThuoc = @idDonThuoc AND idDuocPham = @idDuocPham;
        
    IF @@ROWCOUNT = 0
    BEGIN; THROW 56004, N'Lỗi: Không tìm thấy chi tiết thuốc này trong đơn để sửa.', 1; RETURN; END;

    PRINT N'Đã cập nhật chi tiết dược phẩm ' + @idDuocPham + N' trong đơn thuốc ' + @idDonThuoc;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_SuaDonNghiPhep]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- sửa
CREATE PROCEDURE [dbo].[sp_SuaDonNghiPhep]
    -- Tham số đầu vào
    @idNghiPhep CHAR(10), -- Khóa chính để xác định đơn cần sửa
    -- Các thông tin có thể sửa đổi
    @LoaiPhep NVARCHAR(50),
    @NgayBD DATE,
    @NgayKT DATE,
    @GioBD TIME(7) = NULL,
    @GioKT TIME(7) = NULL,
    @NghiCaNgay BIT,
    @TongNgayNghi FLOAT,
    @LyDo NVARCHAR(50),
    @HoTenNguoiLienHe NVARCHAR(100),
    @SDTNguoiLienHe VARCHAR(50),
    @MoiQuanHe NVARCHAR(50),
    @GhiChu NVARCHAR(50),
    @idNhanVienThayThe CHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Lấy ID của người dùng đang thực hiện hành động sửa
    DECLARE @current_user_id CHAR(10) = CAST(SESSION_CONTEXT(N'UserID') AS CHAR(10));
    IF @current_user_id IS NULL 
    BEGIN; THROW 51000, N'Lỗi: Không thể xác định người dùng đang đăng nhập.', 1; RETURN; END;

    -- === KIỂM TRA AN TOÀN TRƯỚC KHI SỬA ===
    DECLARE @TrangThaiHienTai NVARCHAR(50), @idNguoiTaoDon CHAR(10);
    SELECT @TrangThaiHienTai = TrangThai, @idNguoiTaoDon = idNguoiDung
    FROM [dbo].[DON_NGHIPHEP] WHERE idNghiPhep = @idNghiPhep;

    IF @TrangThaiHienTai IS NULL
    BEGIN; THROW 50004, N'Lỗi: Đơn xin nghỉ không tồn tại.', 1; RETURN; END;
    IF @idNguoiTaoDon <> @current_user_id
    BEGIN; THROW 59003, N'Lỗi: Bạn không có quyền sửa đơn xin nghỉ của người khác.', 1; RETURN; END;
    IF @TrangThaiHienTai <> N'Chờ duyệt'
    BEGIN; THROW 59001, N'Lỗi: Không thể sửa đơn xin nghỉ đã được xử lý.', 1; RETURN; END;

    -- === BẮT ĐẦU GIAO DỊCH ĐỂ ĐẢM BẢO TOÀN VẸN DỮ LIỆU ===
    BEGIN TRANSACTION;
    BEGIN TRY
        
        -- Bước 1: Xóa các liên kết cũ đến các ca bị ảnh hưởng
        DELETE FROM [dbo].[NGHIPHEP_ANHHUONGCA]
        WHERE idNghiPhep = @idNghiPhep;

        -- Bước 2: Cập nhật thông tin chính của đơn xin nghỉ
        UPDATE [dbo].[DON_NGHIPHEP]
        SET 
            [LoaiPhep] = @LoaiPhep, [NgayBD] = @NgayBD, [NgayKT] = @NgayKT,
            [GioBD] = @GioBD, [GioKT] = @GioKT, [NghiCaNgay] = @NghiCaNgay,
            [TongNgayNghi] = @TongNgayNghi, [LyDo] = @LyDo,
            [HoTenNguoiLienHe] = @HoTenNguoiLienHe, [SDTNguoiLienHe] = @SDTNguoiLienHe,
            [MoiQuanHe] = @MoiQuanHe, [GhiChu] = @GhiChu,
            [idNhanVienThayThe] = @idNhanVienThayThe,
            [NgayLap] = GETDATE() -- Cập nhật lại ngày thành ngày sửa đổi
        WHERE 
            idNghiPhep = @idNghiPhep;

        -- Bước 3: Tìm và tạo lại các liên kết mới đến các ca bị ảnh hưởng (dựa trên ngày nghỉ mới)
        INSERT INTO [dbo].[NGHIPHEP_ANHHUONGCA] (idNghiPhep, idCaLamViec)
        SELECT
            @idNghiPhep,
            clv.idCaLamViec
        FROM
            [dbo].[CALAMVIEC] clv
        WHERE
            clv.idNhanVien = @current_user_id -- Ca của người nộp đơn
            AND clv.NgayLamViec BETWEEN @NgayBD AND @NgayKT -- Dùng ngày nghỉ MỚI để tìm
            AND clv.TrangThai NOT IN (N'Đã hủy', N'Đã hoàn thành');

        -- Nếu mọi thứ thành công, hoàn tất giao dịch
        COMMIT TRANSACTION;
        
        PRINT N'Đã cập nhật thành công đơn xin nghỉ và các ca bị ảnh hưởng: ' + @idNghiPhep;

    END TRY
    BEGIN CATCH
        -- Nếu có lỗi ở bất kỳ bước nào, hủy bỏ tất cả các thay đổi
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        -- Ném lại lỗi để ứng dụng có thể bắt được
        THROW;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_SuaDonThuoc]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_SuaDonThuoc]
    @idDonThuoc CHAR(10),
    @GhiChu NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE DON_THUOC 
    SET GhiChu = @GhiChu
    WHERE idDonThuoc = @idDonThuoc;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_SuaPhieuChuyenVien]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	-- sửa
CREATE PROCEDURE [dbo].[sp_SuaPhieuChuyenVien]
    @idChuyenVien CHAR(10),
    @NgayChuyen DATE,
    @ThoiGianDuKien TIME(7),
    @SDT_CoSoYTe VARCHAR(20),
    @YThuc NVARCHAR(200),
    @GhiChu NVARCHAR(200),
	@idBacSiPhuTrach CHAR(10)
AS
BEGIN

    UPDATE [dbo].[P_CHUYENVIEN]
    SET [NgayChuyen] = @NgayChuyen, [ThoiGianDuKien] = @ThoiGianDuKien, [SDT_CoSoYTe] = @SDT_CoSoYTe,
        [YThuc] = @YThuc, [GhiChu] = @GhiChu
    WHERE idChuyenVien = @idChuyenVien;

    PRINT N'Đã cập nhật thành công phiếu chuyển viện: ' + @idChuyenVien;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_SuaPhieuDangKyKham]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- sửa
CREATE PROCEDURE [dbo].[sp_SuaPhieuDangKyKham]
    @idDKKhambenh CHAR(10),
    @LyDoKham NVARCHAR(200),
    @ThoiGianBatDauTrieuChung DATE,
    @PhongKhamSo NVARCHAR(10),
    @TienSuBenhLyBanThan NVARCHAR(200),
    @TienSuBenhLyGiaDinh NVARCHAR(200),
    @ThuocDangSuDung NVARCHAR(200),
    @KhamBHYT BIT,
    @idKhoa CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra trạng thái của phiếu
    DECLARE @CurrentTrangThai NVARCHAR(50);
    SELECT @CurrentTrangThai = TrangThai FROM [dbo].[PDK_KHAMBENH] WHERE idDKKhambenh = @idDKKhambenh;
    
    IF @CurrentTrangThai IS NULL
    BEGIN; THROW 50004, N'Lỗi: Phiếu đăng ký không tồn tại.', 1; RETURN; END;
    
    IF @CurrentTrangThai <> N'Chờ khám'
    BEGIN; THROW 53001, N'Lỗi: Chỉ có thể sửa phiếu ở trạng thái "Chờ khám".', 1; RETURN; END;

    UPDATE [dbo].[PDK_KHAMBENH]
    SET 
        [LyDoKham] = @LyDoKham, [ThoiGianBatDauTrieuChung] = @ThoiGianBatDauTrieuChung, 
        [PhongKhamSo] = @PhongKhamSo, [TienSuBenhLyBanThan] = @TienSuBenhLyBanThan,
        [TienSuBenhLyGiaDinh] = @TienSuBenhLyGiaDinh, [ThuocDangSuDung] = @ThuocDangSuDung,
        [KhamBHYT] = @KhamBHYT, [idKhoa] = @idKhoa
    WHERE idDKKhambenh = @idDKKhambenh;

    PRINT N'Đã cập nhật thành công phiếu đăng ký khám bệnh: ' + @idDKKhambenh;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_SuaPhieuYeuCauChuyenVien]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- sửa
CREATE PROCEDURE [dbo].[sp_SuaPhieuYeuCauChuyenVien]
    @idYeuCauChuyenVien CHAR(10),
    @LyDo NVARCHAR(200),
    @CoSoChuyenDen NVARCHAR(200),
    @DiaChi NVARCHAR(200),
    @NgayChuyen DATE,
    @MucDo NVARCHAR(50),
    @GhiChu NVARCHAR(200),
    @idBacSiPhuTrach CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra trạng thái của phiếu
    DECLARE @CurrentTrangThai NVARCHAR(50);
    SELECT @CurrentTrangThai = TrangThai FROM [dbo].[PYC_CHUYENVIEN] WHERE idYeuCauChuyenVien = @idYeuCauChuyenVien;

    IF @CurrentTrangThai IS NULL
    BEGIN; THROW 50004, N'Lỗi: Phiếu yêu cầu không tồn tại.', 1; RETURN; END;

    IF @CurrentTrangThai <> N'Chờ duyệt'
    BEGIN; THROW 50005, N'Lỗi: Chỉ có thể sửa phiếu ở trạng thái "Chờ duyệt".', 1; RETURN; END;
    
    -- Kiểm tra lại khóa ngoại
    IF @idBacSiPhuTrach IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [dbo].[NGUOIDUNG] WHERE idNguoiDung = @idBacSiPhuTrach)
    BEGIN; THROW 50003, N'Lỗi: Bác sĩ phụ trách không tồn tại.', 1; RETURN; END;

    UPDATE [dbo].[PYC_CHUYENVIEN]
    SET [LyDo] = @LyDo, [CoSoChuyenDen] = @CoSoChuyenDen, [DiaChi] = @DiaChi, [NgayChuyen] = @NgayChuyen,
        [MucDo] = @MucDo, [GhiChu] = @GhiChu, [idBacSiPhuTrach] = @idBacSiPhuTrach
    WHERE idYeuCauChuyenVien = @idYeuCauChuyenVien;

    PRINT N'Đã cập nhật thành công phiếu yêu cầu chuyển viện: ' + @idYeuCauChuyenVien;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_SuaYeuCauChuyenCa]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- sửa
CREATE PROCEDURE [dbo].[sp_SuaYeuCauChuyenCa]
    @idYeuCauChuyenCa CHAR(10),
    @idNhanVienMoi CHAR(10),
    @NgayChuyen DATE,
    @LyDo NVARCHAR(200),
    @CanBuCa BIT,
    @GhiChu NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @current_user_id CHAR(10) = CAST(SESSION_CONTEXT(N'UserID') AS CHAR(10));
    IF @current_user_id IS NULL BEGIN; THROW 51000, N'Lỗi: Không thể xác định người dùng đang đăng nhập.', 1; RETURN; END;

    UPDATE [dbo].[PYC_CHUYENCA]
    SET idNhanVienMoi = @idNhanVienMoi, NgayChuyen = @NgayChuyen, LyDo = @LyDo,
        CanBuCa = @CanBuCa, GhiChu = @GhiChu
    WHERE idYeuCauChuyenCa = @idYeuCauChuyenCa
      AND TrangThai = N'Chờ duyệt'
      AND idNguoiDung = @current_user_id; -- Chỉ người tạo mới được sửa
    
    IF @@ROWCOUNT = 0 BEGIN; THROW 57009, N'Lỗi: Yêu cầu không tồn tại, đã được xử lý hoặc bạn không có quyền sửa.', 1; RETURN; END;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_TaoDangKyTiemChungMoi]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 3. Tạo đăng ký tiêm chủng mới
CREATE PROCEDURE [dbo].[sp_TaoDangKyTiemChungMoi]
    @idBenhNhan CHAR(10),
    @HoTenNguoiLienHe NVARCHAR(50),
    @QuanHe NVARCHAR(50),
    @SDT_LienHe NVARCHAR(20),
    @Email NVARCHAR(50),
    @idVacXin CHAR(10),
    @NgayTiem DATE,
    @ThoiGianTiem NVARCHAR(50),
    @LieuTiem NVARCHAR(50),
    @GhiChu NVARCHAR(50),
    @idNguoiDung CHAR(10),
    @idDKTiemChungMoi CHAR(10) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Kiểm tra bệnh nhân tồn tại
        IF NOT EXISTS (SELECT 1 FROM BENHNHAN WHERE idBenhNhan = @idBenhNhan)
        BEGIN
            RAISERROR(N'Bệnh nhân không tồn tại', 16, 1);
            RETURN;
        END
        
        -- Kiểm tra vắc xin tồn tại và còn hàng
        DECLARE @SoLuongTon INT;
        SELECT @SoLuongTon = SoLuong 
        FROM VACXIN 
        WHERE idVacXin = @idVacXin AND (HSD IS NULL OR HSD > GETDATE());
        
        IF @SoLuongTon IS NULL
        BEGIN
            RAISERROR(N'Vắc xin không tồn tại hoặc đã hết hạn', 16, 1);
            RETURN;
        END
        
        IF @SoLuongTon <= 0
        BEGIN
            RAISERROR(N'Vắc xin đã hết hàng', 16, 1);
            RETURN;
        END
        
        -- Tạo ID mới (đơn giản hơn vì không có sequence)
        DECLARE @MaxId INT;
        SELECT @MaxId = ISNULL(MAX(CAST(RIGHT(idDKTiemChung, 8) AS INT)), 0) + 1
        FROM PDK_TIEMCHUNG 
        WHERE idDKTiemChung LIKE 'DK%';
        
        SET @idDKTiemChungMoi = 'DK' + RIGHT('00000000' + CAST(@MaxId AS VARCHAR(8)), 8);
        
        -- Thêm đăng ký tiêm chủng
        INSERT INTO PDK_TIEMCHUNG (
            idDKTiemChung, NgayLap, NgayTiem, HoTenNguoiLienHe, QuanHe,
            SDT_LienHe, Email, ThoiGianTiem, LieuTiem, GhiChu,
            TrangThai, idVacXin, idNguoiDung, idBenhNhan
        ) VALUES (
            @idDKTiemChungMoi, GETDATE(), @NgayTiem, @HoTenNguoiLienHe, @QuanHe,
            @SDT_LienHe, @Email, @ThoiGianTiem, @LieuTiem, @GhiChu,
            N'Đã đăng ký', @idVacXin, @idNguoiDung, @idBenhNhan
        );
        
        COMMIT TRANSACTION;
        
        SELECT N'Tạo đăng ký tiêm chủng thành công' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_TaoDonNghiPhep]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 4. DON_NGHIPHEP
	-- thêm
CREATE PROCEDURE [dbo].[sp_TaoDonNghiPhep]
    -- Tham số đầu vào
    @LoaiPhep NVARCHAR(50),
    @NgayBD DATE,
    @NgayKT DATE,
    @GioBD TIME(7) = NULL,
    @GioKT TIME(7) = NULL,
    @NghiCaNgay BIT,
    @TongNgayNghi FLOAT,
    @LyDo NVARCHAR(50),
    @HoTenNguoiLienHe NVARCHAR(100),
    @SDTNguoiLienHe VARCHAR(50),
    @MoiQuanHe NVARCHAR(50),
    @GhiChu NVARCHAR(50),
    @idNhanVienThayThe CHAR(10) = NULL,
    -- Tham số đầu ra
    @idNghiPhepMoi CHAR(10) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @current_user_id CHAR(10) = CAST(SESSION_CONTEXT(N'UserID') AS CHAR(10));
    IF @current_user_id IS NULL BEGIN; THROW 51000, N'Lỗi: Không thể xác định người dùng đang đăng nhập.', 1; RETURN; END;
    
    DECLARE @newId CHAR(10);
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Logic sinh mã tự động DNP + 7 chữ số (ví dụ)
        DECLARE @idNumber INT;
        SELECT @idNumber = ISNULL(MAX(CAST(SUBSTRING(idNghiPhep, 4, 7) AS INT)), 0)
        FROM [dbo].[DON_NGHIPHEP] WITH (UPDLOCK, HOLDLOCK) WHERE idNghiPhep LIKE 'DNP[0-9]%';
        SET @idNumber = @idNumber + 1;
        SET @newId = 'NP' + RIGHT('0000' + CAST(@idNumber AS VARCHAR(4)), 4);
        SET @idNghiPhepMoi = @newId;

        INSERT INTO [dbo].[DON_NGHIPHEP] (
            idNghiPhep, LoaiPhep, NgayBD, NgayKT, GioBD, GioKT, NghiCaNgay, TongNgayNghi,
            LyDo, TrangThai, NgayLap, HoTenNguoiLienHe, SDTNguoiLienHe, MoiQuanHe, GhiChu,
            idNhanVien, idNguoiDung, idNhanVienThayThe
        ) VALUES (
            @newId, @LoaiPhep, @NgayBD, @NgayKT, @GioBD, @GioKT, @NghiCaNgay, @TongNgayNghi,
            @LyDo, N'Chờ duyệt', GETDATE(), @HoTenNguoiLienHe, @SDTNguoiLienHe, @MoiQuanHe, @GhiChu,
            @current_user_id, @current_user_id, @idNhanVienThayThe -- Người nộp đơn và người tạo là một
        );

		 -- Bước 2 (MỚI): Tìm các ca bị ảnh hưởng và thêm vào bảng liên kết
        INSERT INTO [dbo].[NGHIPHEP_ANHHUONGCA] (idNghiPhep, idCaLamViec)
        SELECT
            @newId, -- Mã đơn nghỉ vừa tạo
            clv.idCaLamViec
        FROM
            [dbo].[CALAMVIEC] clv
        WHERE
            clv.idNhanVien = @current_user_id -- Ca của người nộp đơn
            AND clv.NgayLamViec BETWEEN @NgayBD AND @NgayKT -- Nằm trong khoảng ngày nghỉ
            AND clv.TrangThai NOT IN (N'Đã hủy', N'Đã hoàn thành'); -- Chỉ ảnh hưởng đến các ca sắp tới
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_TaoDonThuocMoi]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_TaoDonThuocMoi]
    @idBenhNhan CHAR(10),
    @idBacSi CHAR(10),
    @idKhambenh CHAR(10), -- Nhận từ input, không tạo mới
    @ChanDoan NVARCHAR(500),
    @GhiChu NVARCHAR(200) = NULL,
    @DanhSachThuoc NVARCHAR(MAX), -- JSON format
    @idDonThuocMoi CHAR(10) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Kiểm tra idKhamBenh có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM P_KHAMBENH WHERE idKhamBenh = @idKhambenh)
        BEGIN
            RAISERROR(N'Mã khám bệnh không tồn tại: %s', 16, 1, @idKhambenh);
            RETURN;
        END

        -- Tạo ID đơn thuốc mới
        DECLARE @SoThuTu INT;
        SELECT @SoThuTu = ISNULL(MAX(CAST(SUBSTRING(idDonThuoc, 3, 8) AS INT)), 0) + 1
        FROM DON_THUOC 
        WHERE idDonThuoc LIKE 'DT%';

        SET @idDonThuocMoi = 'DT' + RIGHT('000' + CAST(@SoThuTu AS VARCHAR(8)), 8);

        -- Tạo đơn thuốc với idKhamBenh từ input
        INSERT INTO DON_THUOC (idDonThuoc, NgayLap, TrangThai, GhiChu, idNguoiDung, idKhamBenh)
        VALUES (@idDonThuocMoi, GETDATE(), N'Chờ thanh toán', @GhiChu, @idBacSi, @idKhambenh);

        -- Thêm chi tiết đơn thuốc
        IF @DanhSachThuoc IS NOT NULL AND @DanhSachThuoc != ''
        BEGIN
            INSERT INTO CT_DONTHUOC (idDonThuoc, idDuocPham, SoLuong, LieuDung, DuongDung)
            SELECT 
                @idDonThuocMoi,
                JSON_VALUE(value, '$.idDuocPham'),
                CAST(JSON_VALUE(value, '$.SoLuong') AS INT),
                JSON_VALUE(value, '$.LieuDung'),
                JSON_VALUE(value, '$.DuongDung')
            FROM OPENJSON(@DanhSachThuoc);
        END

        COMMIT TRANSACTION;
        
        -- Trả về thông báo thành công
        PRINT N'Tạo đơn thuốc thành công với ID: ' + @idDonThuocMoi;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        
        -- Lấy thông tin lỗi
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        -- Ném lại lỗi với thông tin chi tiết
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_TaoPhieuChuyenVien]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- 2. P_CHUYENVIEN
	-- thêm
CREATE PROCEDURE [dbo].[sp_TaoPhieuChuyenVien]
    -- Tham số đầu vào
    @idYeuCauChuyenVien CHAR(10), -- Mã phiếu yêu cầu ĐÃ ĐƯỢC DUYỆT
    @NgayChuyen DATE,
    @ThoiGianDuKien TIME(7),
    @SDT_CoSoYTe VARCHAR(20),
    @YThuc NVARCHAR(200),
    @GhiChu NVARCHAR(200),
    @idNguoiDung CHAR(10),
    -- Tham số đầu ra
    @idChuyenVienMoi CHAR(10) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Lấy ID người dùng đang thực thi từ session context (người lập phiếu này)


    -- === KIỂM TRA LOGIC NGHIỆP VỤ ===
    -- 1. Kiểm tra xem Phiếu Yêu Cầu có tồn tại và đã được duyệt chưa?
    IF NOT EXISTS (SELECT 1 FROM [dbo].[PYC_CHUYENVIEN] 
                   WHERE idYeuCauChuyenVien = @idYeuCauChuyenVien AND TrangThai = N'Đã duyệt')
    BEGIN; THROW 52001, N'Lỗi: Phiếu yêu cầu chuyển viện không tồn tại hoặc chưa được duyệt.', 1; RETURN; END;

    -- 2. Kiểm tra xem đã có Phiếu Chuyển Viện nào được tạo từ Yêu cầu này chưa để tránh trùng lặp.
    IF EXISTS (SELECT 1 FROM [dbo].[P_CHUYENVIEN] WHERE idYeuCauChuyenVien = @idYeuCauChuyenVien)
    BEGIN; THROW 52002, N'Lỗi: Đã có phiếu chuyển viện được tạo cho yêu cầu này.', 1; RETURN; END;
    
    -- ===================================

    DECLARE @idNumber INT;
    DECLARE @newId CHAR(10);

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Tạo mã mới (PCV: Phiếu Chuyển Viện)
        SELECT @idNumber = ISNULL(MAX(CAST(SUBSTRING(idChuyenVien, 4, 7) AS INT)), 0)
        FROM [dbo].[P_CHUYENVIEN] WITH (UPDLOCK, HOLDLOCK)
        WHERE idChuyenVien LIKE 'CV[0-9]%';

        SET @idNumber = @idNumber + 1;
        SET @newId = 'CV' + RIGHT('0000' + CAST(@idNumber AS VARCHAR(4)), 4);
        SET @idChuyenVienMoi = @newId;

        INSERT INTO [dbo].[P_CHUYENVIEN] (
            [idChuyenVien], [NgayLap], [NgayChuyen], [ThoiGianDuKien], [SDT_CoSoYTe], [YThuc],
            [GhiChu], [TrangThai], [idYeuCauChuyenVien], [idNguoiDung]
        ) VALUES (
            @newId, GETDATE(), @NgayChuyen, @ThoiGianDuKien, @SDT_CoSoYTe, @YThuc, 
            @GhiChu, N'Đang chuyển viện', @idYeuCauChuyenVien, @idNguoiDung
        );

        COMMIT TRANSACTION;
        PRINT N'Đã tạo phiếu chuyển viện thành công với mã: ' + @newId;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_TaoYeuCauChuyenCa]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 3. PYC_CHUYENCA
	-- thêm
CREATE PROCEDURE [dbo].[sp_TaoYeuCauChuyenCa]
    -- Tham số đầu vào
    @idCaLamViecGoc CHAR(10),
    @idNhanVienMoi CHAR(10),
    @NgayChuyen DATE,
    @LyDo NVARCHAR(200),
    @CanBuCa BIT,
    @GhiChu NVARCHAR(50),
    -- Tham số đầu ra
    @idYeuCauMoi CHAR(10) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @current_user_id CHAR(10) = CAST(SESSION_CONTEXT(N'UserID') AS CHAR(10));
    IF @current_user_id IS NULL BEGIN; THROW 51000, N'Lỗi: Không thể xác định người dùng đang đăng nhập.', 1; RETURN; END;

    -- Lấy thông tin nhân viên cũ từ ca làm việc gốc
    DECLARE @idNhanVienCu CHAR(10);
    SELECT @idNhanVienCu = idNhanVien FROM [dbo].[CALAMVIEC] WHERE idCaLamViec = @idCaLamViecGoc AND TrangThai = N'Đã lên lịch';
    IF @idNhanVienCu IS NULL BEGIN; THROW 57008, N'Lỗi: Ca làm việc gốc không tồn tại hoặc không ở trạng thái hợp lệ để chuyển.', 1; RETURN; END;
    
    -- Người yêu cầu phải là chủ của ca làm việc gốc
    IF @idNhanVienCu <> @current_user_id BEGIN; THROW 57011, N'Lỗi: Bạn chỉ có thể tạo yêu cầu chuyển ca cho chính mình.', 1; RETURN; END;
    
    DECLARE @newId CHAR(10);
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Logic sinh mã tự động YCC + 4 chữ số (ví dụ)
        DECLARE @idNumber INT;
        SELECT @idNumber = ISNULL(MAX(CAST(SUBSTRING(idYeuCauChuyenCa, 4, 7) AS INT)), 0)
        FROM [dbo].[PYC_CHUYENCA] WITH (UPDLOCK, HOLDLOCK) WHERE idYeuCauChuyenCa LIKE 'YCCC[0-9]%';
        SET @idNumber = @idNumber + 1;
        SET @newId = 'YCCC' + RIGHT('0000' + CAST(@idNumber AS VARCHAR(4)), 4);
        SET @idYeuCauMoi = @newId;

        INSERT INTO [dbo].[PYC_CHUYENCA] (
            idYeuCauChuyenCa, NgayYeuCau, TrangThai, idCaLamViecGoc, idNhanVienCu,
            idNhanVienMoi, NgayChuyen, LyDo, CanBuCa, GhiChu, idNguoiDung
        ) VALUES (
            @newId, GETDATE(), N'Chờ duyệt', @idCaLamViecGoc, @idNhanVienCu,
            @idNhanVienMoi, @NgayChuyen, @LyDo, @CanBuCa, @GhiChu, @current_user_id
        );
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ThemBenhNhan]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



------------------------********************-------------------- NGA ---------------------********************----------------------
---------------------*****************************************************************************************----------------------

-- 1. BENHNHAN
	-- thêm
CREATE PROCEDURE [dbo].[sp_ThemBenhNhan]
    -- Tham số đầu vào (tất cả các cột trừ idBenhNhan)
    @HoTen NVARCHAR(100),
    @NgaySinh DATE,
    @GioiTinh NVARCHAR(10),
    @NgheNghiep NVARCHAR(50),
    @DanToc NVARCHAR(50),
    @SDT VARCHAR(15),
    @DiaChi NVARCHAR(200),
    @CCCD VARCHAR(20),
    @BHYT VARCHAR(20),
    @ThoiHanBHYT DATE,
    @DoiTuongUuTien NVARCHAR(50),
    @HoTenThanNhan NVARCHAR(100),
    @MoiQuanHe NVARCHAR(20),
    @SDTThanNhan VARCHAR(15),
    @BenhManTinh NVARCHAR(200),
    @DiUng NVARCHAR(200),
    @PhauThuatDaLam NVARCHAR(200),
    @TrangThai NVARCHAR(50),
    @idLoaiBHYT CHAR(10),
    -- Tham số đầu ra
    @idBenhNhanMoi CHAR(10) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra sự hợp lệ của khóa ngoại idLoaiBHYT
    IF @idLoaiBHYT IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [dbo].[LOAI_BHYT] WHERE idLoaiBHYT = @idLoaiBHYT)
    BEGIN
        PRINT N'Lỗi: Mã Loại BHYT "' + @idLoaiBHYT + N'" không tồn tại. Vui lòng kiểm tra lại.';
        RETURN;
    END

    DECLARE @idNumber INT;
    DECLARE @newId CHAR(10);

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Tìm số lớn nhất trong các idBenhNhan hiện có và khóa bảng để tránh trùng lặp
        SELECT @idNumber = ISNULL(MAX(CAST(SUBSTRING(idBenhNhan, 4, 7) AS INT)), 0)
        FROM [dbo].[BENHNHAN] WITH (UPDLOCK, HOLDLOCK)
        WHERE idBenhNhan LIKE 'BN[0-9]%';

        SET @idNumber = @idNumber + 1;
        SET @newId = 'BN' + RIGHT('0000' + CAST(@idNumber AS VARCHAR(4)), 4);
        SET @idBenhNhanMoi = @newId;

        INSERT INTO [dbo].[BENHNHAN] (
            [idBenhNhan], [HoTen], [NgaySinh], [GioiTinh], [NgheNghiep], [DanToc], 
            [SDT], [DiaChi], [CCCD], [BHYT], [ThoiHanBHYT], [DoiTuongUuTien], 
            [HoTenThanNhan], [MoiQuanHe], [SDTThanNhan], [BenhManTinh], 
            [DiUng], [PhauThuatDaLam], [TrangThai], [idLoaiBHYT]
        ) VALUES (
            @newId, @HoTen, @NgaySinh, @GioiTinh, @NgheNghiep, @DanToc,
            @SDT, @DiaChi, @CCCD, @BHYT, @ThoiHanBHYT, @DoiTuongUuTien,
            @HoTenThanNhan, @MoiQuanHe, @SDTThanNhan, @BenhManTinh,
            @DiUng, @PhauThuatDaLam, @TrangThai, @idLoaiBHYT
        );

        COMMIT TRANSACTION;
        PRINT N'Đã thêm thành công bệnh nhân với mã mới: ' + @newId;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        PRINT N'Đã xảy ra lỗi trong quá trình thêm bệnh nhân.';
        THROW;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ThemCaLamViec]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ThemCaLamViec] 
    -- Tham số đầu vào
    @idNhanVien CHAR(10),
    @NgayLamViec DATE,
    @LoaiCa NVARCHAR(50),
    @GioBD TIME(7),
    @GioKT TIME(7),
    @LoaiCongViec NVARCHAR(50),
    @GhiChu NVARCHAR(200),
    @idKhoa CHAR(10),
    @idLichTongThe CHAR(10),
    -- Tham số đầu ra
    @idCaLamViecMoi CHAR(10) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- === KHAI BÁO BIẾN ===
    --DECLARE @current_user_id CHAR(10);
    DECLARE @TrangThaiLich NVARCHAR(50);
    DECLARE @idNumber INT;
    DECLARE @newId CHAR(10);

    -- === KIỂM TRA LOGIC & KHÓA NGOẠI ===
    ---- 1. Lấy và kiểm tra người dùng đang đăng nhập
    --SET @current_user_id = CAST(SESSION_CONTEXT(N'UserID') AS CHAR(10));
    --IF @current_user_id IS NULL 
    --BEGIN; THROW 51000, N'Lỗi: Không thể xác định người dùng đang đăng nhập.', 1; RETURN; END;

    -- 2. Kiểm tra các khóa ngoại đầu vào
    --IF NOT EXISTS (SELECT 1 FROM [dbo].[NGUOIDUNG] WHERE idNguoiDung = @idNhanVien)
    --BEGIN; THROW 57001, N'Lỗi: Nhân viên được phân công không tồn tại.', 1; RETURN; END;
    --IF NOT EXISTS (SELECT 1 FROM [dbo].[KHOA] WHERE idKhoa = @idKhoa)
    --BEGIN; THROW 50009, N'Lỗi: Khoa không tồn tại.', 1; RETURN; END;

    ---- 3. Kiểm tra trạng thái của Lịch Tổng Thể cha
    --SELECT @TrangThaiLich = TrangThai FROM [dbo].[LICH_TONGTHE] WHERE idLichTongThe = @idLichTongThe;
    --IF @TrangThaiLich IS NULL 
    --BEGIN; THROW 57002, N'Lỗi: Lịch làm việc tổng thể không tồn tại.', 1; RETURN; END;
    --IF @TrangThaiLich <> N'Bản nháp' 
    --BEGIN; THROW 58004, N'Lỗi: Chỉ có thể thêm ca vào lịch đang ở trạng thái "Bản nháp".', 1; RETURN; END;

    -- 4. Kiểm tra trùng lặp lịch làm việc cho nhân viên (logic đã cải tiến)
    IF EXISTS (
        SELECT 1 FROM [dbo].[CALAMVIEC]
        WHERE idNhanVien = @idNhanVien 
          AND NgayLamViec = @NgayLamViec 
          AND TrangThai <> N'Đã hủy'
          AND @GioBD < GioKT AND @GioKT > GioBD -- Kiểm tra giờ giao nhau chuẩn
    )
    BEGIN; THROW 57006, N'Lỗi: Nhân viên đã được xếp lịch làm việc trùng thời gian trong ngày này.', 1; RETURN; END;
    
    -- === THỰC THI LỆNH ===
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Tạo mã mới (CLV: Ca Làm Việc)
        SELECT @idNumber = ISNULL(MAX(CAST(SUBSTRING(idCaLamViec, 4, 7) AS INT)), 0)
        FROM [dbo].[CALAMVIEC] WITH (UPDLOCK, HOLDLOCK) WHERE idCaLamViec LIKE 'CLV[0-9]%';
        
        SET @idNumber = @idNumber + 1;
        -- Sửa lỗi tạo mã mới để đảm bảo chính xác
        SET @newId = 'CLV' + RIGHT('0000' + CAST(@idNumber AS VARCHAR(4)), 4);
        SET @idCaLamViecMoi = @newId;

        INSERT INTO [dbo].[CALAMVIEC] (
            idCaLamViec, NgayLamViec, LoaiCa, GioBD, GioKT, TrangThai, LoaiCongViec,
            GhiChu, idNhanVien, idKhoa, idLichTongThe
        ) VALUES (
            @newId, @NgayLamViec, @LoaiCa, @GioBD, @GioKT, N'Đã lên lịch', @LoaiCongViec,
            @GhiChu, @idNhanVien, @idKhoa, @idLichTongThe
        );
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ThemChiTietDonThuoc]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedure thêm chi tiết đơn thuốc (CORRECTED)
CREATE   PROCEDURE [dbo].[sp_ThemChiTietDonThuoc] 
    @idDonThuoc CHAR(10),
    @idDuocPham CHAR(10),
    @SoLuong INT,
    @LieuDung NVARCHAR(50),
    @DuongDung NVARCHAR(20),
    @GhiChu NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO CT_DONTHUOC (idDonThuoc, idDuocPham, SoLuong, LieuDung, DuongDung, GhiChu)
    VALUES (@idDonThuoc, @idDuocPham, @SoLuong, @LieuDung, @DuongDung, @GhiChu);
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ThemDonThuoc]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ThemDonThuoc]
    @idKhamBenh CHAR(10),
    @GhiChu NVARCHAR(200) = NULL,
    @idDonThuocMoi CHAR(10) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Tạo ID mới cho đơn thuốc
        DECLARE @SoThuTu INT;
        SELECT @SoThuTu = ISNULL(MAX(CAST(SUBSTRING(idDonThuoc, 3, 8) AS INT)), 0) + 1
        FROM DON_THUOC 
        WHERE idDonThuoc LIKE 'DT%';
        
        SET @idDonThuocMoi = 'DT' + RIGHT('000' + CAST(@SoThuTu AS VARCHAR(8)), 8);
        
        -- Lấy idNguoiDung từ KHAM_BENH (bác sĩ khám)
        DECLARE @idNguoiDung CHAR(10);
        SELECT @idNguoiDung = idNguoiDung 
        FROM KHAM_BENH 
        WHERE idKhamBenh = @idKhamBenh;
        
        INSERT INTO DON_THUOC (idDonThuoc, NgayLap, TrangThai, GhiChu, idNguoiDung, idKhamBenh)
        VALUES (@idDonThuocMoi, GETDATE(), N'Chờ thanh toán', @GhiChu, @idNguoiDung, @idKhamBenh);
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ThemMoiBenhNhan]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 12. Thêm mới bệnh nhân
CREATE PROCEDURE [dbo].[sp_ThemMoiBenhNhan]
    @idBenhNhan CHAR(10),
    @HoTen NVARCHAR(100),
    @NgaySinh DATE = NULL,
    @GioiTinh NVARCHAR(10) = N'Nam',
    @NgheNghiep NVARCHAR(50) = NULL,
    @DanToc NVARCHAR(50) = N'Kinh',
    @SDT INT = NULL,
    @DiaChi NVARCHAR(200) = NULL,
    @CCCD VARCHAR(20) = NULL,
    @BHYT VARCHAR(20) = NULL,
    @HoTenThanNhan NVARCHAR(100) = NULL,
    @MoiQuanHe NVARCHAR(20) = NULL,
    @SDTThanNhan VARCHAR(15) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Kiểm tra ID đã tồn tại
        IF EXISTS (SELECT 1 FROM BENHNHAN WHERE idBenhNhan = @idBenhNhan)
        BEGIN
            RAISERROR(N'Mã bệnh nhân đã tồn tại', 16, 1);
            RETURN;
        END
        
        -- Thêm bệnh nhân mới
        INSERT INTO BENHNHAN (
            idBenhNhan, HoTen, NgaySinh, GioiTinh, NgheNghiep, DanToc,
            SDT, DiaChi, CCCD, BHYT, HoTenThanNhan, MoiQuanHe, SDTThanNhan,
            TrangThai
        ) VALUES (
            @idBenhNhan, @HoTen, @NgaySinh, @GioiTinh, @NgheNghiep, @DanToc,
            @SDT, @DiaChi, @CCCD, @BHYT, @HoTenThanNhan, @MoiQuanHe, @SDTThanNhan,
            N'Hoạt động'
        );
        
        COMMIT TRANSACTION;
        
        SELECT N'Thêm bệnh nhân thành công' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ThemPhieuDangKyKham]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ThemPhieuDangKyKham]
    @LyDoKham NVARCHAR(200),
    @ThoiGianBatDauTrieuChung DATE,
    @PhongKhamSo NVARCHAR(10),
    @TienSuBenhLyBanThan NVARCHAR(200),
    @TienSuBenhLyGiaDinh NVARCHAR(200),
    @ThuocDangSuDung NVARCHAR(200),
    @KhamBHYT BIT,
    @idBenhNhan CHAR(10),
    @idKhoa CHAR(10),
    @idNguoiDung CHAR(10),
    @idDKKhambenhMoi CHAR(10) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra khóa ngoại
    IF NOT EXISTS (SELECT 1 FROM [dbo].[BENHNHAN] WHERE idBenhNhan = @idBenhNhan)
    BEGIN; THROW 50001, N'Lỗi: Bệnh nhân không tồn tại.', 1; RETURN; END;

    IF NOT EXISTS (SELECT 1 FROM [dbo].[KHOA] WHERE idKhoa = @idKhoa)
    BEGIN; THROW 50009, N'Lỗi: Khoa khám bệnh không tồn tại.', 1; RETURN; END;

    DECLARE @idNumber INT = 0;
    DECLARE @newId CHAR(10);
    DECLARE @isExists INT = 1;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Khóa bảng để tránh race condition
        -- (chỉ khóa trong khoảng ngắn khi sinh ID)
        WHILE @isExists = 1
        BEGIN
            SELECT @idNumber = ISNULL(MAX(CAST(SUBSTRING(idDKKhambenh, 5, 4) AS INT)), 0) + 1
            FROM [dbo].[PDK_KHAMBENH] WITH (TABLOCKX);

            SET @newId = 'DKKB' + RIGHT('0000' + CAST(@idNumber AS VARCHAR), 4);

            -- Kiểm tra trùng ID
            IF NOT EXISTS (SELECT 1 FROM [dbo].[PDK_KHAMBENH] WHERE idDKKhambenh = @newId)
            BEGIN
                SET @isExists = 0; -- Không trùng => dùng ID này
            END
        END

        SET @idDKKhambenhMoi = @newId;

        -- Chèn bản ghi mới
        INSERT INTO [dbo].[PDK_KHAMBENH] (
            [idDKKhambenh], [NgayLap], [LyDoKham], [ThoiGianBatDauTrieuChung], [PhongKhamSo],
            [TienSuBenhLyBanThan], [TienSuBenhLyGiaDinh], [ThuocDangSuDung], [KhamBHYT],
            [TrangThai], [idBenhNhan], [idKhoa], [idNguoiDung]
        ) VALUES (
            @newId, GETDATE(), @LyDoKham, @ThoiGianBatDauTrieuChung, @PhongKhamSo,
            @TienSuBenhLyBanThan, @TienSuBenhLyGiaDinh, @ThuocDangSuDung, @KhamBHYT,
            N'Chờ khám', @idBenhNhan, @idKhoa, @idNguoiDung
        );

        COMMIT TRANSACTION;
        PRINT N'Đã lập phiếu đăng ký khám thành công với mã: ' + @newId;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ThemPhieuYeuCauChuyenVien]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_ThemPhieuYeuCauChuyenVien]
  @LyDo NVARCHAR(200),
  @CoSoChuyenDen NVARCHAR(200),
  @DiaChi NVARCHAR(200),
  @NgayChuyen DATE,
  @MucDo NVARCHAR(50),
  @GhiChu NVARCHAR(200),
  @idBacSiPhuTrach CHAR(10),
  @idBenhNhan CHAR(10),
  @idNguoiDung CHAR(10),
  @idYeuCauMoi CHAR(10) OUTPUT
AS
BEGIN
  SET NOCOUNT ON;
  -- kiểm tra FK như trước…
  
  DECLARE @idNumber INT;
  DECLARE @newId CHAR(10);
  BEGIN TRAN;
  BEGIN TRY
    -- Lấy số lớn nhất từ 4 chữ số cuối
    SELECT @idNumber = ISNULL(
      MAX(CAST(RIGHT(RTRIM(idYeuCauChuyenVien),4) AS INT)), 0)
    FROM [dbo].[PYC_CHUYENVIEN] WITH (UPDLOCK, HOLDLOCK)
    WHERE idYeuCauChuyenVien LIKE 'YCCV%';

    SET @idNumber += 1;
    SET @newId = 'YCCV' + RIGHT('0000' + CAST(@idNumber AS VARCHAR(4)), 4);
    SET @idYeuCauMoi = @newId;

    INSERT INTO [dbo].[PYC_CHUYENVIEN] (
      idYeuCauChuyenVien, NgayLap, LyDo, CoSoChuyenDen, DiaChi, NgayChuyen,
      TrangThai, GhiChu, MucDo, idBacSiPhuTrach, idBenhNhan, idNguoiDung
    )
    VALUES (
      @newId, GETDATE(), @LyDo, @CoSoChuyenDen, @DiaChi, @NgayChuyen,
      N'Chờ duyệt', @GhiChu, @MucDo, @idBacSiPhuTrach, @idBenhNhan, @idNguoiDung
    );

    COMMIT TRAN;
    PRINT N'Đã tạo phiếu yêu cầu chuyển viện thành công với mã: ' + @newId;
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    THROW;
  END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ThongKeDangKyTiemChung]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 9. Thống kê đăng ký tiêm chủng
CREATE PROCEDURE [dbo].[sp_ThongKeDangKyTiemChung]
    @TuNgay DATE = NULL,
    @DenNgay DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @StartDate DATE = ISNULL(@TuNgay, DATEADD(MONTH, -1, GETDATE()));
    DECLARE @EndDate DATE = ISNULL(@DenNgay, GETDATE());
    
    -- Thống kê tổng quan
    SELECT 
        COUNT(*) as TongSoDangKy,
        COUNT(CASE WHEN TrangThai = N'Đã đăng ký' THEN 1 END) as DaDangKy,
        COUNT(CASE WHEN TrangThai = N'Đã tiêm' THEN 1 END) as DaTiem,
        COUNT(CASE WHEN TrangThai = N'Đã hủy' THEN 1 END) as DaHuy,
        COUNT(CASE WHEN NgayTiem = CAST(GETDATE() AS DATE) THEN 1 END) as TiemHomNay,
        SUM(CASE WHEN TrangThai = N'Đã tiêm' THEN VX.DonGiaBan ELSE 0 END) as TongDoanhThu,
        COUNT(DISTINCT PDK.idBenhNhan) as SoBenhNhanDaTiem
    FROM PDK_TIEMCHUNG PDK
    INNER JOIN VACXIN VX ON PDK.idVacXin = VX.idVacXin
    WHERE PDK.NgayLap BETWEEN @StartDate AND @EndDate;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ThongKeDonThuoc]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Sửa lại procedure thống kê đơn thuốc
CREATE   PROCEDURE [dbo].[sp_ThongKeDonThuoc]
    @TuNgay DATE = NULL,
    @DenNgay DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @TuNgay IS NULL SET @TuNgay = DATEADD(MONTH, -1, GETDATE());
    IF @DenNgay IS NULL SET @DenNgay = GETDATE();
    
    -- Tạo CTE để tính toán trước các giá trị
    WITH DonThuocThongKe AS (
        SELECT 
            dt.idDonThuoc,
            dt.TrangThai,
            bn.BHYT,
            -- Tính tổng tiền cho mỗi đơn thuốc
            ISNULL(SUM(ct.SoLuong * dp.DonGiaBan), 0) as TongTienDon,
            -- Tính tiền BHYT cho mỗi đơn thuốc
            CASE 
                WHEN bn.BHYT IS NOT NULL AND bn.BHYT != '' 
                THEN ISNULL(SUM(ct.SoLuong * dp.DonGiaBan), 0) * 0.8 
                ELSE 0 
            END as TienBHYTDon,
            -- Tính tiền bệnh nhân trả cho mỗi đơn thuốc
            CASE 
                WHEN bn.BHYT IS NOT NULL AND bn.BHYT != '' 
                THEN ISNULL(SUM(ct.SoLuong * dp.DonGiaBan), 0) * 0.2 
                ELSE ISNULL(SUM(ct.SoLuong * dp.DonGiaBan), 0) 
            END as TienBenhNhanTraDon
            
        FROM DON_THUOC dt
        LEFT JOIN P_KHAMBENH kb ON dt.idKhamBenh = kb.idKhamBenh
        LEFT JOIN PDK_KHAMBENH pdk ON kb.idDKKhamBenh = pdk.idDKKhambenh
        LEFT JOIN BENHNHAN bn ON pdk.idBenhNhan = bn.idBenhNhan
        LEFT JOIN CT_DONTHUOC ct ON dt.idDonThuoc = ct.idDonThuoc
        LEFT JOIN DUOCPHAM dp ON ct.idDuocPham = dp.idDuocPham
        
        WHERE dt.NgayLap >= @TuNgay AND dt.NgayLap <= @DenNgay
        
        GROUP BY dt.idDonThuoc, dt.TrangThai, bn.BHYT
    )
    
    -- Thống kê cuối cùng
    SELECT 
        -- Thống kê tổng quan
        COUNT(*) as TongDonThuoc,
        COUNT(CASE WHEN TrangThai = N'Chờ thanh toán' THEN 1 END) as DonChoThanhToan,
        COUNT(CASE WHEN TrangThai = N'Đã thanh toán' THEN 1 END) as DonDaThanhToan,
        
        -- Thống kê về tiền (tổng doanh thu = tiền bệnh nhân trả)
        SUM(TienBenhNhanTraDon) as TongDoanhThu,
        
        -- Thống kê bảo hiểm
        COUNT(CASE WHEN BHYT IS NOT NULL AND BHYT != '' THEN 1 END) as DonCoBHYT,
        COUNT(CASE WHEN BHYT IS NULL OR BHYT = '' THEN 1 END) as DonKhongBHYT,
        
        -- Thống kê chi tiết tiền
        SUM(TongTienDon) as TongTienTatCaDon,
        SUM(TienBHYTDon) as TongTienBHYTTra,
        SUM(TienBenhNhanTraDon) as TongTienBenhNhanTra
        
    FROM DonThuocThongKe;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ThongKeTinhTrangVacXin]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 20. Thống kê tình trạng vắc xin
CREATE PROCEDURE [dbo].[sp_ThongKeTinhTrangVacXin]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        COUNT(*) as TongSoVacXin,
        COUNT(CASE WHEN SoLuong > 0 THEN 1 END) as ConHang,
        COUNT(CASE WHEN SoLuong = 0 THEN 1 END) as HetHang,
        COUNT(CASE WHEN HSD IS NOT NULL AND HSD <= GETDATE() THEN 1 END) as DaHetHan,
        COUNT(CASE WHEN HSD IS NOT NULL AND HSD <= DATEADD(DAY, 30, GETDATE()) AND HSD > GETDATE() THEN 1 END) as SapHetHan,
        SUM(SoLuong) as TongSoLuongTon,
        SUM(SoLuong * DonGiaBan) as TongGiaTriTonKho,
        AVG(DonGiaBan) as GiaBanTrungBinh
    FROM VACXIN;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_TimKiemBenhNhan]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- tìm kiếm
CREATE PROCEDURE [dbo].[sp_TimKiemBenhNhan]
    @TuKhoa NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        bn.idBenhNhan,
        bn.HoTen,
        bn.NgaySinh,
        bn.GioiTinh,
        bn.SDT,
        bn.CCCD,
        bn.BHYT,
        bn.DiaChi,
        lb.TenLoaiBHYT, -- Lấy tên loại BHYT từ bảng liên quan
        bn.TrangThai
    FROM 
        [dbo].[BENHNHAN] bn
    LEFT JOIN 
        [dbo].[LOAI_BHYT] lb ON bn.idLoaiBHYT = lb.idLoaiBHYT
    WHERE
        -- Tìm theo Họ Tên (không phân biệt hoa/thường, có/không dấu)
        bn.HoTen LIKE N'%' + @TuKhoa + '%' COLLATE Vietnamese_CI_AI
        -- Hoặc tìm chính xác theo các mã định danh
        OR bn.SDT = @TuKhoa
        OR bn.CCCD = @TuKhoa
        OR bn.BHYT = @TuKhoa
        OR bn.idBenhNhan = @TuKhoa
    ORDER BY
        bn.HoTen;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_TimKiemBenhNhann]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 13. Tìm kiếm bệnh nhân
CREATE PROCEDURE [dbo].[sp_TimKiemBenhNhann]
    @Keyword NVARCHAR(100) = NULL,
    @GioiTinh NVARCHAR(10) = NULL,
    @TuNgaySinh DATE = NULL,
    @DenNgaySinh DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        idBenhNhan as _id,
        HoTen as fullName,
        NgaySinh as dateOfBirth,
        GioiTinh as gender,
        SDT as phone,
        DiaChi as address,
        CCCD as idNumber,
        BHYT as insuranceNumber,
        DanToc as ethnicity,
        NgheNghiep as occupation,
        HoTenThanNhan as guardianName,
        MoiQuanHe as relationship,
        SDTThanNhan as guardianPhone,
        TrangThai as status
    FROM BENHNHAN
    WHERE 
        (TrangThai IS NULL OR TrangThai != N'Đã xóa')
        AND (@Keyword IS NULL OR 
             HoTen LIKE N'%' + @Keyword + N'%' OR
             CCCD LIKE '%' + @Keyword + '%' OR
             BHYT LIKE '%' + @Keyword + '%' OR
             CAST(SDT AS VARCHAR) LIKE '%' + @Keyword + '%')
        AND (@GioiTinh IS NULL OR GioiTinh = @GioiTinh)
        AND (@TuNgaySinh IS NULL OR NgaySinh >= @TuNgaySinh)
        AND (@DenNgaySinh IS NULL OR NgaySinh <= @DenNgaySinh)
    ORDER BY HoTen;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_TimKiemDonThuoc]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_TimKiemDonThuoc] 
    @TuNgay DATE = NULL,
    @DenNgay DATE = NULL,
    @TrangThai NVARCHAR(50) = NULL,
    @Keyword NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @TuNgay IS NULL SET @TuNgay = DATEADD(MONTH, -1, GETDATE());
    IF @DenNgay IS NULL SET @DenNgay = GETDATE();
    
    EXEC sp_LayDanhSachDonThuocChiTiet @TuNgay, @DenNgay, @TrangThai, @Keyword;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_TimKiemDuocPham]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- tìm kiếm
CREATE PROCEDURE [dbo].[sp_TimKiemDuocPham]
    -- Các tham số tìm kiếm, tất cả đều là tùy chọn
    @Keyword NVARCHAR(100) = NULL,      -- Tìm theo Tên, Hoạt chất, Nhà sản xuất
    @idLoaiDuocPham CHAR(10) = NULL,   -- Lọc theo Loại dược phẩm
    @idNCC CHAR(10) = NULL,            -- Lọc theo Nhà cung cấp
    @KiemTraTonKho BIT = NULL,         -- Lọc theo tình trạng tồn kho (1: Còn hàng, 0: Hết hàng)
    @KiemTraHanSuDung BIT = NULL      -- Lọc theo hạn sử dụng (1: Còn hạn, 0: Hết hạn)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        dp.idDuocPham,
        dp.TenDuocPham,
        dp.HoatChat,
        dp.DVT,
        dp.SoLuong,
        dp.DonGiaBan,
        dp.HanSuDung,
        ldp.TenLoaiDuocPham
    FROM 
        [dbo].[DUOCPHAM] dp
    LEFT JOIN 
        [dbo].[LOAI_DUOCPHAM] ldp ON dp.idLoaiDuocPham = ldp.idLoaiDuocPham
    WHERE
        -- Điều kiện lọc theo từ khóa (Keyword)
        (@Keyword IS NULL OR 
            (dp.TenDuocPham LIKE N'%' + @Keyword + N'%' COLLATE Vietnamese_CI_AI) OR
            (dp.HoatChat LIKE N'%' + @Keyword + N'%' COLLATE Vietnamese_CI_AI) OR
            (dp.NhaSX LIKE N'%' + @Keyword + N'%' COLLATE Vietnamese_CI_AI)
        )
        -- Điều kiện lọc theo Loại dược phẩm
        AND (@idLoaiDuocPham IS NULL OR dp.idLoaiDuocPham = @idLoaiDuocPham)
        -- Điều kiện lọc theo Nhà cung cấp
        AND (@idNCC IS NULL OR dp.idNCC = @idNCC)
        -- Điều kiện lọc theo Tồn kho
        AND (@KiemTraTonKho IS NULL OR
            (@KiemTraTonKho = 1 AND dp.SoLuong > 0) OR
            (@KiemTraTonKho = 0 AND (dp.SoLuong IS NULL OR dp.SoLuong <= 0))
        )
        -- Điều kiện lọc theo Hạn sử dụng
        AND (@KiemTraHanSuDung IS NULL OR
            (@KiemTraHanSuDung = 1 AND (dp.HanSuDung IS NULL OR dp.HanSuDung >= GETDATE())) OR
            (@KiemTraHanSuDung = 0 AND dp.HanSuDung < GETDATE())
        )
    ORDER BY
        dp.TenDuocPham;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_TimKiemPhieuChuyenVien]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- tìm kiếm 
CREATE PROCEDURE [dbo].[sp_TimKiemPhieuChuyenVien]
    @TuNgay DATE,
    @DenNgay DATE,
    @TrangThai NVARCHAR(50) = NULL,
    @Keyword NVARCHAR(200) = NULL -- Tìm theo tên BN hoặc cơ sở chuyển đến
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        pcv.idChuyenVien,
        pcv.NgayLap,
        pcv.NgayChuyen,
        bn.HoTen AS TenBenhNhan,
        pyc.CoSoChuyenDen,
        pcv.TrangThai
    FROM [dbo].[P_CHUYENVIEN] pcv
    INNER JOIN [dbo].[PYC_CHUYENVIEN] pyc ON pcv.idYeuCauChuyenVien = pyc.idYeuCauChuyenVien
    INNER JOIN [dbo].[BENHNHAN] bn ON pyc.idBenhNhan = bn.idBenhNhan
    WHERE 
        (CAST(pcv.NgayLap AS DATE) BETWEEN @TuNgay AND @DenNgay)
    AND (@TrangThai IS NULL OR pcv.TrangThai = @TrangThai)
    AND (@Keyword IS NULL 
         OR bn.HoTen LIKE N'%' + @Keyword + N'%' COLLATE Vietnamese_CI_AI
         OR pyc.CoSoChuyenDen LIKE N'%' + @Keyword + N'%' COLLATE Vietnamese_CI_AI)
    ORDER BY pcv.NgayLap DESC;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_TimKiemPhieuChuyenVien_V2]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 4. Tìm kiếm phiếu chuyển viện với tham số linh hoạt
CREATE  PROCEDURE [dbo].[sp_TimKiemPhieuChuyenVien_V2]
    @tuKhoa NVARCHAR(255) = NULL,
    @trangThai NVARCHAR(50) = NULL,
    @tuNgay DATE = NULL,
    @denNgay DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @today DATE = GETDATE();
    
    SELECT 
        pcv.idChuyenVien,
        pcv.idChuyenVien as transferCode,
        pcv.NgayLap as createdDate,
        pcv.NgayChuyen as transferDate,
        pcv.ThoiGianDuKien as estimatedTime,
        pcv.SDT_CoSoYTe as destinationPhone,
        pcv.Phuongtien as transportMethod,        -- ✅ THÊM: Phương tiện
        pcv.YThuc as consciousness,
        pcv.GhiChu as notes,
        pcv.TrangThai as status,
        pcv.NgayPheDuyet as approvalDate,
        
        -- Thông tin từ yêu cầu chuyển viện
        pyc.LyDo as reason,
        pyc.CoSoChuyenDen as destinationFacility,
        pyc.DiaChi as destinationAddress,
        pyc.MucDo as priority,
        
        -- Thông tin bệnh nhân
        bn.idBenhNhan as patientId,
        bn.HoTen as patientName,
        PARSENAME(REPLACE(bn.HoTen, ' ', '.'), 1) as lastName,
        STUFF(bn.HoTen, CHARINDEX(' ' + PARSENAME(REPLACE(bn.HoTen, ' ', '.'), 1), bn.HoTen), LEN(PARSENAME(REPLACE(bn.HoTen, ' ', '.'), 1)) + 1, '') as firstName,
        bn.NgaySinh as dateOfBirth,
        DATEDIFF(YEAR, bn.NgaySinh, @today) AS age,  -- ✅ THÊM: Tuổi
        bn.GioiTinh as gender,
        bn.SDT as phone,
        bn.DiaChi as address,
        bn.CCCD as idNumber,
        bn.BHYT as insuranceNumber,
        bn.DoiTuongUuTien as priorityType,
        bn.NgheNghiep as occupation,              -- ✅ THÊM: Nghề nghiệp
        
        -- Thông tin người liên quan
        pd.idNguoiDung as approverId,
        pd.HoTen as approverName,
        pd.ChucVu as approverPosition,            -- ✅ THÊM: Chức vụ người phê duyệt
        
        nd.idNguoiDung as createdById,
        nd.HoTen as createdByName,
        nd.ChucVu as createdByPosition,           -- ✅ THÊM: Chức vụ người tạo
        
        nd_dikem.idNguoiDung as companionId,      -- ✅ THÊM: Người đi kèm
        nd_dikem.HoTen as companionName,
        nd_dikem.ChucVu as companionPosition,
        
        pyc.NgayLap as treatmentDate,
        pyc.idYeuCauChuyenVien as requesttransferCode,
        
        -- ✅ THÊM: Thông tin khoa điều trị
        k.TenKhoa as departmentName,
        
        -- ✅ THÊM: Thông tin lâm sàng từ lần khám gần nhất
        pkb.ChanDoanPhanBiet as diagnosis,
        icd.TenBenh as diagnosisName,
        icd.idICD as icdCode,
        pkb.ChiSoMach as pulse,
        pkb.ChiSoHuyetAp as bloodPressure,
        pkb.ChiSoNhipTho as respiratoryRate,
        pkb.ChiSoNhietDo as temperature,
        pkb.QuaTrinhBenhLy as clinicalProgress,
        
        -- ✅ THÊM: Điều trị đã thực hiện
        LTRIM(RTRIM(
            ISNULL(t.DieuTriThuoc, '') +
            CASE WHEN t.DieuTriThuoc IS NOT NULL AND c.DieuTriCLS IS NOT NULL THEN '; ' ELSE '' END +
            ISNULL(c.DieuTriCLS, '')
        )) AS treatmentPerformed,
        
        -- ✅ THÊM: Tài liệu kèm theo
        CONCAT(
            CASE WHEN clsXE.slXE > 0  THEN N'Kết quả xét nghiệm; '                        ELSE '' END,
            CASE WHEN clsHA.slHA > 0  THEN N'Phim chụp (X-quang, CT, MRI…); '             ELSE '' END,
            CASE WHEN hs.chk   > 0    THEN N'Hồ sơ bệnh án tóm tắt; '                     ELSE '' END,
            CASE WHEN clsKH.slKH > 0  THEN N'Tài liệu khác: ' + clsKH.danhSach + '; '     ELSE '' END
        ) AS accompaningDocuments
        
    FROM P_CHUYENVIEN pcv
    LEFT JOIN PYC_CHUYENVIEN pyc ON pcv.idYeuCauChuyenVien = pyc.idYeuCauChuyenVien
    LEFT JOIN BENHNHAN bn ON pyc.idBenhNhan = bn.idBenhNhan
    LEFT JOIN NGUOIDUNG pd ON pcv.idNguoiPheDuyet = pd.idNguoiDung
    LEFT JOIN NGUOIDUNG nd ON pcv.idNguoiDung = nd.idNguoiDung
    LEFT JOIN NGUOIDUNG nd_dikem ON pcv.idNguoiDiKem = nd_dikem.idNguoiDung  -- ✅ THÊM
    
    -- ✅ THÊM: Lấy thông tin lần khám gần nhất
    OUTER APPLY (
        SELECT TOP 1 pkb.*
        FROM P_KHAMBENH pkb
        JOIN PDK_KHAMBENH pdk ON pdk.idDKKhambenh = pkb.idDKKhamBenh
        WHERE pdk.idBenhNhan = bn.idBenhNhan     
        ORDER BY pkb.NgayKham DESC
    ) pkb
    
    LEFT JOIN ICD icd ON icd.idICD = pkb.idICDChanDoan
    LEFT JOIN PDK_KHAMBENH dkk ON dkk.idDKKhambenh = pkb.idDKKhamBenh
    LEFT JOIN KHOA k ON k.idKhoa = dkk.idKhoa
    
    -- ✅ THÊM: Điều trị thuốc
    OUTER APPLY (
        SELECT STRING_AGG(dp.TenDuocPham + ' (' + ISNULL(ct.LieuDung, N'không rõ') + ')', '; ') AS DieuTriThuoc
        FROM DON_THUOC dt
        JOIN CT_DONTHUOC ct ON ct.idDonThuoc = dt.idDonThuoc
        JOIN DUOCPHAM dp ON dp.idDuocPham = ct.idDuocPham
        WHERE dt.idKhamBenh = pkb.idKhamBenh
    ) t
    
    -- ✅ THÊM: CLS can thiệp
    OUTER APPLY (
        SELECT STRING_AGG(c.TenCLS + ' (' + c.TenLoaiCLS + ')', '; ') AS DieuTriCLS
        FROM CANLAMSANG c
        WHERE c.idCanLamSang = pkb.idCanLamSang
          AND (c.TenLoaiCLS LIKE N'%nội soi%' 
               OR c.TenLoaiCLS LIKE N'%can thiệp%'
               OR c.TenLoaiCLS LIKE N'%phẫu thuật%'
               OR c.TenLoaiCLS LIKE N'%điều trị%')
    ) c
    
    -- ✅ THÊM: Kiểm tra tài liệu kèm theo
    OUTER APPLY (
        SELECT COUNT(*) AS slXE
        FROM CANLAMSANG c1
        WHERE c1.idCanLamSang = pkb.idCanLamSang
          AND (c1.TenLoaiCLS IN (N'Huyết học', N'Sinh hóa') 
               OR c1.TenCLS LIKE N'%xét nghiệm%')
    ) clsXE
    
    OUTER APPLY (
        SELECT COUNT(*) AS slHA
        FROM CANLAMSANG c2
        WHERE c2.idCanLamSang = pkb.idCanLamSang
          AND (c2.TenLoaiCLS IN (N'Chẩn đoán hình ảnh', N'Siêu âm', N'X-Quang') 
               OR c2.TenCLS LIKE N'%chụp%' 
               OR c2.TenCLS LIKE N'%siêu âm%'
               OR c2.TenCLS LIKE N'%X-quang%')
    ) clsHA
    
    OUTER APPLY (
        SELECT COUNT(*) AS slKH,
               STRING_AGG(c3.TenCLS, '; ') AS danhSach
        FROM CANLAMSANG c3
        WHERE c3.idCanLamSang = pkb.idCanLamSang
          AND c3.TenLoaiCLS NOT IN (N'Huyết học', N'Sinh hóa', N'Chẩn đoán hình ảnh', N'Siêu âm', N'X-Quang')
          AND c3.TenCLS NOT LIKE N'%xét nghiệm%'
          AND c3.TenCLS NOT LIKE N'%chụp%'
          AND c3.TenCLS NOT LIKE N'%siêu âm%'
          AND c3.TenCLS NOT LIKE N'%X-quang%'
    ) clsKH
    
    -- ✅ THÊM: Kiểm tra hồ sơ bệnh án
    OUTER APPLY (
        SELECT CASE WHEN EXISTS (
                    SELECT 1 FROM HOSOBENHAN hs 
                    WHERE hs.idBenhNhan = bn.idBenhNhan
                ) THEN 1 ELSE 0 END AS chk
    ) hs
    
    WHERE 
        (@tuKhoa IS NULL OR 
         pcv.idChuyenVien LIKE '%' + @tuKhoa + '%' OR
         bn.HoTen LIKE '%' + @tuKhoa + '%' OR
         bn.SDT LIKE '%' + @tuKhoa + '%' OR
         bn.CCCD LIKE '%' + @tuKhoa + '%' OR
         bn.BHYT LIKE '%' + @tuKhoa + '%')
        AND (@trangThai IS NULL OR pcv.TrangThai = @trangThai)
        AND (@tuNgay IS NULL OR pcv.NgayLap >= @tuNgay)
        AND (@denNgay IS NULL OR pcv.NgayLap <= @denNgay)
    ORDER BY pcv.NgayLap DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_TimKiemPhieuDangKyKham]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_TimKiemPhieuDangKyKham]
    -- === THAM SỐ TÙY CHỌN ĐỂ LỌC (giá trị mặc định là NULL - không lọc) ===
    @TuNgay DATE = NULL,                  -- Lọc từ ngày
    @DenNgay DATE = NULL,                    -- Lọc đến ngày
    @TrangThai NVARCHAR(50) = NULL,         -- Lọc theo trạng thái
    @keyword CHAR(10) = NULL                 -- Lọc theo khoa
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        -- === 1. THÔNG TIN CHÍNH TỪ PHIẾU ĐĂNG KÝ ===
        pdk.idDKKhambenh AS MaPhieuDangKy,
        pdk.NgayLap,
        pdk.LyDoKham,
        pdk.TrangThai,
        pdk.PhongKhamSo,
		pdk.KhamBHYT as KhamBHYT,

        -- === 2. THÔNG TIN CHI TIẾT CỦA BỆNH NHÂN ===
        bn.idBenhNhan AS MaBenhNhan,
        bn.HoTen AS TenBenhNhan,
        bn.NgaySinh,
        -- Tự động tính tuổi chính xác
        DATEDIFF(YEAR, bn.NgaySinh, GETDATE()) -
            CASE
                WHEN MONTH(bn.NgaySinh) > MONTH(GETDATE()) OR
                     (MONTH(bn.NgaySinh) = MONTH(GETDATE()) AND DAY(bn.NgaySinh) > DAY(GETDATE()))
                THEN 1
                ELSE 0
            END AS Tuoi,
        bn.GioiTinh,
        bn.SDT AS SoDienThoai,
        bn.DiaChi,

        -- === 3. THÔNG TIN VỀ KHOA ĐĂNG KÝ ===
        k.TenKhoa,
        k.idKhoa,

        -- === 4. THÔNG TIN TIỀN SỬ & HÌNH THỨC KHÁM ===
        pdk.TienSuBenhLyBanThan,
        pdk.TienSuBenhLyGiaDinh,
        pdk.ThuocDangSuDung,
        pdk.ThoiGianBatDauTrieuChung,
        CASE 
            WHEN pdk.KhamBHYT = 1 THEN N'Khám Bảo hiểm Y tế'
            ELSE N'Khám Dịch vụ'
        END AS LoaiHinhKham,

        -- === 5. THÔNG TIN NGƯỜI LẬP PHIẾU ===
        nd.HoTen AS NhanVienTiepNhan

    FROM
        dbo.PDK_KHAMBENH AS pdk
    -- Dùng LEFT JOIN để nếu phiếu đăng ký chưa có khoa hoặc người lập thì vẫn được hiển thị
    LEFT JOIN
        dbo.BENHNHAN AS bn ON pdk.idBenhNhan = bn.idBenhNhan
    LEFT JOIN
        dbo.KHOA AS k ON pdk.idKhoa = k.idKhoa
    LEFT JOIN
        dbo.NGUOIDUNG AS nd ON pdk.idNguoiDung = nd.idNguoiDung
    WHERE
        -- Logic lọc linh hoạt: chỉ áp dụng điều kiện khi tham số được truyền vào
        (@TuNgay IS NULL OR CAST(pdk.NgayLap AS DATE) >= @TuNgay)
        AND (@DenNgay IS NULL OR CAST(pdk.NgayLap AS DATE) <= @DenNgay)
        AND (@TrangThai IS NULL OR pdk.TrangThai = @TrangThai)
    ORDER BY
        pdk.NgayLap DESC; -- Sắp xếp để các phiếu mới nhất hiển thị ở trên cùng

END
GO
/****** Object:  StoredProcedure [dbo].[sp_TimKiemPhieuKham]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- tìm kiếm
CREATE PROCEDURE [dbo].[sp_TimKiemPhieuKham]
    -- Các tham số tìm kiếm, tất cả đều là tùy chọn
    @TuNgay DATE,
    @DenNgay DATE,
    @Keyword NVARCHAR(100) = NULL -- Tìm theo Tên/Mã BN, SĐT, BHYT, CCCD, Mã phiếu khám...
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        -- Các thông tin tóm tắt cần thiết theo yêu cầu
        pkb.idKhamBenh,
        pkb.NgayKham,
        bn.HoTen,
        bn.GioiTinh,
        bn.BHYT,
        bn.SDT,
        icd_kl.TenBenh AS ICDKetLuan,
        nd.HoTen AS TenBacSiKham
    FROM 
        [dbo].[P_KHAMBENH] pkb
    -- Phải dùng INNER JOIN để đảm bảo chỉ lấy các phiếu khám của bệnh nhân được tìm thấy
    INNER JOIN [dbo].[PDK_KHAMBENH] pdk ON pkb.idDKKhamBenh = pdk.idDKKhambenh
    INNER JOIN [dbo].[BENHNHAN] bn ON pdk.idBenhNhan = bn.idBenhNhan
    
    -- Dùng LEFT JOIN cho các thông tin phụ
    LEFT JOIN [dbo].[ICD] icd_kl ON pkb.idICDKetLuan = icd_kl.idICD
    LEFT JOIN [dbo].[NGUOIDUNG] nd ON pkb.idNguoiDung = nd.idNguoiDung
    WHERE
        -- Điều kiện lọc theo khoảng thời gian
        (CAST(pkb.NgayKham AS DATE) BETWEEN @TuNgay AND @DenNgay)

        -- Điều kiện lọc theo từ khóa (Keyword)
        AND (@Keyword IS NULL OR 
            (bn.HoTen LIKE N'%' + @Keyword + N'%' COLLATE Vietnamese_CI_AI) OR
            (bn.idBenhNhan = @Keyword) OR
            (bn.SDT = @Keyword) OR
            (bn.BHYT = @Keyword) OR
            (bn.CCCD = @Keyword) OR
            (pkb.idKhamBenh = @Keyword)
        )
    ORDER BY
        pkb.NgayKham DESC; -- Sắp xếp để các lượt khám mới nhất lên đầu
END
GO
/****** Object:  StoredProcedure [dbo].[sp_TimKiemPhieuYeuCauChuyenVien]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_TimKiemPhieuYeuCauChuyenVien]
    @TuNgay DATE,
    @DenNgay DATE,
    @TrangThai NVARCHAR(50) = NULL,
    @Keyword NVARCHAR(200) = NULL -- Tìm theo Tên BN hoặc Cơ sở chuyển đến
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        pyc.idYeuCauChuyenVien,
        pyc.NgayLap,
        bn.HoTen AS TenBenhNhan,
        pyc.CoSoChuyenDen,
        pyc.TrangThai,
		pyc.idBacSiPhuTrach as doctorId
    FROM [dbo].[PYC_CHUYENVIEN] pyc
    INNER JOIN [dbo].[BENHNHAN] bn ON pyc.idBenhNhan = bn.idBenhNhan
    WHERE 
        (CAST(pyc.NgayLap AS DATE) BETWEEN @TuNgay AND @DenNgay)
    AND (@TrangThai IS NULL OR pyc.TrangThai = @TrangThai)
    AND (@Keyword IS NULL 
         OR bn.HoTen LIKE N'%' + @Keyword + N'%' COLLATE Vietnamese_CI_AI
         OR pyc.CoSoChuyenDen LIKE N'%' + @Keyword + N'%' COLLATE Vietnamese_CI_AI)
    ORDER BY pyc.NgayLap DESC;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_TimKiemVacXin]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	

------------------------********************-------------------- TRÀ ---------------------********************----------------------
---------------------*****************************************************************************************----------------------

-- 1. VACXIN
	-- tìm kiếm
CREATE PROCEDURE [dbo].[sp_TimKiemVacXin]
    -- Các tham số tìm kiếm, tất cả đều là tùy chọn
    @Keyword NVARCHAR(100) = NULL,      -- Tìm theo Tên vắc-xin
    @idLoaiVX CHAR(10) = NULL,         -- Lọc theo Loại vắc-xin
    @idNCC CHAR(10) = NULL,            -- Lọc theo Nhà cung cấp
    @KiemTraTonKho BIT = NULL,         -- Lọc theo tình trạng tồn kho (1: Còn hàng, 0: Hết hàng)
    @KiemTraHanSuDung BIT = NULL      -- Lọc theo hạn sử dụng (1: Còn hạn, 0: Hết hạn)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        -- Các thông tin tóm tắt cần thiết cho danh sách
        vx.idVacXin,
        vx.TenVacXin,
        vx.SoLuong,
        vx.DonGiaBan,
        vx.HSD,
        lvx.TenLoai AS TenLoaiVacXin
    FROM 
        [dbo].[VACXIN] vx
    LEFT JOIN 
        [dbo].[LOAI_VACXIN] lvx ON vx.idLoaiVX = lvx.idLoaiVX
    WHERE
        -- Điều kiện lọc theo từ khóa (Keyword) cho Tên Vắc-xin
        (@Keyword IS NULL OR vx.TenVacXin LIKE N'%' + @Keyword + N'%' COLLATE Vietnamese_CI_AI)
        
        -- Điều kiện lọc theo Loại vắc-xin
        AND (@idLoaiVX IS NULL OR vx.idLoaiVX = @idLoaiVX)
        
        -- Điều kiện lọc theo Nhà cung cấp
        AND (@idNCC IS NULL OR vx.idNCC = @idNCC)
        
        -- Điều kiện lọc theo Tồn kho
        AND (@KiemTraTonKho IS NULL OR
            (@KiemTraTonKho = 1 AND vx.SoLuong > 0) OR
            (@KiemTraTonKho = 0 AND (vx.SoLuong IS NULL OR vx.SoLuong <= 0))
        )
        
        -- Điều kiện lọc theo Hạn sử dụng (HSD)
        AND (@KiemTraHanSuDung IS NULL OR
            (@KiemTraHanSuDung = 1 AND (vx.HSD IS NULL OR vx.HSD >= GETDATE())) OR -- Còn hạn hoặc chưa có HSD
            (@KiemTraHanSuDung = 0 AND vx.HSD < GETDATE()) -- Đã hết hạn
        )
    ORDER BY
        vx.TenVacXin;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_TimKiemYeuCauChuyenVien]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_TimKiemYeuCauChuyenVien]
    @tuKhoa NVARCHAR(255) = NULL,
    @trangThai NVARCHAR(50) = NULL,
    @tuNgay DATE = NULL,
    @denNgay DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        pyc.idYeuCauChuyenVien,
        pyc.idYeuCauChuyenVien as requestCode,
        pyc.NgayLap as requestDate,
        pyc.LyDo as reason,
        pyc.CoSoChuyenDen as destinationFacility,
        pyc.DiaChi as destinationAddress,
        pyc.NgayChuyen as transferDate,
        pyc.TrangThai as status,
        pyc.NgayPheDuyet as approvalDate,
        pyc.MucDo as priority,
        pyc.GhiChu as notes,
        pyc.YkienPheDuyet as approvalNotes,
		pyc.idBacSiPhuTrach as doctorId,
        
        -- Thông tin bệnh nhân
        bn.idBenhNhan as patientId,
        bn.HoTen as patientName,
        PARSENAME(REPLACE(bn.HoTen, ' ', '.'), 1) as lastName,
        STUFF(bn.HoTen, CHARINDEX(' ' + PARSENAME(REPLACE(bn.HoTen, ' ', '.'), 1), bn.HoTen), LEN(PARSENAME(REPLACE(bn.HoTen, ' ', '.'), 1)) + 1, '') as firstName,
        bn.NgaySinh as dateOfBirth,
        bn.GioiTinh as gender,
        bn.SDT as phone,
        bn.DiaChi as address,
        bn.CCCD as idNumber,
        bn.BHYT as insuranceNumber,
        bn.DoiTuongUuTien as priorityType,
        
        -- Thông tin bác sĩ phụ trách

        bs.HoTen as doctorName,
        
        -- Thông tin người phê duyệt
        pd.idNguoiDung as approverId,
        pd.HoTen as approverName,
        
        -- Thông tin người tạo
        nd.idNguoiDung as createdById,
        nd.HoTen as createdByName,
        
        pyc.NgayLap as treatmentDate
    FROM PYC_CHUYENVIEN pyc
    LEFT JOIN BENHNHAN bn ON pyc.idBenhNhan = bn.idBenhNhan
    LEFT JOIN NGUOIDUNG bs ON pyc.idBacSiPhuTrach = bs.idNguoiDung
    LEFT JOIN NGUOIDUNG pd ON pyc.idNguoiPheDuyet = pd.idNguoiDung
    LEFT JOIN NGUOIDUNG nd ON pyc.idNguoiDung = nd.idNguoiDung
    WHERE 
        (@tuKhoa IS NULL OR 
         pyc.idYeuCauChuyenVien LIKE '%' + @tuKhoa + '%' OR
         bn.HoTen LIKE '%' + @tuKhoa + '%' OR
         bn.SDT LIKE '%' + @tuKhoa + '%' OR
         bn.CCCD LIKE '%' + @tuKhoa + '%' OR
         bn.BHYT LIKE '%' + @tuKhoa + '%')
        AND (@trangThai IS NULL OR pyc.TrangThai = @trangThai)
        AND (@tuNgay IS NULL OR pyc.NgayLap >= @tuNgay)
        AND (@denNgay IS NULL OR pyc.NgayLap <= @denNgay)
    ORDER BY pyc.NgayLap DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_TopThuocDuocKe]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Cũng sửa luôn procedure lấy top thuốc để tránh lỗi tương tự
CREATE   PROCEDURE [dbo].[sp_TopThuocDuocKe]
    @Top INT = 10,
    @TuNgay DATE = NULL,
    @DenNgay DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @TuNgay IS NULL SET @TuNgay = DATEADD(MONTH, -1, GETDATE());
    IF @DenNgay IS NULL SET @DenNgay = GETDATE();
    
    SELECT TOP (@Top)
        dp.idDuocPham,
        dp.TenDuocPham,
        dp.DVT,
        SUM(ct.SoLuong) as TongSoLuongKe,
        COUNT(DISTINCT ct.idDonThuoc) as SoDonThuocKe,
        AVG(CAST(ct.SoLuong AS FLOAT)) as SoLuongTrungBinh,
        SUM(ct.SoLuong * dp.DonGiaBan) as TongGiaTri,
        -- Thêm thông tin về loại thuốc
        ldp.TenLoaiDuocPham
        
    FROM CT_DONTHUOC ct
    INNER JOIN DUOCPHAM dp ON ct.idDuocPham = dp.idDuocPham
    INNER JOIN DON_THUOC dt ON ct.idDonThuoc = dt.idDonThuoc
    LEFT JOIN LOAI_DUOCPHAM ldp ON dp.idLoaiDuocPham = ldp.idLoaiDuocPham
    
    WHERE dt.NgayLap >= @TuNgay AND dt.NgayLap <= @DenNgay
    
    GROUP BY dp.idDuocPham, dp.TenDuocPham, dp.DVT, ldp.TenLoaiDuocPham
    ORDER BY TongSoLuongKe DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_TopVacXinDuocDangKy]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 10. Top vắc xin được đăng ký nhiều nhất
CREATE PROCEDURE [dbo].[sp_TopVacXinDuocDangKy]
    @Top INT = 10,
    @TuNgay DATE = NULL,
    @DenNgay DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @StartDate DATE = ISNULL(@TuNgay, DATEADD(MONTH, -1, GETDATE()));
    DECLARE @EndDate DATE = ISNULL(@DenNgay, GETDATE());
    
    SELECT TOP (@Top)
        VX.idVacXin,
        VX.TenVacXin,
        ISNULL(LVX.TenLoai, N'Chưa phân loại') as LoaiVacXin,
        VX.DonGiaBan,
        COUNT(PDK.idDKTiemChung) as SoLuongDangKy,
        COUNT(CASE WHEN PDK.TrangThai = N'Đã tiêm' THEN 1 END) as SoLuongDaTiem,
        SUM(CASE WHEN PDK.TrangThai = N'Đã tiêm' THEN VX.DonGiaBan ELSE 0 END) as DoanhThu,
        CAST(COUNT(CASE WHEN PDK.TrangThai = N'Đã tiêm' THEN 1 END) * 100.0 / 
             NULLIF(COUNT(PDK.idDKTiemChung), 0) AS DECIMAL(5,2)) as TyLeTiem,
        VX.SoLuong as SoLuongTon
    FROM VACXIN VX
    LEFT JOIN LOAI_VACXIN LVX ON VX.idLoaiVX = LVX.idLoaiVX
    INNER JOIN PDK_TIEMCHUNG PDK ON VX.idVacXin = PDK.idVacXin
    WHERE PDK.NgayLap BETWEEN @StartDate AND @EndDate
    GROUP BY VX.idVacXin, VX.TenVacXin, LVX.TenLoai, VX.DonGiaBan, VX.SoLuong
    ORDER BY SoLuongDangKy DESC, DoanhThu DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_XacNhanCaLamViec]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- phê duyệt
CREATE PROCEDURE [dbo].[sp_XacNhanCaLamViec]
    @idCaLamViec CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @confirmer_id CHAR(10) = CAST(SESSION_CONTEXT(N'UserID') AS CHAR(10));
    IF @confirmer_id IS NULL BEGIN; THROW 51000, N'Lỗi: Không thể xác định người dùng đang xác nhận.', 1; RETURN; END;

    UPDATE [dbo].[CALAMVIEC]
    SET 
        TrangThai = N'Đã xác nhận',
        idNguoiPheDuyet = @confirmer_id,
        ThoiGianPheDuyet = GETDATE()
    WHERE 
        idCaLamViec = @idCaLamViec AND TrangThai = N'Đã lên lịch';
        
    IF @@ROWCOUNT = 0 BEGIN; THROW 57003, N'Lỗi: Ca làm việc không tồn tại hoặc không ở trạng thái "Đã lên lịch".', 1; RETURN; END;

    PRINT N'Đã xác nhận thành công ca làm việc ' + @idCaLamViec;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_XacNhanDaTiem]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 6. Xác nhận đã tiêm
CREATE PROCEDURE [dbo].[sp_XacNhanDaTiem]
    @idDKTiemChung CHAR(10),
    @idNguoiThucHien CHAR(10),
    @GhiChuSauTiem NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Kiểm tra đăng ký tồn tại
        IF NOT EXISTS (SELECT 1 FROM PDK_TIEMCHUNG WHERE idDKTiemChung = @idDKTiemChung)
        BEGIN
            RAISERROR(N'Đăng ký tiêm chủng không tồn tại', 16, 1);
            RETURN;
        END
        
        -- Kiểm tra trạng thái hiện tại
        DECLARE @TrangThai NVARCHAR(50);
        SELECT @TrangThai = TrangThai 
        FROM PDK_TIEMCHUNG 
        WHERE idDKTiemChung = @idDKTiemChung;
        
        IF @TrangThai = N'Đã hủy'
        BEGIN
            RAISERROR(N'Không thể xác nhận đăng ký đã bị hủy', 16, 1);
            RETURN;
        END
        
        IF @TrangThai = N'Đã tiêm'
        BEGIN
            RAISERROR(N'Đăng ký này đã được xác nhận tiêm trước đó', 16, 1);
            RETURN;
        END
        
        -- Lấy thông tin vắc xin
        DECLARE @idVacXin CHAR(10);
        SELECT @idVacXin = idVacXin 
        FROM PDK_TIEMCHUNG 
        WHERE idDKTiemChung = @idDKTiemChung;
        
        -- Kiểm tra tồn kho
        DECLARE @SoLuongTon INT;
        SELECT @SoLuongTon = SoLuong 
        FROM VACXIN 
        WHERE idVacXin = @idVacXin;
        
        IF @SoLuongTon <= 0
        BEGIN
            RAISERROR(N'Vắc xin đã hết hàng, không thể xác nhận tiêm', 16, 1);
            RETURN;
        END
        
        -- Cập nhật trạng thái và ghi chú
        UPDATE PDK_TIEMCHUNG 
        SET 
            TrangThai = N'Đã tiêm',
            GhiChu = CASE 
                WHEN @GhiChuSauTiem IS NOT NULL THEN 
                    CASE 
                        WHEN GhiChu IS NULL OR GhiChu = '' THEN @GhiChuSauTiem
                        ELSE GhiChu + N'; ' + @GhiChuSauTiem
                    END
                ELSE GhiChu
            END
        WHERE idDKTiemChung = @idDKTiemChung;
        
        -- Giảm số lượng vắc xin trong kho
        UPDATE VACXIN 
        SET SoLuong = SoLuong - 1
        WHERE idVacXin = @idVacXin;
        
        COMMIT TRANSACTION;
        
        SELECT N'Xác nhận đã tiêm thành công' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_XacNhanThanhToanDonThuoc]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedure xác nhận thanh toán đơn thuốc (CORRECTED)
CREATE   PROCEDURE [dbo].[sp_XacNhanThanhToanDonThuoc]
    @idDonThuoc CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE DON_THUOC 
    SET TrangThai = N'Đã thanh toán'
    WHERE idDonThuoc = @idDonThuoc;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_XoaCaLamViec]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- xoá
CREATE PROCEDURE [dbo].[sp_XoaCaLamViec]
    @idCaLamViec CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra trạng thái của Lịch Tổng Thể cha
    DECLARE @TrangThaiLich NVARCHAR(50);
    SELECT @TrangThaiLich = ltt.TrangThai FROM [dbo].[CALAMVIEC] clv
    JOIN [dbo].[LICH_TONGTHE] ltt ON clv.idLichTongThe = ltt.idLichTongThe
    WHERE clv.idCaLamViec = @idCaLamViec;
    
    IF @TrangThaiLich IS NULL BEGIN; THROW 50004, N'Lỗi: Ca làm việc không tồn tại.', 1; RETURN; END;
    IF @TrangThaiLich <> N'Bản nháp' BEGIN; THROW 58004, N'Lỗi: Không thể xóa vĩnh viễn ca từ một lịch đã được công bố.', 1; RETURN; END;

    -- Kiểm tra ràng buộc khóa ngoại từ PYC_CHUYENCA
    IF EXISTS (SELECT 1 FROM [dbo].[PYC_CHUYENCA] WHERE idCaLamViecGoc = @idCaLamViec)
    BEGIN; THROW 57010, N'Lỗi: Không thể xóa. Ca làm việc này đang được tham chiếu trong một yêu cầu chuyển ca.', 1; RETURN; END;
    
    DELETE FROM [dbo].[CALAMVIEC] WHERE idCaLamViec = @idCaLamViec;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_XoaChiTietDonThuoc]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- xoá
CREATE PROCEDURE [dbo].[sp_XoaChiTietDonThuoc]
    @idDonThuoc CHAR(10),
    @idDuocPham CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra trạng thái của đơn thuốc cha
    DECLARE @TrangThaiDonThuoc NVARCHAR(50);
    SELECT @TrangThaiDonThuoc = TrangThai FROM [dbo].[DON_THUOC] WHERE idDonThuoc = @idDonThuoc;
    IF @TrangThaiDonThuoc IS NULL
    BEGIN; THROW 50004, N'Lỗi: Đơn thuốc không tồn tại.', 1; RETURN; END;
    IF @TrangThaiDonThuoc <> N'Chưa thanh toán'
    BEGIN; THROW 56001, N'Lỗi: Không thể xóa thuốc khỏi đơn đã được thanh toán hoặc đã hủy.', 1; RETURN; END;
    
    -- Thực hiện xóa
    DELETE FROM [dbo].[CT_DONTHUOC]
    WHERE idDonThuoc = @idDonThuoc AND idDuocPham = @idDuocPham;

    IF @@ROWCOUNT = 0
    BEGIN; THROW 56004, N'Lỗi: Không tìm thấy chi tiết thuốc này trong đơn để xóa.', 1; RETURN; END;

    PRINT N'Đã xóa dược phẩm ' + @idDuocPham + N' khỏi đơn thuốc ' + @idDonThuoc;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_XoaCungDonThuoc]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedure xóa đơn thuốc (CORRECTED)
CREATE   PROCEDURE [dbo].[sp_XoaCungDonThuoc]
    @idDonThuoc CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Xóa chi tiết đơn thuốc trước
        DELETE FROM CT_DONTHUOC WHERE idDonThuoc = @idDonThuoc;
        
        -- Xóa đơn thuốc
        DELETE FROM DON_THUOC WHERE idDonThuoc = @idDonThuoc;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_XoaCungPhieuChuyenVien]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- xoá
CREATE PROCEDURE [dbo].[sp_XoaCungPhieuChuyenVien]
    @idChuyenVien CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    -- CẢNH BÁO: Hành động này sẽ xóa vĩnh viễn dữ liệu và không thể hoàn tác.
    -- Việc này có thể ảnh hưởng đến tính toàn vẹn của dữ liệu báo cáo và lịch sử.

    -- === KIỂM TRA AN TOÀN ===
    
    -- 1. Kiểm tra phiếu có tồn tại không
    IF NOT EXISTS (SELECT 1 FROM [dbo].[P_CHUYENVIEN] WHERE idChuyenVien = @idChuyenVien)
    BEGIN;
        THROW 50004, N'Lỗi: Phiếu chuyển viện không tồn tại để xóa.', 1;
        RETURN;
    END

    -- 2. Quy tắc an toàn: Chỉ cho phép xóa cứng một phiếu đã được hủy (Đã xóa mềm).
    -- Điều này tạo ra một quy trình 2 bước, tăng cường an toàn.
    --DECLARE @CurrentTrangThai NVARCHAR(50);
    --SELECT @CurrentTrangThai = TrangThai 
    --FROM [dbo].[P_CHUYENVIEN] 
    --WHERE idChuyenVien = @idChuyenVien;

    --IF @CurrentTrangThai <> N'Đã hủy'
    --BEGIN;
    --    THROW 54004, N'Lỗi: Chỉ có thể xóa vĩnh viễn phiếu đã được hủy trước đó.', 1;
    --    RETURN;
    --END

    -- === THỰC HIỆN LỆNH XÓA ===
    BEGIN TRANSACTION;
    BEGIN TRY
        DELETE FROM [dbo].[P_CHUYENVIEN]
        WHERE idChuyenVien = @idChuyenVien;

        COMMIT TRANSACTION;
        PRINT N'Đã XÓA VĨNH VIỄN thành công phiếu chuyển viện: ' + @idChuyenVien;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_XoaCungPhieuDangKyKham]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- xoá
CREATE PROCEDURE [dbo].[sp_XoaCungPhieuDangKyKham]
    @idDKKhambenh CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    -- CẢNH BÁO: Hành động này sẽ xóa vĩnh viễn dữ liệu và không thể hoàn tác.
    -- Chỉ nên sử dụng khi chắc chắn rằng bản ghi này không còn giá trị lưu trữ.

    -- === CÁC BƯỚC KIỂM TRA AN TOÀN ===

    -- 1. Lấy trạng thái của phiếu để kiểm tra
    DECLARE @CurrentTrangThai NVARCHAR(50);
    SELECT @CurrentTrangThai = TrangThai 
    FROM [dbo].[PDK_KHAMBENH] 
    WHERE idDKKhambenh = @idDKKhambenh;

    -- 2. Kiểm tra phiếu có tồn tại không
    IF @CurrentTrangThai IS NULL
    BEGIN;
        THROW 50004, N'Lỗi: Phiếu đăng ký không tồn tại để xóa.', 1;
        RETURN;
    END
    
    -- 3. Chỉ cho phép xóa cứng phiếu ở trạng thái "Đã hủy" hoặc "Chờ khám".
    -- KHÔNG cho phép xóa phiếu "Đã khám" vì nó có thể liên quan đến các dữ liệu khác (kết quả, đơn thuốc...).
    IF @CurrentTrangThai NOT IN (N'Chờ khám', N'Đã hủy')
    BEGIN;
        THROW 54003, N'Lỗi: Không thể xóa phiếu đã ở trạng thái khám hoặc đang xử lý.', 1;
        RETURN;
    END

    -- === THỰC HIỆN LỆNH XÓA ===
    BEGIN TRANSACTION;
    BEGIN TRY
        DELETE FROM [dbo].[PDK_KHAMBENH]
        WHERE idDKKhambenh = @idDKKhambenh;

        COMMIT TRANSACTION;
        PRINT N'Đã XÓA VĨNH VIỄN thành công phiếu đăng ký khám bệnh: ' + @idDKKhambenh;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_XoaCungPhieuYeuCauChuyenVien]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- xoá
CREATE PROCEDURE [dbo].[sp_XoaCungPhieuYeuCauChuyenVien]
    @idYeuCauChuyenVien CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    -- === CÁC BƯỚC KIỂM TRA AN TOÀN TRƯỚC KHI XÓA ===

    -- 1. Kiểm tra xem phiếu yêu cầu có tồn tại không.
    IF NOT EXISTS (SELECT 1 FROM [dbo].[PYC_CHUYENVIEN] WHERE idYeuCauChuyenVien = @idYeuCauChuyenVien)
    BEGIN;
        THROW 50004, N'Lỗi: Phiếu yêu cầu chuyển viện không tồn tại.', 1;
        RETURN;
    END

    -- 2. Kiểm tra xem phiếu này đã được duyệt hay chưa. Chỉ cho phép xóa phiếu đang "Chờ duyệt" hoặc "Từ chối".
    DECLARE @TrangThaiHienTai NVARCHAR(50);
    SELECT @TrangThaiHienTai = TrangThai 
    FROM [dbo].[PYC_CHUYENVIEN] 
    WHERE idYeuCauChuyenVien = @idYeuCauChuyenVien;

    IF @TrangThaiHienTai = N'Đã duyệt'
    BEGIN;
        THROW 54001, N'Lỗi: Không thể xóa phiếu đã được duyệt.', 1;
        RETURN;
    END

    -- 3. Kiểm tra xem đã có Phiếu Chuyển Viện (P_CHUYENVIEN) nào được tạo từ yêu cầu này chưa.
    IF EXISTS (SELECT 1 FROM [dbo].[P_CHUYENVIEN] WHERE idYeuCauChuyenVien = @idYeuCauChuyenVien)
    BEGIN;
        THROW 54002, N'Lỗi: Không thể xóa. Đã có phiếu chuyển viện được tạo từ yêu cầu này.', 1;
        RETURN;
    END

    -- === THỰC HIỆN LỆNH XÓA ===
    BEGIN TRANSACTION;
    BEGIN TRY
        DELETE FROM [dbo].[PYC_CHUYENVIEN]
        WHERE idYeuCauChuyenVien = @idYeuCauChuyenVien;

        COMMIT TRANSACTION;
        PRINT N'Đã xóa vĩnh viễn thành công phiếu yêu cầu: ' + @idYeuCauChuyenVien;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW; -- Ném lỗi chi tiết ra để xử lý
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_XoaDangKyTiemChung]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 5. Xóa đăng ký tiêm chủng
CREATE PROCEDURE [dbo].[sp_XoaDangKyTiemChung]
    @idDKTiemChung CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Kiểm tra đăng ký tồn tại
        IF NOT EXISTS (SELECT 1 FROM PDK_TIEMCHUNG WHERE idDKTiemChung = @idDKTiemChung)
        BEGIN
            RAISERROR(N'Đăng ký tiêm chủng không tồn tại', 16, 1);
            RETURN;
        END
        
        -- Kiểm tra trạng thái có thể xóa
        DECLARE @TrangThai NVARCHAR(50);
        SELECT @TrangThai = TrangThai 
        FROM PDK_TIEMCHUNG 
        WHERE idDKTiemChung = @idDKTiemChung;
        
        IF @TrangThai = N'Đã tiêm'
        BEGIN
            RAISERROR(N'Không thể xóa đăng ký đã tiêm', 16, 1);
            RETURN;
        END
        
        -- Cập nhật trạng thái thành "Đã hủy"
        UPDATE PDK_TIEMCHUNG 
        SET TrangThai = N'Đã hủy'
        WHERE idDKTiemChung = @idDKTiemChung;
        
        COMMIT TRANSACTION;
        
        SELECT N'Hủy đăng ký tiêm chủng thành công' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_XoaDonNghiPhep]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- xoá
CREATE PROCEDURE [dbo].[sp_XoaDonNghiPhep]
    @idNghiPhep CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    -- Các kiểm tra an toàn...
    
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Bước 1 (MỚI): Xóa các dòng trong bảng liên kết trước
        DELETE FROM [dbo].[NGHIPHEP_ANHHUONGCA]
        WHERE idNghiPhep = @idNghiPhep;

        -- Bước 2: Xóa đơn nghỉ
        DELETE FROM [dbo].[DON_NGHIPHEP]
        WHERE idNghiPhep = @idNghiPhep
          AND TrangThai IN (N'Từ chối', N'Đã hủy');
          
        IF @@ROWCOUNT = 0 BEGIN; ROLLBACK; THROW 59002, N'Lỗi: Không thể xóa đơn đang chờ duyệt hoặc đã được duyệt.', 1; RETURN; END;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_XoaYeuCauChuyenCa]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- xoá
CREATE PROCEDURE [dbo].[sp_XoaYeuCauChuyenCa]
    @idYeuCauChuyenCa CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    -- CẢNH BÁO: Hành động này sẽ xóa vĩnh viễn dữ liệu.

    -- === KIỂM TRA AN TOÀN ===
    DECLARE @CurrentTrangThai NVARCHAR(50);
    SELECT @CurrentTrangThai = TrangThai 
    FROM [dbo].[PYC_CHUYENCA] 
    WHERE idYeuCauChuyenCa = @idYeuCauChuyenCa;

    IF @CurrentTrangThai IS NULL
    BEGIN; THROW 50004, N'Lỗi: Yêu cầu chuyển ca không tồn tại để xóa.', 1; RETURN; END;
    
    -- Quy tắc an toàn: Chỉ cho phép xóa khi yêu cầu đã ở trạng thái kết thúc (không phải 'Chờ duyệt' hoặc 'Đã duyệt').
    IF @CurrentTrangThai IN (N'Chờ duyệt', N'Đã duyệt')
    BEGIN; THROW 57012, N'Lỗi: Không thể xóa một yêu cầu đang chờ xử lý hoặc đã được duyệt thành công.', 1; RETURN; END;
    
    -- === THỰC HIỆN LỆNH XÓA ===
    BEGIN TRANSACTION;
    BEGIN TRY
        DELETE FROM [dbo].[PYC_CHUYENCA]
        WHERE idYeuCauChuyenCa = @idYeuCauChuyenCa;

        COMMIT TRANSACTION;
        PRINT N'Đã XÓA VĨNH VIỄN thành công yêu cầu chuyển ca: ' + @idYeuCauChuyenCa;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_XuLyDonNghiPhep]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- phê duyệt
CREATE PROCEDURE [dbo].[sp_XuLyDonNghiPhep]
    @idNghiPhep CHAR(10),
    @IsApproved BIT,
    @GhiChuPheDuyet NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @approver_id CHAR(10) = CAST(SESSION_CONTEXT(N'UserID') AS CHAR(10));
    IF @approver_id IS NULL BEGIN; THROW 51000, N'Lỗi: Không thể xác định người phê duyệt.', 1; RETURN; END;
    
    DECLARE @TrangThaiMoi NVARCHAR(50) = CASE WHEN @IsApproved = 1 THEN N'Đã duyệt' ELSE N'Từ chối' END;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Bước 1: Cập nhật trạng thái của đơn xin nghỉ
        UPDATE [dbo].[DON_NGHIPHEP]
        SET TrangThai = @TrangThaiMoi,
            idNguoiPheDuyet = @approver_id,
            NgayPheDuyet = GETDATE(),
            GhiChuPheDuyet = @GhiChuPheDuyet
        WHERE idNghiPhep = @idNghiPhep AND TrangThai = N'Chờ duyệt';

        IF @@ROWCOUNT = 0
        BEGIN;
             ROLLBACK TRANSACTION;
             THROW 59001, N'Lỗi: Đơn xin nghỉ không tồn tại hoặc đã được xử lý.', 1; 
             RETURN;
        END

        -- Bước 2 (MỚI): Nếu duyệt, cập nhật trạng thái của các ca bị ảnh hưởng
        -- Logic này có thể được xử lý bởi một trigger hoặc ngay tại đây
        IF @IsApproved = 1
        BEGIN
            UPDATE clv
            SET clv.TrangThai = N'Đã nghỉ phép'
            FROM [dbo].[CALAMVIEC] clv
            INNER JOIN [dbo].[NGHIPHEP_ANHHUONGCA] anhhuong ON clv.idCaLamViec = anhhuong.idCaLamViec
            WHERE anhhuong.idNghiPhep = @idNghiPhep;
        END
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_XuLyPhieuYeuCauChuyenVien]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- phê duyệt
CREATE PROCEDURE [dbo].[sp_XuLyPhieuYeuCauChuyenVien]
    @idYeuCauChuyenVien CHAR(10),
    @idNguoiPheDuyet CHAR(10),
    @TrangThaiMoi NVARCHAR(50), -- Phải là 'Đã duyệt' hoặc 'Từ chối'
    @YKienPheDuyet NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;

    IF @TrangThaiMoi NOT IN (N'Đã duyệt', N'Từ chối')
    BEGIN; THROW 50008, N'Lỗi: Trạng thái mới không hợp lệ. Phải là "Đã duyệt" hoặc "Từ chối".', 1; RETURN; END;

    IF NOT EXISTS (SELECT 1 FROM [dbo].[PYC_CHUYENVIEN] WHERE idYeuCauChuyenVien = @idYeuCauChuyenVien)
    BEGIN; THROW 50004, N'Lỗi: Phiếu yêu cầu không tồn tại.', 1; RETURN; END;

    IF NOT EXISTS (SELECT 1 FROM [dbo].[NGUOIDUNG] WHERE idNguoiDung = @idNguoiPheDuyet)
    BEGIN; THROW 50006, N'Lỗi: Người phê duyệt không tồn tại.', 1; RETURN; END;

    UPDATE [dbo].[PYC_CHUYENVIEN]
    SET 
        [TrangThai] = @TrangThaiMoi,
        [idNguoiPheDuyet] = @idNguoiPheDuyet,
        [NgayPheDuyet] = GETDATE(),
        [YKienPheDuyet] = @YKienPheDuyet
    WHERE 
        idYeuCauChuyenVien = @idYeuCauChuyenVien AND TrangThai = N'Chờ duyệt';
    
    IF @@ROWCOUNT = 0
    BEGIN; THROW 50007, N'Lỗi: Phiếu không ở trạng thái "Chờ duyệt" hoặc đã được xử lý.', 1; RETURN; END;

    PRINT N'Đã xử lý phiếu ' + @idYeuCauChuyenVien + N' với trạng thái mới: "' + @TrangThaiMoi + N'".';
END
GO
/****** Object:  StoredProcedure [dbo].[sp_XuLyYeuCauChuyenCa]    Script Date: 27/06/2025 4:04:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	-- phê duyệt
CREATE PROCEDURE [dbo].[sp_XuLyYeuCauChuyenCa]
    @idYeuCauChuyenCa CHAR(10),
    @IsApproved BIT, -- 1 = duyệt, 0 = từ chối
    @GhiChuPheDuyet NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @approver_id CHAR(10) = CAST(SESSION_CONTEXT(N'UserID') AS CHAR(10));
    IF @approver_id IS NULL BEGIN; THROW 51000, N'Lỗi: Không thể xác định người phê duyệt.', 1; RETURN; END;
    
    DECLARE @idCaGoc CHAR(10), @idNVMoi CHAR(10);
    SELECT @idCaGoc = idCaLamViecGoc, @idNVMoi = idNhanVienMoi
    FROM [dbo].[PYC_CHUYENCA] WHERE idYeuCauChuyenCa = @idYeuCauChuyenCa AND TrangThai = N'Chờ duyệt';
    IF @idCaGoc IS NULL BEGIN; THROW 57009, N'Lỗi: Yêu cầu không tồn tại hoặc đã được xử lý.', 1; RETURN; END;

    BEGIN TRANSACTION;
    BEGIN TRY
        IF @IsApproved = 0 -- Từ chối
        BEGIN
            UPDATE [dbo].[PYC_CHUYENCA]
            SET TrangThai = N'Từ chối', idNguoiPheDuyet = @approver_id, NgayPheDuyet = GETDATE(), GhiChuPheDuyet = @GhiChuPheDuyet
            WHERE idYeuCauChuyenCa = @idYeuCauChuyenCa;
        END
        ELSE -- Chấp thuận
        BEGIN
            UPDATE [dbo].[CALAMVIEC] SET TrangThai = N'Đã chuyển ca' WHERE idCaLamViec = @idCaGoc;
            
            DECLARE @idCaMoi CHAR(10);
            -- Logic sinh mã mới cho @idCaMoi...
            
            INSERT INTO [dbo].[CALAMVIEC] (idCaLamViec, NgayLamViec, LoaiCa, GioBD, GioKT, TrangThai, LoaiCongViec, GhiChu, idNhanVien, idNguoiDung, idKhoa, idLichTongThe)
            SELECT @idCaMoi, NgayLamViec, LoaiCa, GioBD, GioKT, N'Đã lên lịch', LoaiCongViec, N'Ca được chuyển từ ' + idNhanVien, @idNVMoi, @approver_id, idKhoa, idLichTongThe
            FROM [dbo].[CALAMVIEC] WHERE idCaLamViec = @idCaGoc;

            UPDATE [dbo].[PYC_CHUYENCA]
            SET TrangThai = N'Đã duyệt', idNguoiPheDuyet = @approver_id, NgayPheDuyet = GETDATE(), GhiChuPheDuyet = @GhiChuPheDuyet, idCaLamViecMoi = @idCaMoi
            WHERE idYeuCauChuyenCa = @idYeuCauChuyenCa;
        END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END
GO

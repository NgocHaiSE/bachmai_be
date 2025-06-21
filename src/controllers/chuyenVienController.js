const prisma = require('../utils/prisma');

// ============ YÊU CẦU CHUYỂN VIỆN ============

const layDanhSachYeuCauChuyenVien = async (req, res) => {
  try {
    const result = await prisma.$queryRaw`EXEC sp_LayDanhSachYeuCauChuyenVien`;

    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layDanhSachYeuCauChuyenVien:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy danh sách yêu cầu chuyển viện',
      error: error.message
    });
  }
};

// Lấy danh sách phiếu chuyển viện
const layDanhSachPhieuChuyenVien = async (req, res) => {
  try {
    const result = await prisma.$queryRaw`EXEC sp_LayDanhSachPhieuChuyenVien`;

    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layDanhSachPhieuChuyenVien:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy danh sách phiếu chuyển viện',
      error: error.message
    });
  }
};

// Thêm phiếu yêu cầu chuyển viện
const themPhieuYeuCauChuyenVien = async (req, res) => {
  try {
    const {
      LyDo, CoSoChuyenDen, DiaChi, NgayChuyen, MucDo,
      GhiChu, idBacSiPhuTrach, idBenhNhan, idNguoiDung
    } = req.body;

    console.log(req.body)

    const result = await prisma.$executeRaw`
      DECLARE @idYeuCauMoi CHAR(10);
      EXEC sp_ThemPhieuYeuCauChuyenVien 
        @LyDo = ${LyDo},
        @CoSoChuyenDen = ${CoSoChuyenDen},
        @DiaChi = ${DiaChi},
        @NgayChuyen = ${NgayChuyen},
        @MucDo = ${MucDo},
        @GhiChu = ${GhiChu},
        @idBacSiPhuTrach = ${idBacSiPhuTrach},
        @idBenhNhan = ${idBenhNhan},
        @idNguoiDung = ${idNguoiDung},
        @idYeuCauMoi = @idYeuCauMoi OUTPUT;
      SELECT @idYeuCauMoi as idYeuCauMoi;
    `;

    res.status(201).json({
      success: true,
      message: 'Tạo phiếu yêu cầu chuyển viện thành công',
      data: result
    });
  } catch (error) {
    console.error('Error in themPhieuYeuCauChuyenVien:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi tạo phiếu yêu cầu chuyển viện',
      error: error.message
    });
  }
};

// Sửa phiếu yêu cầu chuyển viện
const suaPhieuYeuCauChuyenVien = async (req, res) => {
  try {
    const { id } = req.params;
    const {
      LyDo, CoSoChuyenDen, DiaChi, NgayChuyen,
      MucDo, GhiChu, idBacSiPhuTrach
    } = req.body;

    await prisma.$executeRaw`
      EXEC sp_SuaPhieuYeuCauChuyenVien 
        @idYeuCauChuyenVien = ${id},
        @LyDo = ${LyDo},
        @CoSoChuyenDen = ${CoSoChuyenDen},
        @DiaChi = ${DiaChi},
        @NgayChuyen = ${NgayChuyen},
        @MucDo = ${MucDo},
        @GhiChu = ${GhiChu},
        @idBacSiPhuTrach = ${idBacSiPhuTrach}
    `;

    res.json({
      success: true,
      message: 'Cập nhật phiếu yêu cầu chuyển viện thành công'
    });
  } catch (error) {
    console.error('Error in suaPhieuYeuCauChuyenVien:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi cập nhật phiếu yêu cầu chuyển viện',
      error: error.message
    });
  }
};

// Xử lý phiếu yêu cầu chuyển viện (phê duyệt/từ chối)
const xuLyPhieuYeuCauChuyenVien = async (req, res) => {
  try {
    const { id } = req.params;
    const { idNguoiPheDuyet, TrangThaiMoi, YKienPheDuyet } = req.body;

    await prisma.$executeRaw`
      EXEC sp_XuLyPhieuYeuCauChuyenVien 
        @idYeuCauChuyenVien = ${id},
        @idNguoiPheDuyet = ${idNguoiPheDuyet},
        @TrangThaiMoi = ${TrangThaiMoi},
        @YKienPheDuyet = ${YKienPheDuyet}
    `;

    res.json({
      success: true,
      message: 'Xử lý phiếu yêu cầu chuyển viện thành công'
    });
  } catch (error) {
    console.error('Error in xuLyPhieuYeuCauChuyenVien:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi xử lý phiếu yêu cầu chuyển viện',
      error: error.message
    });
  }
};

// Xóa phiếu yêu cầu chuyển viện
const xoaPhieuYeuCauChuyenVien = async (req, res) => {
  try {
    const { id } = req.params;

    await prisma.$executeRaw`
      EXEC sp_XoaCungPhieuYeuCauChuyenVien @idYeuCauChuyenVien = ${id}
    `;

    res.json({
      success: true,
      message: 'Xóa phiếu yêu cầu chuyển viện thành công'
    });
  } catch (error) {
    console.error('Error in xoaPhieuYeuCauChuyenVien:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi xóa phiếu yêu cầu chuyển viện',
      error: error.message
    });
  }
};

// Lấy phiếu yêu cầu chuyển viện theo ID
const layChiTietYeuCauChuyenVien = async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await prisma.$queryRaw`
      EXEC sp_LayChiTietYeuCauChuyenVien @idYeuCauChuyenVien = ${id}
    `;
    
    if (result.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy phiếu yêu cầu chuyển viện'
      });
    }
    
    res.json({
      success: true,
      data: result[0]
    });
  } catch (error) {
    console.error('Error in layChiTietYeuCauChuyenVien:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy thông tin phiếu yêu cầu chuyển viện',
      error: error.message
    });
  }
};

// Tìm kiếm phiếu yêu cầu chuyển viện
const timKiemYeuCauChuyenVien = async (req, res) => {
  try {
    const { tuKhoa, trangThai, tuNgay, denNgay } = req.query;

    const result = await prisma.$queryRaw`
      EXEC sp_TimKiemYeuCauChuyenVien
        @tuKhoa = ${tuKhoa || null},
        @trangThai = ${trangThai || null},
        @tuNgay = ${tuNgay || null},
        @denNgay = ${denNgay || null}
    `;
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in timKiemYeuCauChuyenVien:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi tìm kiếm phiếu yêu cầu chuyển viện',
      error: error.message
    });
  }
};

// ============ PHIẾU CHUYỂN VIỆN ============

// Tạo phiếu chuyển viện
const taoPhieuChuyenVien = async (req, res) => {
  try {
    const {
      idYeuCauChuyenVien, NgayChuyen, ThoiGianDuKien, SDT_CoSoYTe,
      YThuc, GhiChu, idNguoiDung 
    } = req.body;
    console.log('Request body:', req.body);

    const result = await prisma.$executeRaw`
      DECLARE @idChuyenVienMoi CHAR(10);
      EXEC sp_TaoPhieuChuyenVien 
        @idYeuCauChuyenVien = ${idYeuCauChuyenVien},
        @NgayChuyen = ${NgayChuyen},
        @ThoiGianDuKien = ${ThoiGianDuKien},
        @SDT_CoSoYTe = ${SDT_CoSoYTe},
        @YThuc = ${YThuc},
        @GhiChu = ${GhiChu},
        @idNguoiDung = ${idNguoiDung},
        @idChuyenVienMoi = @idChuyenVienMoi OUTPUT;
      SELECT @idChuyenVienMoi as idChuyenVienMoi;
    `;

    res.status(201).json({
      success: true,
      message: 'Tạo phiếu chuyển viện thành công',
      data: result
    });
  } catch (error) {
    console.error('Error in taoPhieuChuyenVien:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi tạo phiếu chuyển viện',
      error: error.message
    });
  }
};

// Sửa phiếu chuyển viện
const suaPhieuChuyenVien = async (req, res) => {
  try {
    const { id } = req.params;
    const {
      NgayChuyen, ThoiGianDuKien, SDT_CoSoYTe,
      YThuc, GhiChu
    } = req.body;

    await prisma.$executeRaw`
      EXEC sp_SuaPhieuChuyenVien 
        @idChuyenVien = ${id},
        @NgayChuyen = ${NgayChuyen},
        @ThoiGianDuKien = ${ThoiGianDuKien},
        @SDT_CoSoYTe = ${SDT_CoSoYTe},
        @YThuc = ${YThuc},
        @GhiChu = ${GhiChu}
    `;

    res.json({
      success: true,
      message: 'Cập nhật phiếu chuyển viện thành công'
    });
  } catch (error) {
    console.error('Error in suaPhieuChuyenVien:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi cập nhật phiếu chuyển viện',
      error: error.message
    });
  }
};

// Cập nhật trạng thái chuyển viện
const capNhatTrangThaiChuyenVien = async (req, res) => {
  try {
    const { id } = req.params;
    const { TrangThaiMoi, GhiChuCapNhat } = req.body;

    await prisma.$executeRaw`
      EXEC sp_CapNhatTrangThaiChuyenVien 
        @idChuyenVien = ${id},
        @TrangThaiMoi = ${TrangThaiMoi},
        @GhiChuCapNhat = ${GhiChuCapNhat || null}
    `;

    res.json({
      success: true,
      message: 'Cập nhật trạng thái chuyển viện thành công'
    });
  } catch (error) {
    console.error('Error in capNhatTrangThaiChuyenVien:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi cập nhật trạng thái chuyển viện',
      error: error.message
    });
  }
};

// Xóa phiếu chuyển viện
const xoaPhieuChuyenVien = async (req, res) => {
  try {
    const { id } = req.params;

    await prisma.$executeRaw`
      EXEC sp_XoaCungPhieuChuyenVien @idChuyenVien = ${id}
    `;

    res.json({
      success: true,
      message: 'Xóa phiếu chuyển viện thành công'
    });
  } catch (error) {
    console.error('Error in xoaPhieuChuyenVien:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi xóa phiếu chuyển viện',
      error: error.message
    });
  }
};

// Lấy phiếu chuyển viện theo ID
const layChiTietPhieuChuyenVien = async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await prisma.$queryRaw`
      EXEC sp_LayChiTietPhieuChuyenVien @idChuyenVien = ${id}
    `;
    
    if (result.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy phiếu chuyển viện'
      });
    }
    
    res.json({
      success: true,
      data: result[0]
    });
  } catch (error) {
    console.error('Error in layChiTietPhieuChuyenVien:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy thông tin phiếu chuyển viện',
      error: error.message
    });
  }
};

// Tìm kiếm phiếu chuyển viện
const timKiemPhieuChuyenVien = async (req, res) => {
  try {
    const { tuKhoa, trangThai, tuNgay, denNgay } = req.query;

    const result = await prisma.$queryRaw`
      EXEC sp_TimKiemPhieuChuyenVien_V2
        @tuKhoa = ${tuKhoa || null},
        @trangThai = ${trangThai || null},
        @tuNgay = ${tuNgay || null},
        @denNgay = ${denNgay || null}
    `;
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in timKiemPhieuChuyenVien:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi tìm kiếm phiếu chuyển viện',
      error: error.message
    });
  }
};

module.exports = {
  // Yêu cầu chuyển viện
  themPhieuYeuCauChuyenVien,
  suaPhieuYeuCauChuyenVien,
  xuLyPhieuYeuCauChuyenVien,
  xoaPhieuYeuCauChuyenVien,
  layChiTietYeuCauChuyenVien,
  timKiemYeuCauChuyenVien,
  layDanhSachYeuCauChuyenVien,
  
  // Phiếu chuyển viện
  taoPhieuChuyenVien,
  suaPhieuChuyenVien,
  capNhatTrangThaiChuyenVien,
  xoaPhieuChuyenVien,
  layChiTietPhieuChuyenVien,
  timKiemPhieuChuyenVien,
  layDanhSachPhieuChuyenVien
};
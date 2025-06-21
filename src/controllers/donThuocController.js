// src/controllers/donThuocController.js - Corrected for actual database structure
const prisma = require('../utils/prisma');


// Helper function để format dữ liệu đơn thuốc
const formatPrescriptionData = (rawData) => {
  return rawData.map(item => {
    // Xử lý tên bệnh nhân
    const fullName = item.BenhNhan_HoTen || '';
    const nameParts = fullName.trim().split(' ');
    const firstName = nameParts.length > 0 ? nameParts[0] : '';
    const lastName = nameParts.length > 1 ? nameParts.slice(1).join(' ') : '';

    // Xử lý tên bác sĩ
    const doctorFullName = item.BacSi_HoTen || '';
    const doctorNameParts = doctorFullName.trim().split(' ');
    const doctorFirstName = doctorNameParts.length > 0 ? doctorNameParts[0] : '';
    const doctorLastName = doctorNameParts.length > 1 ? doctorNameParts.slice(1).join(' ') : '';

    return {
      _id: item.idDonThuoc,
      prescriptionCode: item.idDonThuoc,
      createdDate: item.NgayLap ? item.NgayLap.toISOString().split('T')[0] : null,
      patient: {
        _id: item.idBenhNhan,
        firstName: firstName,
        lastName: lastName,
        phone: item.BenhNhan_SDT ? item.BenhNhan_SDT.toString() : '',
        address: item.BenhNhan_DiaChi || '',
        insuranceNumber: item.SoBHYT || ''
      },
      doctor: {
        _id: item.BacSi_Id,
        firstName: doctorFirstName,
        lastName: doctorLastName,
        department: item.BacSi_ChucVu || ''
      },
      diagnosis: item.ChanDoan || '',
      totalAmount: parseFloat(item.TotalAmount) || 0,
      insuranceAmount: parseFloat(item.InsuranceAmount) || 0,
      finalAmount: parseFloat(item.FinalAmount) || 0,
      hasInsurance: Boolean(item.HasInsurance),
      notes: item.GhiChu || '',
      status: item.TrangThai || ''
    };
  });
};

// Lấy danh sách đơn thuốc với tìm kiếm
const timKiemDonThuoc = async (req, res) => {
  try {
    const { TuNgay, DenNgay, TrangThai, Keyword } = req.query;
    console.log(req.query);

    // Parse date strings thành Date objects hoặc null
    const parsedTuNgay = TuNgay ? new Date(TuNgay) : null;
    const parsedDenNgay = DenNgay ? new Date(DenNgay) : null;

    const result = await prisma.$queryRaw`
      EXEC sp_LayDanhSachDonThuocChiTiet 
        @TuNgay = ${parsedTuNgay},
        @DenNgay = ${parsedDenNgay},
        @TrangThai = ${TrangThai || null},
        @Keyword = ${Keyword || null}
    `;
    
    const formattedData = formatPrescriptionData(result);
    
    res.json({
      success: true,
      data: formattedData
    });
  } catch (error) {
    console.error('Error in timKiemDonThuoc:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi tìm kiếm đơn thuốc',
      error: error.message
    });
  }
};

// Lấy tất cả đơn thuốc
// Revert về bản gốc trong controller
const layTatCaDonThuoc = async (req, res) => {
  try {
    const result = await prisma.$queryRaw`
      EXEC sp_LayDanhSachDonThuocChiTiet 
        @TuNgay = NULL,
        @DenNgay = NULL,
        @TrangThai = NULL,
        @Keyword = NULL
    `;
    
    const formattedData = formatPrescriptionData(result);
    
    res.json({
      success: true,
      data: formattedData
    });
  } catch (error) {
    console.error('Error in layTatCaDonThuoc:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy danh sách đơn thuốc',
      error: error.message
    });
  }
};

// Lấy đơn thuốc theo ID với chi tiết đầy đủ
const layDonThuocTheoID = async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await prisma.$queryRaw`
      EXEC sp_LayChiTietDonThuocDay @idDonThuoc = ${id}
    `;
    
    if (!result || result.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy đơn thuốc'
      });
    }

    // Lấy thông tin đơn thuốc (result đầu tiên)
    const prescriptionInfo = Array.isArray(result[0]) ? result[0][0] : result[0];
    
    if (!prescriptionInfo) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy thông tin đơn thuốc'
      });
    }

    // Lấy danh sách thuốc
    const medicationsResult = await prisma.$queryRaw`
      EXEC sp_LayChiTietDonThuoc @idDonThuoc = ${id}
    `;

    // Xử lý tên bệnh nhân
    const patientFullName = prescriptionInfo.BenhNhan_HoTen || '';
    const patientNameParts = patientFullName.trim().split(' ');
    const patientFirstName = patientNameParts.length > 0 ? patientNameParts[0] : '';
    const patientLastName = patientNameParts.length > 1 ? patientNameParts.slice(1).join(' ') : '';

    // Xử lý tên bác sĩ
    const doctorFullName = prescriptionInfo.BacSi_HoTen || '';
    const doctorNameParts = doctorFullName.trim().split(' ');
    const doctorFirstName = doctorNameParts.length > 0 ? doctorNameParts[0] : '';
    const doctorLastName = doctorNameParts.length > 1 ? doctorNameParts.slice(1).join(' ') : '';

    const formattedPrescription = {
      _id: prescriptionInfo.idDonThuoc,
      prescriptionCode: prescriptionInfo.idDonThuoc,
      createdDate: prescriptionInfo.NgayLap ? prescriptionInfo.NgayLap.toISOString().split('T')[0] : null,
      patient: {
        _id: prescriptionInfo.idBenhNhan,
        firstName: patientFirstName,
        lastName: patientLastName,
        phone: prescriptionInfo.BenhNhan_SDT ? prescriptionInfo.BenhNhan_SDT.toString() : '',
        address: prescriptionInfo.BenhNhan_DiaChi || '',
        insuranceNumber: prescriptionInfo.SoBHYT || ''
      },
      doctor: {
        _id: prescriptionInfo.BacSi_Id,
        firstName: doctorFirstName,
        lastName: doctorLastName,
        department: prescriptionInfo.BacSi_ChucVu || ''
      },
      diagnosis: prescriptionInfo.ChanDoan || '',
      hasInsurance: Boolean(prescriptionInfo.HasInsurance),
      notes: prescriptionInfo.GhiChu || '',
      status: prescriptionInfo.TrangThai || '',
      medications: medicationsResult.map(med => ({
        code: med.code,
        name: med.name,
        quantity: med.quantity,
        expiryDate: med.expiryDate ? med.expiryDate.toISOString().split('T')[0] : '',
        dosage: med.dosage || '',
        unitPrice: parseFloat(med.unitPrice) || 0,
        totalPrice: parseFloat(med.totalPrice) || 0
      }))
    };

    // Tính toán tổng tiền
    const totalAmount = formattedPrescription.medications.reduce((sum, med) => sum + med.totalPrice, 0);
    const insuranceAmount = formattedPrescription.hasInsurance ? totalAmount * 0.8 : 0;
    const finalAmount = totalAmount - insuranceAmount;

    formattedPrescription.totalAmount = totalAmount;
    formattedPrescription.insuranceAmount = insuranceAmount;
    formattedPrescription.finalAmount = finalAmount;
    
    res.json({
      success: true,
      data: formattedPrescription
    });
  } catch (error) {
    console.error('Error in layDonThuocTheoID:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy thông tin đơn thuốc',
      error: error.message
    });
  }
};

// Thêm đơn thuốc mới (cải tiến)
const themDonThuoc = async (req, res) => {
  try {
    const { 
      patientId, 
      doctorId, 
      diagnosis, 
      notes, 
      medications = [] 
    } = req.body;

    // Validate required fields
    if (!patientId || !doctorId || !diagnosis) {
      return res.status(400).json({
        success: false,
        message: 'Thiếu thông tin bắt buộc: bệnh nhân, bác sĩ, hoặc chẩn đoán'
      });
    }

    // Format medications for stored procedure
    const medicationsJson = JSON.stringify(medications.map(med => ({
      idDuocPham: med.code,
      SoLuong: med.quantity,
      LieuDung: med.dosage,
      DuongDung: med.duongDung || 'Uống'
    })));

    const result = await prisma.$executeRaw`
      DECLARE @idDonThuocMoi CHAR(10);
      EXEC sp_TaoDonThuocMoi 
        @idBenhNhan = ${patientId},
        @idBacSi = ${doctorId},
        @ChanDoan = ${diagnosis},
        @GhiChu = ${notes || null},
        @DanhSachThuoc = ${medicationsJson},
        @idDonThuocMoi = @idDonThuocMoi OUTPUT;
      SELECT @idDonThuocMoi as idDonThuocMoi;
    `;

    res.status(201).json({
      success: true,
      message: 'Tạo đơn thuốc thành công',
      data: { idDonThuoc: result }
    });
  } catch (error) {
    console.error('Error in themDonThuoc:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi tạo đơn thuốc',
      error: error.message
    });
  }
};

// Sửa đơn thuốc (cải tiến)
const suaDonThuoc = async (req, res) => {
  try {
    const { id } = req.params;
    const { 
      diagnosis, 
      notes, 
      medications = [] 
    } = req.body;

    // Format medications for stored procedure
    const medicationsJson = medications.length > 0 ? JSON.stringify(medications.map(med => ({
      idDuocPham: med.code,
      SoLuong: med.quantity,
      LieuDung: med.dosage,
      DuongDung: med.duongDung || 'Uống'
    }))) : null;

    await prisma.$executeRaw`
      EXEC sp_CapNhatDonThuoc 
        @idDonThuoc = ${id},
        @ChanDoan = ${diagnosis || null},
        @GhiChu = ${notes || null},
        @DanhSachThuoc = ${medicationsJson}
    `;

    res.json({
      success: true,
      message: 'Cập nhật đơn thuốc thành công'
    });
  } catch (error) {
    console.error('Error in suaDonThuoc:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi cập nhật đơn thuốc',
      error: error.message
    });
  }
};

// Xóa đơn thuốc
const xoaDonThuoc = async (req, res) => {
  try {
    const { id } = req.params;

    await prisma.$executeRaw`
      EXEC sp_XoaCungDonThuoc @idDonThuoc = ${id}
    `;

    res.json({
      success: true,
      message: 'Xóa đơn thuốc thành công'
    });
  } catch (error) {
    console.error('Error in xoaDonThuoc:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi xóa đơn thuốc',
      error: error.message
    });
  }
};

// Xác nhận thanh toán đơn thuốc
const xacNhanThanhToanDonThuoc = async (req, res) => {
  try {
    const { id } = req.params;

    await prisma.$executeRaw`
      EXEC sp_XacNhanThanhToanDonThuoc @idDonThuoc = ${id}
    `;

    res.json({
      success: true,
      message: 'Xác nhận thanh toán thành công'
    });
  } catch (error) {
    console.error('Error in xacNhanThanhToanDonThuoc:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi xác nhận thanh toán',
      error: error.message
    });
  }
};

// Lấy chi tiết đơn thuốc (danh sách thuốc)
const layChiTietDonThuoc = async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await prisma.$queryRaw`
      EXEC sp_LayChiTietDonThuoc @idDonThuoc = ${id}
    `;
    
    const formattedMedications = result.map(med => ({
      code: med.code,
      name: med.name,
      quantity: med.quantity,
      expiryDate: med.expiryDate ? med.expiryDate.toISOString().split('T')[0] : '',
      dosage: med.dosage || '',
      unitPrice: parseFloat(med.unitPrice) || 0,
      totalPrice: parseFloat(med.totalPrice) || 0
    }));
    
    res.json({
      success: true,
      data: formattedMedications
    });
  } catch (error) {
    console.error('Error in layChiTietDonThuoc:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy chi tiết đơn thuốc',
      error: error.message
    });
  }
};

// Thêm chi tiết đơn thuốc
const themChiTietDonThuoc = async (req, res) => {
  try {
    const { idDonThuoc, idDuocPham, SoLuong, LieuDung, DuongDung, GhiChu } = req.body;

    await prisma.$executeRaw`
      EXEC sp_ThemChiTietDonThuoc 
        @idDonThuoc = ${idDonThuoc},
        @idDuocPham = ${idDuocPham},
        @SoLuong = ${SoLuong},
        @LieuDung = ${LieuDung},
        @DuongDung = ${DuongDung},
        @GhiChu = ${GhiChu}
    `;

    res.status(201).json({
      success: true,
      message: 'Thêm dược phẩm vào đơn thuốc thành công'
    });
  } catch (error) {
    console.error('Error in themChiTietDonThuoc:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi thêm dược phẩm vào đơn thuốc',
      error: error.message
    });
  }
};

// Lấy danh sách bác sĩ
const layDanhSachBacSi = async (req, res) => {
  try {
    const result = await prisma.$queryRaw`EXEC sp_LayDanhSachBacSi`;
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layDanhSachBacSi:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy danh sách bác sĩ',
      error: error.message
    });
  }
};

// Lấy danh sách bệnh nhân
const layDanhSachBenhNhan = async (req, res) => {
  try {
    const result = await prisma.$queryRaw`EXEC sp_LayDanhSachBenhNhan`;
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layDanhSachBenhNhan:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy danh sách bệnh nhân',
      error: error.message
    });
  }
};

// Kiểm tra tồn kho thuốc
const kiemTraTonKhoThuoc = async (req, res) => {
  try {
    const { medications } = req.body;

    if (!medications || medications.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Danh sách thuốc không được để trống'
      });
    }

    const medicationsJson = JSON.stringify(medications.map(med => ({
      idDuocPham: med.code,
      SoLuong: med.quantity
    })));

    const result = await prisma.$queryRaw`
      EXEC sp_KiemTraTonKhoThuoc @DanhSachThuoc = ${medicationsJson}
    `;

    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in kiemTraTonKhoThuoc:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi kiểm tra tồn kho thuốc',
      error: error.message
    });
  }
};

// Thống kê đơn thuốc
const thongKeDonThuoc = async (req, res) => {
  try {
    const { TuNgay, DenNgay } = req.query;

    const result = await prisma.$queryRaw`
      EXEC sp_ThongKeDonThuoc 
        @TuNgay = ${TuNgay || null},
        @DenNgay = ${DenNgay || null}
    `;

    res.json({
      success: true,
      data: result[0] || {}
    });
  } catch (error) {
    console.error('Error in thongKeDonThuoc:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy thống kê đơn thuốc',
      error: error.message
    });
  }
};

// Top thuốc được kê nhiều nhất
const topThuocDuocKe = async (req, res) => {
  try {
    const { Top = 10, TuNgay, DenNgay } = req.query;

    const result = await prisma.$queryRaw`
      EXEC sp_TopThuocDuocKe 
        @Top = ${parseInt(Top)},
        @TuNgay = ${TuNgay || null},
        @DenNgay = ${DenNgay || null}
    `;

    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in topThuocDuocKe:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy top thuốc được kê',
      error: error.message
    });
  }
};

module.exports = {
  timKiemDonThuoc,
  layTatCaDonThuoc,
  layDonThuocTheoID,
  themDonThuoc,
  suaDonThuoc,
  xoaDonThuoc,
  xacNhanThanhToanDonThuoc,
  layChiTietDonThuoc,
  themChiTietDonThuoc,
  layDanhSachBacSi,
  layDanhSachBenhNhan,
  kiemTraTonKhoThuoc,
  thongKeDonThuoc,
  topThuocDuocKe
};
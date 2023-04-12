go
--Lab 7:
--Câu 1:
CREATE PROCEDURE sp_NhapHangsx
    @mahangsx nvarchar(10),
    @tenhang nvarchar(20),
    @diachi nvarchar(30),
    @sodt nvarchar(20),
    @email nvarchar(30)
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra trùng lặp trường tenhang
    IF EXISTS (SELECT * FROM Hangsx WHERE tenhang = @tenhang)
    BEGIN
        RAISERROR('Tên hãng đã tồn tại, vui lòng nhập tên hãng khác!', 16, 1);
        RETURN;
    END

    -- Thêm dữ liệu mới vào bảng
    INSERT INTO Hangsx (mahangsx, tenhang, diachi, sodt, email)
    VALUES (@mahangsx, @tenhang, @diachi, @sodt, @email);

    PRINT 'Thêm dữ liệu thành công!';
END
go
EXEC sp_NhapHangsx 'H01', 'Samsung', 'Korea', '0123456789', 'hsx1@gmail.com';
go
--Câu 2:
CREATE PROCEDURE sp_NhapSanPham 
    @masp nchar(10),
    @mahangsx nchar(10),
    @tensp nvarchar(20),
    @soluong int,
    @mausac nvarchar(20),
    @giaban money,
    @donvitinh nchar(10),
    @mota nvarchar(MAX)
AS
BEGIN
    IF EXISTS(SELECT * FROM sanpham WHERE masp = @masp)
    BEGIN
        UPDATE sanpham
        SET mahangsx = @mahangsx,
            tensp = @tensp,
            soluong = @soluong,
            mausac = @mausac,
            giaban = @giaban,
            donvitinh = @donvitinh,
            mota = @mota
        WHERE masp = @masp
    END
    ELSE
    BEGIN
        INSERT INTO sanpham (masp, mahangsx, tensp, soluong, mausac, giaban, donvitinh, mota)
        VALUES (@masp, @mahangsx, @tensp, @soluong, @mausac, @giaban, @donvitinh, @mota)
    END
END

go
--Câu 3:
CREATE PROCEDURE sp_XoaHangSX
	@ten nvarchar(20)
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM Hangsx WHERE tenhang = @ten)
	BEGIN
		PRINT 'Tên hãng không tồn tại!'
	END
	ELSE
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			DECLARE @mahangsx nvarchar(10)
			SELECT @mahangsx = mahangsx FROM Hangsx WHERE tenhang = @ten

			-- Xóa sản phẩm của hãng này
			DELETE FROM Sanpham WHERE mahangsx = @mahangsx

			-- Xóa hãng
			DELETE FROM Hangsx WHERE tenhang = @ten

			COMMIT TRANSACTION
			PRINT 'Xóa dữ liệu thành công!'
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			PRINT 'Xóa dữ liệu thất bại!'
		END CATCH
	END
END
go
--Câu 4:
CREATE PROCEDURE sp_NhapNhanVien
    @manv nvarchar(10),
    @tennv nvarchar(50),
    @gioitinh nvarchar(3),
    @diachi nvarchar(100),
    @sodt nvarchar(20),
    @email nvarchar(50),
    @phong nvarchar(50),
    @flag bit
AS
BEGIN
    IF @flag = 0 -- Cập nhật nhân viên đã có
    BEGIN
        UPDATE NhanVien
        SET Tennv = @tennv,
            Gioitinh = @gioitinh,
            Diachi = @diachi,
            Sodt = @sodt,
            Email = @email,
            Phong = @phong
        WHERE Manv = @manv;
        
        IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'Không tìm thấy nhân viên với mã ' + @manv;
        END
        ELSE
        BEGIN
            PRINT 'Cập nhật thông tin nhân viên thành công!';
        END
    END
    ELSE -- Thêm mới nhân viên
    BEGIN
        IF EXISTS (SELECT * FROM NhanVien WHERE Manv = @manv)
        BEGIN
            PRINT 'Mã nhân viên đã tồn tại, không thể thêm mới!';
        END
        ELSE
        BEGIN
            INSERT INTO NhanVien (Manv, Tennv, Gioitinh, Diachi, Sodt, Email, Phong)
            VALUES (@manv, @tennv, @gioitinh, @diachi, @sodt, @email, @phong);
            PRINT 'Thêm mới nhân viên thành công!';
        END
    END
END
go
--Câu 5:
CREATE PROCEDURE sp_NhapHangNhap
    @sohdn nvarchar(10),
    @masp nchar(10),
    @manv nvarchar(10),
    @ngaynhap datetime,
    @soluongN int,
    @dongiaN money
AS
BEGIN
    -- Kiểm tra masp có tồn tại trong bảng Sanpham hay không?
    IF NOT EXISTS(SELECT * FROM Sanpham WHERE masp = @masp)
    BEGIN
        PRINT 'Mã sản phẩm không tồn tại trong bảng Sanpham'
        RETURN
    END

    -- Kiểm tra manv có tồn tại trong bảng Nhanvien hay không?
    IF NOT EXISTS(SELECT * FROM Nhanvien WHERE manv = @manv)
    BEGIN
        PRINT 'Mã nhân viên không tồn tại trong bảng Nhanvien'
        RETURN
    END

    -- Kiểm tra số lượng nhập có lớn hơn 0 hay không?
    IF @soluongN <= 0
    BEGIN
        PRINT 'Số lượng nhập không hợp lệ'
        RETURN
    END

    -- Kiểm tra đơn giá nhập có lớn hơn 0 hay không?
    IF @dongiaN <= 0
    BEGIN
        PRINT 'Đơn giá nhập không hợp lệ'
        RETURN
    END

    -- Kiểm tra sohdn đã tồn tại trong bảng Nhap hay chưa?
    IF EXISTS(SELECT * FROM Nhap WHERE sohdn = @sohdn)
    BEGIN
        -- Cập nhật bảng Nhap
        UPDATE Nhap
        SET masp = @masp,
            manv = @manv,
            ngaynhap = @ngaynhap,
            soluongN = @soluongN,
            dongiaN = @dongiaN
        WHERE sohdn = @sohdn
    END
    ELSE
    BEGIN
        -- Thêm mới bảng Nhap
        INSERT INTO Nhap(sohdn, masp, manv, ngaynhap, soluongN, dongiaN)
        VALUES(@sohdn, @masp, @manv, @ngaynhap, @soluongN, @dongiaN)
    END
END
go
--Câu 6:
CREATE PROCEDURE sp_NhapXuat
(
    @sohdx nvarchar(10),
    @masp nvarchar(10),
    @manv nvarchar(10),
    @ngayxuat datetime,
    @soluongX int
)
AS
BEGIN
    -- Kiểm tra sản phẩm có tồn tại trong bảng Sanpham hay không?
    IF NOT EXISTS (SELECT * FROM Sanpham WHERE masp = @masp)
    BEGIN
        PRINT 'Sản phẩm không tồn tại trong bảng Sanpham!'
        RETURN
    END

    -- Kiểm tra nhân viên có tồn tại trong bảng Nhanvien hay không?
    IF NOT EXISTS (SELECT * FROM Nhanvien WHERE manv = @manv)
    BEGIN
        PRINT 'Nhân viên không tồn tại trong bảng Nhanvien!'
        RETURN
    END

    -- Kiểm tra số lượng xuất có nhỏ hơn hoặc bằng số lượng tồn kho hay không?
    DECLARE @soluongton int
    SELECT @soluongton = soluong FROM Sanpham WHERE masp = @masp

    IF @soluongX > @soluongton
    BEGIN
        PRINT 'Số lượng xuất vượt quá số lượng tồn kho!'
        RETURN
    END

    -- Kiểm tra số hóa đơn xuất đã tồn tại hay chưa?
    IF EXISTS (SELECT * FROM Xuat WHERE sohdx = @sohdx)
    BEGIN
        -- Cập nhật thông tin hóa đơn xuất
        UPDATE Xuat
        SET masp = @masp,
            manv = @manv,
            ngayxuat = @ngayxuat,
            soluongX = @soluongX
        WHERE sohdx = @sohdx
    END
    ELSE
    BEGIN
        -- Thêm mới thông tin hóa đơn xuất
        INSERT INTO Xuat(sodh, masp, manv, ngayxuat, soluongX)
        VALUES (@sohdx, @masp, @manv, @ngayxuat, @soluongX)
    END

    -- Cập nhật số lượng sản phẩm trong bảng Sanpham
    UPDATE Sanpham
    SET soluong = soluong - @soluongX
    WHERE masp = @masp
END
go
--Câu 7:
CREATE PROCEDURE sp_XoaNhanVien
	@manv nvarchar(10)
AS
BEGIN
	-- kiểm tra xem manv đã tồn tại hay chưa
	IF NOT EXISTS (SELECT * FROM Nhanvien WHERE manv = @manv)
	BEGIN
		PRINT N'Mã nhân viên ' + @manv + N' không tồn tại.'
		RETURN
	END
	
	BEGIN TRANSACTION
	BEGIN TRY
		-- xóa các bản ghi liên quan trong bảng Nhap
		DELETE FROM Nhap WHERE manv = @manv
		
		-- xóa các bản ghi liên quan trong bảng Xuat
		DELETE FROM Xuat WHERE manv = @manv
		
		-- xóa bản ghi trong bảng Nhanvien
		DELETE FROM Nhanvien WHERE manv = @manv
		
		COMMIT TRANSACTION
		PRINT N'Đã xóa nhân viên có mã ' + @manv + N' và các bản ghi liên quan trong bảng Nhap và Xuat.'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT N'Xóa dữ liệu thất bại. Vui lòng kiểm tra lại.'
	END CATCH
END
go
EXEC sp_XoaNhanVien'NV01' 

--Câu 8:
CREATE PROCEDURE sp_XoaSanPham
    @masp nchar(10)
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM Sanpham WHERE masp = @masp)
        PRINT 'Không tìm thấy sản phẩm để xóa'
    ELSE
    BEGIN
        BEGIN TRANSACTION
        
        DELETE FROM Xuat WHERE masp = @masp
        DELETE FROM Nhap WHERE masp = @masp
        DELETE FROM Sanpham WHERE masp = @masp
        
        COMMIT TRANSACTION
        
        PRINT 'Đã xóa sản phẩm ' + @masp
    END
END
go
EXEC sp_XoaSanPham N'SP05' 

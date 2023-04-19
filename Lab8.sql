--1. Viết thủ tục thêm mới nhân viên bao gồm các tham số: manv, tennv, gioitinh, diachi, sodt, email, phong và 1 biến Flag, 
--Nếu Flag=0 thì nhập mới, ngược lại thì cập nhật thông tin nhân viên theo mã. Hãy kiểm tra:
--- gioitinh nhập vào có phải là Nam hoặc Nữ không, nếu không trả về mã lỗi 1. - Ngược lại nếu thỏa mãn thì cho phép nhập và trả về mã lỗi ..
CREATE PROCEDURE ThemMoiNhanVien
(
    @manv NVARCHAR(10),
    @tennv NVARCHAR(50),
    @gioitinh NVARCHAR(3),
    @diachi NVARCHAR(100),
    @sodt NVARCHAR(15),
    @email NVARCHAR(50),
    @phong NVARCHAR(50),
    @flag INT
)
AS
BEGIN
    IF @flag = 0 -- Thêm mới
    BEGIN
        IF @gioitinh NOT IN ('Nam', 'Nữ')
        BEGIN
            RETURN 1; -- Mã lỗi 1: Giới tính không hợp lệ
        END
        INSERT INTO NhanVien (MaNV, TenNV, GioiTinh, DiaChi, SoDT, Email, Phong) 
        VALUES (@manv, @tennv, @gioitinh, @diachi, @sodt, @email, @phong);
        RETURN 0; -- Thêm mới thành công
    END
    ELSE -- Cập nhật
    BEGIN
        IF @gioitinh NOT IN ('Nam', 'Nữ')
        BEGIN
            RETURN 1; -- Mã lỗi 1: Giới tính không hợp lệ
        END
        UPDATE NhanVien SET TenNV = @tennv, GioiTinh = @gioitinh, DiaChi = @diachi, SoDT = @sodt, Email = @email, 
        Phong = @phong WHERE MaNV = @manv;
        RETURN 0; -- Cập nhật thành công
    END
END

--2. Viết thủ tục thêm mới sản phẩm với các tham biến masp, tenhang, tensp, soluong, mausac, giaban, donvitinh, mota và 1 biến Flag.
--Nếu Flag=0 thì thêm mới sản phẩm, ngược lại cập nhật sản phẩm. Hãy kiểm tra:
--- Nếu tenhang không có trong bảng hangsx thì trả về mã lỗi 1 - Nếu soluong <0 thì trả về mã lỗi 2
--- Ngược lại trả về mã lỗi 0.
go
CREATE PROCEDURE usp_InsertOrUpdateProduct
    @masp nchar(10),
    @tenhang nvarchar(20),
    @tensp nvarchar(20),
    @soluong int,
    @mausac nvarchar(20),
    @giaban money,
    @donvitinh nchar(10),
    @mota nvarchar(max),
    @Flag bit
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mahangsx nchar(10), @tenhangsx nvarchar(20)

    -- Kiểm tra tên hãng sản xuất có tồn tại trong bảng hangsx không
    SELECT @mahangsx = mahangsx, @tenhangsx = tenhang FROM hangsx WHERE tenhang = @tenhang

    IF @tenhangsx IS NULL
    BEGIN
        -- Trả về mã lỗi 1 nếu tên hãng sản xuất không tồn tại
        SELECT 1 AS ErrorCode
        RETURN
    END

    -- Kiểm tra số lượng sản phẩm
    IF @soluong < 0
    BEGIN
        -- Trả về mã lỗi 2 nếu số lượng sản phẩm nhỏ hơn 0
        SELECT 2 AS ErrorCode
        RETURN
    END

    -- Nếu Flag = 0, thực hiện thêm mới sản phẩm
    IF @Flag = 0
    BEGIN
        INSERT INTO Sanpham (masp, mahangsx, tensp, soluong, mausac, giaban, donvitinh, mota)
        VALUES (@masp, @mahangsx, @tensp, @soluong, @mausac, @giaban, @donvitinh, @mota)
    END
    ELSE
    BEGIN
        -- Nếu Flag = 1, thực hiện cập nhật sản phẩm
        UPDATE Sanpham
        SET mahangsx = @mahangsx, tensp = @tensp, soluong = @soluong, mausac = @mausac, giaban = @giaban, donvitinh = @donvitinh, mota = @mota
        WHERE masp = @masp
    END

    -- Trả về mã lỗi 0 nếu thêm mới/cập nhật sản phẩm thành công
    SELECT 0 AS ErrorCode
END

--3. Viết thủ tục xóa dữ liệu bảng nhanvien với tham biến là many. Nếu many chưa có thì trả về 1, 
--ngược lại xóa nhanvien với nhanvien bị xóa là many và trả về 0. (Lưu ý: xóa nhanvien thì phải xóa các bảng Nhap, Xuat mà nhân viên này tham gia).
go
CREATE PROCEDURE usp_DeleteNhanvien
    @many nchar(10)
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem nếu nhân viên chưa tồn tại thì trả về 1
    IF NOT EXISTS (SELECT * FROM Nhanvien WHERE manv = @many)
    BEGIN
        RETURN 1;
    END

    -- Xóa các bản ghi liên quan trong bảng Nhap và Xuat
    DELETE FROM Nhap WHERE manv = @many;
    DELETE FROM Xuat WHERE manv = @many;

    -- Xóa bản ghi trong bảng Nhanvien
    DELETE FROM Nhanvien WHERE manv = @many;

    -- Trả về 0 để báo hiệu đã xóa thành công
    RETURN 0;
END

--4. Viết thủ tục xóa dữ liệu bảng sanpham với tham biến là masp. Nếu masp chưa có thì trả về 1, 
--ngược lại xóa sanpham với sanpham bị xóa là masp và trả về 0. (Lưu ý: xóa sanpham thì phải xóa các bảng Nhap, Xuat mà sanpham này cung ứng).
go
CREATE PROCEDURE sp_delete_sanpham
    @masp nchar(10),
    @result int output
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra masp đã tồn tại trong bảng sanpham hay chưa
    IF NOT EXISTS (SELECT * FROM sanpham WHERE masp = @masp)
    BEGIN
        SET @result = 1;
        RETURN;
    END

    BEGIN TRANSACTION;

    -- Xóa các bản ghi trong bảng Nhap có masp trùng với @masp
    DELETE FROM Nhap WHERE masp = @masp;

    -- Xóa các bản ghi trong bảng Xuat có masp trùng với @masp
    DELETE FROM Xuat WHERE masp = @masp;

    -- Xóa bản ghi trong bảng Sanpham có masp = @masp
    DELETE FROM Sanpham WHERE masp = @masp;

    -- Nếu không có lỗi xảy ra, commit transaction và trả về kết quả 0
    SET @result = 0;
    COMMIT TRANSACTION;
END
go
DECLARE @result int;
EXEC sp_delete_sanpham 'SP001', @result OUTPUT;
PRINT @result;

--5. Tạo thủ tục nhập liệu cho bảng Hangsx, với các tham biến truyền vào mahangsx, tenhang, diachi, sodt, email. 
--Hãy kiểm tra xem tenhang đã tồn tại trước đó hay chưa, nếu rồi trả về mã lỗi 1? Nếu có rồi thì không cho nhập và trả về mã lỗi 0.
go
CREATE PROCEDURE InsertHangsx
    @mahangsx nchar(10),
    @tenhang nvarchar(20),
    @diachi nvarchar(30),
    @sodt nvarchar(20),
    @email nvarchar(30)
AS
BEGIN
    -- Kiểm tra xem tenhang đã tồn tại hay chưa
    IF EXISTS (SELECT 1 FROM Hangsx WHERE tenhang = @tenhang)
    BEGIN
        -- Trả về mã lỗi 1 nếu tenhang đã tồn tại
        SELECT 1 AS ErrorCode
        RETURN
    END

    -- Thêm bản ghi mới vào bảng Hangsx nếu tenhang chưa tồn tại
    INSERT INTO Hangsx (mahangsx, tenhang, diachi, sodt, email)
    VALUES (@mahangsx, @tenhang, @diachi, @sodt, @email)

    -- Trả về mã lỗi 0 để cho biết thêm bản ghi thành công
    SELECT 0 AS ErrorCode
END
go
--6. Viết thủ tục nhập dữ liệu cho bảng Nhap với các tham biến sohdn, masp, many, ngaynhap, soluongN, dongiaN. 
--Kiểm tra xem masp có tồn tại trong bảng Sanpham hay không, nếu không trả về 1? many có tồn tại trong bảng nhanvien hay không nếu không trả về 2? 
--ngược lại thì hãy kiểm tra: Nếu sohdn đã tồn tại thì cập nhật bảng Nhap theo sohdn, ngược lại thêm mới bảng Nhap và trả về mã lỗi 0.
CREATE PROCEDURE usp_InsertNhap
    @sohdn nchar(10),
    @masp nchar(10),
    @manv nchar(10),
    @ngaynhap datetime,
    @soluongN int,
    @dongiaN money,
    @error_code int OUTPUT
AS
BEGIN
    -- Kiểm tra sự tồn tại của masp trong bảng Sanpham
    IF NOT EXISTS (SELECT 1 FROM Sanpham WHERE masp = @masp)
    BEGIN
        SET @error_code = 1; -- Mã lỗi 1: masp không tồn tại trong bảng Sanpham
        RETURN;
    END
    
    -- Kiểm tra sự tồn tại của manv trong bảng Nhanvien
    IF NOT EXISTS (SELECT 1 FROM Nhanvien WHERE manv = @manv)
    BEGIN
        SET @error_code = 2; -- Mã lỗi 2: manv không tồn tại trong bảng Nhanvien
        RETURN;
    END
    
    -- Kiểm tra xem sohdn đã tồn tại trong bảng Nhap hay chưa
    IF EXISTS (SELECT 1 FROM Nhap WHERE sohdn = @sohdn)
    BEGIN
        -- Nếu đã tồn tại thì cập nhật bảng Nhap
        UPDATE Nhap 
        SET masp = @masp, manv = @manv, ngaynhap = @ngaynhap, soluongN = @soluongN, dongiaN = @dongiaN 
        WHERE sohdn = @sohdn;
    END
    ELSE
    BEGIN
        -- Nếu chưa tồn tại thì thêm mới bảng Nhap
        INSERT INTO Nhap (sohdn, masp, manv, ngaynhap, soluongN, dongiaN)
        VALUES (@sohdn, @masp, @manv, @ngaynhap, @soluongN, @dongiaN);
    END
    
    SET @error_code = 0; -- Mã lỗi 0: Thành công
END

--7. Viết thủ tục nhập dữ liệu cho bảng xuất với các tham biến sohdx, masp, many, ngayxuat, soluongX. 
--Kiểm tra xem masp có tồn tại trong bảng Sanpham hay không nếu không trả về 1? many có tồn tại trong bảng nhanvien hay không nếu không trả về 2? 
--soluongX<= Soluong nếu không trả về 3? ngược lại thì hãy kiểm tra: Nếu sohdx đã tồn tại thì cập nhật bảng Xuat theo sohdx, 
--ngược lại thêm mới bảng Xuat và trả về mã lỗi 0
go
CREATE PROCEDURE InsertXuatSP
    @sohdx nchar(10),
    @masp nchar(10),
    @manv nchar(10),
    @ngayxuat datetime,
    @soluongX int
AS
BEGIN
    -- Kiểm tra sự tồn tại của masp trong bảng Sanpham
    IF NOT EXISTS(SELECT masp FROM Sanpham WHERE masp = @masp)
        RETURN 1

    -- Kiểm tra sự tồn tại của many trong bảng Nhanvien
    IF NOT EXISTS(SELECT manv FROM Nhanvien WHERE manv = @manv)
        RETURN 2

    -- Kiểm tra số lượng xuất không vượt quá số lượng tồn kho Soluong
    DECLARE @Soluong int
    SELECT @Soluong = soluong FROM Sanpham WHERE masp = @masp
    IF @soluongX > @Soluong
        RETURN 3

    -- Thêm hoặc cập nhật dữ liệu vào bảng Xuất
    IF EXISTS(SELECT sohdx FROM Xuat WHERE sohdx = @sohdx)
    BEGIN
        UPDATE Xuat
        SET masp = @masp,
            manv = @manv,
            ngayxuat = @ngayxuat,
            soluongX = @soluongX
        WHERE sohdx = @sohdx
    END
    ELSE
    BEGIN
        INSERT INTO Xuat (sohdx, masp, manv, ngayxuat, soluongX)
        VALUES (@sohdx, @masp, @manv, @ngayxuat, @soluongX)
    END
    
    RETURN 0
END

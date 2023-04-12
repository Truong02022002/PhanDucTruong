go
--Lab 6:
--Câu 1:
create function fn_DSSPtheohangsx (@tenhang nvarchar(20))
returns @bang table(
					masp nvarchar(10), tensp nvarchar (20), 
					soluong int, mausac nvarchar(20),
					giaban float, donvitinh nvarchar(10), mota nvarchar (max)
					)
as
begin
	insert into @bang
		select masp, tensp, soluong, mausac, giaban, donvitinh, mota 
		from sanpham inner join hangsx
				on sanpham.mahangsx = hangsx.mahangsx
		where tenhang = @tenhang
	return
end
go 
SELECT * FROM fn_DSSPtheohangsx('Samsung')
go
--Câu 2:
create function fn_DSSPtheongaynhap (@x datetime, @y datetime)
returns @bang table(
					masp nvarchar(10), tensp nvarchar (20), soluong int, mausac nvarchar(20), 
					giaban float, donvitinh nvarchar(10), 
					mota nvarchar (max), tenhang nvarchar(20)
					)
as
begin
	insert into @bang
		SELECT sanpham.masp, sanpham.tensp, sanpham.soluong, sanpham.mausac, sanpham.giaban, sanpham.donvitinh, sanpham.mota, hangsx.tenhang
		FROM sanpham INNER JOIN hangsx ON sanpham.mahangsx = hangsx.mahangsx INNER JOIN nhap ON sanpham.masp = nhap.masp
		WHERE nhap.ngaynhap >= @x AND nhap.ngaynhap <= @y
	return
end
go
SELECT * FROM fn_DSSPtheongaynhap('2019-01-01', '2020-12-31')
go
--Câu 3:
CREATE FUNCTION fn_DSSPtheoHangSX_SoLuong(@tenhang nvarchar(20), @luachon bit)
RETURNS @bang TABLE(
    masp nvarchar(10), tensp nvarchar(20), soluong int, 
    mausac nvarchar(20), giaban float, donvitinh nvarchar(10), 
    mota nvarchar(max), tenhang nvarchar(20)
)
AS
BEGIN
    IF (@luachon = 0)
        INSERT INTO @bang
        SELECT sp.masp, sp.tensp, sp.soluong, sp.mausac, sp.giaban, sp.donvitinh, sp.mota, hsx.tenhang
        FROM sanpham sp
        INNER JOIN hangsx hsx ON sp.mahangsx = hsx.mahangsx
        WHERE hsx.tenhang = @tenhang AND sp.soluong = 0;
    ELSE
        INSERT INTO @bang
        SELECT sp.masp, sp.tensp, sp.soluong, sp.mausac, sp.giaban, sp.donvitinh, sp.mota, hsx.tenhang
        FROM sanpham sp
        INNER JOIN hangsx hsx ON sp.mahangsx = hsx.mahangsx
        WHERE hsx.tenhang = @tenhang AND sp.soluong > 0;
    RETURN
END
go
SELECT * FROM fn_DSSPtheoHangSX_SoLuong('OPPO', 0)
SELECT * FROM fn_DSSPtheoHangSX_SoLuong('OPPO', 1)
go
--Câu 4:
CREATE FUNCTION fn_DSNVtheoPhong(@tenphong nvarchar(30))
RETURNS @bang TABLE(
    manv nchar(10), 
    tennv nvarchar(20), 
    gioitinh nchar(10), 
    diachi nvarchar(30),
    sodt nvarchar(20), 
    email nvarchar(30), 
    phong nvarchar(30)
)
AS
BEGIN
    INSERT INTO @bang
    SELECT manv, tennv, gioitinh, diachi, sodt, email, phong
    FROM nhanvien
    WHERE phong = @tenphong;
    RETURN
END
go
Select * from fn_DSNVtheoPhong(N'Kế toán')
go 
--Câu 5:
CREATE FUNCTION fn_DSHangSXtheoDiaChi(@diachi nvarchar(30))
RETURNS @bang TABLE(
    mahangsx nchar(10), 
    tenhang nvarchar(20), 
    diachi nvarchar(30),
    sodt nvarchar(20), 
    email nvarchar(30)
)
AS
BEGIN
    INSERT INTO @bang
    SELECT mahangsx, tenhang, diachi, sodt, email
    FROM hangsx
    WHERE diachi LIKE '%' + @diachi + '%';
    RETURN
END
go
SELECT * FROM fn_DSHangSXtheoDiaChi(N'Việt Nam')
go
--Câu 6:
CREATE FUNCTION fn_DSSPtheoHangSXVaLuaChon (@tenhang nvarchar(20), @luaChon bit)
RETURNS @bang TABLE(
    masp nvarchar(10), tensp nvarchar(20), soluong int, 
    mausac nvarchar(20), giaban float, donvitinh nvarchar(10), mota nvarchar(max)
)
AS
BEGIN
    IF @luaChon = 0
    BEGIN
        INSERT INTO @bang
        SELECT sanpham.masp, sanpham.tensp, nhap.soluongN, sanpham.mausac, sanpham.giaban, sanpham.donvitinh, sanpham.mota
        FROM sanpham
        INNER JOIN hangsx ON sanpham.mahangsx = hangsx.mahangsx INNER JOIN nhap ON sanpham.masp = nhap.masp
        WHERE hangsx.tenhang = @tenhang;
    END
    ELSE
    BEGIN
        INSERT INTO @bang
        SELECT sanpham.masp, sanpham.tensp, xuat.soluongX, sanpham.mausac, sanpham.giaban, sanpham.donvitinh, sanpham.mota
        FROM sanpham
        INNER JOIN hangsx ON sanpham.mahangsx = hangsx.mahangsx INNER JOIN xuat ON sanpham.masp = xuat.masp
        WHERE hangsx.tenhang = @tenhang;
    END
    RETURN
END
go
SELECT * FROM fn_DSSPtheoHangSXVaLuaChon('Samsung', 0)
SELECT * FROM fn_DSSPtheoHangSXVaLuaChon('OPPO', 1)
go
--Câu 7:
CREATE FUNCTION fn_DSPXtheohangsx(@x INT, @y INT)
RETURNS @bang TABLE (
    masp NVARCHAR(10), mahangsx NVARCHAR(10), tensp NVARCHAR(20), 
    soluong INT, mausac NVARCHAR(20), giaban FLOAT, donvitinh NVARCHAR(10), 
    mota NVARCHAR(MAX), ngayxuat DATE, tenhang NVARCHAR(20), 
    diachi NVARCHAR(30), sodt NVARCHAR(20), email NVARCHAR(30)
)
AS
BEGIN
    INSERT INTO @bang
        SELECT sp.masp, sp.mahangsx, sp.tensp, sp.soluong, sp.mausac, sp.giaban, sp.donvitinh, sp.mota, 
               xuat.ngayxuat, hsx.tenhang, hsx.diachi, hsx.sodt, hsx.email
        FROM sanpham sp
        INNER JOIN xuat ON sp.masp = xuat.masp
        INNER JOIN hangsx hsx ON sp.mahangsx = hsx.mahangsx
        WHERE YEAR(xuat.ngayxuat) BETWEEN @x AND @y

    RETURN
END

go
SELECT * FROM fn_DSPXtheohangsx(2019, 2020)
go
--Câu 8:
CREATE FUNCTION fn_DSNhanvienNhapHang (@ngayNhap date)
RETURNS @bang TABLE (
    manv nchar(10),
    tennv nvarchar(20),
    gioitinh nchar(10),
    diachi nvarchar(30),
    sodt nvarchar(20),
    email nvarchar(30),
    phong nvarchar(30)
)
AS 
BEGIN
    INSERT INTO @bang
    SELECT nv.manv, nv.tennv, nv.gioitinh, nv.diachi, nv.sodt, nv.email, nv.phong
    FROM Nhap n JOIN Nhanvien nv ON n.manv = nv.manv
    WHERE n.ngaynhap = @ngayNhap
    GROUP BY nv.manv, nv.tennv, nv.gioitinh, nv.diachi, nv.sodt, nv.email, nv.phong
    RETURN
END
go
SELECT * FROM fn_DSNhanvienNhapHang('2020-03-22')
go
--Câu 9:
CREATE FUNCTION fn_DSsanphamTheoGiaHangsx (
    @x FLOAT,@y FLOAT,@tenhang nvarchar(20)
)
RETURNS @bang table(
    masp nvarchar(10),
    tensp nvarchar(20),
    soluong int,
    mausac nvarchar(20),
    giaban float,
    donvitinh nvarchar(10),
    mota nvarchar(max),
    tenhang nvarchar(20)
)
AS
BEGIN
    INSERT INTO @bang
        SELECT s.masp, s.tensp, s.soluong, s.mausac, s.giaban, s.donvitinh, s.mota, h.tenhang
        FROM sanpham s
        INNER JOIN hangsx h ON s.mahangsx = h.mahangsx
        WHERE s.giaban >= @x AND s.giaban <= @y AND h.tenhang = @tenhang 
    RETURN
END
go
SELECT * FROM fn_DSsanphamTheoGiaHangsx(1500000, 8000000, 'OPPO')
go
--Câu 10:
CREATE FUNCTION fn_ProductAndManufacturerList()
RETURNS TABLE
AS
RETURN
(
	SELECT sanpham.masp, hangsx.mahangsx, hangsx.tenhang, sanpham.tensp, sanpham.soluong, sanpham.mausac, sanpham.giaban, sanpham.donvitinh, sanpham.mota
	FROM sanpham
	INNER JOIN hangsx
	ON sanpham.mahangsx = hangsx.mahangsx
);
go
SELECT * FROM fn_ProductAndManufacturerList()

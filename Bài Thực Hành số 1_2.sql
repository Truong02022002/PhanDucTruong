--Câu 1:Hiển thị thông tin các bảng dữ liệu trên
/*select * from Hangsx;
select * from Nhanvien;
select * from Nhap;
select * from Xuat;
select * from Sanpham;*/
--Câu 2:Đưa ra thông tin masp, tensp, tenhang, soluong, mausac, giaban, donvitinh, mota của các sản phẩm sắp xếp theo chiều giảm dần giá bán
--SELECT * FROM sanpham ORDER BY giaban ASC;
--Câu 3:Đưa ra thông tin các sản phẩm có trong cửa hàng do công ty có tên hãng là samsung sản xuất
/*SELECT * FROM sanpham sp JOIN HangSX hsx ON sp.mahangsx = hsx.mahangsx
WHERE tenhang = 'Samsung';*/
--Câu 4:Đưa ra thông tin các nhân viên Nữ ở phòng 'Kế toán'
--SELECT * FROM Nhanvien WHERE gioitinh like N'Nữ' AND phong like N'Kế toán';
--Câu 5:Đưa ra thông tin phiếu nhập gồm: sohdn, masp, tensp, tenhang, soluongN, dongiaN, tiennhap = soluongN*dongiaN, mausac, donvitinh, ngaynhap, tennv, phong. Sắp xếp theo chiều tăng dần của hóa đơn nhập.
/*
SELECT n.sohdn, n.masp, sp.tensp, hsx.tenhang, n.soluongN, n.dongiaN, n.soluongN * n.dongiaN AS tiennhap, sp.mausac, sp.donvitinh, n.ngaynhap, nv.tennv, nv.phong
FROM Nhap n
JOIN SanPham sp ON n.masp = sp.masp
JOIN HangSX hsx ON sp.mahangsx = hsx.mahangsx
JOIN NhanVien nv ON n.manv = nv.manv
WHERE nv.phong = N'kế toán' AND nv.gioitinh = N'nữ'
ORDER BY n.sohdn ASC;
*/
--Câu 6:Đưa ra thông tin phiếu xuất gồm: sohdx, masp, tensp, tenhang, soluongX, giaban, tienxuat-soluongX*giaban, mausac, donvitinh, ngayxuat, tennv, phong trong tháng 10 năm 2018, sắp xếp theo chiều tăng dần của sohdx.
/*SELECT x.sohdx, x.masp, sp.tensp, hsx.tenhang, x.soluongX, sp.giaban, x.soluongX * sp.giaban AS tienxuat, sp.mausac, sp.donvitinh, x.ngayxuat, nv.tennv, nv.phong
FROM Xuat x
JOIN Sanpham sp ON x.masp = sp.masp
JOIN Hangsx hsx ON sp.mahangsx = hsx.mahangsx
JOIN Nhanvien nv ON x.manv = nv.manv
WHERE MONTH(x.ngayxuat) = 10 AND YEAR(x.ngayxuat) = 2018
ORDER BY x.sohdx ASC;*/

--Câu 7. Đưa ra các thông tin về các hóa đơn mà hãng samsung đã nhập trong năm 2017, gồm: sohdn, masp, tensp, soluongN, dongiaN, ngaynhap, tennv, phong.
/*SELECT n.sohdn, n.masp, sp.tensp, n.soluongN, n.dongiaN, n.ngaynhap, nv.tennv, nv.phong
FROM Nhap n
JOIN Sanpham sp ON n.masp = sp.masp
JOIN Hangsx hsx ON sp.mahangsx = hsx.mahangsx
JOIN Nhanvien nv ON n.manv = nv.manv
WHERE YEAR(n.ngaynhap) = 2017 AND hsx.tenhang LIKE '%samsung%';*/

--Câu 8. Đưa ra Top 10 hóa đơn xuất có số lượng xuất nhiều nhất trong năm 2018, sắp xếp theo chiều giảm dần của soluongX.
/*SELECT TOP 10 x.sohdx, x.masp, sp.tensp, hsx.tenhang, x.soluongX, sp.giaban, x.soluongX * sp.giaban AS tienxuat, sp.mausac, sp.donvitinh, x.ngayxuat, nv.tennv, nv.phong
FROM Xuat x
JOIN Sanpham sp ON x.masp = sp.masp
JOIN Hangsx hsx ON sp.mahangsx = hsx.mahangsx
JOIN Nhanvien nv ON x.manv = nv.manv
WHERE YEAR(x.ngayxuat) = 2018
ORDER BY x.soluongX DESC*/

--câu 9. Đưa ra thông tin 10 sản phẩm có giá bán cao nhất trong cửa hàng, theo chiều giảm dần gia bán.
/*SELECT TOP 10 masp, tensp, giaban
FROM Sanpham
ORDER BY giaban DESC*/

--Câu 10. Đưa ra các thông tin sản phẩm có gía bán từ 100.000 đến 500.000 của hãng samsung.
/*SELECT masp, tensp, tenhang, giaban, mausac, donvitinh 
FROM Sanpham JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
WHERE tenhang like '%Samsung%' AND giaban >= 100000 AND giaban <= 500000*/

--Câu 11. Tính tổng tiền đã nhập trong năm 2018 của hãng samsung.
/*SELECT SUM(soluongN*dongiaN) AS TongTienNhap
FROM Nhap n JOIN SanPham SP ON n.masp = SP.masp
JOIN HangSX HSX ON SP.mahangsx = HSX.mahangsx
WHERE YEAR(ngaynhap) = 2018 AND HSX.tenhang LIKE '%Samsung%'*/

--Câu 12. Thống kê tổng tiền đã xuất trong ngày 2/9/2018
/*SELECT SUM(x.soluongX * giaban) as TongTienXuat
FROM Xuat x JOIN SanPham SP ON x.masp = SP.masp
WHERE ngayxuat = '2018-09-02'*/

--Câu 13. Đưa ra sohdn, ngaynhap có tiền nhập phải trả cao nhất trong năm 2018
/*SELECT TOP 1 n.sohdn, n.ngaynhap
FROM Nhap n JOIN SanPham SP ON n.masp = SP.masp
WHERE YEAR(n.ngaynhap) = 2018
ORDER BY soluongN*dongiaN DESC*/

--Câu 14. Đưa ra 10 mặt hàng có soluongN nhiều nhất trong năm 2019.
/*SELECT TOP 10 n.masp, SP.tensp, SUM(soluongN) AS total_quantity
FROM Nhap n JOIN SanPham SP ON n.masp = SP.masp
WHERE YEAR(ngaynhap) = 2019
GROUP BY n.masp, SP.tensp
ORDER BY total_quantity DESC*/

--Câu 15. Đưa ra masp,tensp của các sản phẩm do công ty “Samsung’ sản xuất do nhân viên có mã ‘NV01’ nhập.
/*SELECT masp, tensp
FROM Sanpham SP JOIN Hangsx HSX ON SP.mahangsx = HSX.mahangsx
WHERE tenhang = 'Samsung' AND manv = 'NV01';*/

--Câu 16. Đưa ra sohdn,masp,soluongN,ngayN của mặt hàng có masp là ‘SP02’, được nhân viên ‘NV02’ xuất.
/*SELECT n.sohdn, SP.masp, soluongN, n.ngaynhap
FROM Sanpham SP JOIN Nhap n ON SP.masp = n.masp
WHERE SP.masp like 'SP02' AND manv = 'NV02';*/

--Câu 17. Đưa ra manv,tennv đã xuất mặt hàng có mã ‘SPO2’ ngày ’03-02-2020.
/*SELECT nv.manv,nv.tennv 
FROM Nhanvien nv JOIN Xuat x ON nv.manv = x.manv
WHERE x.masp like 'SP02' AND ngayxuat = '03-02-2020';*/

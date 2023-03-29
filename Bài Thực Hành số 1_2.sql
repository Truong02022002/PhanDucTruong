--Câu 1:Hiển thị thông tin các bảng dữ liệu trên
/*select * from Hangsx;
select * from Nhanvien;
select * from Nhap;
select * from Xuat;
select * from Sanpham;*/
--Câu 2:Đưa ra thông tin masp, tensp, tenhang, soluong, mausac, giaban, donvitinh, mota của các sản phẩm sắp xếp theo chiều giảm dần giá bán
--SELECT * FROM sanpham ORDER BY giaban ASC;
--Câu 3:Đưa ra thông tin các sản phẩm có trong cửa hàng do công ty có tên hãng là samsung sản xuất
/*SELECT * FROM sanpham
WHERE mahangsx = 'H01';*/
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

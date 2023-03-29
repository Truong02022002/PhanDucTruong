use QLBanHang
--1. Hãy thống kê xem mỗi hãng sản xuất có bao nhiêu loại sản phẩm
/*SELECT mahangsx, COUNT(DISTINCT masp) AS so_loai_san_pham
FROM Sanpham SP 
GROUP BY mahangsx;*/

--2. Hãy thống kê xem tổng tiền nhập của mỗi sản phẩm trong năm 2018
/*SELECT SP.tensp, SUM(n.soluongN * n.dongiaN) as TongTienNhap
FROM Sanpham SP JOIN Nhap n ON SP.masp = n.masp
WHERE YEAR(n.ngaynhap) = 2020
GROUP BY SP.masp, SP.tensp*/

--3. Hãy thống kê các sản phẩm có tổng số lượng xuất năm 2018 là lớn hơn 10.000 sản phẩm của hãng samsung.
/*SELECT tensp, SUM(soluongX) as tongxuat
FROM Xuat x JOIN Sanpham SP ON x.masp = SP.masp JOIN Hangsx hsx ON hsx.mahangsx = SP.mahangsx 
WHERE YEAR(ngayxuat) = 2018 AND hsx.tenhang = 'Samsung'
GROUP BY SP.masp, SP.tensp
HAVING SUM(soluongX) > 10000*/

--4. Thống kê số lượng nhân viên Nam của mỗi phòng ban.
/*SELECT phong , COUNT(DISTINCT gioitinh) AS so_nhan_vien_nam
FROM Nhanvien 
WHERE gioitinh like N'%Nam%'
GROUP BY phong;*/

--5. Thống kê tổng số lượng nhập của mỗi hãng sản xuất trong năm 2018.
/*SELECT tenhang , COUNT(DISTINCT n.soluongN) AS so_nhan_vien_nam
FROM Hangsx hsx JOIN Sanpham SP ON hsx.mahangsx = SP.mahangsx JOIN Nhap n ON SP.masp = n.masp
WHERE YEAR(ngaynhap) = 2018
GROUP BY tenhang;*/

--6. Hãy thống kê xem tổng lượng tiền xuất của mỗi nhân viên trong năm 2018  bao nhiêu.
/*SELECT nv.tennv , SUM( SP.giaban * x.soluongX) AS tong_luong_tien_xuat
FROM Nhanvien nv JOIN Xuat x ON nv.manv = x.manv  JOIN Sanpham SP ON x.masp = SP.masp
WHERE YEAR(x.ngayxuat) = 2018
GROUP BY nv.tennv;*/

--7. Hãy đưa ra tổng tiền nhập của mỗi nhân viên trong tháng 8 – năm 2018 có tổng giá trị lớn hơn 100.000
/*SELECT nv.tennv , SUM( SP.giaban * x.soluongX) AS tong_luong_tien_xuat
FROM Nhanvien nv JOIN Xuat x ON nv.manv = x.manv  JOIN Sanpham SP ON x.masp = SP.masp
WHERE MONTH(x.ngayxuat) = 10 AND YEAR(x.ngayxuat) = 2018
GROUP BY nv.tennv
HAVING SUM(soluongX) > 10000*/

--8. Hãy đưa ra danh sách các sản phẩm đã nhập nhưng chưa xuất bao giờ.
/*SELECT SP.tensp 
FROM Sanpham SP LEFT JOIN Nhap n ON SP.masp = n.masp LEFT JOIN Xuat x ON SP.masp = x.masp 
WHERE X.masp IS NULL AND N.masp IS NOT NULL
GROUP BY SP.tensp;*/

--9. Hãy đưa ra danh sách các sản phẩm đã nhập năm 2018 và đã xuất năm 2018.
/*SELECT SP.tensp 
FROM Sanpham SP LEFT JOIN Nhap n ON SP.masp = n.masp LEFT JOIN Xuat x ON SP.masp = x.masp 
WHERE YEAR(n.ngaynhap) = 2018 AND YEAR(x.ngayxuat) = 2018
GROUP BY SP.tensp;*/

--10. Hãy đưa ra danh sách các nhân viên vừa nhập vừa xuất.
/*SELECT nv.tennv 
FROM Nhap n JOIN Xuat x ON n.manv = x.manv
JOIN Nhanvien nv ON n.manv = nv.manv
GROUP BY nv.manv, NV.tennv */


--11. Hãy đưa ra danh sách các nhân viên không tham gia việc nhập và xuất.
/*SELECT tennv
FROM Nhap n JOIN Xuat x ON n.manv = x.manv JOIN Nhanvien nv ON n.manv = nv.manv
WHERE n.manv NOT IN (SELECT DISTINCT manv FROM Nhap)
AND x.manv NOT IN (SELECT DISTINCT manv FROM Xuat)
GROUP BY nv.manv, NV.tennv */

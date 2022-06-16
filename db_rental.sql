-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 10, 2022 at 04:44 AM
-- Server version: 10.4.20-MariaDB
-- PHP Version: 8.0.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_rental`
--

-- --------------------------------------------------------

--
-- Table structure for table `tb_detail_pemesanan`
--

CREATE TABLE `tb_detail_pemesanan` (
  `id_detail` int(11) NOT NULL,
  `PLAT_KENDARAAN` varchar(50) DEFAULT NULL,
  `ID_PEMESANAN` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_detail_pemesanan`
--

INSERT INTO `tb_detail_pemesanan` (`id_detail`, `PLAT_KENDARAAN`, `ID_PEMESANAN`) VALUES
(74, 'M 2734 SA', 30),
(75, 'M 2734 SA', 30),
(76, 'S 7721 B', 30),
(77, 'S 7721 B', 30);

--
-- Triggers `tb_detail_pemesanan`
--
DELIMITER $$
CREATE TRIGGER `update_tb_kendaran` AFTER INSERT ON `tb_detail_pemesanan` FOR EACH ROW UPDATE tb_kendaraan SET tb_kendaraan.STATUS_KENDARAAN = 'Di Sewa' WHERE NEW.PLAT_KENDARAAN = tb_kendaraan.PLAT_KENDARAAN
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_total_harga` AFTER INSERT ON `tb_detail_pemesanan` FOR EACH ROW UPDATE tb_pemesanan SET TOTAL_HARGA = 
(SELECT tb_pemesanan.TOTAL_HARGA+ 
 
 (SELECT tb_kendaraan.BIAYA_SEWA FROM tb_kendaraan INNER JOIN tb_detail_pemesanan USING(PLAT_KENDARAAN) WHERE new.PLAT_KENDARAAN =tb_kendaraan.PLAT_KENDARAAN LIMIT 1)

 FROM tb_pemesanan WHERE tb_pemesanan.ID_PEMESANAN=new.ID_PEMESANAN),
 
 JML_SEWA = (SELECT tb_pemesanan.JML_SEWA + 1 FROM tb_pemesanan WHERE tb_pemesanan.ID_PEMESANAN=new.ID_PEMESANAN LIMIT 1)
 
 WHERE tb_pemesanan.ID_PEMESANAN=new.ID_PEMESANAN
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tb_kendaraan`
--

CREATE TABLE `tb_kendaraan` (
  `PLAT_KENDARAAN` varchar(50) NOT NULL,
  `NAMA_KENDARAAN` varchar(100) DEFAULT NULL,
  `TYPE_KENDARAAN` varchar(100) DEFAULT NULL,
  `BIAYA_SEWA` int(11) DEFAULT NULL,
  `STATUS_KENDARAAN` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_kendaraan`
--

INSERT INTO `tb_kendaraan` (`PLAT_KENDARAAN`, `NAMA_KENDARAAN`, `TYPE_KENDARAAN`, `BIAYA_SEWA`, `STATUS_KENDARAAN`) VALUES
('M 2734 SA', 'Pajero', 'AD 512', 1000000, 'Di Sewa'),
('M 453 LK', 'Toyota', 'Mega Mendung', 2000000, 'Di Sewa'),
('S 7721 B', 'R3', 'Roda 2', 1000, 'Di Sewa'),
('W 098 KL', 'Avanza', 'X800 2022', 1000000, 'Di Sewa');

-- --------------------------------------------------------

--
-- Table structure for table `tb_pembayaran`
--

CREATE TABLE `tb_pembayaran` (
  `ID_PEMBAYARAN` int(11) NOT NULL,
  `ID_PEMESANAN` int(11) DEFAULT NULL,
  `DENDA` int(11) DEFAULT NULL,
  `TGL_PEMBAYARAN` datetime DEFAULT NULL,
  `TOTAL_PEMBAYARAN` int(11) DEFAULT NULL,
  `STATUS_PEMBAYARAN` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_pembayaran`
--

INSERT INTO `tb_pembayaran` (`ID_PEMBAYARAN`, `ID_PEMESANAN`, `DENDA`, `TGL_PEMBAYARAN`, `TOTAL_PEMBAYARAN`, `STATUS_PEMBAYARAN`) VALUES
(25, 30, 0, NULL, 4004000, 'DP');

--
-- Triggers `tb_pembayaran`
--
DELIMITER $$
CREATE TRIGGER `insert_tb_pembayaran_akhir` AFTER INSERT ON `tb_pembayaran` FOR EACH ROW INSERT INTO tb_pembayaran_akhir(tgl_pembayaran,sisa_pembayaran,id_pembayaran)
VALUES(NULL,(SELECT (tb_pembayaran.TOTAL_PEMBAYARAN/2) FROM tb_pembayaran WHERE tb_pembayaran.ID_PEMBAYARAN=new.ID_PEMBAYARAN),new.ID_PEMBAYARAN)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_sisa_pembayaran_akhir` AFTER UPDATE ON `tb_pembayaran` FOR EACH ROW UPDATE tb_pembayaran_akhir SET sisa_pembayaran = (SELECT (tb_pembayaran.TOTAL_PEMBAYARAN/2) FROM tb_pembayaran WHERE tb_pembayaran.ID_PEMBAYARAN=new.ID_PEMBAYARAN) WHERE tb_pembayaran_akhir.ID_PEMBAYARAN=new.ID_PEMBAYARAN
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tb_pembayaran_akhir`
--

CREATE TABLE `tb_pembayaran_akhir` (
  `TGL_PEMBAYARAN` datetime DEFAULT NULL,
  `SISA_PEMBAYARAN` int(11) DEFAULT NULL,
  `ID_PEMBAYARAN` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_pembayaran_akhir`
--

INSERT INTO `tb_pembayaran_akhir` (`TGL_PEMBAYARAN`, `SISA_PEMBAYARAN`, `ID_PEMBAYARAN`) VALUES
(NULL, 2002000, 25);

-- --------------------------------------------------------

--
-- Table structure for table `tb_pemesanan`
--

CREATE TABLE `tb_pemesanan` (
  `ID_PEMESANAN` int(11) NOT NULL,
  `ID_USER` int(11) DEFAULT NULL,
  `TGL_SEWA` datetime DEFAULT NULL,
  `LAMA_SEWA` int(20) DEFAULT NULL,
  `TGL_PENGEMBALIAN` datetime DEFAULT NULL,
  `JML_SEWA` int(11) NOT NULL,
  `TOTAL_HARGA` int(11) NOT NULL,
  `STATUS` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_pemesanan`
--

INSERT INTO `tb_pemesanan` (`ID_PEMESANAN`, `ID_USER`, `TGL_SEWA`, `LAMA_SEWA`, `TGL_PENGEMBALIAN`, `JML_SEWA`, `TOTAL_HARGA`, `STATUS`) VALUES
(30, 2, NULL, 2, NULL, 4, 2002000, 'DP');

--
-- Triggers `tb_pemesanan`
--
DELIMITER $$
CREATE TRIGGER `insert_tb_pembayaran` AFTER INSERT ON `tb_pemesanan` FOR EACH ROW INSERT INTO tb_pembayaran(id_pemesanan, denda, tgl_pembayaran,total_pembayaran, status_pembayaran)VALUES((SELECT tb_pemesanan.ID_PEMESANAN FROM tb_pemesanan WHERE tb_pemesanan.ID_PEMESANAN=new.ID_PEMESANAN),0,NULL,(SELECT tb_pemesanan.TOTAL_HARGA*tb_pemesanan.LAMA_SEWA FROM tb_pemesanan WHERE tb_pemesanan.ID_PEMESANAN=new.ID_PEMESANAN),'DP')
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_pembayaran_harga` AFTER UPDATE ON `tb_pemesanan` FOR EACH ROW UPDATE tb_pembayaran SET total_pembayaran = (SELECT tb_pemesanan.TOTAL_HARGA*tb_pemesanan.LAMA_SEWA FROM tb_pemesanan WHERE tb_pemesanan.ID_PEMESANAN=new.ID_PEMESANAN) WHERE tb_pembayaran.ID_PEMESANAN=new.ID_PEMESANAN
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tb_user`
--

CREATE TABLE `tb_user` (
  `ID_USER` int(11) NOT NULL,
  `NAMA` varchar(100) DEFAULT NULL,
  `PASSWORD` varchar(100) DEFAULT NULL,
  `LEVEL` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_user`
--

INSERT INTO `tb_user` (`ID_USER`, `NAMA`, `PASSWORD`, `LEVEL`) VALUES
(1, 'Alex', '123', 'user'),
(2, 'Nico', 'nicon', 'user'),
(3, 'Yoha', 'yohaa', 'user');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tb_detail_pemesanan`
--
ALTER TABLE `tb_detail_pemesanan`
  ADD PRIMARY KEY (`id_detail`),
  ADD KEY `ID_PEMESANAN` (`ID_PEMESANAN`),
  ADD KEY `PLAT_KENDARAAN` (`PLAT_KENDARAAN`);

--
-- Indexes for table `tb_kendaraan`
--
ALTER TABLE `tb_kendaraan`
  ADD PRIMARY KEY (`PLAT_KENDARAAN`);

--
-- Indexes for table `tb_pembayaran`
--
ALTER TABLE `tb_pembayaran`
  ADD PRIMARY KEY (`ID_PEMBAYARAN`),
  ADD KEY `ID_PEMESANAN` (`ID_PEMESANAN`);

--
-- Indexes for table `tb_pembayaran_akhir`
--
ALTER TABLE `tb_pembayaran_akhir`
  ADD PRIMARY KEY (`ID_PEMBAYARAN`);

--
-- Indexes for table `tb_pemesanan`
--
ALTER TABLE `tb_pemesanan`
  ADD PRIMARY KEY (`ID_PEMESANAN`),
  ADD KEY `ID_USER` (`ID_USER`);

--
-- Indexes for table `tb_user`
--
ALTER TABLE `tb_user`
  ADD PRIMARY KEY (`ID_USER`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tb_detail_pemesanan`
--
ALTER TABLE `tb_detail_pemesanan`
  MODIFY `id_detail` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=78;

--
-- AUTO_INCREMENT for table `tb_pembayaran`
--
ALTER TABLE `tb_pembayaran`
  MODIFY `ID_PEMBAYARAN` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `tb_pemesanan`
--
ALTER TABLE `tb_pemesanan`
  MODIFY `ID_PEMESANAN` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `tb_user`
--
ALTER TABLE `tb_user`
  MODIFY `ID_USER` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tb_detail_pemesanan`
--
ALTER TABLE `tb_detail_pemesanan`
  ADD CONSTRAINT `FK_DETAIL_PEMESANAN` FOREIGN KEY (`ID_PEMESANAN`) REFERENCES `tb_pemesanan` (`ID_PEMESANAN`),
  ADD CONSTRAINT `FK_MENAMBIL` FOREIGN KEY (`PLAT_KENDARAAN`) REFERENCES `tb_kendaraan` (`PLAT_KENDARAAN`);

--
-- Constraints for table `tb_pembayaran`
--
ALTER TABLE `tb_pembayaran`
  ADD CONSTRAINT `tb_pembayaran_ibfk_1` FOREIGN KEY (`ID_PEMESANAN`) REFERENCES `tb_pemesanan` (`ID_PEMESANAN`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tb_pembayaran_akhir`
--
ALTER TABLE `tb_pembayaran_akhir`
  ADD CONSTRAINT `FK_DETAIL_PEMBAYARAN2` FOREIGN KEY (`ID_PEMBAYARAN`) REFERENCES `tb_pembayaran` (`ID_PEMBAYARAN`);

--
-- Constraints for table `tb_pemesanan`
--
ALTER TABLE `tb_pemesanan`
  ADD CONSTRAINT `FK_DAPAT_MEMESAN` FOREIGN KEY (`ID_USER`) REFERENCES `tb_user` (`ID_USER`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 25, 2024 at 05:54 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `finalproject_pbd`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_customer` ()   BEGIN  
SELECT * FROM customer;  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_transaksi` (IN `jumlah_min` DECIMAL(10,2), IN `jumlah_max` DECIMAL(10,2))   BEGIN
    IF jumlah_min <= jumlah_max THEN
        SELECT * 
        FROM transaksi
        WHERE jumlah_pembayaran > 450000.00
          AND jumlah_pembayaran BETWEEN jumlah_min AND jumlah_max;
    ELSE
        SELECT 'Parameter tidak valid: jumlah_min harus kurang dari atau sama dengan jumlah_max' AS error_message;
    END IF;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `f_jumlah_pesanan` (`tanggal_mulai` DATE, `tanggal_selesai` DATE) RETURNS BIGINT(20)  BEGIN
    DECLARE jumlah_pesanan BIGINT;
    
    SELECT COUNT(id_pesanan) INTO jumlah_pesanan
    FROM pesanan
    WHERE tanggal_pesanan BETWEEN tanggal_mulai AND tanggal_selesai;

    RETURN jumlah_pesanan;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `f_total` () RETURNS DECIMAL(10,2)  BEGIN
DECLARE total DECIMAL(10, 2);
SELECT SUM(jumlah_pembayaran) INTO total FROM Transaksi;
RETURN total;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin_master`
--

CREATE TABLE `admin_master` (
  `id_admin_master` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `no_hp` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_master`
--

INSERT INTO `admin_master` (`id_admin_master`, `username`, `password`, `no_hp`) VALUES
('001', 'Yunandra', 'hi123', '081234567891'),
('002', 'Niko', 'halo345', '085123456789'),
('003', 'Sabrina', 'hey789', '087321654987'),
('004', 'Okzen', 'higes567', '081575809426'),
('005', 'Anas', 'woi987', '089132465798'),
('006', 'Putri', 'haloguys17', '087651213469'),
('007', 'Prabu', 'inipwnya91', '082769843521');

-- --------------------------------------------------------

--
-- Table structure for table `admin_via`
--

CREATE TABLE `admin_via` (
  `id_admin_via` varchar(50) NOT NULL,
  `id_paket_tour` varchar(50) DEFAULT NULL,
  `nama_via` varchar(50) NOT NULL,
  `no_hp` varchar(15) NOT NULL,
  `password` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_via`
--

INSERT INTO `admin_via` (`id_admin_via`, `id_paket_tour`, `nama_via`, `no_hp`, `password`, `username`) VALUES
('0001', '01', 'Via_Malang', '089121345674', 'jogja123', 'Wahyu'),
('0002', '02', 'Via_Probolinggo', '087342167854', 'jogja456', 'Faisal'),
('0003', '03', 'Via_Pasuruan', '085457863142', 'jogja213', 'Febri'),
('0004', '04', 'Via_Tumpang', '087762895349', 'jogja986', 'Agus'),
('0005', '05', 'Via_Nongkojajar', '082789543276', 'jogja678', 'Surya'),
('0006', '06', 'Via_Tongas', '081234213444', 'concat45', 'Bagus'),
('0007', '07', 'Via_Tosari', '085676469876', 'jogjasleman23', 'Ega'),
('0008', NULL, 'Via_Surabaya', '082345678901', 'surabaya123', 'Aditya'),
('0009', NULL, 'Via_Surabaya', '082345678901', 'surabaya123', 'Aditya');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `id_customer` varchar(50) NOT NULL,
  `nama_customer` varchar(50) NOT NULL,
  `alamat_customer` varchar(100) DEFAULT NULL,
  `no_hp` varchar(15) NOT NULL,
  `id_admin_via` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`id_customer`, `nama_customer`, `alamat_customer`, `no_hp`, `id_admin_via`) VALUES
('C001', 'Andi', 'Jl. Merdeka No. 1, Malang', '081234567890', '0001'),
('C002', 'Budi', 'Jl. Pahlawan No. 23, Probolinggo', '081345678901', '0002'),
('C003', 'Citra', 'Jl. Kenanga No. 45, Pasuruan', '081456789012', '0003'),
('C004', 'Dewi', 'Jl. Anggrek No. 67, Tumpang', '081567890123', '0004'),
('C005', 'Eko', 'Jl. Melati No. 89, Nongkojajar', '081678901234', '0005'),
('C006', 'Fajar', 'Jl. Sudirman No. 12, Malang', '081234567891', '0006'),
('C007', 'Gita', 'Jl. Diponegoro No. 34, Probolinggo', '081345678902', '0007');

-- --------------------------------------------------------

--
-- Table structure for table `log_transaksi`
--

CREATE TABLE `log_transaksi` (
  `log_id` int(11) NOT NULL,
  `action_type` varchar(20) DEFAULT NULL,
  `id_transaksi` varchar(50) DEFAULT NULL,
  `id_pesanan` varchar(50) DEFAULT NULL,
  `jumlah_pembayaran` decimal(15,2) DEFAULT NULL,
  `metode_pembayaran` varchar(50) DEFAULT NULL,
  `tanggal_pembayaran` date DEFAULT NULL,
  `action_timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `log_transaksi`
--

INSERT INTO `log_transaksi` (`log_id`, `action_type`, `id_transaksi`, `id_pesanan`, `jumlah_pembayaran`, `metode_pembayaran`, `tanggal_pembayaran`, `action_timestamp`) VALUES
(4, 'BEFORE UPDATE', 'T002', 'P002', 520000.00, 'QRIS', '2024-07-21', '2024-07-25 15:08:59'),
(5, 'AFTER UPDATE', 'T002', 'P002', 520000.00, 'QRIS', '2024-07-21', '2024-07-25 15:08:59'),
(6, 'BEFORE UPDATE', 'T002', 'P002', 520000.00, 'QRIS', '2024-07-21', '2024-07-25 15:10:16'),
(7, 'AFTER UPDATE', 'T002', 'P002', 520000.00, 'QRIS', '2024-07-21', '2024-07-25 15:10:16');

-- --------------------------------------------------------

--
-- Table structure for table `paket_tour`
--

CREATE TABLE `paket_tour` (
  `id_paket_tour` varchar(50) NOT NULL,
  `deskripsi_paket` text DEFAULT NULL,
  `nama_via` varchar(50) NOT NULL,
  `harga_paket` decimal(10,2) NOT NULL,
  `rute_paket_tour` varchar(100) NOT NULL,
  `id_admin_via` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `paket_tour`
--

INSERT INTO `paket_tour` (`id_paket_tour`, `deskripsi_paket`, `nama_via`, `harga_paket`, `rute_paket_tour`, `id_admin_via`) VALUES
('01', 'Paket Malang', 'Via_Malang', 500000.00, 'Malang - Bromo', '0001'),
('02', 'Paket Probolinggo', 'Via_Probolinggo', 450000.00, 'Probolinggo - Bromo', '0002'),
('03', 'Paket Pasuruan', 'Via_Pasuruan', 400000.00, 'Pasuruan - Bromo', '0003'),
('04', 'Paket Tumpang', 'Via_Tumpang', 420000.00, 'Tumpang - Bromo', '0004'),
('05', 'Paket Nongkojajar', 'Via_Nongkojajar', 480000.00, 'Nongkojajar - Bromo', '0005'),
('06', 'Paket Tongas', 'Via_Tongas', 475000.00, 'Tongas - Bromo', '0006'),
('07', 'Paket Tosari', 'Via_Tosari', 495000.00, 'Tosari - Bromo', '0007');

-- --------------------------------------------------------

--
-- Table structure for table `pesanan`
--

CREATE TABLE `pesanan` (
  `id_pesanan` varchar(50) NOT NULL,
  `tanggal_pesanan` date NOT NULL,
  `total_harga` decimal(10,2) NOT NULL,
  `id_paket_tour` varchar(50) DEFAULT NULL,
  `id_customer` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pesanan`
--

INSERT INTO `pesanan` (`id_pesanan`, `tanggal_pesanan`, `total_harga`, `id_paket_tour`, `id_customer`) VALUES
('P001', '2024-07-20', 500000.00, '01', 'C001'),
('P002', '2024-07-21', 450000.00, '02', 'C002'),
('P003', '2024-07-22', 400000.00, '03', 'C003'),
('P004', '2024-07-23', 420000.00, '04', 'C004'),
('P005', '2024-07-24', 480000.00, '05', 'C005'),
('P006', '2024-07-28', 475000.00, '06', 'C006'),
('P007', '2024-08-03', 495000.00, '07', 'C007');

--
-- Triggers `pesanan`
--
DELIMITER $$
CREATE TRIGGER `AfterDeletePesanan` AFTER DELETE ON `pesanan` FOR EACH ROW BEGIN
    INSERT INTO LogChanges (change_type, table_name, record_id, change_time)
    VALUES ('DELETE', 'Pesanan', OLD.id_pesanan, NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `AfterInsertPesanan` AFTER INSERT ON `pesanan` FOR EACH ROW BEGIN
    INSERT INTO LogChanges (change_type, table_name, record_id, change_time)
    VALUES ('INSERT', 'Pesanan', NEW.id_pesanan, NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `AfterUpdatePesanan` AFTER UPDATE ON `pesanan` FOR EACH ROW BEGIN
    INSERT INTO LogChanges (change_type, table_name, record_id, change_time)
    VALUES ('UPDATE', 'Pesanan', NEW.id_pesanan, NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `BeforeDeletePesanan` BEFORE DELETE ON `pesanan` FOR EACH ROW BEGIN
    INSERT INTO LogChanges (change_type, table_name, record_id, change_time)
    VALUES ('DELETE', 'Pesanan', OLD.id_pesanan, NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `BeforeInsertPesanan` BEFORE INSERT ON `pesanan` FOR EACH ROW BEGIN
    IF NEW.total_harga <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Total Harga must be greater than 0';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `BeforeUpdatePesanan` BEFORE UPDATE ON `pesanan` FOR EACH ROW BEGIN
    IF OLD.total_harga != NEW.total_harga THEN
        INSERT INTO LogChanges (change_type, table_name, record_id, change_time)
        VALUES ('UPDATE', 'Pesanan', OLD.id_pesanan, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `t1_fp`
--

CREATE TABLE `t1_fp` (
  `id_pesanan` varchar(50) NOT NULL,
  `id_paket_tour` varchar(50) DEFAULT NULL,
  `id_customer` varchar(50) DEFAULT NULL,
  `id_transaksi` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transaksi`
--

CREATE TABLE `transaksi` (
  `id_transaksi` varchar(50) NOT NULL,
  `id_pesanan` varchar(50) DEFAULT NULL,
  `jumlah_pembayaran` decimal(10,2) NOT NULL,
  `metode_pembayaran` varchar(50) NOT NULL,
  `tanggal_pembayaran` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaksi`
--

INSERT INTO `transaksi` (`id_transaksi`, `id_pesanan`, `jumlah_pembayaran`, `metode_pembayaran`, `tanggal_pembayaran`) VALUES
('T001', 'P001', 500000.00, 'Transfer Bank', '2024-07-20'),
('T002', 'P002', 520000.00, 'QRIS', '2024-07-21'),
('T003', 'P003', 400000.00, 'Transfer Bank', '2024-07-22'),
('T004', 'P004', 420000.00, 'Kartu Kredit', '2024-07-23'),
('T005', 'P005', 480000.00, 'QRIS', '2024-07-24'),
('T006', 'P006', 475000.00, 'QRIS', '2024-07-28'),
('T007', 'P007', 495000.00, 'QRIS', '2024-08-03');

--
-- Triggers `transaksi`
--
DELIMITER $$
CREATE TRIGGER `after_delete_transaksi` AFTER DELETE ON `transaksi` FOR EACH ROW BEGIN
    INSERT INTO log_transaksi (action_type, id_transaksi, id_pesanan, jumlah_pembayaran, metode_pembayaran, tanggal_pembayaran)
    VALUES ('AFTER DELETE', OLD.id_transaksi, OLD.id_pesanan, OLD.jumlah_pembayaran, OLD.metode_pembayaran, OLD.tanggal_pembayaran);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_insert_transaksi` AFTER INSERT ON `transaksi` FOR EACH ROW BEGIN
    INSERT INTO log_transaksi (action_type, id_transaksi, id_pesanan, jumlah_pembayaran, metode_pembayaran, tanggal_pembayaran)
    VALUES ('AFTER INSERT', NEW.id_transaksi, NEW.id_pesanan, NEW.jumlah_pembayaran, NEW.metode_pembayaran, NEW.tanggal_pembayaran);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_update_transaksi` AFTER UPDATE ON `transaksi` FOR EACH ROW BEGIN
    INSERT INTO log_transaksi (action_type, id_transaksi, id_pesanan, jumlah_pembayaran, metode_pembayaran, tanggal_pembayaran)
    VALUES ('AFTER UPDATE', NEW.id_transaksi, NEW.id_pesanan, NEW.jumlah_pembayaran, NEW.metode_pembayaran, NEW.tanggal_pembayaran);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_delete_transaksi` BEFORE DELETE ON `transaksi` FOR EACH ROW BEGIN
    INSERT INTO log_transaksi (action_type, id_transaksi, id_pesanan, jumlah_pembayaran, metode_pembayaran, tanggal_pembayaran)
    VALUES ('BEFORE DELETE', OLD.id_transaksi, OLD.id_pesanan, OLD.jumlah_pembayaran, OLD.metode_pembayaran, OLD.tanggal_pembayaran);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_transaksi` BEFORE INSERT ON `transaksi` FOR EACH ROW BEGIN
    INSERT INTO log_transaksi (action_type, id_transaksi, id_pesanan, jumlah_pembayaran, metode_pembayaran, tanggal_pembayaran)
    VALUES ('BEFORE INSERT', NEW.id_transaksi, NEW.id_pesanan, NEW.jumlah_pembayaran, NEW.metode_pembayaran, NEW.tanggal_pembayaran);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_transaksi` BEFORE UPDATE ON `transaksi` FOR EACH ROW BEGIN
    INSERT INTO log_transaksi (action_type, id_transaksi, id_pesanan, jumlah_pembayaran, metode_pembayaran, tanggal_pembayaran)
    VALUES ('BEFORE UPDATE', OLD.id_transaksi, OLD.id_pesanan, OLD.jumlah_pembayaran, OLD.metode_pembayaran, OLD.tanggal_pembayaran);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_admin_via_summary`
-- (See below for the actual view)
--
CREATE TABLE `v_admin_via_summary` (
`id_admin_via` varchar(50)
,`nama_via` varchar(50)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_admin_via_vertical`
-- (See below for the actual view)
--
CREATE TABLE `v_admin_via_vertical` (
`id_admin_via` varchar(50)
,`nama_via` varchar(50)
,`no_hp` varchar(15)
,`password` varchar(50)
,`username` varchar(50)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_horizontal_transaksi`
-- (See below for the actual view)
--
CREATE TABLE `v_horizontal_transaksi` (
`id_transaksi` varchar(50)
,`id_pesanan` varchar(50)
,`jumlah_pembayaran` decimal(10,2)
,`metode_pembayaran` varchar(50)
,`tanggal_pembayaran` date
);

-- --------------------------------------------------------

--
-- Structure for view `v_admin_via_summary`
--
DROP TABLE IF EXISTS `v_admin_via_summary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_admin_via_summary`  AS SELECT `v_admin_via_vertical`.`id_admin_via` AS `id_admin_via`, `v_admin_via_vertical`.`nama_via` AS `nama_via` FROM `v_admin_via_vertical`WITH CASCADED CHECK OPTION  ;

-- --------------------------------------------------------

--
-- Structure for view `v_admin_via_vertical`
--
DROP TABLE IF EXISTS `v_admin_via_vertical`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_admin_via_vertical`  AS SELECT `admin_via`.`id_admin_via` AS `id_admin_via`, `admin_via`.`nama_via` AS `nama_via`, `admin_via`.`no_hp` AS `no_hp`, `admin_via`.`password` AS `password`, `admin_via`.`username` AS `username` FROM `admin_via` ;

-- --------------------------------------------------------

--
-- Structure for view `v_horizontal_transaksi`
--
DROP TABLE IF EXISTS `v_horizontal_transaksi`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_horizontal_transaksi`  AS SELECT `transaksi`.`id_transaksi` AS `id_transaksi`, `transaksi`.`id_pesanan` AS `id_pesanan`, `transaksi`.`jumlah_pembayaran` AS `jumlah_pembayaran`, `transaksi`.`metode_pembayaran` AS `metode_pembayaran`, `transaksi`.`tanggal_pembayaran` AS `tanggal_pembayaran` FROM `transaksi` WHERE `transaksi`.`metode_pembayaran` = 'QRIS' ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_master`
--
ALTER TABLE `admin_master`
  ADD PRIMARY KEY (`id_admin_master`);

--
-- Indexes for table `admin_via`
--
ALTER TABLE `admin_via`
  ADD PRIMARY KEY (`id_admin_via`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`id_customer`),
  ADD KEY `id_admin_via` (`id_admin_via`);

--
-- Indexes for table `log_transaksi`
--
ALTER TABLE `log_transaksi`
  ADD PRIMARY KEY (`log_id`);

--
-- Indexes for table `paket_tour`
--
ALTER TABLE `paket_tour`
  ADD PRIMARY KEY (`id_paket_tour`),
  ADD KEY `fk_AdminVia` (`id_admin_via`);

--
-- Indexes for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD PRIMARY KEY (`id_pesanan`),
  ADD KEY `id_Paket_tour` (`id_paket_tour`),
  ADD KEY `id_customer` (`id_customer`);

--
-- Indexes for table `t1_fp`
--
ALTER TABLE `t1_fp`
  ADD PRIMARY KEY (`id_pesanan`),
  ADD KEY `i_fp` (`id_customer`),
  ADD KEY `composite_index` (`id_paket_tour`,`id_transaksi`);

--
-- Indexes for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `id_pesanan` (`id_pesanan`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `log_transaksi`
--
ALTER TABLE `log_transaksi`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin_via`
--
ALTER TABLE `admin_via`
  ADD CONSTRAINT `fk_PaketTour` FOREIGN KEY (`id_Paket_tour`) REFERENCES `paket_tour` (`id_Paket_tour`);

--
-- Constraints for table `customer`
--
ALTER TABLE `customer`
  ADD CONSTRAINT `customer_ibfk_1` FOREIGN KEY (`id_admin_via`) REFERENCES `admin_via` (`id_admin_Via`);

--
-- Constraints for table `paket_tour`
--
ALTER TABLE `paket_tour`
  ADD CONSTRAINT `fk_AdminVia` FOREIGN KEY (`id_Admin_via`) REFERENCES `admin_via` (`id_admin_Via`);

--
-- Constraints for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD CONSTRAINT `pesanan_ibfk_1` FOREIGN KEY (`id_Paket_tour`) REFERENCES `paket_tour` (`id_Paket_tour`),
  ADD CONSTRAINT `pesanan_ibfk_2` FOREIGN KEY (`id_customer`) REFERENCES `customer` (`id_customer`);

--
-- Constraints for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `transaksi_ibfk_1` FOREIGN KEY (`id_pesanan`) REFERENCES `pesanan` (`id_pesanan`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

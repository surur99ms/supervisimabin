-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 03, 2026 at 11:18 AM
-- Server version: 10.6.28-MariaDB-cll-lve
-- PHP Version: 8.4.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jsnimmnm_supervisi_mabin`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin_users`
--

CREATE TABLE `admin_users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_users`
--

INSERT INTO `admin_users` (`id`, `username`, `password`) VALUES
(1, 'UPTMabin', '$2y$10$jpAsY9L6SolqlsVe1LGQiOfnKnXp2EO/fDzSUVjIR9Vg8k5onmQgG');

-- --------------------------------------------------------

--
-- Table structure for table `kategori_supervisi`
--

CREATE TABLE `kategori_supervisi` (
  `id` int(11) NOT NULL,
  `nama_kategori` varchar(255) DEFAULT NULL,
  `icon` varchar(100) DEFAULT 'ph-folder-open',
  `urutan` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kategori_supervisi`
--

INSERT INTO `kategori_supervisi` (`id`, `nama_kategori`, `icon`, `urutan`, `created_at`) VALUES
(1, 'MANAJEMEN & ADMINISTRASI', 'ph-folder-open', 1, '2026-07-25 04:37:23'),
(2, 'PENDATAAN & VALIDASI DIGITAL', 'ph-database', 2, '2026-07-25 04:37:23'),
(3, 'KBM, AGENDA & LAPORAN', 'ph-notebook', 3, '2026-07-25 04:37:23');

-- --------------------------------------------------------

--
-- Table structure for table `madrasah`
--

CREATE TABLE `madrasah` (
  `id` int(11) NOT NULL,
  `nama_madrasah` varchar(255) DEFAULT NULL,
  `wilayah` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `madrasah`
--

INSERT INTO `madrasah` (`id`, `nama_madrasah`, `wilayah`, `created_at`) VALUES
(1, 'BKL-01 MIFTAHUL ULUM AL KHOTIBI', 'BANGKALAN', '2026-07-25 19:17:56'),
(2, 'BWI-01 MIFTAHUL ULUM BANYUGIRI', 'BANYUWANGI', '2026-07-25 19:17:56'),
(3, 'BWS-01 MDTA AL FALAH', 'BONDOWOSO', '2026-07-25 19:17:56'),
(4, 'BWS-02 NURUL ALIM', 'BONDOWOSO', '2026-07-25 19:17:56'),
(5, 'BWS-03 NURUL IHSAN PAKISAN', 'BONDOWOSO', '2026-07-25 19:17:56'),
(6, 'BWS-04 MD NURUL IMAN', 'BONDOWOSO', '2026-07-25 19:17:56'),
(7, 'BWS-05 MDTA MIFTAHUL ULUM', 'BONDOWOSO', '2026-07-25 19:17:56'),
(8, 'BWS-06 AL HUDA', 'BONDOWOSO', '2026-07-25 19:17:56'),
(9, 'BWS-07 RAUDLATUL JANNAH', 'BONDOWOSO', '2026-07-25 19:17:56'),
(10, 'BWS-08 AL-FITROH AN-NASHRIYYAH', 'BONDOWOSO', '2026-07-25 19:17:56'),
(11, 'BWS-09 NURUL JADID', 'BONDOWOSO', '2026-07-25 19:17:56'),
(12, 'BWS-10 YPI NURUL ANWAR', 'BONDOWOSO', '2026-07-25 19:17:56'),
(13, 'JMB-01 YPI. DARUL MURTADLO MULYOREJO', 'JEMBER', '2026-07-25 19:17:56'),
(14, 'JMB-02 RAUDLATUL ULUM', 'JEMBER', '2026-07-25 19:17:56'),
(15, 'JMB-03 PPS AL-MAJIDI', 'JEMBER', '2026-07-25 19:17:56'),
(16, 'JMB-04 MADIN DARUN NAJAH', 'JEMBER', '2026-07-25 19:17:56'),
(17, 'JMB-05 ASSALAFI DARUN NAJAH', 'JEMBER', '2026-07-25 19:17:56'),
(18, 'JMB-06 AL- HIKMAH BALUNG', 'JEMBER', '2026-07-25 19:17:56'),
(19, 'JMB-07 DARUT TAUBAH AL MUQORROBIN', 'JEMBER', '2026-07-25 19:17:56'),
(20, 'JMB-08 AL DJALIL 2', 'JEMBER', '2026-07-25 19:17:56'),
(21, 'JMB-09 MMU KALIWATES', 'JEMBER', '2026-07-25 19:17:56'),
(22, 'JMB-10 MADRASAH AZ ZAITUN', 'JEMBER', '2026-07-25 19:17:56'),
(23, 'JMB-11 YAYASAN PONDOK PESANTREN AS SABROWI', 'JEMBER', '2026-07-25 19:17:56'),
(24, 'JMB-12 ALFAGIRI', 'JEMBER', '2026-07-25 19:17:56'),
(25, 'JMB-13 ROUDHOTUS SHOLIHIN', 'JEMBER', '2026-07-25 19:17:56'),
(26, 'JMB-14 MIFTAHUL ULUM', 'JEMBER', '2026-07-25 19:17:56'),
(27, 'JMB-15 MIFTAHUL ULUM', 'JEMBER', '2026-07-25 19:17:56'),
(28, 'JMB-16 AR-ROHMAH', 'JEMBER', '2026-07-25 19:17:56'),
(29, 'JMB-17 MIFTAHUL ULUM', 'JEMBER', '2026-07-25 19:17:56'),
(30, 'JMB-18 QUWWATUL ISLAM', 'JEMBER', '2026-07-25 19:17:56'),
(31, 'JMB-19 AL ANWAR', 'JEMBER', '2026-07-25 19:17:56'),
(32, 'JMB-20 MIFTAHUL ULUM', 'JEMBER', '2026-07-25 19:17:56'),
(33, 'JMB-21 BABUSSALAM', 'JEMBER', '2026-07-25 19:17:56'),
(34, 'JMB-22 AL WARISIN', 'JEMBER', '2026-07-25 19:17:56'),
(35, 'JMB-23 DARUL FALAH AS-SIDDIQY', 'JEMBER', '2026-07-25 19:17:56'),
(36, 'LMJ-01 MIFTAHUL ULUM 007', 'LUMAJANG', '2026-07-25 19:17:56'),
(37, 'LMJ-03 MIFTAHUL ULUM TEMPURSARI', 'LUMAJANG', '2026-07-25 19:17:56'),
(38, 'LMJ-05 ASSUNNIYYAH', 'LUMAJANG', '2026-07-25 19:17:56'),
(39, 'LMJ-06 FATIHUL ULUM', 'LUMAJANG', '2026-07-25 19:17:56'),
(40, 'LMJ-07 AL ISLAH CANDIPURO', 'LUMAJANG', '2026-07-25 19:17:56'),
(41, 'LMJ-08 NURUL JANNAH CANDIPURO', 'LUMAJANG', '2026-07-25 19:17:56'),
(42, 'LMJ-09 AL KAROMAH JATIROTO', 'LUMAJANG', '2026-07-25 19:17:56'),
(43, 'LMJ-10 NURUL ULUM JATIROTO', 'LUMAJANG', '2026-07-25 19:17:56'),
(44, 'LMJ-11 AN NUR SUMBER WRINGIN', 'LUMAJANG', '2026-07-25 19:17:56'),
(45, 'LMJ-12 ROUDLOTUL ULUM', 'LUMAJANG', '2026-07-25 19:17:56'),
(46, 'LMJ-13 NURUL IMAN AL IKHLAS L-023', 'LUMAJANG', '2026-07-25 19:17:56'),
(47, 'LMJ-14 MIFTAHUL ULUM AN NAWAWI', 'LUMAJANG', '2026-07-25 19:17:56'),
(48, 'LMJ-16 NURUL JANNAH SAWARAN LOR', 'LUMAJANG', '2026-07-25 19:17:56'),
(49, 'LMJ-17 DARUL JANNAH', 'LUMAJANG', '2026-07-25 19:17:56'),
(50, 'LMJ-18 MIFTAHUL ULUM AL-ISLAMI', 'LUMAJANG', '2026-07-25 19:17:56'),
(51, 'LMJ-19 MADRASAH AN NAFI\'AH', 'LUMAJANG', '2026-07-25 19:17:56'),
(52, 'LMJ-20 MIFTAHUL ULUM AL AMIN', 'LUMAJANG', '2026-07-25 19:17:56'),
(53, 'LMJ-21 RIYADUS SHOLIHIN', 'LUMAJANG', '2026-07-25 19:17:56'),
(54, 'LMJ-22 MIFTAHUL ULUM', 'LUMAJANG', '2026-07-25 19:17:56'),
(55, 'LMJ-23 MADRASAH DINIYAH NURUL JANNAH', 'LUMAJANG', '2026-07-25 19:17:56'),
(56, 'LMJ-24 MIFTAHUL ULUM SENTUL', 'LUMAJANG', '2026-07-25 19:17:56'),
(57, 'LMJ-25 BAITURROHMAN', 'LUMAJANG', '2026-07-25 19:17:56'),
(58, 'LMJ-26 NURUL IHSAN', 'LUMAJANG', '2026-07-25 19:17:56'),
(59, 'LMJ-27 AN NAFI\'AH', 'LUMAJANG', '2026-07-25 19:17:56'),
(60, 'LMJ-28 MADIN NURUL IKHWAN', 'LUMAJANG', '2026-07-25 19:17:56'),
(61, 'LMJ-29 NURUL MUNAWWIROH', 'LUMAJANG', '2026-07-25 19:17:56'),
(62, 'MLG-01 MIFTAHUL ULUM', 'MALANG', '2026-07-25 19:17:56'),
(63, 'MLG-02 MDT AL KHOIROT', 'MALANG', '2026-07-25 19:17:56'),
(64, 'MLG-03 MIFTAHUL ULUM SRIMULYO', 'MALANG', '2026-07-25 19:17:56'),
(65, 'MLG-04 ROUDLOTUL JANNAH', 'MALANG', '2026-07-25 19:17:56'),
(66, 'MLG-05 PESANTREN TANI INDONESIA', 'MALANG', '2026-07-25 19:17:56'),
(67, 'PBL-01 MIFTAHUL HUDA', 'PROBOLINGGO', '2026-07-25 19:17:56'),
(68, 'PBL-02 NURUL HUDA', 'PROBOLINGGO', '2026-07-25 19:17:56'),
(69, 'PBL-03 MIFTAHUL ULUM', 'PROBOLINGGO', '2026-07-25 19:17:56'),
(70, 'PBL-04 NURUL HUDA', 'PROBOLINGGO', '2026-07-25 19:17:56'),
(71, 'PBL-05 MIFTAHUL ULUM', 'PROBOLINGGO', '2026-07-25 19:17:56'),
(72, 'PBL-06 ZAINUL YASIN', 'PROBOLINGGO', '2026-07-25 19:17:56'),
(73, 'PBL-07 DARUL MUTA\'ALLIMIN', 'PROBOLINGGO', '2026-07-25 19:17:56'),
(74, 'PBL-08 NURUL BURHAN', 'PROBOLINGGO', '2026-07-25 19:17:56'),
(75, 'PBL-09 MADIN ZAINUL FALAH', 'PROBOLINGGO', '2026-07-25 19:17:56'),
(76, 'PBL-10 NURUL HUDA', 'PROBOLINGGO', '2026-07-25 19:17:56'),
(77, 'PBL-11 MIFTAHUL ULUM', 'PROBOLINGGO', '2026-07-25 19:17:56'),
(78, 'PBL-12 NURUL ANWAR', 'PROBOLINGGO', '2026-07-25 19:17:56'),
(79, 'PBL-13 ASSYARBANI', 'PROBOLINGGO', '2026-07-25 19:17:56'),
(80, 'PBL-14 DARUL ULUM PAITON', 'PROBOLINGGO', '2026-07-25 19:17:56'),
(81, 'PBL-15 MIFTAHUL ULUM IBTIDAIYAH', 'PROBOLINGGO', '2026-07-25 19:17:56'),
(82, 'PBL-16 NURUN NAFIAH AL-KURSY', 'PROBOLINGGO', '2026-07-25 19:17:56'),
(83, 'PSR-01 HUBBUL WATHON', 'PASURUAN', '2026-07-25 19:17:56'),
(84, 'PSR-02 MADRASAH DINIYAH AZ-ZAHRAH', 'PASURUAN', '2026-07-25 19:17:56'),
(85, 'PSR-03 MADIN RIYADHUS SHOLIHIN', 'PASURUAN', '2026-07-25 19:17:56'),
(86, 'PSR-04 MADRASAH MIFTAHUL ULUM', 'PASURUAN', '2026-07-25 19:17:56'),
(87, 'PSR-05 MADIN MIFTAHUL ULUM KRAJAN', 'PASURUAN', '2026-07-25 19:17:56'),
(88, 'PSR-06 MIFTAHUL ULUM PANDAAN', 'PASURUAN', '2026-07-25 19:17:56'),
(89, 'PSR-07 SABILUL MUTTAQIN CUKURGULING', 'PASURUAN', '2026-07-25 19:17:56'),
(90, 'PSR-09 MIFTAHUL ULUM KARANG KUKUN', 'PASURUAN', '2026-07-25 19:17:56'),
(91, 'SMP-01 NAHDLATUL WATHAN', 'SUMENEP', '2026-07-25 19:17:56'),
(92, 'SMP-02 MIFTAHUL ULUM', 'SUMENEP', '2026-07-25 19:17:56'),
(93, 'SMP-03 MIFTAHUL ULUM -THOLABURRIDHO', 'SUMENEP', '2026-07-25 19:17:56'),
(94, 'SMP-04 RAUDLATUN NASYIEN', 'SUMENEP', '2026-07-25 19:17:56'),
(95, 'SMP-05 NURUL YAQIN', 'SUMENEP', '2026-07-25 19:17:56'),
(96, 'SMP-06 TARBIYATUS SIBYAN', 'SUMENEP', '2026-07-25 19:17:56'),
(97, 'SMP-07 MABIN SUMENEP', 'SUMENEP', '2026-07-25 19:17:56'),
(98, 'SMP-08 PP RAUDHATUT THOLIBIN', 'SUMENEP', '2026-07-25 19:17:56'),
(99, 'SMP-09 DARUL QUR\'AN WAL ULUM', 'SUMENEP', '2026-07-25 19:17:56'),
(100, 'SMP-10 NURUL HUDA', 'SUMENEP', '2026-07-25 19:17:56'),
(101, 'SMP-11 MIFTAHUL JANNAH', 'SUMENEP', '2026-07-25 19:17:56'),
(102, 'SPG-01 MMU DAMPUL TIMUR', 'SAMPANG', '2026-07-25 19:17:56'),
(103, 'SPG-02 MMU SUMBER BUNGA', 'SAMPANG', '2026-07-25 19:17:56'),
(104, 'SPG-03 MD AZ HARUL ULUM', 'SAMPANG', '2026-07-25 19:17:56'),
(105, 'SPG-04 MMU NAGASARI', 'SAMPANG', '2026-07-25 19:17:56'),
(106, 'SPG-05 NURUL HUDA', 'SAMPANG', '2026-07-25 19:17:56'),
(107, 'SPG-06 TARBIYATUL ATHFAL', 'SAMPANG', '2026-07-25 19:17:56');

-- --------------------------------------------------------

--
-- Table structure for table `poin_supervisi`
--

CREATE TABLE `poin_supervisi` (
  `id` varchar(50) NOT NULL,
  `kategori_id` int(11) DEFAULT NULL,
  `nama_poin` varchar(255) DEFAULT NULL,
  `deskripsi` varchar(255) DEFAULT '',
  `urutan` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `poin_supervisi`
--

INSERT INTO `poin_supervisi` (`id`, `kategori_id`, `nama_poin`, `deskripsi`, `urutan`, `created_at`) VALUES
('kl_1', 3, 'Input KBM', 'Kegiatan Belajar Mengajar', 1, '2026-07-25 04:37:23'),
('kl_2', 3, 'Input Agenda Kegiatan Madrasah', 'Agenda dan jadwal kegiatan', 2, '2026-07-25 04:37:23'),
('kl_3', 3, 'Input Data Keuangan', 'Data keuangan madrasah', 3, '2026-07-25 04:37:23'),
('kl_4', 3, 'Input Laporan Bulanan', 'Laporan aktivitas bulanan', 4, '2026-07-25 04:37:23'),
('ma_1', 1, 'Buku Tamu', 'Pemeriksaan pencatatan tamu', 1, '2026-07-25 04:37:23'),
('ma_2', 1, 'Visi, Misi, dan Tujuan', 'Kesesuaian visi misi dan tujuan', 2, '2026-07-25 04:37:23'),
('ma_3', 1, 'RKM', 'Rencana Kerja Madrasah', 3, '2026-07-25 04:37:23'),
('ma_4', 1, 'RKAM', 'Rencana Kegiatan Anggaran Madrasah', 4, '2026-07-25 04:37:23'),
('ma_5', 1, 'Struktur Organisasi Madrasah', 'Bagan dan susunan pengurus', 5, '2026-07-25 04:37:23'),
('ma_6', 1, 'TUPOKSI', 'Tugas pokok fungsi pengurus', 6, '2026-07-25 04:37:23'),
('pv_1', 2, 'Validasi Data Lembaga', 'Pemeriksaan data lembaga', 1, '2026-07-25 04:37:23'),
('pv_2', 2, 'Input Data Murid', 'Kelengkapan data peserta didik', 2, '2026-07-25 04:37:23'),
('pv_3', 2, 'Input Data Guru', 'Kelengkapan data tenaga pendidik', 3, '2026-07-25 04:37:23'),
('pv_4', 2, 'Input Data Sahabat Khidmah', 'Data sahabat khidmah madrasah', 4, '2026-07-25 04:37:23');

-- --------------------------------------------------------

--
-- Table structure for table `rekap_supervisi`
--

CREATE TABLE `rekap_supervisi` (
  `id` int(11) NOT NULL,
  `madrasah_nama` varchar(255) DEFAULT NULL,
  `supervisor_id` int(11) DEFAULT NULL,
  `supervisor_nama` varchar(255) DEFAULT NULL,
  `nilai` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`nilai`)),
  `catatan` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`catatan`)),
  `waktu` datetime DEFAULT current_timestamp(),
  `periode` varchar(50) DEFAULT '1447 H'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rekap_supervisi`
--

INSERT INTO `rekap_supervisi` (`id`, `madrasah_nama`, `supervisor_id`, `supervisor_nama`, `nilai`, `catatan`, `waktu`, `periode`) VALUES
(1, 'BWS-07 RAUDLATUL JANNAH - BONDOWOSO', 5, 'ABD. Rohim', '{\"ma_1\":\"Sedang\",\"ma_2\":\"Baik\",\"ma_3\":\"Buruk\",\"ma_4\":\"Sedang\",\"ma_5\":\"Buruk\",\"ma_6\":\"Baik\",\"pv_1\":\"Baik\",\"pv_2\":\"Sedang\",\"pv_3\":\"Baik\",\"pv_4\":\"Buruk\",\"kl_1\":\"Baik\",\"kl_2\":\"Sedang\",\"kl_3\":\"Buruk\",\"kl_4\":\"Sedang\"}', '{\"ma_1\":\"kurang ttd\",\"ma_2\":\"\",\"ma_3\":\"\",\"ma_4\":\"\",\"ma_5\":\"\",\"ma_6\":\"\",\"pv_1\":\"\",\"pv_2\":\"\",\"pv_3\":\"\",\"pv_4\":\"\",\"kl_1\":\"\",\"kl_2\":\"\",\"kl_3\":\"\",\"kl_4\":\"\"}', '2026-07-23 12:54:55', '1447 H'),
(2, 'MI Al-Hidayah - Surabaya', 1, 'Moh. Rifqi Al Mahmudy', '{\"kur_2\":\"Buruk\",\"kur_1\":\"Baik\"}', '{\"kur_2\":\"\",\"kur_1\":\"\"}', '2026-07-26 01:33:21', '1447 H'),
(3, 'BKL-01 MIFTAHUL ULUM AL KHOTIBI - BANGKALAN', 1, 'Moh. Rifqi Al Mahmudy', '{\"kur_2\":\"Sedang\"}', '{\"kur_2\":\"\"}', '2026-07-26 01:42:07', '1447 H'),
(4, 'BKL-01 MIFTAHUL ULUM AL KHOTIBI - BANGKALAN', 1, 'Moh. Rifqi Al Mahmudy', '{\"adm_2\":\"Sedang\",\"adm_1\":\"Baik\",\"adm_4\":\"Buruk\"}', '{\"adm_2\":\"\",\"adm_1\":\"\",\"adm_4\":\"\"}', '2026-07-26 18:08:38', '1447-1448 H'),
(5, 'BWI-01 MIFTAHUL ULUM BANYUGIRI - BANYUWANGI', 1, 'Moh. Rifqi Al Mahmudy', '{\"kur_1\":\"Baik\",\"adm_1\":\"Sedang\",\"adm_3\":\"Sedang\"}', '{\"kur_1\":\"\",\"adm_1\":\"\",\"adm_3\":\"\"}', '2026-07-27 11:36:32', '1447-1448 H'),
(6, 'BWS-01 MDTA AL FALAH - BONDOWOSO', 6, 'Misbahussurur', '{\"loy_3\":\"Buruk\"}', '{\"loy_3\":\"\"}', '2026-07-26 01:52:31', '1447-1448 H'),
(7, 'BWI-01 MIFTAHUL ULUM BANYUGIRI - BANYUWANGI', 6, 'Misbahussurur', '{\"kur_2\":\"Baik\"}', '{\"kur_2\":\"\"}', '2026-07-26 01:53:36', '1445-1446 H'),
(8, 'BWI-01 MIFTAHUL ULUM BANYUGIRI - BANYUWANGI', 6, 'Misbahussurur', '{\"loy_3\":\"Sedang\"}', '{\"loy_3\":\"\"}', '2026-07-26 01:53:49', '1449-1450 H'),
(9, 'JMB-19 AL ANWAR - JEMBER', 5, 'ABD. Rohim', '{\"adm_1\":\"Baik\"}', '{\"adm_1\":\"\"}', '2026-07-26 04:20:01', '1447-1448 H'),
(10, 'LMJ-06 FATIHUL ULUM - LUMAJANG', 5, 'ABD. Rohim', '{\"adm_2\":\"Buruk\",\"adm_1\":\"Baik\",\"adm_4\":\"Baik\"}', '{\"adm_2\":\"\",\"adm_1\":\"\",\"adm_4\":\"\"}', '2026-07-26 04:20:35', '1447-1448 H'),
(11, 'LMJ-06 FATIHUL ULUM - LUMAJANG', 2, 'Ahmad Muntahal Hadi', '{\"adm_2\":\"Sedang\",\"adm_1\":\"Baik\",\"adm_4\":\"Buruk\"}', '{\"adm_2\":\"\",\"adm_1\":\"\",\"adm_4\":\"\"}', '2026-07-26 15:06:16', '1446-1447 H'),
(12, 'JMB-06 AL- HIKMAH BALUNG - JEMBER', 1, 'Moh. Rifqi Al Mahmudy', '{\"adm_1\":\"Sedang\",\"adm_2\":\"Sedang\",\"adm_3\":\"Sedang\",\"adm_4\":\"Baik\",\"loy_1\":\"Baik\",\"loy_2\":\"Baik\",\"loy_3\":\"Buruk\"}', '{\"adm_1\":\"\",\"adm_2\":\"\",\"adm_3\":\"\",\"adm_4\":\"\",\"loy_1\":\"\",\"loy_2\":\"\",\"loy_3\":\"\"}', '2026-07-26 17:57:33', '1447-1448 H'),
(13, 'JMB-16 AR-ROHMAH - JEMBER', 6, 'Misbahussurur', '{\"adm_1\":\"Baik\",\"adm_4\":\"Sedang\",\"adm_3\":\"Buruk\",\"adm_5\":\"Buruk\"}', '{\"adm_1\":\"\",\"adm_4\":\"\",\"adm_3\":\"\",\"adm_5\":\"\"}', '2026-07-26 18:04:37', '1447-1448 H'),
(14, 'JMB-03 PPS AL-MAJIDI - JEMBER', 1, 'Moh. Rifqi Al Mahmudy', '{\"adm_1\":\"Sedang\"}', '{\"adm_1\":\"\"}', '2026-07-26 18:14:23', '1447-1448 H'),
(15, 'PSR-03 MADIN RIYADHUS SHOLIHIN - PASURUAN', 2, 'Ahmad Muntahal Hadi', '{\"adm_1\":\"Baik\",\"adm_2\":\"Sedang\",\"adm_3\":\"Baik\",\"adm_4\":\"Baik\",\"adm_5\":\"Sedang\",\"adm_6\":\"Sedang\",\"kur_1\":\"Baik\",\"kur_2\":\"Sedang\",\"kur_3\":\"Buruk\",\"kur_4\":\"Sedang\",\"loy_1\":\"Baik\",\"loy_2\":\"Sedang\",\"loy_3\":\"Buruk\",\"loy_4\":\"Sedang\"}', '{\"adm_1\":\"\",\"adm_2\":\"\",\"adm_3\":\"\",\"adm_4\":\"\",\"adm_5\":\"\",\"adm_6\":\"\",\"kur_1\":\"\",\"kur_2\":\"\",\"kur_3\":\"\",\"kur_4\":\"\",\"loy_1\":\"\",\"loy_2\":\"\",\"loy_3\":\"\",\"loy_4\":\"\"}', '2026-07-26 18:53:26', '1447-1448 H'),
(16, 'SPG-06 TARBIYATUL ATHFAL - SAMPANG', 2, 'Ahmad Muntahal Hadi', '{\"adm_1\":\"Baik\",\"adm_2\":\"Sedang\",\"adm_3\":\"Sedang\",\"adm_4\":\"Baik\",\"adm_5\":\"Sedang\",\"adm_6\":\"Buruk\"}', '{\"adm_1\":\"\",\"adm_2\":\"\",\"adm_3\":\"\",\"adm_4\":\"\",\"adm_5\":\"\",\"adm_6\":\"\"}', '2026-07-26 21:03:15', '1447-1448 H'),
(17, 'SMP-06 TARBIYATUS SIBYAN - SUMENEP', 1, 'Moh. Rifqi Al Mahmudy', '{\"adm_2\":\"Sedang\",\"adm_3\":\"Buruk\"}', '{\"adm_2\":\"\",\"adm_3\":\"\"}', '2026-07-27 11:37:39', '1447-1448 H'),
(18, 'PSR-01 HUBBUL WATHON - PASURUAN', 1, 'Moh. Rifqi Al Mahmudy', '{\"adm_1\":\"Baik\",\"adm_2\":\"Sedang\",\"adm_3\":\"Sedang\",\"adm_4\":\"Sedang\",\"adm_5\":\"Baik\",\"adm_6\":\"Sedang\",\"kur_1\":\"Baik\",\"kur_2\":\"Sedang\",\"kur_3\":\"Buruk\",\"kur_4\":\"Sedang\",\"loy_1\":\"Baik\",\"loy_2\":\"Baik\",\"loy_3\":\"Baik\",\"loy_4\":\"Sedang\"}', '{\"adm_1\":\"\",\"adm_2\":\"\",\"adm_3\":\"\",\"adm_4\":\"\",\"adm_5\":\"\",\"adm_6\":\"\",\"kur_1\":\"\",\"kur_2\":\"\",\"kur_3\":\"\",\"kur_4\":\"\",\"loy_1\":\"\",\"loy_2\":\"\",\"loy_3\":\"\",\"loy_4\":\"Mantap Gus\"}', '2026-07-27 16:39:08', '1447-1448 H'),
(19, 'PSR-09 MIFTAHUL ULUM KARANG KUKUN - PASURUAN', 1, 'Moh. Rifqi Al Mahmudy', '{\"adm_1\":\"Baik\",\"adm_2\":\"Sedang\",\"adm_5\":\"Buruk\",\"adm_6\":\"Sedang\",\"adm_3\":\"Sedang\",\"kur_2\":\"Sedang\",\"loy_3\":\"Sedang\",\"loy_2\":\"Baik\"}', '{\"adm_1\":\"\",\"adm_2\":\"\",\"adm_5\":\"\",\"adm_6\":\"\",\"adm_3\":\"kurang isi\",\"kur_2\":\"\",\"loy_3\":\"\",\"loy_2\":\"\"}', '2026-07-29 12:09:16', '1447-1448 H'),
(20, 'PBL-10 NURUL HUDA - PROBOLINGGO', 1, 'Moh. Rifqi Al Mahmudy', '{\"adm_1\":\"Sedang\",\"adm_3\":\"Buruk\",\"adm_4\":\"Sedang\",\"adm_5\":\"Baik\",\"adm_6\":\"Sedang\",\"adm_2\":\"Baik\",\"kur_1\":\"Baik\",\"kur_2\":\"Sedang\",\"kur_3\":\"Buruk\",\"kur_4\":\"Buruk\",\"loy_1\":\"Sedang\",\"loy_2\":\"Baik\",\"loy_3\":\"Buruk\",\"loy_4\":\"Buruk\"}', '{\"adm_1\":\"\",\"adm_3\":\"\",\"adm_4\":\"\",\"adm_5\":\"\",\"adm_6\":\"\",\"adm_2\":\"\",\"kur_1\":\"\",\"kur_2\":\"\",\"kur_3\":\"\",\"kur_4\":\"\",\"loy_1\":\"\",\"loy_2\":\"\",\"loy_3\":\"\",\"loy_4\":\"KURANG MANTAP\"}', '2026-07-29 12:12:41', '1447-1448 H'),
(21, 'PBL-11 MIFTAHUL ULUM - PROBOLINGGO', 1, 'Moh. Rifqi Al Mahmudy', '{\"adm_2\":\"Buruk\",\"adm_3\":\"Baik\",\"adm_5\":\"Baik\",\"kur_1\":\"Baik\",\"loy_3\":\"Sedang\",\"loy_1\":\"Baik\"}', '{\"adm_2\":\"\",\"adm_3\":\"\",\"adm_5\":\"\",\"kur_1\":\"\",\"loy_3\":\"\",\"loy_1\":\"\"}', '2026-07-29 12:16:05', '1447-1448 H'),
(22, 'BWS-10 YPI NURUL ANWAR - BONDOWOSO', 8, 'M. Usman', '{\"adm_2\":\"Sedang\",\"adm_4\":\"Buruk\"}', '{\"adm_2\":\"\",\"adm_4\":\"\"}', '2026-07-29 13:02:25', '1447-1448 H'),
(23, 'PSR-01 HUBBUL WATHON - PASURUAN', 3, 'Ahmad Firdaus', '{\"adm_1\":\"Buruk\",\"adm_2\":\"Sedang\",\"adm_3\":\"Sedang\",\"adm_4\":\"Buruk\",\"adm_5\":\"Baik\",\"adm_6\":\"Sedang\",\"kur_1\":\"Baik\",\"kur_2\":\"Sedang\",\"kur_3\":\"Buruk\",\"kur_4\":\"Sedang\",\"loy_1\":\"Baik\",\"loy_2\":\"Baik\",\"loy_3\":\"Baik\",\"loy_4\":\"Sedang\"}', '{\"adm_1\":\"\",\"adm_2\":\"\",\"adm_3\":\"\",\"adm_4\":\"\",\"adm_5\":\"\",\"adm_6\":\"\",\"kur_1\":\"\",\"kur_2\":\"\",\"kur_3\":\"\",\"kur_4\":\"\",\"loy_1\":\"\",\"loy_2\":\"\",\"loy_3\":\"\",\"loy_4\":\"Mantap Gus\"}', '2026-07-29 13:35:16', '1447-1448 H'),
(24, 'PSR-03 MADIN RIYADHUS SHOLIHIN - PASURUAN', 3, 'Ahmad Firdaus', '{\"adm_1\":\"Baik\",\"adm_2\":\"Baik\",\"adm_3\":\"Baik\",\"adm_4\":\"Baik\",\"adm_5\":\"Sedang\",\"adm_6\":\"Sedang\",\"kur_1\":\"Baik\",\"kur_2\":\"Sedang\",\"kur_3\":\"Buruk\",\"kur_4\":\"Sedang\",\"loy_1\":\"Baik\",\"loy_2\":\"Sedang\",\"loy_3\":\"Buruk\",\"loy_4\":\"Sedang\"}', '{\"adm_1\":\"\",\"adm_2\":\"\",\"adm_3\":\"\",\"adm_4\":\"\",\"adm_5\":\"\",\"adm_6\":\"\",\"kur_1\":\"\",\"kur_2\":\"\",\"kur_3\":\"\",\"kur_4\":\"\",\"loy_1\":\"\",\"loy_2\":\"\",\"loy_3\":\"\",\"loy_4\":\"\"}', '2026-07-29 13:36:18', '1447-1448 H'),
(25, 'PBL-10 NURUL HUDA - PROBOLINGGO', 3, 'Ahmad Firdaus', '{\"adm_1\":\"Sedang\",\"adm_3\":\"Baik\",\"adm_4\":\"Sedang\",\"adm_5\":\"Baik\",\"adm_6\":\"Sedang\",\"adm_2\":\"Baik\",\"kur_1\":\"Baik\",\"kur_2\":\"Sedang\",\"kur_3\":\"Buruk\",\"kur_4\":\"Buruk\",\"loy_1\":\"Sedang\",\"loy_2\":\"Baik\",\"loy_3\":\"Buruk\",\"loy_4\":\"Buruk\"}', '{\"adm_1\":\"\",\"adm_3\":\"\",\"adm_4\":\"\",\"adm_5\":\"\",\"adm_6\":\"\",\"adm_2\":\"\",\"kur_1\":\"\",\"kur_2\":\"\",\"kur_3\":\"\",\"kur_4\":\"\",\"loy_1\":\"\",\"loy_2\":\"\",\"loy_3\":\"\",\"loy_4\":\"KURANG MANTAP\"}', '2026-07-29 13:37:41', '1447-1448 H'),
(26, 'BKL-01 MIFTAHUL ULUM AL KHOTIBI - BANGKALAN', 3, 'Ahmad Firdaus', '{\"adm_2\":\"Sedang\",\"adm_1\":\"Baik\",\"adm_4\":\"Buruk\"}', '{\"adm_2\":\"\",\"adm_1\":\"\",\"adm_4\":\"\"}', '2026-07-29 13:40:50', '1447-1448 H'),
(27, 'PBL-10 NURUL HUDA - PROBOLINGGO', 4, 'Afwan Hafy', '{\"adm_1\":\"Sedang\",\"adm_3\":\"Baik\",\"adm_4\":\"Sedang\",\"adm_5\":\"Baik\",\"adm_6\":\"Sedang\",\"adm_2\":\"Baik\",\"kur_1\":\"Baik\",\"kur_2\":\"Sedang\",\"kur_3\":\"Buruk\",\"kur_4\":\"Buruk\",\"loy_1\":\"Sedang\",\"loy_2\":\"Baik\",\"loy_3\":\"Buruk\",\"loy_4\":\"Buruk\"}', '{\"adm_1\":\"\",\"adm_3\":\"\",\"adm_4\":\"\",\"adm_5\":\"\",\"adm_6\":\"\",\"adm_2\":\"\",\"kur_1\":\"\",\"kur_2\":\"\",\"kur_3\":\"\",\"kur_4\":\"\",\"loy_1\":\"\",\"loy_2\":\"\",\"loy_3\":\"\",\"loy_4\":\"KURANG MANTAP\"}', '2026-07-29 15:59:32', '1447-1448 H'),
(28, 'PBL-10 NURUL HUDA - PROBOLINGGO', 4, 'Afwan Hafy', '{\"adm_1\":\"Sedang\",\"adm_3\":\"Baik\",\"adm_4\":\"Sedang\",\"adm_5\":\"Baik\",\"adm_6\":\"Sedang\",\"adm_2\":\"Baik\",\"kur_1\":\"Baik\",\"kur_2\":\"Sedang\",\"kur_3\":\"Baik\",\"kur_4\":\"Baik\",\"loy_1\":\"Sedang\",\"loy_2\":\"Baik\",\"loy_3\":\"Buruk\",\"loy_4\":\"Buruk\"}', '{\"adm_1\":\"\",\"adm_3\":\"\",\"adm_4\":\"\",\"adm_5\":\"\",\"adm_6\":\"\",\"adm_2\":\"\",\"kur_1\":\"\",\"kur_2\":\"\",\"kur_3\":\"\",\"kur_4\":\"\",\"loy_1\":\"\",\"loy_2\":\"\",\"loy_3\":\"\",\"loy_4\":\"KURANG MANTAP\"}', '2026-07-29 15:59:57', '1447-1448 H'),
(29, 'PBL-10 NURUL HUDA - PROBOLINGGO', 4, 'Afwan Hafy', '{\"adm_1\":\"Buruk\",\"adm_3\":\"Buruk\",\"adm_4\":\"Sedang\",\"adm_5\":\"Baik\",\"adm_6\":\"Sedang\",\"adm_2\":\"Buruk\",\"kur_1\":\"Buruk\",\"kur_2\":\"Sedang\",\"kur_3\":\"Buruk\",\"kur_4\":\"Buruk\",\"loy_1\":\"Sedang\",\"loy_2\":\"Baik\",\"loy_3\":\"Buruk\",\"loy_4\":\"Buruk\"}', '{\"adm_1\":\"\",\"adm_3\":\"\",\"adm_4\":\"\",\"adm_5\":\"\",\"adm_6\":\"\",\"adm_2\":\"\",\"kur_1\":\"\",\"kur_2\":\"\",\"kur_3\":\"\",\"kur_4\":\"\",\"loy_1\":\"\",\"loy_2\":\"\",\"loy_3\":\"\",\"loy_4\":\"KURANG MANTAP\"}', '2026-07-29 16:00:33', '1447-1448 H'),
(30, 'PSR-03 MADIN RIYADHUS SHOLIHIN - PASURUAN', 5, 'ABD. Rohim', '{\"adm_1\":\"Baik\",\"adm_2\":\"Baik\",\"adm_3\":\"Baik\",\"adm_4\":\"Baik\",\"adm_5\":\"Baik\",\"adm_6\":\"Baik\",\"kur_1\":\"Baik\",\"kur_2\":\"Baik\",\"kur_3\":\"Baik\",\"kur_4\":\"Sedang\",\"loy_1\":\"Baik\",\"loy_2\":\"Baik\",\"loy_3\":\"Baik\",\"loy_4\":\"Baik\"}', '{\"adm_1\":\"\",\"adm_2\":\"\",\"adm_3\":\"\",\"adm_4\":\"\",\"adm_5\":\"\",\"adm_6\":\"\",\"kur_1\":\"\",\"kur_2\":\"\",\"kur_3\":\"\",\"kur_4\":\"\",\"loy_1\":\"\",\"loy_2\":\"\",\"loy_3\":\"\",\"loy_4\":\"\"}', '2026-07-29 16:13:35', '1447-1448 H'),
(31, 'PSR-03 MADIN RIYADHUS SHOLIHIN - PASURUAN', 7, 'Sakaruddin', '{\"adm_1\":\"Baik\",\"adm_2\":\"Baik\",\"adm_3\":\"Baik\",\"adm_4\":\"Baik\",\"adm_5\":\"Baik\",\"adm_6\":\"Baik\",\"kur_1\":\"Baik\",\"kur_2\":\"Baik\",\"kur_3\":\"Baik\",\"kur_4\":\"Baik\",\"loy_1\":\"Baik\",\"loy_2\":\"Baik\",\"loy_3\":\"Baik\",\"loy_4\":\"Baik\"}', '{\"adm_1\":\"\",\"adm_2\":\"\",\"adm_3\":\"\",\"adm_4\":\"\",\"adm_5\":\"\",\"adm_6\":\"\",\"kur_1\":\"\",\"kur_2\":\"\",\"kur_3\":\"\",\"kur_4\":\"\",\"loy_1\":\"\",\"loy_2\":\"\",\"loy_3\":\"\",\"loy_4\":\"\"}', '2026-07-29 16:42:58', '1447-1448 H'),
(32, 'PSR-03 MADIN RIYADHUS SHOLIHIN - PASURUAN', 7, 'Sakaruddin', '{\"adm_1\":\"Baik\",\"adm_2\":\"Baik\",\"adm_3\":\"Baik\",\"adm_4\":\"Baik\",\"adm_5\":\"Baik\",\"adm_6\":\"Baik\",\"kur_1\":\"Baik\",\"kur_2\":\"Baik\",\"kur_3\":\"Baik\",\"kur_4\":\"Baik\",\"loy_1\":\"Baik\",\"loy_2\":\"Baik\",\"loy_3\":\"Baik\",\"loy_4\":\"Sedang\"}', '{\"adm_1\":\"\",\"adm_2\":\"\",\"adm_3\":\"\",\"adm_4\":\"\",\"adm_5\":\"\",\"adm_6\":\"\",\"kur_1\":\"\",\"kur_2\":\"\",\"kur_3\":\"\",\"kur_4\":\"\",\"loy_1\":\"\",\"loy_2\":\"\",\"loy_3\":\"\",\"loy_4\":\"\"}', '2026-07-29 16:54:16', '1447-1448 H');

-- --------------------------------------------------------

--
-- Table structure for table `supervisors`
--

CREATE TABLE `supervisors` (
  `id` int(11) NOT NULL,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `nama_supervisor` varchar(255) DEFAULT NULL,
  `wilayah_tugas` varchar(255) DEFAULT NULL,
  `foto_profil` varchar(500) DEFAULT NULL,
  `webauthn_credential_id` varchar(500) DEFAULT NULL,
  `webauthn_public_key` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supervisors`
--

INSERT INTO `supervisors` (`id`, `username`, `password`, `nama_supervisor`, `wilayah_tugas`, `foto_profil`, `webauthn_credential_id`, `webauthn_public_key`, `created_at`) VALUES
(1, 'sup01', '$2y$10$v.kxSBRN5a0cc04q6leaFeQXYTCyGDhpimsM00b8Tg4JGcDO.gimG', 'Moh. Rifqi Al Mahmudy', 'Surabaya', NULL, NULL, NULL, '2026-07-23 05:52:29'),
(2, 'sup02', '$2y$10$CKYuL3SbczDoJyQ3rhCzNueGNbl/IK8Vw8gY1cfh6xG9SBOwMeBY.', 'Ahmad Muntahal Hadi', 'Surabaya', NULL, NULL, NULL, '2026-07-23 05:52:29'),
(3, 'sup03', '$2y$10$Bwv7SH3aUyJd0plGX4PHbuZuhJQcR1ODP8i/NXiFmRSTDhSc0JnHq', 'Ahmad Firdaus', 'Surabaya', NULL, NULL, NULL, '2026-07-23 05:52:29'),
(4, 'sup04', '$2y$10$lWovn1NP.XC33m615uDf3Opsc3db26aBmu.sGyy4D.X87ZOeiG6sG', 'Afwan Hafy', 'Malang', NULL, NULL, NULL, '2026-07-23 05:52:29'),
(5, 'sup05', '$2y$10$DHgJrOGltpDLnbGmTeLxNemfSC04uUqoBrDS3mnZQduQMOdOWh1Ga', 'ABD. Rohim', 'Malang', NULL, NULL, NULL, '2026-07-23 05:52:29'),
(6, 'sup06', '$2y$10$htvICByAYawjOL5dBpXm7OD9ZMuROt9aEqXvcBCllR2X8O2KryXlS', 'Misbahussurur', 'Malang', NULL, NULL, NULL, '2026-07-23 05:52:29'),
(7, 'sup07', '$2y$10$D4NkQSQ90b9eBnD0e5du4eTy/a/npFTsRVZZmMUljNmcrv4jGJ/2K', 'Sakaruddin', 'Pasuruan', NULL, NULL, NULL, '2026-07-23 05:52:29'),
(8, 'sup08', '$2y$10$qe9PF1SPavYhmVzrQ8ubluByHIm4YCDRiCmcC528.Azc02ai.y4SC', 'M. Usman', 'Pasuruan', NULL, NULL, NULL, '2026-07-23 05:52:30'),
(9, 'sup09', '$2y$10$VJAr2f9O4MXC9YHog1hO3.f7nwyfFj608FYdNxslEwtf04yW4K2iq', 'Khobir Khozin', 'Pasuruan', NULL, NULL, NULL, '2026-07-29 11:14:04');

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_rekap_supervisi_rapi`
-- (See below for the actual view)
--
CREATE TABLE `v_rekap_supervisi_rapi` (
`id` int(11)
,`madrasah_nama` varchar(255)
,`supervisor_id` int(11)
,`supervisor_nama` varchar(255)
,`periode` varchar(50)
,`waktu` datetime
,`1 Buku Tamu` longtext
,`1 Visi, Misi, dan Tujuan` longtext
,`1 RKM` longtext
,`1 RKAM` longtext
,`1 Struktur Organisasi` longtext
,`1 TUPOKSI` longtext
,`2 Data Lembaga` longtext
,`2 Input Data Murid` longtext
,`2 Input Data Guru` longtext
,`2 Sahabat Khidmah` longtext
,`3 Input KBM` longtext
,`3 Agenda Kegiatan` longtext
,`3 Input Data Keuangan` longtext
,`3 Laporan Bulanan` longtext
,`catatan` longtext
);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_users`
--
ALTER TABLE `admin_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `kategori_supervisi`
--
ALTER TABLE `kategori_supervisi`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `madrasah`
--
ALTER TABLE `madrasah`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `poin_supervisi`
--
ALTER TABLE `poin_supervisi`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `rekap_supervisi`
--
ALTER TABLE `rekap_supervisi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `madrasah_nama` (`madrasah_nama`),
  ADD KEY `supervisor_id` (`supervisor_id`);

--
-- Indexes for table `supervisors`
--
ALTER TABLE `supervisors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin_users`
--
ALTER TABLE `admin_users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `kategori_supervisi`
--
ALTER TABLE `kategori_supervisi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `madrasah`
--
ALTER TABLE `madrasah`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=108;

--
-- AUTO_INCREMENT for table `rekap_supervisi`
--
ALTER TABLE `rekap_supervisi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `supervisors`
--
ALTER TABLE `supervisors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

-- --------------------------------------------------------

--
-- Structure for view `v_rekap_supervisi_rapi`
--
DROP TABLE IF EXISTS `v_rekap_supervisi_rapi`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_rekap_supervisi_rapi`  AS SELECT `rekap_supervisi`.`id` AS `id`, `rekap_supervisi`.`madrasah_nama` AS `madrasah_nama`, `rekap_supervisi`.`supervisor_id` AS `supervisor_id`, `rekap_supervisi`.`supervisor_nama` AS `supervisor_nama`, `rekap_supervisi`.`periode` AS `periode`, `rekap_supervisi`.`waktu` AS `waktu`, ifnull(json_unquote(json_extract(`rekap_supervisi`.`nilai`,'$.adm_1')),'-') AS `1 Buku Tamu`, ifnull(json_unquote(json_extract(`rekap_supervisi`.`nilai`,'$.adm_2')),'-') AS `1 Visi, Misi, dan Tujuan`, ifnull(json_unquote(json_extract(`rekap_supervisi`.`nilai`,'$.adm_3')),'-') AS `1 RKM`, ifnull(json_unquote(json_extract(`rekap_supervisi`.`nilai`,'$.adm_4')),'-') AS `1 RKAM`, ifnull(json_unquote(json_extract(`rekap_supervisi`.`nilai`,'$.adm_5')),'-') AS `1 Struktur Organisasi`, ifnull(json_unquote(json_extract(`rekap_supervisi`.`nilai`,'$.adm_6')),'-') AS `1 TUPOKSI`, ifnull(json_unquote(json_extract(`rekap_supervisi`.`nilai`,'$.kur_1')),'-') AS `2 Data Lembaga`, ifnull(json_unquote(json_extract(`rekap_supervisi`.`nilai`,'$.kur_2')),'-') AS `2 Input Data Murid`, ifnull(json_unquote(json_extract(`rekap_supervisi`.`nilai`,'$.kur_3')),'-') AS `2 Input Data Guru`, ifnull(json_unquote(json_extract(`rekap_supervisi`.`nilai`,'$.kur_4')),'-') AS `2 Sahabat Khidmah`, ifnull(json_unquote(json_extract(`rekap_supervisi`.`nilai`,'$.loy_1')),'-') AS `3 Input KBM`, ifnull(json_unquote(json_extract(`rekap_supervisi`.`nilai`,'$.loy_2')),'-') AS `3 Agenda Kegiatan`, ifnull(json_unquote(json_extract(`rekap_supervisi`.`nilai`,'$.loy_3')),'-') AS `3 Input Data Keuangan`, ifnull(json_unquote(json_extract(`rekap_supervisi`.`nilai`,'$.loy_4')),'-') AS `3 Laporan Bulanan`, `rekap_supervisi`.`catatan` AS `catatan` FROM `rekap_supervisi` ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

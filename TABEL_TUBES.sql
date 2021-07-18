
CREATE TABLE Customer(
idCustomer int not null IDENTITY(1,1) primary key,
username varchar(50),
Pass varchar(50),
Email varchar(50),
Nama varchar(50),
NoHP varchar(50),
tanggalLahir date,
idalamat int
)
ALTER TABLE Customer
	ADD CONSTRAINT [fk_Customer]
	FOREIGN KEY (idalamat) REFERENCES alamat (idalamat)



CREATE TABLE Alamat(
idAlamat int not null IDENTITY(1,1) primary key,
kodepos varchar(50),
namaJalan varchar(50),
idKel int,
idKec int,
idKota int,
idProvinsi int
)

ALTER TABLE Alamat
	ADD CONSTRAINT [fk_alamat]
	FOREIGN KEY (idKel) REFERENCES kelurahan (idKel),
	FOREIGN KEY (idKec) REFERENCES kecamatan (idKec),
	FOREIGN KEY (idKota) REFERENCES Kota1 (idKota),
	FOREIGN KEY (idProvinsi) REFERENCES Provinsi (idProvinsi)

ALTER TABLE kelurahan
	ADD CONSTRAINT [fk_kelurahan-kecamatan]
	FOREIGN KEY (idKec) REFERENCES kecamatan (idKec)

ALTER TABLE kecamatan
	ADD CONSTRAINT [fk_kecamatan-kota]
	FOREIGN KEY (idKota) REFERENCES Kota1 (idKota)

ALTER TABLE Kota1
	ADD CONSTRAINT [fk_kota-provinsi]
	FOREIGN KEY (idProvinsi) REFERENCES Provinsi (idProvinsi)



CREATE TABLE Provinsi(
idProvinsi int not null IDENTITY(1,1) primary key,
namaProv varchar(50)
)

CREATE TABLE Kota1(
idKota int not null IDENTITY(1,1) primary key,
idProvinsi int,
namaKota varchar(50)
)

create table kecamatan(
idKec int not null IDENTITY(1,1) primary key,
idKota int,
namaKec varchar(50)
)

create table kelurahan(
idKel int not null IDENTITY(1,1) primary key,
idKec int,
namaKel varchar(50)
)



CREATE TABLE transaksigeneral(
idTransaksi int not null IDENTITY(1,1) primary key,
idCustomer int,
jumlahhampers int,
idHampers varchar(50),
idbarang varchar(50),
tanggalterima varchar(50),
HargaTotal int
)


CREATE TABLE UkuranItem(
idukuranItem int not null IDENTITY(1,1) primary key,
idItem int,
NamaUkuran varchar(5),
Gambar varchar(5000),
Ukuran int,
jumlahitem int,
refrensi varchar(50),
harga int
)




CREATE TABLE StatusPesanan(
idStatus int not null IDENTITY(1,1) primary key,
idTransaksi int,
statusDiterima varchar(50),
statusDiproses varchar(50),
statusTiba varchar(50),
statusPembayaran varchar(50)
)


CREATE TABLE Tanggal(
idTanggal int not null IDENTITY(1,1) primary key,
idTransaksi int,
tanggalKonfirmasi date,
tanggalProses date,
tanggalPengiriman date,
tanggalPembatalan date, 
tanggalSelesai date
)



create table waktukonfirmasi(
idwaktukonfir int not null IDENTITY(1,1) primary key,
idwaktu int,
awal datetime,
selesai datetime
)
ALTER TABLE waktukonfirmasi
	ADD CONSTRAINT [fk_waktukonfirmasi]
	FOREIGN KEY (idwaktu) REFERENCES waktu (idwaktu)

create table waktubuatham(
idwaktubuat int not null IDENTITY(1,1) primary key,
idwaktu int,
awal datetime,
selesai datetime
)

ALTER TABLE waktubuatham
	ADD CONSTRAINT [fk_waktubuatham]
	FOREIGN KEY (idwaktu) REFERENCES waktu (idwaktu)

create table waktuisibar(
idwaktuisi int not null IDENTITY(1,1) primary key,
idwaktu int,
awal datetime,
selesai datetime
)

ALTER TABLE waktuisibar
	ADD CONSTRAINT [fk_waktuisibar]
	FOREIGN KEY (idwaktu) REFERENCES waktu (idwaktu)

create table waktumerapihkan(
idwaktuisi int not null IDENTITY(1,1) primary key,
idwaktu int,
awal datetime,
selesai datetime
)

ALTER TABLE waktumerapihkan
	ADD CONSTRAINT [fk_waktumerapihkan]
	FOREIGN KEY (idwaktu) REFERENCES waktu (idwaktu)



CREATE TABLE DataPembayaran(
idPembayaran int not null IDENTITY(1,1) primary key,
idCustomer1 int,
idTransaksi varchar(50),
nilaiPembayaran int,
tanggalPembayaran date,
fotoBukti varchar(50)
)



CREATE TABLE transaksi(
idTransaksi int not null IDENTITY(1,1) primary key,
idCustomer int,
jumlahhampers int,
idHampers varchar(50),
idbarang varchar(50),
tanggalterima varchar(50),
HargaTotal int
)


CREATE TABLE UkuranHampers(
idukuran int not null IDENTITY(1,1) primary key,
idHampers int,
jenisUkuran varchar(10),
jumlahisi int,
harga int
)


create table waktu (
idwaktu int not null IDENTITY(1,1) primary key,
idtransaksi int,
keterangan varchar(50)
)

ALTER TABLE waktu
	ADD CONSTRAINT [fk_waktu]
	FOREIGN KEY (idtransaksi) REFERENCES transaksi (idtransaksi)
	


CREATE TABLE HistoriBarang(
idHistori int not null IDENTITY(1,1) primary key,
idBarang int,
idukuranitem int,
Tanggal date,
HargaItem float
)

ALTER TABLE HistoriBarang
	ADD CONSTRAINT [fk_HistoriBarang]
	FOREIGN KEY (idBarang) REFERENCES itemHampers (iditem),
	FOREIGN KEY (idUkuranItem) REFERENCES ukuranitem (idUkuranItem)



ALTER TABLE transaksi
ADD CONSTRAINT [fk_transaksi-customer]
FOREIGN KEY
	(
		idCustomer
	)
REFERENCES 
	Customer
	(
		idCustomer
	)




CREATE TABLE Hampers(
idHampers int not null IDENTITY(1,1) primary key,
namahampers varchar(50),
tanggalBukaHampers datetime,
tanggalTutupHampers datetime,
kategori varchar(50)
)



ALTER TABLE UkuranHampers
ADD CONSTRAINT [fk_UkuranHampers-Hampers]
FOREIGN KEY
	(
		idHampers
	)
REFERENCES 
	Hampers
	(
		idHampers
	)


CREATE TABLE ItemHampers(
idItem int not null IDENTITY(1,1) primary key,
NamaItem varchar(50),
Kategoriitem varchar(50),
)


ALTER TABLE UkuranItem
ADD CONSTRAINT [fk_UkuranItem-Barang]
FOREIGN KEY
	(
		idItem
	)
REFERENCES 
	ItemHampers
	(
		idItem
	)




CREATE TABLE Pegawai(
idPegawai int not null IDENTITY(1,1) primary key,
Username varchar(50),
Pass varchar(50)
)

CREATE TABLE MengelolaStatusPesanan(
idStatus int not null,
idPegawai int not null
)

CREATE TABLE Pemilik(
Pass varchar(50),
Username varchar(50)
)

CREATE TABLE Penerima(
idpenerima int not null IDENTITY(1,1) primary key,
idtransaksi int,
idcustomer int,
nama varchar(50),
idalamat int,
noHP varchar (50)
)



ALTER TABLE Tanggal
ADD CONSTRAINT [fk_tanggal-transaksi]
FOREIGN KEY
	(
		idTransaksi
	)
REFERENCES 
	transaksi
	(
		idTransaksi
	)

ALTER TABLE StatusPesanan
ADD CONSTRAINT [fk_statuspesanan-transaksi]
FOREIGN KEY
	(
		idTransaksi
	)
REFERENCES 
	transaksi
	(
		idTransaksi
	)

ALTER TABLE MengelolaStatusPesanan
ADD CONSTRAINT [fk_mengelola]
FOREIGN KEY
	(
		idStatus
	)
REFERENCES 
	StatusPesanan
	(
		idStatus
	),
FOREIGN KEY
	(
		idPegawai
	)
REFERENCES 
	PEgawai
	(
		idPegawai
	)

ALTER TABLE Penerima
	ADD CONSTRAINT [fk_penerima-transaksi-customer]
	FOREIGN KEY
		(
			idCustomer
		)
	REFERENCES 
		Customer
		(
			idCustomer
		),
	FOREIGN KEY
		(
			idTransaksi
		)
	REFERENCES
		transaksi
		(
			idTransaksi
		)


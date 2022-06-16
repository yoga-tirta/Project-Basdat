<?php
include "config.php";
$result = mysqli_query($mysqli, "SELECT tb_kendaraan.PLAT_KENDARAAN, tb_kendaraan.NAMA_KENDARAAN, tb_pemesanan.STATUS FROM tb_kendaraan	INNER JOIN tb_detail_pemesanan USING (PLAT_KENDARAAN)	INNER JOIN tb_pemesanan USING(ID_PEMESANAN)");

$isi = '';
if (isset($_POST['filter'])) {
  $check = $_POST['filter'];
  if ($check == 'Semua') {
    $result = mysqli_query($mysqli, "SELECT tb_kendaraan.PLAT_KENDARAAN, tb_kendaraan.NAMA_KENDARAAN, tb_pemesanan.STATUS FROM tb_kendaraan	INNER JOIN tb_detail_pemesanan USING (PLAT_KENDARAAN)	INNER JOIN tb_pemesanan USING(ID_PEMESANAN)");
    $isi = $check;
  } else {
    $result = mysqli_query($mysqli, "SELECT tb_kendaraan.PLAT_KENDARAAN, tb_kendaraan.NAMA_KENDARAAN, tb_pemesanan.STATUS FROM tb_kendaraan	INNER JOIN tb_detail_pemesanan USING (PLAT_KENDARAAN)	INNER JOIN tb_pemesanan USING(ID_PEMESANAN)	WHERE tb_pemesanan.STATUS = '$check'	");
    $isi = $check;
  }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tampil Data</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
</head>

<body>
    <div class="container mt-5">
    <form action="" method="POST">
        <select onchange="form.submit()" name="filter">
          <option <?php if ($isi == 'Semua') { echo 'selected'; } ?> >Semua</option>
          <option <?php if ($isi == 'Sedang Sewa') { echo 'selected'; } ?> >Sedang Sewa</option>
          <option <?php if ($isi == 'Telat Di Kembalikan') { echo 'selected'; } ?> >Telat Di Kembalikan</option>
        </select>
      </form>
    <h2 class="text-center">Data Kendaraan Yang Telat Dikembalikan</h2>
    <table class="table mt-2">
    <thead>
      <tr>
          <th scope="col">No</th>
          <th scope="col">Plat Kendaraan</th>
          <th scope="col">Nama</th>
          <th scope="col">Status</th>
      </tr>
    </thead>
    <?php $angka = 1; ?>
    <?php foreach($result as $user_data): ?>
    <tbody>
      <tr>
        <td><?= $angka?></td>
        <td><?= $user_data["PLAT_KENDARAAN"] ?></td>
        <td><?= $user_data["NAMA_KENDARAAN"] ?></td>
        <td><?= $user_data["STATUS"] ?></td>
        <!-- <td><a href="edit.php?nrp=<?= $user_data['nrp'] ?>">Edit</a> | <a href="delete.php?nrp=<?= $user_data['nrp'] ?>">Hapus</a></td> -->
      </tr>
    </tbody>
    <?php $angka++;?>
    <?php endforeach;?>
  </table><br>
</body>
</html>
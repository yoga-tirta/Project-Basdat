<?php
include "config.php";
$result = mysqli_query($mysqli, "SELECT * FROM tb_kendaraan")			;

$isi = '';
if (isset($_POST['filter'])) {
  $check = $_POST['filter'];
  if ($check == 'Semua') {
    $result = mysqli_query($mysqli, "SELECT * FROM tb_kendaraan")			;
    $isi = $check;
  } else {
    $result = mysqli_query($mysqli, "SELECT * FROM tb_kendaraan	WHERE tb_kendaraan.STATUS_KENDARAAN = '$check'");
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
          <option <?php if ($isi == 'Di Sewa') { echo 'selected'; } ?> >Di Sewa</option>
          <option <?php if ($isi == 'Tersedia') { echo 'selected'; } ?> >Tersedia</option>
        </select>
      </form>
    <h2 class="text-center">Data Kendaraan Yang Sedang Dipinjam</h2>

    <table class="table mt-2">
    <thead class="thead-dark">
      <tr>
          <th scope="col">No</th>
          <th scope="col">Plat Kendaraan</th>
          <th scope="col">Nama</th>
          <th scope="col">Type</th>
          <th scope="col">Biaya</th>
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
        <td><?= $user_data["TYPE_KENDARAAN"] ?></td>
        <td><?= $user_data["BIAYA_SEWA"] ?></td>
        <td><?= $user_data["STATUS_KENDARAAN"] ?></td>
        <!-- <td><a href="edit.php?nrp=<?= $user_data['nrp'] ?>">Edit</a> | <a href="delete.php?nrp=<?= $user_data['nrp'] ?>">Hapus</a></td> -->
      </tr>
    </tbody>
    <?php $angka++;?>
    <?php endforeach;?>
  </table><br>
</body>
</html>
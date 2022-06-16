<?php
include "config.php";
$result = mysqli_query($mysqli, "SELECT * FROM tbl_mahasiswa ORDER BY nrp DESC");
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
    <h2 class="text-center">Data Penerimaan Rental</h2>

    <table class="table mt-2">
    <thead>
      <tr>
        <form action="" method="POST">
          <input type="date" name="date1">
          <input type="date" name="date2">
          <button type="submit" name="cari">Cari</button>
        </form>
      </tr>
      <tr>
          <th>No</th>
          <th>Jumlah</th>
          <th>Date 1</th>
          <th>Date 2</th>
      </tr>
    </thead>

    <?php $angka = 1; 
    if(isset($_POST['cari'])){
      $date1 = $_POST['date1']; 
      $date2 = $_POST['date2'];
      $cari =  mysqli_fetch_assoc(mysqli_query($mysqli,"SELECT tb_pembayaran.TGL_PEMBAYARAN, SUM(tb_pembayaran.TOTAL_PEMBAYARAN) AS 'total' FROM tb_pembayaran WHERE tb_pembayaran.TGL_PEMBAYARAN BETWEEN '$date1' AND '$date2'"));
      ?>
    <tbody>
      <tr>
        <td><?= $angka?></td>
        <td><?= $cari['total'] ?></td>
        <td><?= $date1 ?></td>
        <td><?= $date2 ?></td>
      </tr>
    </tbody>
    <?php } ?>
  </table><br>
</body>
</html>
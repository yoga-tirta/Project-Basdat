<?php
include "config.php";
$result = mysqli_query($mysqli, "SELECT tb_user.NAMA, COUNT(tb_pemesanan.ID_USER) AS TotalOrder 				
FROM tb_user INNER JOIN tb_pemesanan USING(ID_USER) 				
GROUP BY tb_user.NAMA ORDER BY TotalOrder DESC LIMIT 1				
");
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
    <h2 class="text-center">Data User Yang Sering Meminjam</h2>

    <table class="table mt-2">
      <thead>
        <tr>
          <th scope="col">No</th>
          <th scope="col">Nama</th>
          <th scope="col">Total Order</th>
        </tr>
      </thead>
    <?php $angka = 1; ?>
    <?php foreach($result as $user_data): ?>
    <tbody>
      <tr>
        <td><?= $angka?></td>
        <td><?= $user_data["NAMA"] ?></td>
        <td><?= $user_data["TotalOrder"] ?></td>
        <!-- <td><a href="edit.php?nrp=<?= $user_data['nrp'] ?>">Edit</a> | <a href="delete.php?nrp=<?= $user_data['nrp'] ?>">Hapus</a></td> -->
      </tr>
    </tbody>
    <?php $angka++;?>
    <?php endforeach;?>
  </table><br>
</body>
</html>
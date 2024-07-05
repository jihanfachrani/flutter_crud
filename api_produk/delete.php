<?php
$koneksi = new mysqli('localhost', 'root', ' ', 'db_produk');
$id_produk = $_POST['id_produk'];

$data = mysqli_query($koneksi, "delete from tb_produk 
where id_produk='$id_produk'");

if ($data){
    echo json_encode([
        'pesan'=>'Sukses Hapus'
    ]);
}else{
    echo json_encode([
        'pesan'=>'Gagal Hapus'
    ]);
}

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: DELETE");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

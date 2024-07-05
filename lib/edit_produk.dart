import 'package:app_produk/halaman_produk.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditProduk extends StatefulWidget {
  final Map ListData;
  const EditProduk({super.key, required this.ListData});

  @override
  State<EditProduk> createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  final formKey = GlobalKey<FormState>();
  TextEditingController id_produk = TextEditingController();
  TextEditingController nama_produk = TextEditingController();
  TextEditingController harga_produk = TextEditingController();

  Future _edit() async {
    final respon = await http
        .post(Uri.parse('http://192.168.1.12/api_produk/edit.php'), body: {
      'id_produk': id_produk.text,
      'nama_produk': nama_produk.text,
      'harga_produk': harga_produk.text,
    });
    if (respon.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    id_produk.text = widget.ListData['id_produk'];
    nama_produk.text = widget.ListData['nama_produk'];
    harga_produk.text = widget.ListData['harga_produk'];
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Update Produk', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                TextFormField(
                  controller: nama_produk,
                  decoration: InputDecoration(
                      hintText: 'Nama Produk',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      )),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Nama produk tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: harga_produk,
                  decoration: InputDecoration(
                      hintText: 'Harga Produk',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      )),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Harga produk tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _edit().then((value) {
                          if (value) {
                            const snackBar = SnackBar(
                              content: Text('Data berhasil diubah'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            const snackBar = SnackBar(
                              content: Text('Data gagal diubah'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        });
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => HalamanProduk())),
                            (route) => false);
                      }
                    },
                    child:
                        Text('Update', style: TextStyle(color: Colors.white)))
              ],
            ),
          )),
    );
  }
}

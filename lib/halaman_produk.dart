import 'dart:convert';

import 'package:app_produk/detail_produk.dart';
import 'package:app_produk/edit_produk.dart';
import 'package:app_produk/tambah_produk.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HalamanProduk extends StatefulWidget {
  const HalamanProduk({super.key});

  @override
  State<HalamanProduk> createState() => _HalamanProdukState();
}

class _HalamanProdukState extends State<HalamanProduk> {
  List _listdata = [];
  bool _loading = true;

  Future _getdata() async {
    try {
      final respon =
          await http.get(Uri.parse('http://192.168.1.12/api_produk/read.php'));
      if (respon.statusCode == 200) {
        final data = jsonDecode(respon.body);
        setState(() {
          _listdata = data;
          _loading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _hapus(String id) async {
    try {
      final respon = await http
          .post(Uri.parse('http://192.168.1.12/api_produk/delete.php'), body: {
        "id_produk": id,
      });
      if (respon.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    _getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Produk', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _listdata.length,
              itemBuilder: ((context, index) {
                return Card(
                    child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailProduk(
                                  ListData: {
                                    'id_produk': _listdata[index]['id_produk'],
                                    'nama_produk': _listdata[index]
                                        ['nama_produk'],
                                    'harga_produk': _listdata[index]
                                        ['harga_produk'],
                                  },
                                )));
                  },
                  child: ListTile(
                    title: Text(_listdata[index]['nama_produk']),
                    subtitle: Text(_listdata[index]['harga_produk']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProduk(
                                            ListData: {
                                              'id_produk': _listdata[index]
                                                  ['id_produk'],
                                              'nama_produk': _listdata[index]
                                                  ['nama_produk'],
                                              'harga_produk': _listdata[index]
                                                  ['harga_produk'],
                                            },
                                          )));
                            },
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: ((context) {
                                    return AlertDialog(
                                      content: Text('Hapus data ini?'),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              _hapus(_listdata[index]
                                                      ['id_produk'])
                                                  .then((value) {
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: ((context) =>
                                                            HalamanProduk())),
                                                    (route) => false);
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.redAccent),
                                            child: Text('Hapus',
                                                style: TextStyle(
                                                    color: Colors.white))),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue),
                                            child: Text('Batal',
                                                style: TextStyle(
                                                    color: Colors.white))),
                                      ],
                                    );
                                  }));
                            },
                            icon: Icon(Icons.delete))
                      ],
                    ),
                  ),
                ));
              }),
            ),
      floatingActionButton: FloatingActionButton(
          child: Text(
            '+',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
          backgroundColor: Colors.deepPurple,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TambahProduk()));
          }),
    );
  }
}

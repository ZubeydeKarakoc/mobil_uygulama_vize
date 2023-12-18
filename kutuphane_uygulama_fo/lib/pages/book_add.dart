import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const List<String> list = <String>[
  'Roman',
  'Tarih',
  'Edebiyat',
  'Şiir',
  'Ansiklopedi',
  'Bilim Teknik'
]; // kategori seçmelinin elemanları burdan belirledim

class BookAddPage extends StatefulWidget {
  const BookAddPage({super.key});

  @override
  State<BookAddPage> createState() => _BookAddPageState();
}

class _BookAddPageState extends State<BookAddPage> {
  bool isChecked = false;
  final bookNameController = TextEditingController();
  final publisherController = TextEditingController();
  final authorsController = TextEditingController();
  final pageCountController = TextEditingController();
  final publicationYearController = TextEditingController();
  // burda metinleri değişkenlere atıyorum
  @override
  Widget build(BuildContext context) {
    ThemeData themData = Theme.of(context);
    String dropdownValue = list.first;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kitap Ekle",
          style: themData.textTheme.titleMedium,
        ), //Yazıyı ortak yer main.dartdan çekiyorum
      ),
      body: SingleChildScrollView(
        // taşmayı engellemesi için sayfayı aşşağa kayabilir yapıyor
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: bookNameController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Kitap Adı',
                ), // TextField güzel gözükmesi için
                // https://docs.flutter.dev/cookbook/forms/text-input burda bulunan
                // urlden ınputdecoration kopyaladım tasarımını özelleştirdim
              ),
              TextField(
                controller: publisherController, 
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Yayınevi',
                ),
              ),
              TextField(
                controller: authorsController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Yazarlar',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownMenu<String>(
                  width: 300,
                  initialSelection: list.first,
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  dropdownMenuEntries:
                      list.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                ),
              ),
              TextField(
                controller: pageCountController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Sayfa Sayısı',
                ),
              ),
              TextField(
                controller: publicationYearController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Basım Yılı',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceAround, //aralarına boşluk veriiyorum burda
                  children: [
                    const Text(
                        'Listede Yayınlanacakmı?'), // row ile yanyana yazıyorum
                    Checkbox(
                      checkColor: Colors.red,
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  FirebaseFirestore.instance.collection('books').add({
                    'bookName': bookNameController.text,
                    'publisher': publisherController.text,
                    'authors': authorsController.text,
                    'pageCount': int.parse(pageCountController.text),
                    'publicationYear':
                        int.parse(publicationYearController.text),
                    'isChecked': isChecked,
                    'category': dropdownValue,
                  });
                }, // burda firebase textfieldleri controlleri ile firebase gönderiyorum
                child: const Text("Kaydet"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

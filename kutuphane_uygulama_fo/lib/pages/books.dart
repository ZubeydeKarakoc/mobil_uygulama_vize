import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kutuphane_uygulama_fo/pages/book_add.dart';

class BooksPage extends StatelessWidget {
  //kitap sınıfı tanımlayıp genişletiyoruz
  const BooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    // kitap ekle butonu eklendi 9 ile 13 satır içinde
    return Scaffold(
      Row(  //Ekle butonu ile aynı hizada olmasını sağlıyor row
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
      const Text('Kitap Eklemek İsterseniz '), //kitap eklemek için yönlendiriyor
      const SizedBox(width: 16),
      floatingActionButton: FloatingActionButton( // ekle butonu
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const BookAddPage()), //Navigator push ile sayfalar arası geçiş yapıyorum
          );
        },
        child: const Icon(Icons.add), //ekle butonunun ikonu      ),
    ),
      appBar: AppBar( //uygulamanın başlıgı
        title: const Text('Zübeyde KARAKOÇ kitaplığı'),
      ),
      body: StreamBuilder<QuerySnapshot>( //StreamBuilderwidget’ı, bir Firebase
        // Firestore veritabanından verileri alıyor
        //streambuilder firebaseden verilerin gelip gelmediğini kontrol ediyor
        stream: FirebaseFirestore.instance.collection('books').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {//verilerin gelip gelmediğini karar yapıları
            // ile kontrol ediliyor
            return const Text('Bir hata oluştu');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Yükleniyor");
          }

          return GridView.builder(//kare görünümü GridView ile oluşturuldu
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //gridDelegate özelliği, ızgara düzenini belirle
              //cok sayıda olabileceği için SliverGridDelegateWithFixedCrossAxisCount
              crossAxisCount: 2, // İki sütunlu bir grid oluşturur
            ),
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return Text(snapshot.data?.docs[index][
                  'bookName']); // 'kitap_adi' Firestore'daki alan adınız olmalıdır
            },
          );
        },
      ),
    );
  }
}

# TUGAS 7
1. Jelaskan apa itu widget tree pada Flutter dan bagaimana hubungan parent-child (induk-anak) bekerja antar widget.
Widget tree adalah strukur pohon dari deklarasi UI kita. Biasanya, root itu MaterialApp dan cabang-cabangnya adalah widget layout/komponen. Flutter akan membangun UI dengan cara merekonstruksi subtree saat ada perubahan.
Hubungan parent childnya:
1. Parent melayout dan memberi warna pada are anak
2. Child menerima constraint dari parent dan mengikuti settingan size parent
3. Child bisa mengakses resource parent/ancestornya

2. Sebutkan semua widget yang kamu gunakan dalam proyek ini dan jelaskan fungsinya.
Scaffold = rangka halaman Material (slot appBar, body, dsb). Ini dipakai sebagai kontainer utama UI.

AppBar = bar atas berisi judul “Football News”.

Padding = memberi ruang tepi (EdgeInsets.all(16) di body, dan EdgeInsets.only(top: 16) untuk teks heading).

Columnn = menata child secara vertikal (utama di body, dan di dalam Center).

Row = menata tiga kartu info (InfoCard) secara horizontal di bagian atas.

Center = memusatkan kolom konten utama (judul + grid).

SizedBox = jarak vertikal (height: 16) antara baris InfoCard dan konten berikutnya.

GridView.count = menampilkan daftar ItemCard dalam grid 3 kolom. Kita set shrinkWrap: true biar tinggi menyesuaikan konten.

Text = menampilkan teks statis (judul AppBar, heading “Selamat datang…”, label pada kartu).

Icon = menampilkan ikon pada ItemCard (ikon dari Icons.*).

Card = tampilan kartu Material untuk InfoCard (dengan elevation: 2).

Container = pembungkus serbaguna untuk ukuran, padding, dan styling (dipakai di ItemCard dan InfoCard).

3. Apa fungsi dari widget MaterialApp? Jelaskan mengapa widget ini sering digunakan sebagai widget root.
Fungsinya :
- Registrasi navigator dan route
- Menyediakan tema,localization,textdirection,mediaquery awal
- jadi ancestor untuk lookup berbasis BuildContext
Sering digunakan sebagai root karena dia langsung memasang default wiring aplikasi Material. Tanpa Material itu maka banyak API yang tidak tersedia. Selain itu, dia juga menstsandarkan perilaku UI lintas halaman aplikasinya.

4. Jelaskan perbedaan antara StatelessWidget dan StatefulWidget. Kapan kamu memilih salah satunya?
Stateless Widget = 
- Imutabel
- Sumber perubahan UI dari ancestors
- Biasanya lebih cocok untuk Icon, teks statis, card presentasional, pure render
Stateful Widget=
- Ada State<T> dan bisa berubah
- Perubahan UI nya via internal dengan setState,stream,controller
- Cocoknya untuk form input, animasi, tab controller, fetch data lalu update UI
Kita akan menggunakan stateful ketika kita butuh data dinamis pada grid/menu, controlelr/listener yang perlu dikelola terus menerus, form input, dan caching kecil di sisi UI. Kita akan gunakan stateless kalau kita hanya butuh komponen presentasional yang hanya render title dan content, ItemCard yang fungsinya sekedar tampil + kirim event, halaman statis dengan teks/ikon yang tidak terlalu berubah.

5. Apa itu BuildContext dan mengapa penting di Flutter? Bagaimana penggunaannya di metode build?
BuildContext itu “alamat” sebuah widget di dalam pohon widget. Dengan alamat ini, widget bisa “mengintip” ke atas untuk ambil layanan dari ancestor, seperti Theme, MediaQuery, Navigator, dan ScaffoldMessenger. Di kodenmu, kamu pakai Theme.of(context).colorScheme.primary untuk warna AppBar dan MediaQuery.of(context).size.width untuk lebar InfoCard. Keduanya jalan karena konteksnya berada di bawah penyedia Theme dan MediaQuery.

Penting menjaga scope. Panggil ScaffoldMessenger.of(context) dari konteks yang berada di dalam Scaffold supaya snackbar muncul. Jika butuh konteks yang lebih “dekat” ke widget tertentu, pisahkan jadi widget kecil atau gunakan Builder agar konteksnya tepat. Hindari menyimpan context untuk dipakai lama setelah build, terutama setelah widget dibuang.

6. Jelaskan konsep "hot reload" di Flutter dan bagaimana bedanya dengan "hot restart".
Hot reload menyuntik perubahan kode tanpa mereset aplikasi. State yang sedang aktif tetap ada. Cocok saat kita mengubah tampilan, teks, padding, warna, atau handler tap sederhana. Iterasi cepat karena kamu tidak kehilangan posisi UI atau nilai yang sedang tampil.

Hot restart memulai ulang aplikasi dari awal. Semua state direset dan main() dieksekusi ulang. Kita pilih ini saat mengubah inisialisasi global, struktur root, daftar route, dependency, atau ketika hasil hot reload terasa tidak sinkron. Aturan praktisnya sederhana. Perubahan kosmetik atau logika lokal pakai hot reload. Perubahan fundamental atau gejala “state nyangkut” pakai hot restart.
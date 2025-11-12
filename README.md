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

Hot restart memulai ulang aplikasi dari awal. Semua state direset dan main() dieksekusi ulang. Kita pilih ini saat mengubah inisialisasi global, struktur root, daftar route, dependency, atau ketika hasil hot reload terasa tidak sinkron. Aturan praktisnya sederhana. Perubahan kosmetik atau logika lokal pakai hot reload. Perubahan fundamental atau gejala "state nyangkut" pakai hot restart.

# TUGAS 8

1. Jelaskan perbedaan antara Navigator.push() dan Navigator.pushReplacement() pada Flutter. Dalam kasus apa sebaiknya masing-masing digunakan pada aplikasi Football Shop kamu?

Navigator.push() menambahkan route baru ke stack navigasi tanpa menghapus route sebelumnya. Pengguna dapat kembali ke halaman sebelumnya dengan tombol back. Di aplikasi Football Shop, saya menggunakan Navigator.push() ketika navigasi dari halaman utama ke form tambah produk (ProductFormPage), karena pengguna mungkin ingin kembali ke halaman utama setelah mengisi atau membatalkan form.

Navigator.pushReplacement() menggantikan route saat ini dengan route baru, sehingga route lama dihapus dari stack dan pengguna tidak bisa kembali ke halaman sebelumnya dengan tombol back. Di aplikasi Football Shop, saya menggunakan Navigator.pushReplacement() pada drawer ketika memilih opsi "Halaman Utama", karena ini menggantikan halaman saat ini dengan halaman utama dan tidak perlu ada history sebelumnya.

Kasus penggunaan:
- Navigator.push(): Ketika menekan tombol "Create Product" di halaman utama atau memilih "Tambah Produk" di drawer, karena pengguna bisa kembali ke halaman sebelumnya.
- Navigator.pushReplacement(): Ketika memilih "Halaman Utama" di drawer dari halaman form, karena ini adalah navigasi utama dan tidak perlu bisa kembali ke form setelahnya.

2. Bagaimana kamu memanfaatkan hierarchy widget seperti Scaffold, AppBar, dan Drawer untuk membangun struktur halaman yang konsisten di seluruh aplikasi?

Scaffold, AppBar, dan Drawer membentuk struktur dasar yang konsisten di seluruh aplikasi Football Shop:

Scaffold digunakan sebagai widget root untuk setiap halaman (MyHomePage dan ProductFormPage). Scaffold menyediakan struktur Material Design yang konsisten dengan slot untuk AppBar, body, dan drawer.

AppBar digunakan di semua halaman dengan styling yang konsisten:
- Judul "Football Shop" di halaman utama dan "Tambah Produk" di form
- Warna latar belakang menggunakan Theme.of(context).colorScheme.primary untuk konsistensi tema
- Teks putih dengan fontWeight bold untuk readability

Drawer (LeftDrawer) digunakan di semua halaman melalui property drawer di Scaffold. Drawer menyediakan navigasi yang konsisten dengan:
- DrawerHeader dengan branding "Football Shop" dan warna primary
- ListTile untuk "Halaman Utama" dan "Tambah Produk" dengan ikon yang sesuai
- Navigasi yang konsisten menggunakan Navigator.pushReplacement() untuk Home dan Navigator.push() untuk Form

Dengan struktur ini, setiap halaman memiliki:
- AppBar yang konsisten di bagian atas
- Drawer yang dapat diakses dari hamburger menu
- Body yang fleksibel untuk konten spesifik halaman

Hal ini memastikan pengalaman pengguna yang konsisten dan navigasi yang mudah di seluruh aplikasi.

3. Dalam konteks desain antarmuka, apa kelebihan menggunakan layout widget seperti Padding, SingleChildScrollView, dan ListView saat menampilkan elemen-elemen form? Berikan contoh penggunaannya dari aplikasi kamu.

Padding memberikan ruang kosong di sekeliling widget, meningkatkan readability dan visual hierarchy. Di aplikasi Football Shop, saya menggunakan Padding di:
- Setiap field form (TextFormField, DropdownButtonFormField, SwitchListTile) dengan EdgeInsets.all(8.0) untuk memberikan spacing yang konsisten antar elemen form
- Body halaman utama dengan EdgeInsets.all(16.0) untuk memberikan margin dari tepi layar

SingleChildScrollView memungkinkan konten dapat di-scroll ketika konten melebihi tinggi layar. Ini sangat penting untuk form yang panjang. Di ProductFormPage, saya membungkus Column yang berisi semua field form dengan SingleChildScrollView, sehingga ketika keyboard muncul atau pada layar kecil, pengguna dapat scroll untuk mengakses semua field form tanpa terpotong.

ListView digunakan untuk menampilkan list item yang dapat di-scroll secara efisien. Di LeftDrawer, saya menggunakan ListView untuk menampilkan DrawerHeader dan ListTile items. ListView lebih efisien daripada Column karena hanya me-render item yang terlihat di layar, dan secara otomatis menangani scrolling.

Kelebihan kombinasi ini:
- Padding: Memastikan spacing yang konsisten dan tidak terlalu rapat
- SingleChildScrollView: Memastikan form tetap dapat diakses di semua ukuran layar
- ListView: Efisien untuk list yang panjang dan menangani scrolling dengan baik

4. Bagaimana kamu menyesuaikan warna tema agar aplikasi Football Shop memiliki identitas visual yang konsisten dengan brand toko?

Saya menyesuaikan warna tema di MaterialApp (lib/main.dart) menggunakan ColorScheme.fromSwatch dengan primarySwatch Colors.blue. Warna ini kemudian digunakan secara konsisten di seluruh aplikasi melalui Theme.of(context).colorScheme.primary.

Konsistensi warna di seluruh aplikasi:
- AppBar backgroundColor: Theme.of(context).colorScheme.primary (biru)
- Drawer header backgroundColor: Theme.of(context).colorScheme.primary (biru)
- Tombol "Simpan" di form: Theme.of(context).colorScheme.primary (biru)
- Semua elemen menggunakan warna dari tema yang sama

Keuntungan menggunakan hal ini:
1. Konsistensi: Semua warna berasal dari satu sumber tema sehingga perubahan warna hanya perlu dilakukan di satu tempat (MaterialApp)
2. Mudah diubah: Jika ingin mengubah identitas warna (misalnya ke hijau untuk sepak bola), cukup ubah primarySwatch di MaterialApp
3. Material Design: Mengikuti best practice Material Design dengan menggunakan ColorScheme
4. Accessibility: Flutter secara otomatis menyesuaikan warna kontras untuk readability

import 'package:get/get.dart';

/// Central translation table for the app.
///
/// English is the default/fallback language. Bahasa Indonesia is used when
/// the device language is Indonesian or when the user selects it in Settings.
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': _en,
        'id': _id,
      };

  static const Map<String, String> _en = {
    'app_name': 'KidScale',
    'version_prefix': 'Version',
    'warning': 'Warning',
    'error': 'Error',
    'success': 'Success',
    'cancel': 'Cancel',
    'close': 'Close',
    'ok': 'OK',
    'yes': 'Yes',
    'no': 'No',
    'delete': 'Delete',
    'delete_child_message': 'Delete this child and all of its growth records?',
    'delete_growth_message': 'Delete this growth record?',
    'complete_form_message': 'Please complete the form first.',
    'save': 'Save',
    'validation_required': 'This field is required',
    'validation_number': 'Please enter a valid number',
    'validation_date': 'Please choose a valid date',
    'validation_future_date': 'Birth date cannot be in the future',
    'validation_date_future': 'Date cannot be in the future',
    'validation_select_option': 'Please select one of the options',
    'save_failed': 'Could not save the data. Please try again.',
    'update': 'Update',
    'choose': 'Choose',
    'search': 'Search',
    'all': 'All',
    'login': 'Login',
    'logout': 'Logout',
    'register': 'Register',
    'language': 'Language',
    'language_system': 'System Default',
    'language_english': 'English',
    'language_indonesian': 'Bahasa Indonesia',
    'language_changed': 'Language changed successfully',

    // Welcome / Login / Verification
    'welcome_title': 'Welcome to KidScale',
    'register_new_account': 'Create New Account',
    'login_with_email': 'Sign in with Email',
    'email': 'Email',
    'no_account': "Don't have an account? ",
    'need_help': 'Need help?',
    'verification': 'Verification',
    'verification_instruction':
        'Enter the verification code that was sent to your email. Please check!',
    'verification_code': 'Verification Code',
    'did_not_receive_code': "Didn't receive a verification code? ",
    'verification_incomplete': 'Verification code is incomplete',

    // Settings
    'profile': 'Profile',
    'terms_conditions': 'Terms and Conditions',
    'about_app': 'About App',
    'about_this_app': 'About KidScale',
    'logout_confirm': 'Are you sure you want to logout?',

    // Register
    'register_account': 'Register Account',
    'phone_number': 'Phone Number',
    'phone_number_hint': 'Enter your phone number',
    'email_hint': 'Enter your email address',
    'terms_prefix': 'I have read and agree to the ',
    'terms_link': 'Terms & Conditions',
    'terms_suffix': ' from the KidScale Team.',
    'fill_required_fields':
        'Please check the empty fields or you have not accepted the terms and conditions',

    // Static pages
    'terms_full_title': 'KidScale Terms and Conditions of Use',
    'terms_last_updated': 'Last updated: 14 November 2026',
    'terms_content': '''
## 1. Acceptance of Terms

By using KidScale, you agree to these Terms and Conditions. If you do not agree, please do not use the app.

## 2. About KidScale

KidScale is a child growth and immunization tracking app for parents and caregivers. It is built on official growth and immunization guidelines from the Indonesian Pediatric Society (IDAI). KidScale is not directly supervised or endorsed by IDAI.

## 3. Reference and Education Only

KidScale is for reference and education only. It does not provide medical advice, diagnosis, or treatment. Growth measurements, percentiles, and immunization information are aids and may not be complete or suitable for every child. Always consult a doctor, pediatrician, or official health service for accurate advice about your child. In an emergency, contact your local emergency services.

## 4. Your Responsibilities

You are responsible for the accuracy of the information you enter and for how you use the app. Keep your device and data secure, use KidScale as a supplement to — not a replacement for — professional medical care, and do not use the app to diagnose or treat any condition.

## 5. Data and Privacy

The information you enter is primarily stored on your device. We do not sell your personal data. If you use online features, limited technical data may be processed to provide those features. You are responsible for backing up your data. Uninstalling the app or clearing its storage may delete local data permanently.

## 6. Content and Intellectual Property

The KidScale name, logo, design, and content are owned by KidScale and its licensors. IDAI guidelines are referenced for informational purposes only and do not imply a partnership or endorsement. Do not copy, modify, or redistribute the app or its content without permission.

## 7. Availability and Changes

We may change, suspend, or discontinue features at any time. The app is provided "as is" and "as available", without a guarantee of uninterrupted or error-free operation. We may update these Terms; continued use after an update means you accept the revised Terms.

## 8. Limitation of Liability

To the maximum extent permitted by law, KidScale and its team are not liable for indirect or incidental damages, or for decisions or medical outcomes resulting from use of the app. Nothing in these Terms limits liability that cannot be limited by law.

## 9. Contact

Questions about these Terms? Email {email} or visit {website}.
''',
    'about_description':
        'KidScale helps parents record and understand their child\'s growth and vaccination journey in one simple place. Track weight, height and head circumference, follow the national immunization schedule, and see growth trends over time. All data stays on your device — no account is needed.',
    'website': 'Website',
    'about_disclaimer':
        'KidScale is built on official growth and immunization guidelines from the Indonesian Pediatric Society (IDAI). KidScale is not directly supervised or endorsed by IDAI. This app is for reference and education only, not a medical diagnosis. For accurate advice about your child, always consult a doctor, pediatrician, or official health service.',

    // Notifications / Consultation
    'notifications': 'Notifications',
    'no_notifications': 'No notifications yet',
    'consultation': 'Consultation',

    // Articles
    'articles': 'Articles',
    'search_articles': 'Search Articles',
    'author_by': 'Written by @author',
    'failed': 'Failed',
    'pdf_download_failed':
        'Could not download the reference document. Check your connection.',

    // Vaccination
    'vaccine_added_success': 'Vaccination data added successfully',
    'vaccine_added_failed': 'Failed to add vaccination data',

    // Child profile form
    'edit_child_account': 'Edit Child Account',
    'set_profile': 'Set Your Profile',
    'upload_photo': 'Select Photo',
    'full_name': 'Full Name',
    'child_name_hint': 'Enter your child\'s name',
    'birth_date': 'Date of Birth',
    'gender': 'Gender',
    'male': 'Male',
    'female': 'Female',
    'birth_data': 'Birth Data',
    'is_premature': 'Was your child born prematurely?',
    'birth_weight_label': 'Birth Weight (kg)',
    'birth_weight_hint': 'Enter weight in Kg',
    'birth_height_label': 'Birth Height (Cm)',
    'birth_height_hint': 'Enter height in cm',
    'birth_head_label': 'Head Circumference at Birth (Cm)',
    'additional_profile': 'Additional Profile',
    'blood_group': 'Blood Type',
    'select_blood_group': 'Select Blood Type',
    'has_allergy': 'Does your child have any allergies?',
    'parent_height': 'Parents Height',
    'parent_height_note':
        'Note: Parents height data will be used to measure the child\'s potential adult height',
    'mother_height': 'Mother\'s Height (Cm)',
    'father_height': 'Father\'s Height (Cm)',

    // Parent profile form
    'upload_your_photo': 'Upload Your Photo',
    'parent_full_name': 'Parent\'s Full Name',
    'parent_full_name_hint': 'Enter parent\'s name',
    'province': 'Province',
    'select_province': 'No province selected',
    'city': 'City/Regency',
    'select_city': 'No city/regency selected',
    'district': 'District',
    'select_district': 'No district selected',
    'village': 'Village',
    'select_village': 'No village selected',
    'address': 'Address',
    'address_hint': 'Enter address',
    'education': 'Education',
    'select_last_education': 'Select Last Education',
    'edu_sd': 'Elementary School',
    'edu_smp': 'Junior High School',
    'edu_sma': 'Senior High School',
    'edu_s1': 'Bachelor\'s Degree',
    'edu_s2': 'Master\'s Degree',
    'edu_s3': 'Doctorate',
    'occupation': 'Occupation',
    'select_occupation': 'Select Occupation',
    'civil_servant': 'Civil Servant',
    'entrepreneur': 'Entrepreneur',
    'private_employee': 'Private Employee',
    'income': 'Income',
    'income_hint': 'Enter per capita income',

    // Home
    'no_video_data': 'No Video Data',
    'recommended_articles': 'Recommended Articles',
    'no_child_profile': 'You do not have a child profile yet',
    'add': 'Add',
    'greeting': 'Hi, @name',
    'greeting_parent': 'Hello, Parent!',
    'age_years': '@count years ',
    'age_months': '@count months ',
    'age_days': '@count days',
    'child_profile': 'Child Profile',
    'add_child_profile': 'Add Child Profile',
    'see_all': 'See All',
    'category': 'Category',

    'app_tagline': 'Healthy growth for happy little ones',
    'nav_home': 'Home',
    'nav_settings': 'Settings',
    'quick_add': 'Add',
    'quick_actions': 'Quick Actions',
    'latest_measurement': 'Latest Measurement',
    'no_measurement': 'No measurements yet',
    'add_measurement': 'Add Measurement',
    'growth_trend': 'Growth Trend',
    'last_measured': 'Last measured @date',
    'no_history': 'No measurement history yet',
    'vaccination_progress': 'Vaccination Progress',
    'completed': 'completed',
    'growth_status': 'Growth Status',
    'all_children': 'All children',
    'select_child': 'Select child',
    'read_more': 'Read more',
    'retry': 'Retry',
    'back': 'Back',
    'help_support': 'Help & Support',
    'contact_us': 'Contact us',
    'about_health_tip': 'Daily healthy habit',
    'health_tip':
        'Weigh and measure your little one regularly so growth changes are caught early.',
    'no_articles': 'No articles available right now',
    'measurement_date': 'Measurement date',
    'measurement_note': 'Measurement note',
    'optional': 'Optional',
    'photo': 'Photo',
    'change_photo': 'Change photo',
    'personal_information': 'Personal information',
    'birth_information': 'Birth information',
    'parent_information': 'Parent information',
    'account_settings': 'Account settings',
    'preferences': 'Preferences',
    'general': 'General',
    'support': 'Support',
    'vaccines_completed': '@done of @total vaccines completed',
    'next_vaccine': 'Next vaccine',
    'no_upcoming_vaccine': 'All scheduled vaccines are up to date',
    'summary': 'Summary',
    'overview': 'Overview',
    'details': 'Details',
    'saved': 'Saved successfully',
    'child_added_success': 'New child added successfully',
    'growth_added_success': 'Growth data added successfully',
    'coming_soon': 'Coming soon',

    // Child detail
    'child_book': 'Child Book',
    'age_years_months': '@years years @months months',
    'age_months_only': '@count months',
    'growth_results': 'Growth Results',
    'weight': 'Weight',
    'height': 'Height',
    'head_circumference': 'Head Circ.',
    'head_short': 'Head',
    'last_update': 'Last Update',
    'update_growth': 'Update Growth',
    'vaccination': 'Vaccination',
    'see_detail': 'See Detail',
    'vaccination_schedule': 'Vaccination Schedule',
    'vaccination_schedule_hint':
        'Tap a vaccine to record or update its vaccination details.',
    'growth_history': 'Growth',
    'child_growth_history': 'Child Growth History',

    // Growth
    'add_growth_data': 'Add Growth Data',
    'growth_date': 'Growth Date',
    'weight_kg': 'Weight (kg)',
    'height_cm': 'Height (cm)',
    'head_cm': 'Head Circumference (cm)',
    'example_weight': 'Example: 3.5',
    'example_height': 'Example: 40.8',
    'add_growth': 'Add Growth',
    'latest': 'Latest',
    'sort_newest': 'Newest first',
    'sort_oldest': 'Oldest first',
    'newest': 'Newest',
    'growth_detail': 'Growth Detail',
    'growth_date_label': 'Growth Date: ',
    'child_age_label': 'Child Age: ',
    'weight_label': 'Weight: ',
    'height_label': 'Height: ',
    'head_label': 'Head Circumference: ',
    'growth_status_weight': 'Weight Growth Status based on WHO standard: ',
    'growth_status_height': 'Height Growth Status based on WHO standard: ',
    'growth_status_head':
        'Head Circumference Growth Status based on WHO standard: ',
    'keep_healthy_note': 'Note: Keep your child healthy',
    'consult_note': 'Note: Please consult your local health worker',
    'status_gizi_buruk': 'Severely underweight',
    'status_gizi_kurang': 'Underweight',
    'status_gizi_baik': 'Normal weight',
    'status_gizi_lebih': 'Overweight',
    'status_sangat_pendek': 'Severely stunted',
    'status_pendek': 'Stunted',
    'status_tinggi_normal': 'Normal height',
    'status_tinggi': 'Tall',
    'status_mikrosefali': 'Microcephaly',
    'status_lingkar_normal': 'Normal head circumference',
    'status_tidak_ada': 'No reference data',
    'status_short_sangat_pendek': 'Stunting',
    'status_short_tinggi_normal': 'Normal',
    'status_short_lingkar_normal': 'Normal',
    'status_short_tidak_ada': 'No data',

    // Immunization / Vaccination schedule
    'immunization': 'Immunization',
    'recommended_on': 'Recommended on',
    'recommended_on_period': 'Recommended on ',
    'status_done': 'Done',
    'status_not_yet': 'Not Yet',
    'document': 'Document',
    'how_to_read_age_column': 'How to read the age column',
    'age_column_example':
        'e.g. 2 means 2 months (60 days) up to 2 months 29 days (89 days)',
    'child_age': 'Your little one\'s age',
    'primary': 'Primary',
    'catch_up': 'Catch-up',
    'booster': 'Booster',
    'endemic_area': 'Endemic Area',
    'view_type': 'View Type',
    'add_child_vaccination': 'Add Child Vaccination',
    'vaccination_date': 'Vaccination Date',
    'doctor_name': 'Doctor Name',
    'place': 'Place',
    'place_name': 'Place Name',
    'edit_vaccination_status': 'Edit Vaccination Status',
    'recommended_date': 'Recommended Date',
    'hep_b_description': 'Prevents Hepatitis B, which can cause liver damage',
    'see_more': 'See More',
    'vaccination_status': 'Vaccination Status',
    'edit_status': 'Edit Status',
    'no_vaccination_schedule': 'No vaccination schedule yet',
    'no_vaccination_record': 'No vaccination record yet',
    'no_vaccination_record_message':
        'Record the date, doctor and place after your little one is vaccinated.',
    'vaccination_details': 'Vaccination details',
    'update_vaccination': 'Update vaccination',
    'mark_not_done': 'Mark as not done',
    'mark_not_done_confirm':
        'Remove the recorded data for this vaccine? The schedule will show it as not done again.',
    'mark_not_done_success': 'Vaccination marked as not done',
    'no_batch': 'Batch number',
    'select_date': 'Select date',
    'vaccination_photo_hint':
        'Attach a photo of the vaccination book as a keepsake and proof.',
    'take_photo': 'Take a photo',
    'choose_from_gallery': 'Choose from gallery',
    'document_load_failed': 'Could not display the document.',

    'upgrade_membership': 'Upgrade Membership Level ',
    'child_age_zero': '0 Years 0 Months',

    // ==EN_END==
  };

  static const Map<String, String> _id = {
    'app_name': 'KidScale',
    'version_prefix': 'Versi',
    'warning': 'Peringatan',
    'error': 'Kesalahan',
    'success': 'Berhasil',
    'cancel': 'Batal',
    'close': 'Tutup',
    'ok': 'OK',
    'yes': 'Ya',
    'no': 'Tidak',
    'delete': 'Hapus',
    'delete_child_message':
        'Hapus anak ini beserta seluruh catatan pertumbuhannya?',
    'delete_growth_message': 'Hapus catatan pertumbuhan ini?',
    'complete_form_message': 'Mohon lengkapi formulir terlebih dahulu.',
    'save': 'Simpan',
    'validation_required': 'Wajib diisi',
    'validation_number': 'Masukkan angka yang valid',
    'validation_date': 'Pilih tanggal yang valid',
    'validation_future_date': 'Tanggal lahir tidak boleh di masa depan',
    'validation_date_future': 'Tanggal tidak boleh di masa depan',
    'validation_select_option': 'Silakan pilih salah satu',
    'save_failed': 'Gagal menyimpan data. Silakan coba lagi.',
    'update': 'Update',
    'choose': 'Pilih',
    'search': 'Cari',
    'all': 'Semua',
    'login': 'Masuk',
    'logout': 'Keluar',
    'register': 'Daftar',
    'language': 'Bahasa',
    'language_system': 'Ikuti Sistem',
    'language_english': 'English',
    'language_indonesian': 'Bahasa Indonesia',
    'language_changed': 'Bahasa berhasil diubah',

    // Welcome / Login / Verification
    'welcome_title': 'Selamat Datang di KidScale',
    'register_new_account': 'Daftar Akun Baru',
    'login_with_email': 'Masuk Dengan Email',
    'email': 'Email',
    'no_account': 'Belum memiliki akun? ',
    'need_help': 'Butuh Bantuan ?',
    'verification': 'Verifikasi',
    'verification_instruction':
        'Masukkan Code Verifikasi yang telah dikirim Ke Email Anda. Silahkan cek!',
    'verification_code': 'Kode Verifikasi',
    'did_not_receive_code': 'Tidak Menerima Kode Verifikasi? ',
    'verification_incomplete': 'Kode Verifikasi Belum Lengkap',

    // Settings
    'profile': 'Profil',
    'terms_conditions': 'Syarat dan Ketentuan',
    'about_app': 'Tentang Aplikasi',
    'about_this_app': 'Tentang KidScale',
    'logout_confirm': 'Apakah anda yakin ingin keluar?',

    // Register
    'register_account': 'Daftar Akun',
    'phone_number': 'Nomor HP',
    'phone_number_hint': 'Masukkan Nomor HP Anda',
    'email_hint': 'Masukkan alamat email Anda',
    'terms_prefix': 'Saya telah membaca dan menyetujui ',
    'terms_link': 'Syarat & Ketentuan',
    'terms_suffix': ' dari Tim KidScale.',
    'fill_required_fields':
        'Cek Kembali field yang kosong atau anda belum menerima syarat dan ketentuan',

    // Static pages
    'terms_full_title': 'Syarat dan Ketentuan penggunaan KidScale',
    'terms_last_updated': 'Terakhir diperbarui: 14 November 2026',
    'terms_content': '''
## 1. Penerimaan Syarat

Dengan menggunakan KidScale, Anda menyetujui Syarat dan Ketentuan ini. Jika Anda tidak setuju, mohon jangan menggunakan aplikasi.

## 2. Tentang KidScale

KidScale adalah aplikasi pemantau tumbuh kembang dan imunisasi anak untuk orang tua dan pengasuh. Aplikasi ini dibangun berdasarkan pedoman pertumbuhan dan imunisasi resmi dari Ikatan Dokter Anak Indonesia (IDAI). KidScale tidak diawasi secara langsung dan tidak merupakan dukungan resmi dari IDAI.

## 3. Hanya untuk Referensi dan Edukasi

KidScale hanya untuk referensi dan edukasi. Aplikasi ini tidak memberikan saran medis, diagnosis, atau pengobatan. Pengukuran pertumbuhan, persentil, dan informasi imunisasi merupakan alat bantu dan mungkin tidak lengkap atau tidak sesuai untuk setiap anak. Selalu konsultasikan dengan dokter, dokter anak, atau layanan kesehatan resmi untuk saran yang akurat mengenai anak Anda. Dalam keadaan darurat, hubungi layanan gawat darurat setempat.

## 4. Tanggung Jawab Anda

Anda bertanggung jawab atas keakuratan informasi yang Anda masukkan dan cara Anda menggunakan aplikasi. Jaga keamanan perangkat dan data Anda, gunakan KidScale sebagai pelengkap — bukan pengganti — perawatan medis profesional, dan jangan gunakan aplikasi ini untuk mendiagnosis atau mengobati kondisi apa pun.

## 5. Data dan Privasi

Informasi yang Anda masukkan terutama disimpan di perangkat Anda. Kami tidak menjual data pribadi Anda. Jika Anda menggunakan fitur online, data teknis terbatas dapat diproses untuk menyediakan fitur tersebut. Anda bertanggung jawab untuk mencadangkan data Anda. Menghapus aplikasi atau menghapus penyimpanannya dapat menghapus data lokal secara permanen.

## 6. Konten dan Hak Kekayaan Intelektual

Nama, logo, desain, dan konten KidScale dimiliki oleh KidScale dan pemberi lisensinya. Pedoman IDAI hanya dirujuk untuk tujuan informasi dan tidak menyiratkan kemitraan atau dukungan resmi. Jangan menyalin, mengubah, atau mendistribusikan aplikasi atau kontennya tanpa izin.

## 7. Ketersediaan dan Perubahan

Kami dapat mengubah, menangguhkan, atau menghentikan fitur kapan saja. Aplikasi disediakan "sebagaimana adanya" dan "sebagaimana tersedia", tanpa jaminan operasi yang tidak terputus atau bebas kesalahan. Kami dapat memperbarui Syarat ini; penggunaan berkelanjutan setelah pembaruan berarti Anda menyetujui Syarat yang direvisi.

## 8. Batasan Tanggung Jawab

Sejauh diizinkan oleh hukum, KidScale dan timnya tidak bertanggung jawab atas kerugian tidak langsung atau insidental, atau atas keputusan atau hasil medis yang timbul dari penggunaan aplikasi. Tidak ada bagian dari Syarat ini yang membatasi tanggung jawab yang tidak dapat dibatasi oleh hukum.

## 9. Kontak

Ada pertanyaan tentang Syarat ini? Email {email} atau kunjungi {website}.
''',
    'about_description':
        'KidScale membantu orang tua mencatat dan memahami perjalanan tumbuh kembang serta imunisasi anak dalam satu tempat yang sederhana. Pantau berat badan, tinggi badan, dan lingkar kepala, ikuti jadwal imunisasi nasional, dan lihat tren pertumbuhan dari waktu ke waktu. Semua data tersimpan di perangkat Anda — tanpa perlu akun.',
    'website': 'Situs Web',
    'about_disclaimer':
        'KidScale dibangun berdasarkan pedoman pertumbuhan dan imunisasi resmi dari Ikatan Dokter Anak Indonesia (IDAI). KidScale tidak diawasi secara langsung dan tidak merupakan dukungan resmi dari IDAI. Aplikasi ini hanya untuk referensi dan edukasi, bukan diagnosis medis. Untuk saran yang akurat mengenai anak Anda, selalu konsultasikan dengan dokter, dokter anak, atau layanan kesehatan resmi.',

    // Notifications / Consultation
    'notifications': 'Notifikasi',
    'no_notifications': 'Belum ada notifikasi',
    'consultation': 'Konsultasi',

    // Articles
    'articles': 'Artikel',
    'search_articles': 'Cari Artikel',
    'author_by': 'Ditulis Oleh @author',
    'failed': 'Gagal',
    'pdf_download_failed':
        'Gagal mengunduh dokumen referensi. Periksa koneksi Anda.',

    // Vaccination
    'vaccine_added_success': 'Data vaksinasi berhasil ditambahkan',
    'vaccine_added_failed': 'Anda gagal menambahkan data vaksinasi',

    // Child profile form
    'edit_child_account': 'Edit Akun Anak',
    'set_profile': 'Set Profile Anda',
    'upload_photo': 'Pilih Foto',
    'full_name': 'Nama Lengkap',
    'child_name_hint': 'Masukkan nama anak',
    'birth_date': 'Tanggal Lahir',
    'gender': 'Jenis Kelamin',
    'male': 'Laki-Laki',
    'female': 'Perempuan',
    'birth_data': 'Data Kelahiran',
    'is_premature': 'Apakah anak anda lahir prematur',
    'birth_weight_label': 'Input Berat Badan Saat Lahir (kg)',
    'birth_weight_hint': 'Input Berat Badan dalam Kg',
    'birth_height_label': 'Tinggi Badan Saat Lahir (Cm)',
    'birth_height_hint': 'Masukkan tinggi badan dalam cm',
    'birth_head_label': 'Input Lingkar Kepala Saat Lahir (Cm)',
    'additional_profile': 'Profil Tambahan',
    'blood_group': 'Golongan Darah',
    'select_blood_group': 'Pilih Golongan Darah',
    'has_allergy': 'Apakah anak anda Mempunyai Alergi',
    'parent_height': 'Tinggi Badan Orang Tua',
    'parent_height_note':
        'Keterangan: Data tinggi badang orang tua akan digunakan untuk mengukur potensial tinggi badan anak saat dewasa',
    'mother_height': 'Tinggi Badan Ibu (Cm)',
    'father_height': 'Tinggi Badan Ayah (Cm)',

    // Parent profile form
    'upload_your_photo': 'Unggah Foto Anda',
    'parent_full_name': 'Nama Lengkap Orang tua',
    'parent_full_name_hint': 'Masukkan Nama Orang tua',
    'province': 'Provinsi',
    'select_province': 'Belum Memilih Provinsi',
    'city': 'Kota/Kabupaten',
    'select_city': 'Belum Memilih Kota/Kabupaten',
    'district': 'Kecamatan',
    'select_district': 'Belum Memilih Kecamatan',
    'village': 'Kelurahan/Desa',
    'select_village': 'Belum Memilih Kelurahan/Desa',
    'address': 'Alamat',
    'address_hint': 'Masukkan Alamat',
    'education': 'Pendidikan',
    'select_last_education': 'Pilih Pendidikan Terakhir',
    'edu_sd': 'SD',
    'edu_smp': 'SMP',
    'edu_sma': 'SMA',
    'edu_s1': 'S1',
    'edu_s2': 'S2',
    'edu_s3': 'S3',
    'occupation': 'Pekerjaan',
    'select_occupation': 'Pilih Pekerjaan',
    'civil_servant': 'PNS',
    'entrepreneur': 'Wiraswasta',
    'private_employee': 'Swasta',
    'income': 'Pendapatan',
    'income_hint': 'Masukkan Pendapatan Perkapita',

    // Home
    'no_video_data': 'Tidak Ada Data Video',
    'recommended_articles': 'Rekomendasi Artikel',
    'no_child_profile': 'Saat ini Anda belum Mempunyai Profil anak',
    'add': 'Tambah',
    'greeting': 'Hai, @name',
    'greeting_parent': 'Halo, Parent!',
    'age_years': '@count tahun ',
    'age_months': '@count bulan ',
    'age_days': '@count hari',
    'child_profile': 'Profil Anak',
    'add_child_profile': 'Tambah Profil Anak',
    'see_all': 'Lihat Semua',
    'category': 'Kategori',

    'app_tagline': 'Tumbuh kembang sehat untuk si kecil',
    'nav_home': 'Beranda',
    'nav_settings': 'Pengaturan',
    'quick_add': 'Tambah',
    'quick_actions': 'Aksi Cepat',
    'latest_measurement': 'Pengukuran Terbaru',
    'no_measurement': 'Belum ada pengukuran',
    'add_measurement': 'Tambah Pengukuran',
    'growth_trend': 'Tren Pertumbuhan',
    'last_measured': 'Terakhir diukur @date',
    'no_history': 'Belum ada riwayat pengukuran',
    'vaccination_progress': 'Progres Vaksinasi',
    'completed': 'selesai',
    'growth_status': 'Status Pertumbuhan',
    'all_children': 'Semua anak',
    'select_child': 'Pilih anak',
    'read_more': 'Baca selengkapnya',
    'retry': 'Coba lagi',
    'back': 'Kembali',
    'help_support': 'Bantuan & Dukungan',
    'contact_us': 'Hubungi kami',
    'about_health_tip': 'Kebiasaan sehat hari ini',
    'health_tip':
        'Ukur berat dan tinggi si kecil secara rutin agar perubahan pertumbuhan bisa terdeteksi lebih awal.',
    'no_articles': 'Belum ada artikel saat ini',
    'measurement_date': 'Tanggal pengukuran',
    'measurement_note': 'Catatan pengukuran',
    'optional': 'Opsional',
    'photo': 'Foto',
    'change_photo': 'Ganti foto',
    'personal_information': 'Informasi pribadi',
    'birth_information': 'Informasi kelahiran',
    'parent_information': 'Informasi orang tua',
    'account_settings': 'Pengaturan akun',
    'preferences': 'Preferensi',
    'general': 'Umum',
    'support': 'Dukungan',
    'vaccines_completed': '@done dari @total vaksin selesai',
    'next_vaccine': 'Vaksin berikutnya',
    'no_upcoming_vaccine': 'Semua vaksin terjadwal sudah lengkap',
    'summary': 'Ringkasan',
    'overview': 'Ringkasan',
    'details': 'Detail',
    'saved': 'Berhasil disimpan',
    'child_added_success': 'Data anak baru berhasil ditambahkan',
    'growth_added_success': 'Data pertumbuhan berhasil ditambahkan',
    'coming_soon': 'Segera hadir',

    // Child detail
    'child_book': 'Buku Anak',
    'age_years_months': '@years tahun @months bulan',
    'age_months_only': '@count bulan',
    'growth_results': 'Hasil Pertumbuhan',
    'weight': 'Berat',
    'height': 'Tinggi',
    'head_circumference': 'L.Kepala',
    'head_short': 'Kepala',
    'last_update': 'Terakhir Update',
    'update_growth': 'Update Pertumbuhan',
    'vaccination': 'Vaksinasi',
    'see_detail': 'Lihat Detail',
    'vaccination_schedule': 'Jadwal Vaksinasi',
    'vaccination_schedule_hint':
        'Ketuk vaksin untuk mencatat atau memperbarui data vaksinasinya.',
    'growth_history': 'Pertumbuhan',
    'child_growth_history': 'Riwayat Pertumbuhan Anak',

    // Growth
    'add_growth_data': 'Tambah Data Pertumbuhan',
    'growth_date': 'Tanggal Pertumbuhan',
    'weight_kg': 'Berat Badan (kg)',
    'height_cm': 'Tinggi Badan (cm)',
    'head_cm': 'Lingkar Kepala (cm)',
    'example_weight': 'Contoh : 3.5',
    'example_height': 'Contoh : 40.8',
    'add_growth': 'Tambah Pertumbuhan',
    'latest': 'Terakhir',
    'sort_newest': 'Terbaru dulu',
    'sort_oldest': 'Terlama dulu',
    'newest': 'Terbaru',
    'growth_detail': 'Detail Pertumbuhan',
    'growth_date_label': 'Tanggal Pertumbuhan : ',
    'child_age_label': 'Usia Anak : ',
    'weight_label': 'Berat : ',
    'height_label': 'Tinggi : ',
    'head_label': 'Lingkar Kepala : ',
    'growth_status_weight':
        'Status Pertumbuhan Berat Badan berdasarkan standard WHO : ',
    'growth_status_height':
        'Status Pertumbuhan Tinggi Badan berdasarkan standard WHO : ',
    'growth_status_head':
        'Status Pertumbuhan Lebar Kepala berdasarkan standard WHO : ',
    'keep_healthy_note': 'Ket. Tetap jaga kesehatan Anak Anda',
    'consult_note': 'Ket. Silahkan konsultasi dengan petugas setempat',
    'status_gizi_buruk': 'Gizi Buruk',
    'status_gizi_kurang': 'Gizi Kurang',
    'status_gizi_baik': 'Gizi Baik',
    'status_gizi_lebih': 'Gizi Lebih',
    'status_sangat_pendek': 'Sangat Pendek (terindeksi stunting)',
    'status_pendek': 'Pendek',
    'status_tinggi_normal': 'Tinggi Badan Normal',
    'status_tinggi': 'Tinggi',
    'status_mikrosefali': 'Mikrosefali',
    'status_lingkar_normal': 'Lingkar Kepala Normal',
    'status_tidak_ada': 'Tidak Ada',
    'status_short_sangat_pendek': 'Stunting',
    'status_short_tinggi_normal': 'Normal',
    'status_short_lingkar_normal': 'Normal',
    'status_short_tidak_ada': 'Belum ada',

    // Immunization / Vaccination schedule
    'immunization': 'Imunisasi',
    'recommended_on': 'Di Rekomendasikan di',
    'recommended_on_period': 'Dirokemendasikan di ',
    'status_done': 'Sudah',
    'status_not_yet': 'Belum',
    'document': 'Dokumen',
    'how_to_read_age_column': 'Cara membaca colom umur',
    'age_column_example':
        'Misal 2 berarti 2 bulan (60 Hari) Sampai dengan 2 bulan 29 hari (89 Hari)',
    'child_age': 'Usia si kecil',
    'primary': 'Primer',
    'catch_up': 'Kejar',
    'booster': 'Penguat',
    'endemic_area': 'Daerah Endemis',
    'view_type': 'Jenis Tampilan',
    'add_child_vaccination': 'Tambah Vaksinasi Anak',
    'vaccination_date': 'Tanggal Vaksinasi',
    'doctor_name': 'Nama Dokter',
    'place': 'Tempat',
    'place_name': 'Nama Tempat',
    'edit_vaccination_status': 'Edit Status Vaksinasi',
    'recommended_date': 'Tanggal Direkomendasikan',
    'hep_b_description':
        'Mencegah Penyakit hepatitis B yang dapat menyebabkan kerusakan hati',
    'see_more': 'Lihat Lebih Lanjut',
    'vaccination_status': 'Status Vaksinasi',
    'edit_status': 'Edit Status',
    'no_vaccination_schedule': 'Belum ada jadwal vaksinasi',
    'no_vaccination_record': 'Belum ada catatan vaksinasi',
    'no_vaccination_record_message':
        'Catat tanggal, dokter, dan tempat setelah si kecil divaksinasi.',
    'vaccination_details': 'Detail vaksinasi',
    'update_vaccination': 'Ubah vaksinasi',
    'mark_not_done': 'Tandai belum dilakukan',
    'mark_not_done_confirm':
        'Hapus data vaksinasi yang sudah dicatat? Jadwal akan menampilkan vaksin ini sebagai belum dilakukan.',
    'mark_not_done_success': 'Vaksinasi ditandai belum dilakukan',
    'no_batch': 'Nomor batch',
    'select_date': 'Pilih tanggal',
    'vaccination_photo_hint':
        'Lampirkan foto buku imunisasi sebagai kenangan dan bukti.',
    'take_photo': 'Ambil foto',
    'choose_from_gallery': 'Pilih dari galeri',
    'document_load_failed': 'Gagal menampilkan dokumen.',

    'upgrade_membership': 'Naikan Level Membership ',
    'child_age_zero': '0 Tahun 0 Bulan',

    // ==ID_END==
  };
}

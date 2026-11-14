import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthtracker/controller/VaccinationScheduleByIdaiController.dart';
import 'package:growthtracker/controller/VaccinationScheduleController.dart';
import 'package:growthtracker/helper/AgeHelper.dart';
import 'package:growthtracker/pages/VaccinationDetailPage.dart';
import 'package:growthtracker/pages/VaccinationScheduleByIdaiPage.dart';
import 'package:growthtracker/services/LocalStore.dart';

class VaccinationSchedulePage extends StatefulWidget {
  String anak_id;
  VaccinationSchedulePage({super.key, required this.anak_id});

  @override
  State<VaccinationSchedulePage> createState() =>
      _VaccinationSchedulePageState();
}

class _VaccinationSchedulePageState extends State<VaccinationSchedulePage> {
  var jadwalVaksinasiController = Get.put(VaccinationScheduleController());
  var jadwalVaksinasiIDAIController =
      Get.put(VaccinationScheduleByIdaiController());
  final LocalStore _store = LocalStore();

  bool isDataInitialized = false;
  bool _loadingPdf = false;
  String? _namaAnak;
  DateTime? _birthDate;

  /// Age in months the list is filtered on; `null` shows every period.
  int? selectedMonth;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final child = await _store.childById(widget.anak_id);
    final nama = '${child?['nama_anak'] ?? ''}'.trim();
    final birthDate = DateTime.tryParse('${child?['tanggal_lahir'] ?? ''}');

    await jadwalVaksinasiController.getJadwalVaksin(widget.anak_id);

    if (!mounted) return;
    setState(() {
      _namaAnak = nama.isEmpty ? null : nama;
      _birthDate = birthDate;
      isDataInitialized = true;
    });
  }

  /// Opens the immunization reference PDF. Downloaded on demand so the
  /// schedule itself never waits on the network; a previously downloaded copy
  /// is reused when the device is offline.
  Future<void> _openPdfReference() async {
    if (_loadingPdf) return;
    setState(() => _loadingPdf = true);
    try {
      final file = await jadwalVaksinasiIDAIController.createFileOfPdfUrl();
      if (!mounted) return;
      setState(() => _loadingPdf = false);
      await Get.to(VaccinationScheduleByIdaiPage(path: file.path));
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingPdf = false);
      Get.snackbar(
        'failed'.tr,
        'pdf_download_failed'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vaccinationData = jadwalVaksinasiController.jadwalVaksinasi.toList();
    final filteredData = selectedMonth == null
        ? vaccinationData
        : vaccinationData
            .where((item) => item['bulan_ke'] == '$selectedMonth')
            .toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('vaccination_schedule'.tr),
        actions: [
          IconButton(
            tooltip: 'document'.tr,
            onPressed: _loadingPdf ? null : _openPdfReference,
            icon: _loadingPdf
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.table_chart_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            _buildHeader(),
            Container(
              height: 50,
              margin: const EdgeInsets.only(top: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      side: BorderSide.none,
                      label: Text(
                        'all'.tr,
                        style: const TextStyle(color: Colors.white),
                      ),
                      selected: selectedMonth == null,
                      onSelected: (_) => setState(() => selectedMonth = null),
                      backgroundColor: Colors.grey,
                      selectedColor: Colors.blue[200],
                    ),
                  ),
                  for (final item in vaccinationData)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        side: BorderSide.none,
                        label: Text(
                          '${item['periode']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        selected: '$selectedMonth' == '${item['bulan_ke']}',
                        onSelected: (_) => setState(() => selectedMonth =
                            int.tryParse('${item['bulan_ke']}')),
                        backgroundColor: Colors.grey,
                        selectedColor: Colors.blue[200],
                      ),
                    ),
                ],
              ),
            ),
            if (!isDataInitialized)
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              for (final item in filteredData) _buildPeriodCard(item),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_namaAnak != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                _namaAnak!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (_birthDate != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                ageLabel(_birthDate, DateTime.now()),
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
            ),
          Text(
            'vaccination_schedule_hint'.tr,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodCard(Map<String, dynamic> item) {
    final vaccines = (item['vaksin'] as List?) ?? const [];
    final rekomendasi = '${item['rekomendasi'] ?? ''}';
    final width = MediaQuery.of(context).size.width;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        title: Text(
          '${item['periode']}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${vaccines.where((vaksin) => vaksin['status'] == 'Sudah').length}'
          '/${vaccines.length}',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        children: [
          if (rekomendasi.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2, right: 16, left: 16),
              child: DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  color: Colors.blue,
                  radius: const Radius.circular(20),
                  padding: const EdgeInsets.all(3),
                ),
                child: Container(
                  width: width * 0.9,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'recommended_on_period'.tr,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        rekomendasi,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: vaccines.length,
                itemBuilder: (BuildContext context, int subIndex) {
                  final subItem = vaccines[subIndex] as Map;
                  final sudah = subItem['status'] == "Sudah";

                  return ListTile(
                    title: Text(
                      '${subItem['nama_vaksin']}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Chip(
                          side: BorderSide.none,
                          label: Text(
                            sudah ? 'status_done'.tr : 'status_not_yet'.tr,
                            style: TextStyle(
                              fontSize: 12,
                              color: sudah ? Colors.green : Colors.red,
                            ),
                          ),
                          backgroundColor:
                              sudah ? Colors.green[100] : Colors.red[100],
                        ),
                        IconButton(
                          onPressed: () async {
                            await Get.to(VaccinationDetailPage(
                              anak_id: widget.anak_id,
                              vaksin_id: '${subItem['vaksin_id']}',
                              tgl_rekomendasi: rekomendasi,
                              nama_vaksinasi: '${subItem['nama_vaksin']}',
                              status: sudah ? "Sudah" : "Belum",
                            ));
                            await _loadData();
                          },
                          icon: const Icon(Icons.arrow_forward_ios, size: 15),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

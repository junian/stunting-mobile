import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

List<Map<String, dynamic>> vaccinationData = [
  {
    "periode": "1 Bulan",
    "vaksin": [
      {
        "vaksin_id": "1",
        "nama_vaksin": "Hepatitis B 1",
        "bulan_ke": "1",
        "is_active": "1",
        "created_by": "1",
        "created_date": "2023-06-24 19:59:50",
        "updated_by": null,
        "updated_date": null,
        "anak_id": "2",
        "status": "Sudah"
      },
      {
        "vaksin_id": "8",
        "nama_vaksin": "BCG",
        "bulan_ke": "1",
        "is_active": "1",
        "created_by": "1",
        "created_date": "2023-06-24 20:03:17",
        "updated_by": null,
        "updated_date": null,
        "anak_id": null,
        "status": "Belum"
      },
      {
        "vaksin_id": "9",
        "nama_vaksin": "DTP 1",
        "bulan_ke": "1",
        "is_active": "1",
        "created_by": "1",
        "created_date": "2023-06-24 20:04:06",
        "updated_by": null,
        "updated_date": null,
        "anak_id": null,
        "status": "Belum"
      },
      {
        "vaksin_id": "12",
        "nama_vaksin": "Hib 1",
        "bulan_ke": "1",
        "is_active": "1",
        "created_by": "1",
        "created_date": "2023-06-24 20:04:52",
        "updated_by": null,
        "updated_date": null,
        "anak_id": null,
        "status": "Belum"
      }
    ]
  },
  {
    "periode": "2 Bulan",
    "vaksin": [
      {
        "vaksin_id": "2",
        "nama_vaksin": "Hepatitis B 2",
        "bulan_ke": "2",
        "is_active": "1",
        "created_by": "1",
        "created_date": "2023-06-24 20:00:17",
        "updated_by": null,
        "updated_date": null,
        "anak_id": null,
        "status": "Belum"
      },
      {
        "vaksin_id": "5",
        "nama_vaksin": "Polio 1",
        "bulan_ke": "2",
        "is_active": "1",
        "created_by": "1",
        "created_date": "2023-06-24 20:03:08",
        "updated_by": null,
        "updated_date": null,
        "anak_id": null,
        "status": "Belum"
      },
      {
        "vaksin_id": "10",
        "nama_vaksin": "DTP 2",
        "bulan_ke": "2",
        "is_active": "1",
        "created_by": "1",
        "created_date": "2023-06-24 20:04:07",
        "updated_by": null,
        "updated_date": null,
        "anak_id": null,
        "status": "Belum"
      },
      {
        "vaksin_id": "13",
        "nama_vaksin": "Hib 2",
        "bulan_ke": "2",
        "is_active": "1",
        "created_by": "1",
        "created_date": "2023-06-24 20:04:52",
        "updated_by": null,
        "updated_date": null,
        "anak_id": null,
        "status": "Belum"
      },
      {
        "vaksin_id": "15",
        "nama_vaksin": "PCV 1",
        "bulan_ke": "2",
        "is_active": "1",
        "created_by": "1",
        "created_date": "2023-06-24 20:05:10",
        "updated_by": null,
        "updated_date": null,
        "anak_id": null,
        "status": "Belum"
      },
      {
        "vaksin_id": "18",
        "nama_vaksin": "Rotavirus 1",
        "bulan_ke": "2",
        "is_active": "1",
        "created_by": "1",
        "created_date": "2023-06-24 20:06:38",
        "updated_by": null,
        "updated_date": null,
        "anak_id": null,
        "status": "Belum"
      }
    ]
  },
  {
    "periode": "3 Bulan",
    "vaksin": [
      {
        "vaksin_id": "3",
        "nama_vaksin": "Hepatitis B 3",
        "bulan_ke": "3",
        "is_active": "1",
        "created_by": "1",
        "created_date": "2023-06-24 20:00:28",
        "updated_by": null,
        "updated_date": null,
        "anak_id": null,
        "status": "Belum"
      },
      {
        "vaksin_id": "6",
        "nama_vaksin": "Polio 1",
        "bulan_ke": "3",
        "is_active": "1",
        "created_by": "1",
        "created_date": "2023-06-24 20:03:08",
        "updated_by": null,
        "updated_date": null,
        "anak_id": null,
        "status": "Belum"
      },
      {
        "vaksin_id": "11",
        "nama_vaksin": "DTP 2",
        "bulan_ke": "3",
        "is_active": "1",
        "created_by": "1",
        "created_date": "2023-06-24 20:04:09",
        "updated_by": null,
        "updated_date": null,
        "anak_id": null,
        "status": "Belum"
      },
      {
        "vaksin_id": "14",
        "nama_vaksin": "Hib 3",
        "bulan_ke": "3",
        "is_active": "1",
        "created_by": "1",
        "created_date": "2023-06-24 20:04:53",
        "updated_by": null,
        "updated_date": null,
        "anak_id": null,
        "status": "Belum"
      }
    ]
  },
  {
    "periode": "4 Bulan",
    "vaksin": [
      {
        "vaksin_id": "4",
        "nama_vaksin": "Hepatitis B 4",
        "bulan_ke": "4",
        "is_active": "1",
        "created_by": "1",
        "created_date": "2023-06-24 20:02:22",
        "updated_by": null,
        "updated_date": null,
        "anak_id": null,
        "status": "Belum"
      },
      {
        "vaksin_id": "7",
        "nama_vaksin": "Polio 1",
        "bulan_ke": "4",
        "is_active": "1",
        "created_by": "1",
        "created_date": "2023-06-24 20:03:09",
        "updated_by": null,
        "updated_date": null,
        "anak_id": null,
        "status": "Belum"
      },
      {
        "vaksin_id": "16",
        "nama_vaksin": "PCV 2",
        "bulan_ke": "4",
        "is_active": "1",
        "created_by": "1",
        "created_date": "2023-06-24 20:05:11",
        "updated_by": null,
        "updated_date": null,
        "anak_id": null,
        "status": "Belum"
      },
      {
        "vaksin_id": "19",
        "nama_vaksin": "Rotavirus 2",
        "bulan_ke": "4",
        "is_active": "1",
        "created_by": "1",
        "created_date": "2023-06-24 20:06:39",
        "updated_by": null,
        "updated_date": null,
        "anak_id": null,
        "status": "Belum"
      }
    ]
  },
  {
    "periode": "6 Bulan",
    "vaksin": [
      {
        "vaksin_id": "17",
        "nama_vaksin": "PCV 3",
        "bulan_ke": "6",
        "is_active": "1",
        "created_by": "1",
        "created_date": "2023-06-24 20:06:14",
        "updated_by": null,
        "updated_date": null,
        "anak_id": null,
        "status": "Belum"
      },
      {
        "vaksin_id": "20",
        "nama_vaksin": "Rotavirus 3",
        "bulan_ke": "6",
        "is_active": "1",
        "created_by": "1",
        "created_date": "2023-06-24 20:06:43",
        "updated_by": null,
        "updated_date": null,
        "anak_id": null,
        "status": "Belum"
      }
    ]
  },
  {
    "periode": "9 Bulan",
    "vaksin": [
      {
        "vaksin_id": "21",
        "nama_vaksin": "MR / MMR",
        "bulan_ke": "9",
        "is_active": "1",
        "created_by": "1",
        "created_date": "2023-06-24 20:07:48",
        "updated_by": null,
        "updated_date": null,
        "anak_id": null,
        "status": "Belum"
      }
    ]
  },
  {
    "periode": "12 Bulan",
    "vaksin": [
      {
        "vaksin_id": "23",
        "nama_vaksin": "Varisela 1",
        "bulan_ke": "12",
        "is_active": "1",
        "created_by": "1",
        "created_date": "2023-06-24 20:09:18",
        "updated_by": null,
        "updated_date": null,
        "anak_id": null,
        "status": "Belum"
      },
      {
        "vaksin_id": "25",
        "nama_vaksin": "Hepatitis A 1",
        "bulan_ke": "12",
        "is_active": "1",
        "created_by": "1",
        "created_date": "2023-06-24 20:09:29",
        "updated_by": null,
        "updated_date": null,
        "anak_id": null,
        "status": "Belum"
      }
    ]
  },
  {
    "periode": "18 Bulan",
    "vaksin": [
      {
        "vaksin_id": "24",
        "nama_vaksin": "Varisela 2",
        "bulan_ke": "18",
        "is_active": "1",
        "created_by": "1",
        "created_date": "2023-06-24 20:09:19",
        "updated_by": null,
        "updated_date": null,
        "anak_id": null,
        "status": "Belum"
      },
      {
        "vaksin_id": "26",
        "nama_vaksin": "Hepatitis A 2",
        "bulan_ke": "18",
        "is_active": "1",
        "created_by": "1",
        "created_date": "2023-06-24 20:09:30",
        "updated_by": null,
        "updated_date": null,
        "anak_id": null,
        "status": "Belum"
      }
    ]
  },
  {
    "periode": "24 Bulan",
    "vaksin": [
      {
        "vaksin_id": "22",
        "nama_vaksin": "Tifoid",
        "bulan_ke": "24",
        "is_active": "1",
        "created_by": "1",
        "created_date": "2023-06-24 20:08:38",
        "updated_by": null,
        "updated_date": null,
        "anak_id": null,
        "status": "Belum"
      }
    ]
  }
];

class SfDataGridDemo extends StatefulWidget {
  const SfDataGridDemo({Key? key}) : super(key: key);

  @override
  _SfDataGridDemoState createState() => _SfDataGridDemoState();
}

class _SfDataGridDemoState extends State<SfDataGridDemo> {
  late EmployeeDataSource _employeeDataSource;
  List<Employee> _employees = <Employee>[];

  @override
  void initState() {
    super.initState();
    _employees = getEmployeeData();
    _employeeDataSource = EmployeeDataSource(_employees);
  }

  final CustomColumnSizer _customColumnSizer = CustomColumnSizer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter SfDataGrid'),
      ),
      body: SfDataGrid(
          source: _employeeDataSource,
          columns: getColumns,
          columnSizer: _customColumnSizer,
          columnWidthMode: ColumnWidthMode.auto),
    );
  }

  List<GridColumn> get getColumns {
    return [
      GridColumn(
          columnName: 'id',
          autoFitPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: const Text('ID'))),
      GridColumn(
          columnName: 'name',
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: const Text('Name'))),
      GridColumn(
          columnName: 'mail',
          autoFitPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: const Text(
                'E-Mail',
                softWrap: false,
              ))),
      GridColumn(
          columnName: 'contact no',
          autoFitPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: const Text('Contact No'))),
      GridColumn(
          columnName: 'city',
          autoFitPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: const Text('City')))
    ];
  }

  List<Employee> getEmployeeData() {
    return [
      Employee(10001, 'James', '123thisisareallylongemail@longemaildomain.com',
          '1231233211', 'Paris'),
      Employee(
          10002,
          'Kathryn',
          '123thisisareallylongemail@longemaildomain.com',
          '1212122121',
          'Strasbourg'),
      Employee(10003, 'Lara', '123thisisareallylongemail@longemaildomain.com',
          '1312131221', 'Berlin'),
      Employee(
          10004,
          'Michael',
          '123thisisareallylongemail@longemaildomain.com',
          '7834236578',
          'Lyon'),
      Employee(10005, 'Martin', '123thisisareallylongemail@longemaildomain.com',
          '1122324451', 'Reims'),
    ];
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource(List<Employee> employees) {
    buildDataGridRow(employees);
  }

  void buildDataGridRow(List<Employee> employeeData) {
    dataGridRow = employeeData.map<DataGridRow>((employee) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: employee.id),
        DataGridCell<String>(columnName: 'name', value: employee.name),
        DataGridCell<String>(columnName: 'mail', value: employee.email),
        DataGridCell<String>(
            columnName: 'contact no', value: employee.designation),
        DataGridCell<String>(columnName: 'city', value: employee.salary),
      ]);
    }).toList();
  }

  List<DataGridRow> dataGridRow = <DataGridRow>[];

  @override
  List<DataGridRow> get rows => dataGridRow.isEmpty ? [] : dataGridRow;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            dataGridCell.value.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
            softWrap: false,
          ));
    }).toList());
  }
}

class CustomColumnSizer extends ColumnSizer {
  @override
  double computeHeaderCellWidth(GridColumn column, TextStyle style) {
    style = const TextStyle(fontWeight: FontWeight.bold);

    return super.computeHeaderCellWidth(column, style);
  }

  @override
  double computeCellWidth(GridColumn column, DataGridRow row, Object? cellValue,
      TextStyle textStyle) {
    textStyle = const TextStyle(fontWeight: FontWeight.bold);

    return super.computeCellWidth(column, row, cellValue, textStyle);
  }
}

class Employee {
  Employee(this.id, this.name, this.email, this.designation, this.salary);
  final int id;
  final String name;
  final String email;
  final String designation;
  final String salary;
}

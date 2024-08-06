import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterLaporanModal extends StatefulWidget {
  final void Function(String tahun, String status) onFilterSelected;
  final bool? is_pengawas;
  final String? petugas;

  FilterLaporanModal({
    required this.onFilterSelected,
    this.is_pengawas,
    this.petugas,
  });

  @override
  _FilterLaporanModalState createState() => _FilterLaporanModalState();
}

class _FilterLaporanModalState extends State<FilterLaporanModal> {
  late String selectedYear = DateFormat('yyyy').format(DateTime.now());
  late String selectedStatus = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Filter Laporan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedYear,
                    onChanged: (value) {
                      setState(() {
                        selectedYear = value!;
                      });
                    },
                    items: List.generate(6, (index) {
                      return DropdownMenuItem(
                        value: (DateTime.now().year - 5 + index).toString(),
                        child: Text(
                          (DateTime.now().year - 5 + index).toString(),
                        ),
                      );
                    }),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tahun',
                    ),
                  ),
                  SizedBox(height: 20),
                  if (widget.petugas == null) ...[
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value!;
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          value: '',
                          child: Text('Pilih Status'),
                        ),
                        if (!widget.is_pengawas!)
                          DropdownMenuItem(
                            value: 'inputing',
                            child: Text('Inputing'),
                          ),
                        DropdownMenuItem(
                          value: 'reporting',
                          child: Text('Reporting'),
                        ),
                        DropdownMenuItem(
                          value: 'approval',
                          child: Text('Approval'),
                        ),
                        DropdownMenuItem(
                          value: 'rejection',
                          child: Text('Rejection'),
                        ),
                        DropdownMenuItem(
                          value: 'resubmission',
                          child: Text('Resubmission'),
                        ),
                      ],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  SizedBox(height: 20),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              setState(() {
                                isLoading = true;
                              });
                              String tahun = selectedYear;
                              String status = selectedStatus;

                              widget.onFilterSelected(tahun, status);

                              Navigator.of(context).pop();
                            },
                      child: isLoading
                          ? CircularProgressIndicator()
                          : Text('Filter'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }
}

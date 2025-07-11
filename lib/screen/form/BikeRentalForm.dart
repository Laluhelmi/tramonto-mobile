import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tramontonbike/Remote/GuestApi.dart';
import 'package:tramontonbike/model/Bike.dart';
import 'package:tramontonbike/model/BookingRequest.dart';

class BikeRentalForm extends StatefulWidget {
  const BikeRentalForm({super.key});

  @override
  State<BikeRentalForm> createState() => _BikeRentalFormState();
}

class _BikeRentalFormState extends State<BikeRentalForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  List<Bike> _bikeList = [];
  List<Bike> _selectedBikes = [];

  DateTime? _startDate;
  DateTime? _endDate;

  Future<String>? _submitFuture;

  @override
  void initState() {
    super.initState();
    _fetchAvailableBikes();
  }

  Future<void> _fetchAvailableBikes() async {
    final data = await ApiService.fetchAvailableBikes();
    setState(() {
      _bikeList = data;
    });
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Pilih tanggal mulai dan tanggal selesai."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      int duration = _endDate!.difference(_startDate!).inDays;
      print(formatDateTimeWithUTC(_startDate!));
      if (duration <= 0) duration = 1;

      setState(() {
        _submitFuture = ApiService.submitBooking(
          BookingRequest(
            name: _nameController.text,
            address: _addressController.text,
            phoneNumber: _phoneController.text,
            price: int.tryParse(_priceController.text.replaceAll('.', '')) ?? 0,
            bikeIds: _selectedBikes.map((b) => b.id).toList(),
            startTime: formatDateTimeWithUTC(_startDate!),
            endTime: formatDateTimeWithUTC(_endDate!)
          ),
        );
      });
    }
  }

  Future<void> _selectDateTime({required bool isStart}) async {
    final now = DateTime.now();
    final initialDate = isStart ? (_startDate ?? now) : (_endDate ?? now);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );

    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    if (pickedTime == null) return;

    final combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      if (isStart) {
        _startDate = combined;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = _startDate;
        }
      } else {
        _endDate = combined;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bike Rental")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Nama", _nameController),
              _buildTextField("Hotel", _addressController),
              _buildTextField(
                "No Telp",
                _phoneController,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                "Harga",
                _priceController,
                prefixText: "Rp ",
                isCurrency: true,
              ),
              _buildDatePickers(),
              _buildMultiSelectBike(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Rent Bike", style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 24),
              if (_submitFuture != null) _buildFutureResponse(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickers() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _selectDateTime(isStart: true),
              child: Text(
                _startDate == null
                    ? "Mulai"
                    : DateFormat('dd MMM yyyy – HH:mm').format(_startDate!),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedButton(
              onPressed: () => _selectDateTime(isStart: false),
              child: Text(
                _endDate == null
                    ? "Selesai"
                    : DateFormat('dd MMM yyyy – HH:mm').format(_endDate!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFutureResponse() {
    return FutureBuilder<String>(
      future: _submitFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text(
            '❌ ${snapshot.error}',
            style: const TextStyle(color: Colors.red),
          );
        } else if (snapshot.hasData) {
          return Text(
            snapshot.data!,
            style: const TextStyle(color: Colors.green),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    String? prefixText,
    String? suffixText,
    bool isCurrency = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: isCurrency ? [_CurrencyInputFormatter()] : [],
        decoration: InputDecoration(
          labelText: label,
          prefixText: prefixText,
          suffixText: suffixText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Masukkan $label' : null,
      ),
    );
  }

  Widget _buildMultiSelectBike() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: _showBikeSelectionDialog,
        child: AbsorbPointer(
          child: TextFormField(
            controller: TextEditingController(
              text: _selectedBikes.map((b) => b.name).join(', '),
            ),
            decoration: InputDecoration(
              labelText: "Pilih Sepeda (multi)",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: const Icon(Icons.arrow_drop_down),
            ),
            validator: (_) =>
                _selectedBikes.isEmpty ? 'Pilih minimal 1 sepeda' : null,
          ),
        ),
      ),
    );
  }

  void _showBikeSelectionDialog() async {
    List<Bike> tempSelected = List.from(_selectedBikes);

    final result = await showDialog<List<Bike>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pilih Sepeda"),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: _bikeList.map((bike) {
                    final isSelected = tempSelected.contains(bike);
                    return CheckboxListTile(
                      value: isSelected,
                      title: Text(bike.name),
                      onChanged: (bool? selected) {
                        setStateDialog(() {
                          if (selected == true) {
                            tempSelected.add(bike);
                          } else {
                            tempSelected.remove(bike);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, tempSelected),
              child: const Text("Pilih"),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedBikes = result;
      });
    }
  }


  String formatDateTimeWithUTC(DateTime dateTime) {
    final formatter = DateFormat("yyyy-MM-dd HH:mm:ss");
    return "${formatter.format(dateTime.toUtc())}+00";
  }
}

/// ✅ Currency Formatter untuk input harga
class _CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.decimalPattern('id_ID');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.isEmpty) return newValue.copyWith(text: '');

    final number = int.parse(digitsOnly);
    final newText = _formatter.format(number);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

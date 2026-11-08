import 'package:flutter/material.dart';

enum ConversionDirection { celsiusToFahrenheit, fahrenheitToCelsius }

class TemperatureConverterPage extends StatefulWidget {
  const TemperatureConverterPage({super.key});

  @override
  State<TemperatureConverterPage> createState() =>
      _TemperatureConverterPageState();
}

class _TemperatureConverterPageState extends State<TemperatureConverterPage> {
  final _formKey = GlobalKey<FormState>();
  final _temperatureController = TextEditingController();

  ConversionDirection _direction = ConversionDirection.celsiusToFahrenheit;
  String? _result;

  @override
  void dispose() {
    _temperatureController.dispose();
    super.dispose();
  }

  String? _validateTemperature(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a temperature.';
    }

    final temperature = double.tryParse(value.trim());
    if (temperature == null || !temperature.isFinite) {
      return 'Please enter a valid number.';
    }

    return null;
  }

  void _convertTemperature() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _result = null);
      return;
    }

    final temperature = double.parse(_temperatureController.text.trim());
    final converted = switch (_direction) {
      ConversionDirection.celsiusToFahrenheit => temperature * 9 / 5 + 32,
      ConversionDirection.fahrenheitToCelsius => (temperature - 32) * 5 / 9,
    };
    final unit = switch (_direction) {
      ConversionDirection.celsiusToFahrenheit => '°F',
      ConversionDirection.fahrenheitToCelsius => '°C',
    };

    setState(() => _result = '${converted.toStringAsFixed(2)} $unit');
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Card(
                elevation: 2,
                shadowColor: const Color(0x1A17324D),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(
                          Icons.device_thermostat,
                          color: Color(0xFF1677F9),
                          size: 44,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Temperature Converter',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 28),
                        TextFormField(
                          key: const ValueKey('temperatureInput'),
                          controller: _temperatureController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: 'Temperature',
                            hintText: 'Enter a value',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: _validateTemperature,
                          onChanged: (_) {
                            if (_result != null) {
                              setState(() => _result = null);
                            }
                          },
                          onFieldSubmitted: (_) => _convertTemperature(),
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<ConversionDirection>(
                          key: const ValueKey('conversionType'),
                          initialValue: _direction,
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: 'Conversion type',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: ConversionDirection.celsiusToFahrenheit,
                              child: Text('Celsius to Fahrenheit (°C → °F)'),
                            ),
                            DropdownMenuItem(
                              value: ConversionDirection.fahrenheitToCelsius,
                              child: Text('Fahrenheit to Celsius (°F → °C)'),
                            ),
                          ],
                          onChanged: (direction) {
                            if (direction == null) return;
                            setState(() {
                              _direction = direction;
                              _result = null;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          key: const ValueKey('calculateButton'),
                          onPressed: _convertTemperature,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Convert'),
                        ),
                        if (_result != null) ...[
                          const SizedBox(height: 24),
                          Container(
                            key: const ValueKey('conversionResult'),
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Result',
                                  style: Theme.of(context).textTheme.labelLarge
                                      ?.copyWith(color: Colors.black54),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _result!,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: const Color(0xFF125FC4),
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

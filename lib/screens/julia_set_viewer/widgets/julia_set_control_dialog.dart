import 'package:bigpay_app003/cubit/julia_set_viewer/julia_set_viewer_cubit.dart';
import 'package:bigpay_app003/models/julia_set_viewer_params.dart';
import 'package:bigpay_app003/utils/complex.dart';
import 'package:bigpay_app003/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JuliaSetControl extends StatefulWidget {
  final double viewWidth, viewHeight;
  const JuliaSetControl(
      {Key? key, required this.viewHeight, required this.viewWidth})
      : super(key: key);

  @override
  State<JuliaSetControl> createState() => _JuliaSetControlState();
}

class _JuliaSetControlState extends State<JuliaSetControl> {
  final _formkey = GlobalKey<FormState>();
  double _cRe = -0.7;
  double _cIm = 0.27015;
  int _iterations = 100;

//Complex(-0.7, 0.27015),
  @override
  Widget build(BuildContext context) {
    final state = context.watch<JuliaSetViewerCubit>().state;

    if (state is JuliaSetViewerRenderSuccess) {
      _cRe = state.viewerParams.c.real;
      _cIm = state.viewerParams.c.imaginary;
      _iterations = state.viewerParams.iterations;
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      title: const Text('Edit parameters'),
      content: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                  decoration: const InputDecoration(labelText: 'C real'),
                  inputFormatters: [
                    DecimalTextInputFormatter(decimalRange: 5),
                    FilteringTextInputFormatter.allow(RegExp(r'[\d+\-\.]'))
                  ],
                  initialValue: _cRe.toString(),
                  onSaved: (value) => _cRe = double.parse(value ?? '0'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    } else if (double.parse(value) > 2 ||
                        double.parse(value) < -2) {
                      return 'Please enter a value between -2 and 2';
                    } else {
                      return null;
                    }
                  }),
              const SizedBox(
                height: 16.0,
              ),
              TextFormField(
                  decoration: const InputDecoration(labelText: 'C imaginary'),
                  inputFormatters: [
                    DecimalTextInputFormatter(decimalRange: 5),
                    FilteringTextInputFormatter.allow(RegExp(r'[\d+\-\.]'))
                  ],
                  initialValue: _cIm.toString(),
                  onSaved: (value) => _cIm = double.parse(value ?? '0'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    } else if (double.parse(value) > 2 ||
                        double.parse(value) < -2) {
                      return 'Please enter a value between -2 and 2';
                    } else {
                      return null;
                    }
                  }),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Iterations', hintText: 'Max: 9999'),
                inputFormatters: [
                  IntegerTextFormatter(),
                  FilteringTextInputFormatter.allow(RegExp(r'[\d+\-\.]'))
                ],
                initialValue: _iterations.toString(),
                onSaved: (value) => _iterations = int.parse(value ?? '0'),
                validator: (value) =>
                    value == null || value.isEmpty ? '' : null,
              )
            ],
          ),
        ),
      ),
      actions: [
        OutlinedButton(
            style: OutlinedButton.styleFrom(
              side:
                  BorderSide(width: 2.0, color: Theme.of(context).primaryColor),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel')),
        ElevatedButton(
          child: const Text(
            'Generate',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            if (_formkey.currentState!.validate()) {
              _formkey.currentState!.save();
              context.read<JuliaSetViewerCubit>().generatePoints(
                  JuliaSetViewerParams(
                    c: Complex(_cRe, _cIm),
                    zoom: 1,
                    moveX: 0,
                    moveY: 0,
                    iterations: _iterations,
                  ),
                  widget.viewWidth,
                  widget.viewHeight);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}

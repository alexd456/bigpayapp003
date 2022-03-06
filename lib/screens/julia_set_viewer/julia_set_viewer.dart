import 'package:bigpay_app003/cubit/julia_set_viewer/julia_set_viewer_cubit.dart';
import 'package:bigpay_app003/screens/julia_set_viewer/widgets/julia_set_control_dialog.dart';
import 'package:bigpay_app003/screens/julia_set_viewer/widgets/julia_set_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JuliaSetExplorer extends StatefulWidget {
  final double viewWidth, viewHeight;
  const JuliaSetExplorer(
      {Key? key, required this.viewWidth, required this.viewHeight})
      : super(key: key);

  @override
  _JuliaSetExplorerState createState() => _JuliaSetExplorerState();
}

class _JuliaSetExplorerState extends State<JuliaSetExplorer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Julia set viewer'),
        actions: [
          IconButton(
              onPressed: () => _showDialog(context),
              icon: const Icon(Icons.tune))
        ],
      ),
      body: BlocListener<JuliaSetViewerCubit, JuliaSetViewerState>(
          listener: _snapshotUploadListenerCallback,
          child: SafeArea(
              child: Column(
            children: [
              const Expanded(
                child: ParamsDisplay(),
              ),
              RepaintBoundary(
                  child: JuliaSetView(
                viewWidth: widget.viewWidth,
                viewHeight: widget.viewHeight,
              )),
              Expanded(
                child: Container(),
              )
            ],
          ))),
      floatingActionButton:
          BlocBuilder<JuliaSetViewerCubit, JuliaSetViewerState>(
        builder: (context, state) {
          final snapshotAllowed = state is JuliaSetViewerRenderSuccess;
          return FloatingActionButton(
            backgroundColor: snapshotAllowed ? null : Colors.grey,
            child: const Icon(Icons.add_a_photo),
            onPressed: state is JuliaSetViewerRenderSuccess
                ? () async {
                    context.read<JuliaSetViewerCubit>().saveSnapshot(
                        state.viewerParams, state.pointsPerIteration);
                  }
                : null,
          );
        },
      ),
    );
  }

  void _snapshotUploadListenerCallback(context, state) {
    if (state is JuliaSetViewerUploadSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.white,
        content: Row(children: const [
          Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          SizedBox(width: 16.0),
          Text(
            'Snapshot uploaded',
            style: TextStyle(color: Colors.black),
          )
        ]),
      ));
    } else if (state is JuliaSetViewerUploadError) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          'Error uploading snapshot',
          style: TextStyle(color: Colors.white),
        ),
      ));
    }
  }

  void _showDialog(context) {
    final juliaSetViewerCubit = BlocProvider.of<JuliaSetViewerCubit>(context);
    showDialog(
        context: context,
        builder: (context) {
          return BlocProvider<JuliaSetViewerCubit>.value(
              value: juliaSetViewerCubit,
              child: JuliaSetControl(
                viewWidth: widget.viewWidth,
                viewHeight: widget.viewHeight,
              ));
        });
  }
}

class ParamsDisplay extends StatelessWidget {
  const ParamsDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<JuliaSetViewerCubit>().state;

    if (state is JuliaSetViewerInitial) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Click on the tuner icon above to change the parameters of the Julia Set and generate a new plot.',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else if (state is JuliaSetViewerRenderSuccess) {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'C real: ${state.viewerParams.c.real}  C imaginary: ${state.viewerParams.c.imaginary}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Iterations: ${state.viewerParams.iterations}',
                style: const TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      );
    }
    return Container();
  }
}

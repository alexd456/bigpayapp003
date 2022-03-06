import 'package:bigpay_app003/cubit/julia_set_viewer/julia_set_viewer_cubit.dart';
import 'package:bigpay_app003/cubit/welcome_screen/welcome_screen_cubit.dart';
import 'package:bigpay_app003/data/repository/snapshot_repository.dart';
import 'package:bigpay_app003/screens/julia_set_viewer/julia_set_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => WelcomeScreenCubit()..loadSnapshots(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(children: [
            SizedBox(height: height * 0.05),
            const Text(
              'Julia Set Explorer',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            Expanded(
              child: WelcomeScreenCenter(
                juliaViewWidth: width,
                juliaViewHeight: width,
              ),
            ),
            SizedBox(height: height * 0.05),
            Builder(builder: (context) {
              return Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40)),
                  child: const Text(
                    'Explore new',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    final welcomeScreenCubit =
                        BlocProvider.of<WelcomeScreenCubit>(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider(
                                  create: (context) => JuliaSetViewerCubit(
                                      welcomeScreenCubit, SnapshotRepository()),
                                  child: JuliaSetExplorer(
                                    viewWidth: width,
                                    viewHeight: width,
                                  ),
                                )));
                  },
                ),
              );
            }),
            SizedBox(height: height * 0.05),
          ]),
        )),
      ),
    );
  }
}

class WelcomeScreenCenter extends StatelessWidget {
  final double juliaViewWidth, juliaViewHeight;
  const WelcomeScreenCenter(
      {Key? key, required this.juliaViewWidth, required this.juliaViewHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WelcomeScreenCubit, WelcomeScreenState>(
        builder: ((context, state) {
          late Widget widget;
          if (state is WelcomeScreenInitial || state is WelcomeScreenLoading) {
            widget = const CupertinoActivityIndicator();
          }

          if (state is WelcomeScreenError) {
            widget = const Text('Error loading snapshots');
          }

          if (state is WelcomeScreenSnapshots) {
            if (state.snapshots == null || state.snapshots!.isEmpty) {
              widget = const Center(
                child: Text(
                  'Your snapshots of Julia sets will appear here.\n\nClick below to start exploring',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              widget = SingleChildScrollView(
                child: Wrap(
                    runSpacing: 10.0,
                    children: state.snapshots!
                        .map((snapshot) => Card(
                            clipBehavior: Clip.antiAlias,
                            child: ListTile(
                              title: Text(snapshot.lastModified.toString()),
                              onTap: () {
                                final welcomeScreenCubit =
                                    BlocProvider.of<WelcomeScreenCubit>(
                                        context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                              create: (context) =>
                                                  JuliaSetViewerCubit(
                                                      welcomeScreenCubit,
                                                      SnapshotRepository())
                                                    ..downloadSnapshot(
                                                        snapshot,
                                                        juliaViewWidth,
                                                        juliaViewHeight),
                                              child: JuliaSetExplorer(
                                                viewWidth: juliaViewWidth,
                                                viewHeight: juliaViewHeight,
                                              ),
                                            )));
                              },
                            )))
                        .toList()),
              );
            }
          }
          return Center(
            child: widget,
          );
        }),
        listener: (_, __) {});
  }
}

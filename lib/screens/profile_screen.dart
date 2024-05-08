import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:swifty_companion/models/user.dart';
import 'package:swifty_companion/style/colors.dart';
import 'package:swifty_companion/style/text.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.userModel});

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.dark,
        body: CustomScrollView(slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
            AspectRatio(
              aspectRatio: 10 / 9,
              child: Image.network(
                userModel.imageLink,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                            color: AppColors.prussianBlue,
                            borderRadius:
                                BorderRadius.all(Radius.circular(80))),
                        child: Center(
                          child: Text(
                            userModel.level.toStringAsFixed(2),
                            style: AppStyle.textHeader6,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(userModel.fullName,
                                style: AppStyle.textHeader4),
                            Text(
                              userModel.login,
                              style: AppStyle.textBody1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Correction points",
                              style: AppStyle.textCaptionBold,
                            ),
                            Text(
                              userModel.correctionPoint.toString(),
                              style: AppStyle.textHeader6,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Joined at",
                              style: AppStyle.textCaptionBold,
                            ),
                            Text(
                              userModel.createdAt.toString().split(' ')[0],
                              style: AppStyle.textHeader6,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: AppColors.prussianBlue,
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Skills",
                      style: AppStyle.textHeader6,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70.0),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: RadarChart(
                          RadarChartData(
                              getTitle: (index, level) {
                                return RadarChartTitle(
                                    text: userModel.skills[index].name,
                                    angle: 0.1);
                              },
                              titleTextStyle: AppStyle.textCaptionSmall,
                              dataSets: [
                                RadarDataSet(
                                    borderColor: Colors.white,
                                    dataEntries: userModel.skills
                                        .map<RadarEntry>(
                                            (e) => RadarEntry(value: e.level))
                                        .toList())
                              ]),
                          swapAnimationDuration:
                              const Duration(milliseconds: 150),
                          // Optional
                          swapAnimationCurve: Curves.linear, // Optional
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ])),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 24, left: 24),
              child: Text(
                "Projects",
                style: AppStyle.textHeader6,
              ),
            ),
          ),
          SliverList.builder(
              itemCount: userModel.projects.length,
              itemBuilder: (BuildContext context, int index) {
                ProjectModel project = userModel.projects[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      color: AppColors.prussianBlue
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                children: [
                                  Text(project.name, style: AppStyle.textSubtitle1,),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(width: 8,),
                                      Icon(
                                        PhosphorIcons.arrowsClockwise(),
                                        color: AppColors.pictonBlue,
                                      ),
                                      const SizedBox(width: 4,),
                                      Text("${project.retried} retries", style: AppStyle.textSubtitle1.copyWith(color: AppColors.pictonBlue),),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4,),
                              Text(project.dateTime.toString(), style: AppStyle.textCaptionBold.copyWith(color: AppColors.pictonBlue),)
                            ],
                          ),
                        ),
                        SizedBox(width: 12,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(project.status, style: AppStyle.textCaption,),
                            Text(project.mark.toString(), style: AppStyle.textHeader6,),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),

          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Builder(builder: (context) {
              final blackHole = userModel.blackHole;
              if (blackHole != null) {
                return Column(
                  children: [
                    Text(
                      "Black hole",
                      style: AppStyle.textCaptionBold,
                    ),
                    Text(
                      blackHole.toIso8601String(),
                      style: AppStyle.textHeader6,
                    ),
                  ],
                );
              }
              return const SizedBox();
            }),
          ))
        ]));
  }
}

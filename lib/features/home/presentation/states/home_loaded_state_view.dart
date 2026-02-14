import 'package:breathe/common/styling/app_text_theme.dart';
import 'package:breathe/common/styling/app_theme.dart';
import 'package:breathe/config/app_assets.dart';
import 'package:breathe/features/exercise/domain/entity/excercise_settings_entity.dart';
import 'package:breathe/features/home/presentation/home_state_controller.dart';
import 'package:breathe/features/home/presentation/home_state_machine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

class HomeLoadedStateView extends StatefulWidget {
  const HomeLoadedStateView({
    super.key,
    required this.state,
    required this.controller,
  });

  final HomeLoadedState state;
  final HomeStateController controller;

  @override
  State<HomeLoadedStateView> createState() => _HomeLoadedStateViewState();
}

class _HomeLoadedStateViewState extends State<HomeLoadedStateView> {
  static const _durationChips = ['3s', '4s', '5s', '6s'];
  var _selectedDurationChip = _durationChips[1];
  static const _roundsChips = ['2 quick', '4 calm', '6 deep', '8 zen'];
  var _selectedRoundChip = _roundsChips[1];

  var _isAdvancedOptionsVisible = false;

  var _breathInDuration = 4;
  var _holdInDuration = 4;
  var _breathOutDuration = 4;
  var _holdOutDuration = 4;

  var _allowSound = true;

  @override
  void initState() {
    super.initState();
    AppTheme.watchToggle(watchThemeChanges);
  }

  void watchThemeChanges() {
    // refresh state on theme changes
    widget.controller.refreshUICallback();
  }

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.paddingOf(context);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: AppTheme.instance.backgroundColor,
      primary: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: AppTheme.instance.homePageBackgroundDecoration,
            ),
          ),
          // TODO: Add clouds if enough time available
          // Positioned.fill(
          //   child: Image(
          //     image: AppAssets.lightBackground,
          //     fit: BoxFit.fill,
          //   ),
          // ),
          Align(
            child: Padding(
              padding: EdgeInsets.only(top: insets.top, bottom: insets.bottom),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Set your breathing pace",
                      style: ConfigurableTextStyle.create(
                        FontSizes.large,
                      ).withColor(AppTheme.instance.primary).makeBold(),
                    ),
                    Gap(17),
                    Text(
                      "Customise your breathing session. You\ncan always change this later.",
                      textAlign: .center,
                      style: ConfigurableTextStyle.create(
                        FontSizes.regular,
                      ).withColor(AppTheme.instance.textSubtitle),
                    ),
                    Gap(18),
                    AnimatedContainer(
                      duration: 250.ms,
                      decoration: BoxDecoration(
                        color: AppTheme.instance.backgroundColor,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: AppTheme.instance.borderColor,
                        ),
                      ),
                      width: 321,
                      padding: .symmetric(horizontal: 20, vertical: 32),
                      child: Column(
                        crossAxisAlignment: .start,
                        mainAxisSize: .min,
                        children: [
                          Text(
                            "Breath duration",
                            style:
                                ConfigurableTextStyle.create(FontSizes.medium)
                                    .withColor(AppTheme.instance.textTitle)
                                    .makeSemiBold(),
                          ),
                          Text(
                            "Seconds per phase",
                            style: ConfigurableTextStyle.create(
                              FontSizes.small,
                            ).withColor(AppTheme.instance.textSubtitle),
                          ),
                          Gap(10),
                          buildChips(
                            _durationChips,
                            _selectedDurationChip,
                            onSelected: (value) {
                              setState(() {
                                _selectedDurationChip = value;
                              });
                            },
                          ),
                          Gap(16.5),
                          Text(
                            "Rounds",
                            style:
                                ConfigurableTextStyle.create(FontSizes.medium)
                                    .withColor(AppTheme.instance.textTitle)
                                    .makeSemiBold(),
                          ),
                          Text(
                            "Full box breathing cycles",
                            style: ConfigurableTextStyle.create(
                              FontSizes.small,
                            ).withColor(AppTheme.instance.textSubtitle),
                          ),
                          Gap(10),
                          buildChips(
                            _roundsChips,
                            _selectedRoundChip,
                            onSelected: (value) {
                              setState(() {
                                _selectedRoundChip = value;
                              });
                            },
                            horizontalPadding: false,
                          ),
                          Gap(12),
                          ExpansionTile(
                            title: Text(
                              "Advanced timing",
                              style:
                                  ConfigurableTextStyle.create(FontSizes.medium)
                                      .withColor(AppTheme.instance.textTitle)
                                      .makeSemiBold(),
                            ),
                            subtitle: Text(
                              "Set different durations for each phase",
                              style: ConfigurableTextStyle.create(
                                FontSizes.small,
                              ).withColor(AppTheme.instance.textSubtitle),
                            ),
                            trailing: SizedBox(
                              width: 12,
                              height: 24,
                              child: Image(
                                image: _isAdvancedOptionsVisible
                                    ? AppAssets.arrowUp
                                    : AppAssets.arrowDown,
                              ),
                            ),
                            onExpansionChanged: (value) {
                              setState(() {
                                _isAdvancedOptionsVisible = value;
                              });
                            },
                            backgroundColor: AppTheme.instance.backgroundColor,
                            collapsedBackgroundColor:
                                AppTheme.instance.backgroundColor,
                            splashColor: AppTheme.instance.backgroundColor,
                            tilePadding: .all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: .circular(12),
                            ),
                            children: [
                              Gap(8),
                              buildDurationSelector(
                                'Breathe in',
                                _breathInDuration,
                                onChanged: (value) {
                                  setState(() {
                                    _breathInDuration = value;
                                  });
                                },
                              ),
                              Gap(8),
                              buildDurationSelector(
                                'Hold in',
                                _holdInDuration,
                                onChanged: (value) {
                                  setState(() {
                                    _holdInDuration = value;
                                  });
                                },
                              ),
                              Gap(8),
                              buildDurationSelector(
                                'Breath out',
                                _breathOutDuration,
                                onChanged: (value) {
                                  setState(() {
                                    _breathOutDuration = value;
                                  });
                                },
                              ),
                              Gap(8),
                              buildDurationSelector(
                                'Hold out',
                                _holdOutDuration,
                                onChanged: (value) {
                                  setState(() {
                                    _holdOutDuration = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          ListTile(
                            title: Text(
                              "Sound",
                              style:
                                  ConfigurableTextStyle.create(FontSizes.medium)
                                      .withColor(AppTheme.instance.textTitle)
                                      .makeSemiBold(),
                            ),
                            subtitle: Text(
                              "Gentle chime between phases",
                              style: ConfigurableTextStyle.create(
                                FontSizes.small,
                              ).withColor(AppTheme.instance.textSubtitle),
                            ),
                            trailing: Switch(
                              value: _allowSound,
                              trackColor: WidgetStatePropertyAll(
                                LightTheme()
                                    .primary, // always take light theme's color for this switch, we can optimize code later
                              ),
                              thumbColor: WidgetStatePropertyAll(Colors.white),
                              padding: .all(0),
                              onChanged: (value) {
                                setState(() {
                                  _allowSound = value;
                                });
                              },
                            ),
                            contentPadding: .all(0),
                          ),
                        ],
                      ),
                    ),
                    Gap(26),
                    GestureDetector(
                      onTap: () {
                        final primaryDuration = int.parse(
                          _selectedDurationChip[0],
                        );
                        widget.controller.start(
                          ExcerciseSettingsEntity(
                            durationInSeconds: primaryDuration,
                            rounds: int.parse(_selectedRoundChip[0]),
                            breathInDuration: _isAdvancedOptionsVisible
                                ? _breathInDuration
                                : primaryDuration,
                            holdInDuration: _isAdvancedOptionsVisible
                                ? _holdInDuration
                                : primaryDuration,
                            breathOutDuration: _isAdvancedOptionsVisible
                                ? _breathOutDuration
                                : primaryDuration,
                            holdOutDuration: _isAdvancedOptionsVisible
                                ? _holdOutDuration
                                : primaryDuration,
                            allowSound: _allowSound,
                          ),
                        );
                      },
                      child: Container(
                        width: 271,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppTheme.instance.buttonBackground,
                          borderRadius: .circular(32),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: .min,
                            children: [
                              Text(
                                "Start breathing",
                                style:
                                    ConfigurableTextStyle.create(FontSizes.base)
                                        .withColor(
                                          AppTheme.isLight
                                              ? AppTheme
                                                    .instance
                                                    .backgroundColor
                                              : Colors.white,
                                        )
                                        .useLato()
                                        .makeBold(),
                              ),
                              Gap(8),
                              Image(
                                image: AppAssets.fastWind,
                                width: 24,
                                height: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Gap(16),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: .topRight,
            child: Padding(
              padding: EdgeInsets.only(top: insets.top, bottom: insets.bottom),
              child: Padding(
                padding: .only(right: 35, top: 18),
                child: IconButton(
                  onPressed: () => AppTheme.toggle(),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.instance.borderColor,
                  ),
                  icon: Image(
                    image: AppTheme.isLight
                        ? AppAssets.darkMode
                        : AppAssets.lightMode,
                    width: 20.07,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChips(
    List<String> values,
    String selected, {
    required void Function(String value) onSelected,
    bool horizontalPadding = true,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 8,
        children: [
          ...values.map((e) {
            final isSelected = selected == e;
            return GestureDetector(
              onTap: () => onSelected(e),
              child: Chip(
                label: Padding(
                  padding: .symmetric(
                    horizontal: horizontalPadding ? 8 : 0,
                    vertical: 6,
                  ),
                  child: Text(
                    e,
                    style: ConfigurableTextStyle.create(FontSizes.regular)
                        .withColor(
                          isSelected
                              ? AppTheme.instance.chipActiveBorder
                              : AppTheme.instance.textSubtitle,
                        )
                        .makeSemiBold(onlyIf: () => isSelected),
                  ),
                ),
                backgroundColor: isSelected
                    ? AppTheme.instance.chipActiveBackground
                    : AppTheme.instance.chipBackground,
                shape: RoundedRectangleBorder(borderRadius: .circular(50)),
                side: BorderSide(
                  width: 1,
                  color: isSelected
                      ? AppTheme.instance.chipActiveBorder
                      : Colors.transparent,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget buildDurationSelector(
    String title,
    int value, {
    required void Function(int value) onChanged,
  }) {
    return Container(
      height: 54,
      padding: .only(left: 12, right: 24),
      decoration: BoxDecoration(
        color: AppTheme.instance.durationSelectorBackground,
        borderRadius: .circular(8),
        border: Border.all(color: AppTheme.instance.durationSelectorBorder),
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(
            title,
            style: ConfigurableTextStyle.create(
              FontSizes.regular,
            ).withColor(AppTheme.instance.textTitle).makeSemiBold(),
          ),
          SizedBox(
            width: 100, // making it constant to align contents properly
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if (value - 1 > 0) {
                      onChanged(value - 1);
                    }
                  },
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: AppTheme.instance.backgroundColor,
                      borderRadius: .circular(50),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.remove,
                        size: 18,
                        color: AppTheme.instance.textTitle,
                      ),
                    ),
                  ),
                ),
                Text(
                  '${value}s',
                  style: ConfigurableTextStyle.create(
                    FontSizes.medium,
                  ).useLato().withColor(AppTheme.instance.textTitle),
                ),
                GestureDetector(
                  onTap: () => onChanged(value + 1),
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: AppTheme.instance.backgroundColor,
                      borderRadius: .circular(50),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add,
                        size: 18,
                        color: AppTheme.instance.textTitle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    AppTheme.unwatchToggle(watchThemeChanges);
    super.dispose();
  }
}

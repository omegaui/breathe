import 'package:breathe/common/styling/app_text_theme.dart';
import 'package:breathe/common/styling/app_theme.dart';
import 'package:breathe/config/app_assets.dart';
import 'package:breathe/features/exercise/domain/entity/exercise_settings_entity.dart';
import 'package:breathe/features/home/presentation/home_state_controller.dart';
import 'package:breathe/features/home/presentation/home_state_machine.dart';
import 'package:flutter/foundation.dart';
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
  Widget build(BuildContext context) {
    final insets = MediaQuery.paddingOf(context);
    final colors = context.colors;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: colors.backgroundColor,
      primary: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: colors.homePageBackgroundDecoration,
            ),
          ),
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
                      ).withColor(colors.primary).makeBold(),
                    ),
                    Gap(17),
                    Text(
                      "Customise your breathing session. You\ncan always change this later.",
                      textAlign: .center,
                      style: ConfigurableTextStyle.create(
                        FontSizes.regular,
                      ).withColor(colors.textSubtitle),
                    ),
                    Gap(18),
                    AnimatedContainer(
                      duration: 250.ms,
                      decoration: BoxDecoration(
                        color: colors.backgroundColor,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: colors.borderColor,
                        ),
                      ),
                      width: kIsWeb ? 380 : 321,
                      padding: .symmetric(horizontal: 20, vertical: 32),
                      child: Column(
                        crossAxisAlignment: .start,
                        mainAxisSize: .min,
                        children: [
                          Text(
                            "Breath duration",
                            style:
                                ConfigurableTextStyle.create(FontSizes.medium)
                                    .withColor(colors.textTitle)
                                    .makeSemiBold(),
                          ),
                          Text(
                            "Seconds per phase",
                            style: ConfigurableTextStyle.create(
                              FontSizes.small,
                            ).withColor(colors.textSubtitle),
                          ),
                          Gap(10),
                          buildChips(
                            context,
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
                                    .withColor(colors.textTitle)
                                    .makeSemiBold(),
                          ),
                          Text(
                            "Full box breathing cycles",
                            style: ConfigurableTextStyle.create(
                              FontSizes.small,
                            ).withColor(colors.textSubtitle),
                          ),
                          Gap(10),
                          buildChips(
                            context,
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
                                      .withColor(colors.textTitle)
                                      .makeSemiBold(),
                            ),
                            subtitle: Text(
                              "Set different durations for each phase",
                              style: ConfigurableTextStyle.create(
                                FontSizes.small,
                              ).withColor(colors.textSubtitle),
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
                            backgroundColor: colors.backgroundColor,
                            collapsedBackgroundColor:
                                colors.backgroundColor,
                            splashColor: colors.backgroundColor,
                            tilePadding: .all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: .circular(12),
                            ),
                            children: [
                              Gap(8),
                              buildDurationSelector(
                                context,
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
                                context,
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
                                context,
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
                                context,
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
                                      .withColor(colors.textTitle)
                                      .makeSemiBold(),
                            ),
                            subtitle: Text(
                              "Gentle chime between phases",
                              style: ConfigurableTextStyle.create(
                                FontSizes.small,
                              ).withColor(colors.textSubtitle),
                            ),
                            trailing: Switch(
                              value: _allowSound,
                              activeTrackColor: context.colors.primary,
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
                    FilledButton(
                      onPressed: () {
                        final primaryDuration = int.parse(
                          _selectedDurationChip[0],
                        );
                        widget.controller.start(
                          ExerciseSettingsEntity(
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
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.buttonBackground,
                        fixedSize: const Size(271, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Start breathing",
                            style:
                                ConfigurableTextStyle.create(FontSizes.base)
                                    .withColor(
                                      context.isLightMode
                                          ? colors.backgroundColor
                                          : Colors.white,
                                    )
                                    .useLato()
                                    .makeBold(),
                          ),
                          const Gap(8),
                          Image(
                            image: AppAssets.fastWind,
                            width: 24,
                            height: 24,
                          ),
                        ],
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
                    backgroundColor: colors.borderColor,
                  ),
                  icon: Image(
                    image: context.isLightMode
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
    BuildContext context,
    List<String> values,
    String selected, {
    required void Function(String value) onSelected,
    bool horizontalPadding = true,
  }) {
    final colors = context.colors;
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
                    vertical: kIsWeb ? 0 : 6,
                  ),
                  child: Text(
                    e,
                    style: ConfigurableTextStyle.create(FontSizes.regular)
                        .withColor(
                          isSelected
                              ? colors.chipActiveBorder
                              : colors.textSubtitle,
                        )
                        .makeSemiBold(onlyIf: () => isSelected),
                  ),
                ),
                backgroundColor: isSelected
                    ? colors.chipActiveBackground
                    : colors.chipBackground,
                shape: RoundedRectangleBorder(borderRadius: .circular(50)),
                side: BorderSide(
                  width: 1,
                  color: isSelected
                      ? colors.chipActiveBorder
                      : Colors.transparent,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  static const _minDuration = 1;
  static const _maxDuration = 30;

  Widget buildDurationSelector(
    BuildContext context,
    String title,
    int value, {
    required void Function(int value) onChanged,
  }) {
    final colors = context.colors;
    final canDecrement = value > _minDuration;
    final canIncrement = value < _maxDuration;
    return Container(
      height: 54,
      padding: .only(left: 12, right: 24),
      decoration: BoxDecoration(
        color: colors.durationSelectorBackground,
        borderRadius: .circular(8),
        border: Border.all(color: colors.durationSelectorBorder),
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(
            title,
            style: ConfigurableTextStyle.create(
              FontSizes.regular,
            ).withColor(colors.textTitle).makeSemiBold(),
          ),
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                IconButton(
                  onPressed: canDecrement
                      ? () => onChanged(value - 1)
                      : null,
                  style: IconButton.styleFrom(
                    backgroundColor: colors.backgroundColor,
                    fixedSize: const Size(26, 26),
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(26, 26),
                  ),
                  icon: Icon(
                    Icons.remove,
                    size: 18,
                    color: canDecrement
                        ? colors.textTitle
                        : colors.textSubtitle,
                  ),
                ),
                Text(
                  '${value}s',
                  style: ConfigurableTextStyle.create(
                    FontSizes.medium,
                  ).useLato().withColor(colors.textTitle),
                ),
                IconButton(
                  onPressed: canIncrement
                      ? () => onChanged(value + 1)
                      : null,
                  style: IconButton.styleFrom(
                    backgroundColor: colors.backgroundColor,
                    fixedSize: const Size(26, 26),
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(26, 26),
                  ),
                  icon: Icon(
                    Icons.add,
                    size: 18,
                    color: canIncrement
                        ? colors.textTitle
                        : colors.textSubtitle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

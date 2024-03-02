import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game/extension/extensions.dart';
import 'package:game/models/screen_page.dart';
import 'package:game/theme/text_styles/text_styles.dart';
import 'package:game/view/widget/button_scale.dart';
import 'package:provider/provider.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../state/app_state.dart';
import '../../theme/color/app_color.dart';
import '../widget/coin_game.dart';
import '../widget/slide_sound.dart';
import 'my_game.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  MyGame? game;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      showSelectScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final state = context.watch<AppState>();
    game ??= MyGame(
        height: height,
        width: width,
        state: state,
        finalGame: showEndGame,
        context: context
    );
    return Scaffold(
        body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/bg_${state.bg}.png'),
                    fit: BoxFit.cover)),
            child: Stack(children: [
              SizedBox(
                width: width,
                height: height,
                child: GameWidget(game: game!)
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      height: height * 0.12,
                      margin: const EdgeInsets.only(top: 10, left: 10),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ButtonScale(
                                height: height * 0.12,
                                bg: 'assets/bg_btn_1_enable.png',
                                icon: 'assets/ic_back.png',
                                paddingTop: 0.25,
                                paddingBottom: 0.35,
                                margin: const EdgeInsets.only(right: 10),
                                onClick: () {
                                  state.isPlay = false;
                                  showSelectScreen();
                                }),
                            _tabScreen(height * 0.1, state.thisLevel)
                          ]))),
              Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 10, right: 10),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        ButtonScale(
                            height: height * 0.12,
                            bg: 'assets/bg_btn_2.png',
                            icon: 'assets/ic_sound.png',
                            paddingTop: 0.2,
                            paddingBottom: 0.3,
                            margin: const EdgeInsets.only(bottom: 5),
                            onClick: () {
                              state.isPlay = false;
                              showSetting();
                            }),
                        ButtonScale(
                            height: height * 0.12,
                            bg: 'assets/bg_btn_1_disable.png',
                            icon: 'assets/ic_contact.png',
                            paddingTop: 0.2,
                            paddingBottom: 0.3,
                            onClick: () {
                              state.isPlay = false;
                              showContact();
                            })
                      ]))),
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 5),
                      child: ButtonScale(
                          height: height * 0.125,
                          ratio: 3.389,
                          paddingLeft: 0.2,
                          font: 'InterBold',
                          textColor: AppColor.guide,
                          textCenter: translation(context).guide.toUpperCase(),
                          bg: 'assets/bg_guide.png',
                          onClick: () {
                            state.isPlay = false;
                            showGuide();
                          }))),
              Align(
                  alignment: Alignment.bottomRight,
                  child: CoinGame(
                      state: state,
                      height: height * 0.12,
                      margin: const EdgeInsets.only(right: 10, bottom: 10))),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                        ButtonScale(
                            height: height * 0.125,
                            bg: 'assets/ic_sub.png',
                            onClick: () => state.subGun()),
                        Container(
                          height: height * 0.3,
                          width: height * 0.3,
                          margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/gun.png'),
                              fit: BoxFit.fitHeight
                            )
                          )
                        ),
                        ButtonScale(
                            height: height * 0.125,
                            bg: 'assets/ic_plus.png',
                            onClick: () => state.addGun())
                      ])))
            ])));
  }

  showEndGame(bool isWin) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          double height = MediaQuery.of(context).size.height * 0.6;
          double fontText = height * 0.14;
          final state = context.watch<AppState>();
          return PopScope(
              canPop: false,
              child: Center(
                  child: Container(
                      width: height * 1.779,
                      height: height,
                      padding: EdgeInsets.all(height * 0.1),
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/bg_dialog.png'),
                              fit: BoxFit.fitHeight)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.all(height * 0.03),
                                      child: StrokeText(
                                          text: translation(context).pass_screen.toUpperCase(),
                                          strokeColor: AppColor.white.withOpacity(0.2),
                                          strokeWidth: height * 0.05,
                                          textStyle: TextStyles.textNunitoExtraBold.copyWith(
                                              fontSize: fontText
                                          )
                                      )
                                  ),
                                  ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [AppColor.settingStrokeS, AppColor.settingStrokeE]
                                        ).createShader(bounds);
                                      },
                                      child: Padding(
                                          padding: EdgeInsets.all(height * 0.03),
                                          child: StrokeText(
                                              text: translation(context).pass_screen.toUpperCase(),
                                              strokeColor: AppColor.white,
                                              strokeWidth: height * 0.03,
                                              textStyle: TextStyles.textNunitoExtraBold.copyWith(
                                                  fontSize: fontText
                                              )
                                          )
                                      )
                                  ),
                                  Padding(
                                      padding: EdgeInsets.all(height * 0.03),
                                      child: Text(
                                          translation(context).pass_screen.toUpperCase(),
                                          style: TextStyles.textNunitoExtraBold.copyWith(
                                              fontSize: fontText,
                                              color: AppColor.white
                                          )
                                      )
                                  )
                                ]
                            ),
                            Stack(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.all(height * 0.03),
                                      child: StrokeText(
                                          text: (isWin ? translation(context).passed : translation(context).failed).toUpperCase(),
                                          strokeColor: AppColor.white.withOpacity(0.2),
                                          strokeWidth: height * 0.05,
                                          textStyle: TextStyles.textNunitoBold.copyWith(
                                              fontSize: fontText
                                          )
                                      )
                                  ),
                                  ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: isWin ? [AppColor.settingStrokeS, AppColor.settingStrokeE] : [AppColor.strokeBlock]
                                        ).createShader(bounds);
                                      },
                                      child: Padding(
                                          padding: EdgeInsets.all(height * 0.03),
                                          child: StrokeText(
                                              text: (isWin ? translation(context).passed : translation(context).failed).toUpperCase(),
                                              strokeColor: AppColor.white,
                                              strokeWidth: height * 0.03,
                                              textStyle: TextStyles.textNunitoBold.copyWith(
                                                  fontSize: fontText
                                              )
                                          )
                                      )
                                  ),
                                  Padding(
                                      padding: EdgeInsets.all(height * 0.03),
                                      child: Text(
                                          (isWin ? translation(context).passed : translation(context).failed).toUpperCase(),
                                          style: TextStyles.textNunitoBold.copyWith(
                                              fontSize: fontText,
                                              color: isWin ? AppColor.textSetting : AppColor.textBlock
                                          )
                                      )
                                  )
                                ]
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ButtonScale(
                                    height: height * 0.2,
                                    bg: 'assets/bg_cup_enable.png',
                                    padding: 0.2,
                                    icon: 'assets/ic_restart.png',
                                    onClick: () {
                                      state.resetGame(state.thisLevel);
                                      game!.resetGame();
                                      Navigator.of(context).pop();
                                    }
                                ),
                                if (isWin)
                                  ButtonScale(
                                      height: height * 0.2,
                                      bg: 'assets/bg_btn_3.png',
                                      paddingTop: 0.15,
                                      paddingBottom: 0.3,
                                      paddingLeft: 0.1,
                                      margin: EdgeInsets.only(left: height * 0.1),
                                      icon: 'assets/ic_next.png',
                                      onClick: () {
                                        state.resetGame(state.thisLevel + 1);
                                        game!.resetGame();
                                        Navigator.of(context).pop();
                                      }
                                  )
                              ],
                            )
                          ]
                      )
                  )
              ));
        });
  }

  showGuide() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          double height = MediaQuery.of(context).size.height * 0.6;
          final state = context.watch<AppState>();
          return PopScope(
              canPop: false,
              child: Center(
                  child: Container(
                      width: height * 1.779,
                      height: height,
                      padding: EdgeInsets.all(height * 0.1),
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/bg_dialog.png'),
                              fit: BoxFit.fitHeight)),
                      child: Column(
                          children: [
                            Row(
                                children: [
                                  ButtonScale(
                                      height: height * 0.2,
                                      bg: 'assets/bg_cup_enable.png',
                                      icon: 'assets/ic_back_2.png',
                                      padding: 0.25,
                                      onClick: () {
                                        state.isPlay = true;
                                        Navigator.of(context).pop();
                                      }),
                                  const SizedBox(width: 20),
                                  Text(translation(context).guide, style: TextStyles.textNunitoBold.copyWith(
                                      fontSize: height * 0.1,
                                      color: Colors.white
                                  ))
                                ]
                            ),
                            SizedBox(height: height * 0.05),
                            Expanded(child: SingleChildScrollView(
                              child: Text(
                                translation(context).text,
                                textAlign: TextAlign.justify,
                                style: TextStyles.textInter.copyWith(
                                    fontSize: height * 0.06,
                                    color: Colors.white
                                )
                              )
                            ))
                          ]
                      )
                  )
              ));
        });
  }

  showContact() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          double height = MediaQuery.of(context).size.height * 0.6;
          final state = context.watch<AppState>();
          return PopScope(
            canPop: false,
              child: Center(
              child: Container(
                width: height * 1.779,
                height: height,
                padding: EdgeInsets.all(height * 0.1),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/bg_dialog.png'),
                        fit: BoxFit.fitHeight)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ButtonScale(
                            height: height * 0.2,
                            bg: 'assets/bg_cup_enable.png',
                            icon: 'assets/ic_back_2.png',
                            padding: 0.25,
                            onClick: () {
                              state.isPlay = true;
                              Navigator.of(context).pop();
                            }),
                        const SizedBox(width: 20),
                        Text(translation(context).contact, style: TextStyles.textNunitoBold.copyWith(
                          fontSize: height * 0.1,
                          color: Colors.white
                        ))
                      ]
                    ),
                    SizedBox(height: height * 0.1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _contactItem(height: height * 0.3, text: 'Zalo', icon: 'assets/ic_zalo.png', fit: BoxFit.fitWidth, link: 'https://chat.zalo.me/'),
                        _contactItem(height: height * 0.3, text: 'Messenger', icon: 'assets/ic_mess.png', link: 'https://www.messenger.com/'),
                        _contactItem(height: height * 0.3, text: 'Telegram', icon: 'assets/ic_tele.png', link: 'https://web.telegram.org/')
                      ],
                    )
                  ]
                )
              )
          ));
    });
  }

  showSetting() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          double height = MediaQuery.of(context).size.height * 0.6;
          final state = context.watch<AppState>();
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: PopScope(
                canPop: false,
                child: Center(
                    child: Container(
                        width: height * 1.779,
                        height: height,
                        padding: EdgeInsets.all(height * 0.1),
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/bg_dialog.png'),
                                fit: BoxFit.fitHeight)),
                        child: Stack(
                            children: [
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: ButtonScale(
                                      height: height * 0.2,
                                      bg: 'assets/bg_cup_enable.png',
                                      icon: 'assets/ic_back_2.png',
                                      padding: 0.25,
                                      onClick: () {
                                        state.isPlay = true;
                                        Navigator.of(context).pop();
                                      })
                              ),
                              Align(
                                  alignment: Alignment.topCenter,
                                  child: Stack(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.all(height * 0.03),
                                            child: StrokeText(
                                                text: translation(context).setting.toUpperCase(),
                                                strokeColor: AppColor.white.withOpacity(0.2),
                                                strokeWidth: height * 0.05,
                                                textStyle: TextStyles.textNunitoBold.copyWith(
                                                    fontSize: height * 0.2,
                                                    color: AppColor.settingStrokeS
                                                )
                                            )
                                        ),
                                        ShaderMask(
                                            shaderCallback: (Rect bounds) {
                                              return const LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [AppColor.settingStrokeS, AppColor.settingStrokeE]
                                              ).createShader(bounds);
                                            },
                                            child: Padding(
                                                padding: EdgeInsets.all(height * 0.03),
                                                child: StrokeText(
                                                    text: translation(context).setting.toUpperCase(),
                                                    strokeColor: AppColor.white,
                                                    strokeWidth: height * 0.03,
                                                    textStyle: TextStyles.textNunitoBold.copyWith(
                                                        fontSize: height * 0.2,
                                                        color: AppColor.settingStrokeS
                                                    )
                                                )
                                            )
                                        ),
                                        Padding(
                                            padding: EdgeInsets.all(height * 0.03),
                                            child: Text(
                                                translation(context).setting.toUpperCase(),
                                                style: TextStyles.textNunitoBold.copyWith(
                                                    fontSize: height * 0.2,
                                                    color: AppColor.textSetting
                                                )
                                            )
                                        )
                                      ]
                                  )
                              ),
                              Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                      padding: EdgeInsets.only(top: height * 0.3),
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Stack(
                                                children: [
                                                  Padding(
                                                      padding: EdgeInsets.all(height * 0.02),
                                                      child: StrokeText(
                                                          text: translation(context).sound,
                                                          strokeColor: AppColor.white.withOpacity(0.2),
                                                          strokeWidth: height * 0.03,
                                                          textStyle: TextStyles.textNunitoBold.copyWith(
                                                              fontSize: height * 0.1,
                                                              color: AppColor.settingStrokeS
                                                          )
                                                      )
                                                  ),
                                                  ShaderMask(
                                                      shaderCallback: (Rect bounds) {
                                                        return const LinearGradient(
                                                            begin: Alignment.topCenter,
                                                            end: Alignment.bottomCenter,
                                                            colors: [AppColor.settingStrokeS, AppColor.settingStrokeE]
                                                        ).createShader(bounds);
                                                      },
                                                      child: Padding(
                                                          padding: EdgeInsets.all(height * 0.02),
                                                          child: StrokeText(
                                                              text: translation(context).sound,
                                                              strokeColor: AppColor.white,
                                                              strokeWidth: height * 0.02,
                                                              textStyle: TextStyles.textNunitoBold.copyWith(
                                                                  fontSize: height * 0.1,
                                                                  color: AppColor.settingStrokeS
                                                              )
                                                          )
                                                      )
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.all(height * 0.02),
                                                      child: Text(
                                                          translation(context).sound,
                                                          style: TextStyles.textNunitoBold.copyWith(
                                                              fontSize: height * 0.1,
                                                              color: AppColor.white
                                                          )
                                                      )
                                                  )
                                                ]
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  height: height * 0.15,
                                                  child: Image.asset('assets/sound_disable.png', fit: BoxFit.fitHeight)
                                                ),
                                                CustomSlider(
                                                    max: 100,
                                                    min: 0,
                                                    value: state.sound.toDouble(),
                                                    onChanged: (v) {
                                                      state.saveSound(v.toInt());
                                                    },
                                                    linearGradient: const LinearGradient(
                                                        colors: [AppColor.soundS, AppColor.soundC, AppColor.soundE],
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter
                                                    ),
                                                    inActiveTrackColor: AppColor.white,
                                                    height: height * 0.07
                                                ),
                                                SizedBox(
                                                    height: height * 0.15,
                                                    child: Image.asset('assets/sound_enable.png', fit: BoxFit.fitHeight)
                                                )
                                              ],
                                            )
                                          ]
                                      )
                                  )
                              )
                            ]
                        )
                    )
                ))
          );
        });
  }

  showSelectScreen() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          double height = MediaQuery.of(context).size.height;
          final state = context.watch<AppState>();
          final List<ScreenPage> items = List.generate(state.level,
              (index) => ScreenPage(level: index + 1, type: ScreenEnum.PASS));
          items.add(ScreenPage(level: state.level + 1, type: ScreenEnum.NOW));
          items.add(ScreenPage(level: state.level + 2, type: ScreenEnum.BLOCK));

          PageController pageController =
              PageController(initialPage: (items.length / 3).ceil());
          return PopScope(
            canPop: false,
              child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/bg_select_screen.png'),
                          fit: BoxFit.cover)),
                  child: Center(
                      child: SizedBox(
                          height: height * 0.6,
                          width: height,
                          child: PageView.builder(
                              controller: pageController,
                              itemCount: (items.length / 3).ceil(),
                              itemBuilder: (context, pageIndex) {
                                int startIndex = pageIndex * 3;
                                int endIndex = (startIndex + 3) > items.length
                                    ? items.length
                                    : startIndex + 3;

                                List<ScreenPage> pageItems =
                                    items.sublist(startIndex, endIndex);

                                return _buildPage(height * 0.2, pageItems, (value) {
                                  if (value < state.level + 2) {
                                    if (value != state.thisLevel) {
                                      state.resetGame(value);
                                      game?.resetGame();
                                    }
                                    state.isPlay = true;
                                    Navigator.of(context).pop();
                                  }
                                });
                              })))));
        });
  }

  Widget _contactItem(
      {required double height, required String text, required String icon, required String link, BoxFit? fit}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: height * 0.2),
      child: Column(
          children: [
            ButtonScale(
                height: height,
                bg: 'assets/bg_contact.png',
                padding: 0.2,
                icon: icon,
                fit: fit,
                onClick: () => launchURL(link)
            ),
            const SizedBox(height: 10),
            Text(text, style: TextStyles.textInter.copyWith(
                fontSize: height * 0.2
            ))
          ]
      )
    );
  }

  Widget _buildPage(double height, List<ScreenPage> pageItems, ValueChanged<int> click) {
    List<Widget> list = [];
    for (ScreenPage i in pageItems) {
      list.add(_itemScreen(height, i, click));
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: list
    );
  }

  Widget _itemScreen(double height, ScreenPage screen, ValueChanged<int> click) {
    String icon = screen.type == ScreenEnum.PASS ? 'cup' : screen.type == ScreenEnum.NOW ? 'play' : 'block';
    return Column(mainAxisSize: MainAxisSize.min, children: [
      ButtonScale(
          height: height,
          bg: 'assets/bg_cup_${screen.type == ScreenEnum.BLOCK ? 'disable' : 'enable'}.png',
          icon: 'assets/ic_$icon.png',
          padding: screen.type == ScreenEnum.NOW ? 0.2 : 0.1,
          onClick: () => click.call(screen.level)),
      const SizedBox(height: 5),
      screen.type == ScreenEnum.NOW ? StrokeText(
          text: '${translation(context).screen} ${screen.level}',
          strokeColor: AppColor.white,
          strokeWidth: height * 0.07,
          textStyle: TextStyles.textNunitoBold.copyWith(
              fontSize: height * 0.3,
              color: AppColor.soundC
          )
      ) : Text('${translation(context).screen} ${screen.level}',
          style: TextStyles.textNunitoExtraBold.copyWith(
              fontSize: height * 0.3,
              color: screen.type == ScreenEnum.BLOCK ? AppColor.textBlock : Colors.white
          ))
    ]);
  }

  Widget _tabScreen(double height, int screen) {
    return Container(
        height: height,
        width: height * 2.8,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bg_screen.png'),
                fit: BoxFit.fitHeight)),
        child: Center(
            child: Stack(children: [
          ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColor.white, AppColor.screenC, AppColor.screenE],
                    stops: [0, 0.5, 0.8]).createShader(bounds);
              },
              child: Text('${translation(context).screen} $screen',
                  style: TextStyles.textInterBold
                      .copyWith(fontSize: height * 0.5))),
          Text('${translation(context).screen} $screen',
              textAlign: TextAlign.center,
              style: TextStyles.textInterBold.copyWith(
                  fontSize: height * 0.5,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 0.3
                    ..color = AppColor.screenStroke))
        ])));
  }
}

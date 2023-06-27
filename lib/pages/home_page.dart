import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_v1/models/english_today.dart';
import 'package:flutter_app_v1/packages/quote/qoute_model.dart';
import 'package:flutter_app_v1/pages/control_page.dart';
import 'package:flutter_app_v1/values/app_assets.dart';
import 'package:flutter_app_v1/values/app_colors.dart';
import 'package:flutter_app_v1/values/app_styles.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_app_v1/packages/quote/quote.dart';
import 'package:flutter_app_v1/values/share_keys.dart';
import 'package:flutter_app_v1/widgets/app_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:like_button/like_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late PageController _pageController;

  List<EnglishToday> words = [];

  String quoteRandom = Quotes().getRandom().content!;

  List<int> fixedListRandom({int len = 1, int max = 120, int min = 1}) {
    if (len > max || len < min) {
      return [];
    }
    List<int> newList = [];

    Random random = Random();
    int count = 1;
    while (count <= len) {
      int val = random.nextInt(max);
      if (newList.contains(val)) {
        continue;
      } else {
        newList.add(val);
        count++;
      }
    }
    return newList;
  }

  getEnglishToday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int len = prefs.getInt(ShareKeys.counter) ?? 5;

    List<String> newList = [];
    List<int> rans = fixedListRandom(len: len, max: nouns.length);
    // ignore: avoid_function_literals_in_foreach_calls
    rans.forEach((index) {
      newList.add(nouns[index]);
    });
    setState(() {
      words = newList.map((e) => getQuote(e)).toList();
    });
  }

  EnglishToday getQuote(String noun) {
    Quote? quote;
    quote = Quotes().getByWord(noun);
    return EnglishToday(
      noun: noun,
      quote: quote?.content,
      id: quote?.id,
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.9);
    super.initState();
    getEnglishToday();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: AppColors.secondColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.secondColor,
        elevation: 0,
        title: Text(
          'English Today',
          style: AppStyles.h3.copyWith(
            color: AppColors.textColor,
            fontSize: 36,
          ),
        ),
        leading: InkWell(
          onTap: () {
            _scaffoldkey.currentState?.openDrawer();
          },
          child: Image.asset(AppAssets.menu),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        // margin: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Container(
                height: size.height * 1 / 10,
                padding: const EdgeInsets.all(16),
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                // ignore: prefer_const_constructors
                child: Text(
                  '"$quoteRandom"',
                  style: AppStyles.h5.copyWith(
                    fontSize: 12,
                    color: AppColors.textColor,
                  ),
                )),
            // ignore: sized_box_for_whitespace
            Container(
              height: size.height * 2 / 3,
              child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    String firstLetter =
                        words[index].noun != null ? words[index].noun! : '';
                    firstLetter = firstLetter.substring(0, 1);

                    String leftLetter =
                        words[index].noun != null ? words[index].noun! : '';
                    leftLetter = leftLetter.substring(1, leftLetter.length);

                    String quoteDefault =
                        "This word can't be find in my database. sorry try another word :( ...";

                    String quote = words[index].quote != null
                        ? words[index].quote!
                        : quoteDefault;

                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Material(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24)),
                        color: AppColors.primaryColor,
                        elevation: 4,
                        child: InkWell(
                          onDoubleTap: () {
                            setState(() {
                              words[index].isFavorite =
                                  !words[index].isFavorite;
                            });
                          },
                          splashColor: Colors.transparent,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24)),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(
                                right: 8,
                                bottom: 8), // ignore: prefer_const_constructors
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LikeButton(
                                  onTap: (bool isLiked) async {
                                    setState(() {
                                      words[index].isFavorite =
                                          !words[index].isFavorite;
                                    });
                                    return words[index].isFavorite;
                                  },
                                  isLiked: words[index].isFavorite,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  size: 42,
                                  circleColor: const CircleColor(
                                      start: Color(0xff00ddff),
                                      end: Color(0xff0099cc)),
                                  bubblesColor: const BubblesColor(
                                    dotPrimaryColor: Color(0xff33b5e5),
                                    dotSecondaryColor: Color(0xff0099cc),
                                  ),
                                  likeBuilder: (bool isLiked) {
                                    return ImageIcon(
                                      AssetImage(AppAssets.heart),
                                      color:
                                          isLiked ? Colors.red : Colors.white,
                                      size: 42,
                                    );
                                  },
                                ),
                                // Container(
                                //   alignment: Alignment.centerRight,
                                //   child: Image.asset(
                                //     AppAssets.heart,
                                //     color: words[index].isFavorite
                                //         ? Colors.purple
                                //         : Colors.white,
                                //   ),
                                // ),
                                RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                        text: firstLetter,
                                        style: TextStyle(
                                            fontFamily: FontFamily.sen,
                                            fontSize: 89,
                                            fontWeight: FontWeight.bold,
                                            shadows: const [
                                              BoxShadow(
                                                  color: Colors.black38,
                                                  offset: Offset(3, 6),
                                                  blurRadius: 6),
                                            ]),
                                        children: [
                                          TextSpan(
                                            text: leftLetter,
                                            style: TextStyle(
                                                fontFamily: FontFamily.sen,
                                                fontSize: 56,
                                                fontWeight: FontWeight.bold,
                                                shadows: const [
                                                  BoxShadow(
                                                      color: Colors.black38,
                                                      offset: Offset(3, 6),
                                                      blurRadius: 6),
                                                ]),
                                          )
                                        ])),
                                Padding(
                                  padding: const EdgeInsets.only(top: 24),
                                  child: AutoSizeText(
                                    '"$quote"',
                                    maxFontSize: 20,
                                    style: AppStyles.h4.copyWith(
                                        letterSpacing: 1,
                                        color: AppColors.textColor),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: size.height * 1 / 11,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 24),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return buildIndicator(index == _currentIndex, size);
                  },
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          // ignore: avoid_print

          setState(() {
            getEnglishToday();
          });
        },
        child: Image.asset(AppAssets.exchange),
      ),
      drawer: Drawer(
        child: Container(
          color: AppColors.lightBlue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 70, left: 16),
                child: Text(
                  'Your Mind',
                  style: AppStyles.h3.copyWith(
                    color: AppColors.textColor,
                  ),
                ),
              ),
              AppButton(label: 'Favorites', onTap: () {}),
              AppButton(
                  label: 'Your Control',
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const ControlPage()),
                        (route) => false);
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIndicator(bool isActive, Size size) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 12,
      width: isActive ? size.width * 1 / 5 : 24,
      decoration: BoxDecoration(
          color: isActive ? AppColors.lightBlue : AppColors.lightGrey,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: const [
            BoxShadow(
                color: Colors.black38, offset: Offset(2, 3), blurRadius: 3)
          ]),
    );
  }
}

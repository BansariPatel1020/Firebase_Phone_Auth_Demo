import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../index.dart';
import 'dart:math' as math;

enum LeftAppBarButton {
  logout,
  back,
  empty,
  custom,
}

enum RightAppBarButton {
  logout,
  menu,
  empty,
  custom,
}

abstract class BaseView<Bloc extends BaseBloc> extends StatefulWidget {
  final Bloc? bloc;
  const BaseView({Key? key, this.bloc}) : super(key: key);
}

abstract class BaseViewState<Page extends BaseView> extends State<Page> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  void initBaseState();
}

mixin BasePage<Page extends BaseView> on BaseViewState<Page> {
  final _className = 'BaseView_';
  bool isSafeAreaRequire = true;
  bool isHiddenNavigationBar = false;
  String titleScreen = '';
  LeftAppBarButton leftAppBarButton = LeftAppBarButton.back;
  RightAppBarButton rightAppBarButton = RightAppBarButton.empty;
  Builder? leftbuilder;
  List<Widget>? rightbuilder;
  bool isShowBottomNavigationBar = false;
  Widget? bottomNavigationBar;

  @override
  void initState() {
    super.initState();
    AppManager.instance.globalContext = context;
    initBaseState();
  }

  void showErrorMessage(String? event, ScaffoldState context) {
    if ((event ?? '').isNotEmpty) {
      showBoatToast(event ?? '');
    }
  }

  void showIndicator(String event, ScaffoldState sContext) {
    if (event.isNotEmpty) {
      showProgressDialog(event, sContext.context);
    } else {
      showProgressDialog('Please wait', sContext.context);
    }
  }

  void hideIndicator(ScaffoldState sContext) {
    hideProgressDialog(sContext.context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: Key('${_className}GestureDetector'),
      onTap: () {
        var currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        endDrawer: null,
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: !isHiddenNavigationBar
            ? AppBar(
                elevation: 0.0,
                centerTitle: true,
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                systemOverlayStyle: SystemUiOverlayStyle.light,
                iconTheme: IconThemeData(
                  color: homeAppBarButtonColor,
                ),
                leading: leftAppBarButton == LeftAppBarButton.empty
                    ? rightAppBarButton != RightAppBarButton.empty
                        ? Container(width: appBarIconButtonSize)
                        : null
                    : buildLeftBuilder(),
                backgroundColor: pinkColor.withOpacity(0.85),
                title: Container(
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: buildTitleText(context, titleScreen, _className),
                ),
                actions: rightAppBarButton == RightAppBarButton.custom ||
                        rightAppBarButton == RightAppBarButton.menu ||
                        rightAppBarButton == RightAppBarButton.logout
                    ? buildRightBuilder()
                    : (rightAppBarButton == RightAppBarButton.empty &&
                            leftAppBarButton != LeftAppBarButton.empty)
                        ? [
                            Container(width: appBarIconButtonSize),
                          ]
                        : null,
              )
            : null,
        body: isSafeAreaRequire
            ? Container(
                decoration: BoxDecoration(
                  color: baseViewBackgroundColor,
                ),
                child: ColorfulSafeArea(
                    bottom: true,
                    child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: baseViewBackgroundColor,
                        child: body())),
              )
            : Container(
                color: baseViewBackgroundColor,
                child: body(),
              ),
      ),
    );
  }

  Widget body();

  List<Widget>? buildRightBuilder() {
    if (rightAppBarButton == RightAppBarButton.custom) {
      return rightbuilder;
    } else if (rightAppBarButton == RightAppBarButton.menu) {
      return [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: CustomAppBarIconButton(
            icon: Icons.sort,
            onPressed: () async {
              scaffoldKey.currentState!.openEndDrawer();
            },
          ),
        ),
      ];
    } else if (rightAppBarButton == RightAppBarButton.logout) {
      return [
        CustomAppBarIconButton(
          icon: Icons.exit_to_app,
          onPressed: () async {
            _logout(context);
          },
        )
      ];
    } else {
      return null;
    }
  }

  Builder? buildLeftBuilder() {
    if (leftAppBarButton == LeftAppBarButton.custom) {
      return leftbuilder;
    } else {
      return Builder(
        builder: (BuildContext context) {
          if (leftAppBarButton == LeftAppBarButton.back) {
            return CustomAppBarIconButton(
              icon: Icons.arrow_back_ios_sharp,
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
          } else {
            return CustomAppBarIconButton(
              icon: Icons.arrow_back_ios_sharp,
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
          }
        },
      );
    }
  }
}

_logout(BuildContext context) {
  AlertDialog alert = AlertDialog(
    title: const Text("Are you sure?"),
    content: const Text("Do you want to logout?"),
    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomRaisedButton(
            buttonWidth: 100,
            text: 'Yes',
            onCustomButtonPressed: () async {
              //TODO: delete user values from shared preference
              await HelperFunctions.saveUserLoggedInSharedPreference(false);
              await HelperFunctions.saveUserMobileSharedPreference('');
              AppManager.instance.sharedPreferenceRepository
                  .saveLoggedIn(false);
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, loginScreen, (_) => false);
            },
          ),
          const SizedBox(
            width: 10,
          ),
          CustomRaisedButton(
            buttonWidth: 100,
            buttonColor: Colors.grey,
            text: 'No',
            onCustomButtonPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      )
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Text buildTitleText(BuildContext context, String title, String className) {
  return Text(
    title,
    key: Key('${className}AppBarTitleText'),
    style: appBarTitleText(fontSize: 20),
    textAlign: TextAlign.center,
  );
}

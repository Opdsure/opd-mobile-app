import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:opdsure/config/themes.dart';

import 'package:url_launcher/url_launcher_string.dart';

import '../config/app_config.dart';
import '../utils/platform_infos.dart';



class LoginScaffold extends StatelessWidget {
  final Widget body;
  final AppBar? appBar;
  final bool enforceMobileMode;

  const LoginScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.enforceMobileMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMobileMode =
        enforceMobileMode || !OpdThemes.isColumnMode(context);
    final scaffold = Scaffold(
      key: const Key('LoginScaffold'),
      resizeToAvoidBottomInset: true,
      appBar: appBar == null
          ? null
          : AppBar(
        titleSpacing: appBar?.titleSpacing,
        automaticallyImplyLeading:
        appBar?.automaticallyImplyLeading ?? true,
        centerTitle: appBar?.centerTitle,
        title: appBar?.title,
        leading: appBar?.leading,
        actions: appBar?.actions,
        backgroundColor: isMobileMode ? null : Colors.transparent,
      ),
      body: body,
      backgroundColor: isMobileMode
          ? null
          : Theme.of(context).colorScheme.surface.withOpacity(0.8),

    );
    if (isMobileMode) return scaffold;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.contain,
          image: AssetImage('assets/images/app_logo.png'),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                  clipBehavior: Clip.hardEdge,
                  elevation:
                  Theme.of(context).appBarTheme.scrolledUnderElevation ?? 4,
                  shadowColor: Theme.of(context).appBarTheme.shadowColor,
                  child: ConstrainedBox(
                    constraints: isMobileMode
                        ? const BoxConstraints()
                        : const BoxConstraints(maxWidth: 480, maxHeight: 820),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 10.0,
                        sigmaY: 10.0,
                      ),
                      child: scaffold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // const _PrivacyButtons(mainAxisAlignment: MainAxisAlignment.center),
        ],
      ),
    );
  }
}

class _PrivacyButtons extends StatelessWidget {
  final MainAxisAlignment mainAxisAlignment;
  const _PrivacyButtons({required this.mainAxisAlignment});

  @override
  Widget build(BuildContext context) {
    final shadowTextStyle = OpdThemes.isColumnMode(context)
        ? const TextStyle(
      color: Colors.white,
      shadows: [
        Shadow(
          offset: Offset(0.0, 0.0),
          blurRadius: 3,
          color: Colors.black,
        ),
      ],
    )
        : null;
    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: [
            TextButton(
              onPressed: () => PlatformInfos.showDialog(context),
              child: Text(
                'About',
                style: shadowTextStyle,
              ),
            ),
            TextButton(
              onPressed: () => launchUrlString('https://dev.opdsure.net'),
              child: Text(
                "Privacy",
                style: shadowTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

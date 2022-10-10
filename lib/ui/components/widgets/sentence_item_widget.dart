import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/main_controller.dart';
import '../../../models/concrete/sentence_model.dart';
import '../dialogs/sentence_add_update_dialog.dart';

class SentenceItemWidget extends StatefulWidget {
  final SentenceModel currentSentence;

  const SentenceItemWidget({super.key, required this.currentSentence});

  @override
  State<SentenceItemWidget> createState() => _SentenceItemWidgetState();
}

class _SentenceItemWidgetState extends State<SentenceItemWidget> with SingleTickerProviderStateMixin {
  late MainController mainController;
  final Duration defaultAnimationDuration = const Duration(milliseconds: 200);
  final bool initiallyExpanded = false;

  late AnimationController _animationController;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late Animation<Color?> _headerColor;
  late Animation<Color?> _iconColor;

  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween = Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    mainController = Get.find();
    _animationController = AnimationController(duration: defaultAnimationDuration, vsync: this);

    _iconTurns = _animationController.drive(_halfTween.chain(_easeInTween));
    _heightFactor = _animationController.drive(_easeInTween);
    _headerColor = _animationController.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _animationController.drive(_iconColorTween.chain(_easeInTween));

    _isExpanded = PageStorage.of(context)?.readState(context) as bool? ?? initiallyExpanded;
    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _animationController.isDismissed;
    bool shouldRemoveChildren = closed;

    return AnimatedBuilder(
      animation: _animationController.view,
      builder: (BuildContext context, Widget? child) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: _isExpanded ? Theme.of(context).secondaryHeaderColor : Theme.of(context).primaryColor, style: BorderStyle.solid, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTileTheme.merge(
                iconColor: _iconColor.value,
                textColor: _headerColor.value,
                child: Stack(
                  children: [
                    Positioned(
                      child: ListTile(
                        onTap: _handleTap,

                        /// sentence title
                        title: Text(
                          widget.currentSentence.title,
                          style: TextStyle(
                            color: _isExpanded ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: _buildTrailingIcon(context),
                      ),
                    ),

                    /// delete icon
                    Positioned(
                      right: 0.08.sw,
                      top: 0.005.sh,
                      child: IconButton(
                        onPressed: () {
                          Get.defaultDialog(
                            title: 'UYARI',
                            middleText: 'Seçilen cümleyi silmek istediğinizden emin misiniz?',
                            backgroundColor: Colors.red.shade400,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            middleTextStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            radius: 30,
                            barrierDismissible: false,
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  mainController.deleteSentence(currentSentence: widget.currentSentence);

                                  Get.back();
                                  Get.snackbar(
                                    'UYARI',
                                    'Cümle başarıyla silindi.',
                                    borderColor: Colors.red,
                                    borderWidth: 2,
                                    snackPosition: SnackPosition.BOTTOM,
                                    maxWidth: MediaQuery.of(context).size.width * 0.4,
                                  );
                                },
                                child: const Text('EVET'),
                              ),
                              ElevatedButton(
                                onPressed: () => Get.back(),
                                child: const Text('HAYIR'),
                              ),
                            ],
                          );
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),

                    /// update icon
                    Positioned(
                      right: 0.04.sw,
                      top: 0.005.sh,
                      child: IconButton(
                        onPressed: () => SentenceAddUpdateDialog(currentSentence: widget.currentSentence),
                        icon: Icon(
                          Icons.refresh,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ClipRect(
                child: Align(
                  alignment: Alignment.center,
                  heightFactor: _heightFactor.value,
                  child: child,
                ),
              ),
            ],
          ),
        );
      },
      child: shouldRemoveChildren
          ? null
          : Offstage(
              offstage: closed,
              child: TickerMode(
                enabled: !closed,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.currentSentence.content,
                    style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ),
    );
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
  }

  Widget? _buildTrailingIcon(BuildContext context) {
    return RotationTransition(
      turns: _iconTurns,
      child: Icon(
        Icons.expand_more,
        color: _isExpanded ? Colors.deepOrangeAccent : Colors.blue,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    final ExpansionTileThemeData expansionTileTheme = ExpansionTileTheme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    _borderColorTween.end = theme.dividerColor;
    _headerColorTween
      ..begin = expansionTileTheme.collapsedTextColor ?? theme.textTheme.subtitle1!.color
      ..end = expansionTileTheme.textColor ?? colorScheme.primary;
    _iconColorTween
      ..begin = expansionTileTheme.collapsedIconColor ?? theme.unselectedWidgetColor
      ..end = expansionTileTheme.iconColor ?? colorScheme.primary;
    _backgroundColorTween
      ..begin = expansionTileTheme.collapsedBackgroundColor
      ..end = expansionTileTheme.backgroundColor;
    super.didChangeDependencies();
  }
}

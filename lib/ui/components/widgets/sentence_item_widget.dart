import 'package:flutter/material.dart';

import '../../../models/concrete/sentence_model.dart';

class SentenceItemWidget extends StatefulWidget {
  final SentenceModel sentenceModel;

  const SentenceItemWidget({super.key, required this.sentenceModel});

  @override
  State<SentenceItemWidget> createState() => _SentenceItemWidgetState();
}

class _SentenceItemWidgetState extends State<SentenceItemWidget> with SingleTickerProviderStateMixin {
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
            border: Border.all(color: const Color(0xff5B5B5B), style: BorderStyle.solid, width: 1),
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
                    ListTile(
                      onTap: _handleTap,
                      title: Text(widget.sentenceModel.title),
                      trailing: _buildTrailingIcon(context),
                    ),
                    Positioned(
                      top: 12,
                      right: 50,
                      child: InkWell(
                        child: const Icon(
                          Icons.restore_from_trash_sharp,
                          color: Colors.black54,
                        ),
                        onTap: () {
                          debugPrint('${widget.sentenceModel.id} item delete');
                        },
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 90,
                      child: InkWell(
                        child: const Icon(
                          Icons.recycling_rounded,
                          color: Colors.black54,
                        ),
                        onTap: () {
                          debugPrint('${widget.sentenceModel.id} item update');
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // _isExpanded
              //     ? const Padding(
              //         padding: EdgeInsets.symmetric(horizontal: 8.0),
              //         child: Divider(
              //           color: Colors.black38,
              //           height: 2,
              //         ),
              //       )
              //     : const SizedBox(),
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
                    widget.sentenceModel.content,
                    style: const TextStyle(fontSize: 18, color: Colors.blue, fontStyle: FontStyle.italic),
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
      child: const Icon(Icons.expand_more),
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

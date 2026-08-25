import 'package:flutter/material.dart';

class ExpandableChatText extends StatefulWidget {
  final String text;
  final bool isMe;

  const ExpandableChatText({
    super.key,
    required this.text,
    required this.isMe,
  });

  @override
  State<ExpandableChatText> createState() => _ExpandableChatTextState();
}

class _ExpandableChatTextState extends State<ExpandableChatText> {
  bool _isExpanded = false;
  static const int _maxLinesLimit = 8;

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isMe ? Colors.white : Colors.black87;
    final linkColor = widget.isMe ? Colors.white.withAlpha(200) : Colors.blue.shade700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            // We use a TextPainter to determine if the text exceeds our limit
            final span = TextSpan(
              text: widget.text,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            );
            final tp = TextPainter(
              text: span,
              maxLines: _maxLinesLimit,
              textDirection: TextDirection.ltr,
            );
            // If maxWidth is infinity, we need a fallback to allow wrapping
            final maxWidth = constraints.maxWidth.isFinite ? constraints.maxWidth : MediaQuery.of(context).size.width * 0.7;
            tp.layout(maxWidth: maxWidth);

            if (tp.didExceedMaxLines) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: 14, 
                      fontWeight: FontWeight.w500, 
                      color: textColor,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.start,
                    maxLines: _isExpanded ? null : _maxLinesLimit,
                    overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    child: Text(
                      _isExpanded ? 'See Less' : 'See More',
                      style: TextStyle(
                        fontSize: 13, 
                        fontWeight: FontWeight.w700, 
                        color: linkColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Text(
                widget.text,
                style: TextStyle(
                  fontSize: 14, 
                  fontWeight: FontWeight.w500, 
                  color: textColor,
                  height: 1.4,
                ),
                textAlign: TextAlign.start,
                softWrap: true,
              );
            }
          },
        ),
      ],
    );
  }
}

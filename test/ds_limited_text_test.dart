import 'package:ds_common/widgets/ds_limited_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('font size', (widgetTester) async {
    const textSpan = TextSpan(
      text: 'Some text. Some text. Some text. Some text.',
      style: TextStyle(
        fontSize: 10,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: 100);
    final height10 = textPainter.height;

    textPainter.text = const TextSpan(
      text: 'Some text. Some text. Some text. Some text.',
      style: TextStyle(
        fontSize: 10.2,
      ),
    );

    textPainter.layout(maxWidth: 100);
    final height10_2 = textPainter.height;

    expect(height10, 40);
    expect(height10_2, 80);
  });

  testWidgets('limited text height 1', (tester) async {
    await tester.pumpWidget(const Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: SizedBox(
          width: 100,
          child: DSLimitedText('Some text. Some text. Some text. Some text.',
            textAlign: TextAlign.start, style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
            maxHeight: 80,
          ),
        ),
      ),
    ));

    expect(find.text('Some text. Some text. Some text. Some text.', findRichText: true), findsOneWidget);

    final lt = find.byType(DSLimitedText);
    final ltSize = tester.getSize(lt);
    expect(ltSize.width, 100);
    expect(ltSize.height, lessThanOrEqualTo(80));
  });

  testWidgets('limited text height 2', (tester) async {
    await tester.pumpWidget(const Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: SizedBox(
          width: 150,
          child: DSLimitedText('Some text. Some text. Some text. Some text.',
            textAlign: TextAlign.start, style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
            maxHeight: 75,
          ),
        ),
      ),
    ));

    expect(find.text('Some text. Some text. Some text. Some text.', findRichText: true), findsOneWidget);

    final lt = find.byType(DSLimitedText);
    final ltSize = tester.getSize(lt);
    expect(ltSize.width, 150);
    expect(ltSize.height, lessThanOrEqualTo(75));
    expect(ltSize.height, greaterThanOrEqualTo(60));
  });

  testWidgets('limited text change height 1', (tester) async {
    Future<void> pump(double height) async {
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: 100,
            child: DSLimitedText('Some text. Some text. Some text. Some text.',
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
              maxHeight: height,
            ),
          ),
        ),
      ));
    }

    await pump(80);
    expect(find.text('Some text. Some text. Some text. Some text.', findRichText: true), findsOneWidget);
    final h80 = tester.getSize(find.byType(DSLimitedText)).height;
    expect(h80, lessThanOrEqualTo(80));
    expect(h80, greaterThanOrEqualTo(70));

    await pump(120);
    final h120 = tester.getSize(find.byType(DSLimitedText)).height;
    expect(h120, lessThanOrEqualTo(120));
    expect(h120, greaterThanOrEqualTo(90));
  });

  testWidgets('limited text change group 1', (tester) async {
    Future<void> pump(int group) async {
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: 100,
            child: DSLimitedText('Some text. Some text. Some text. Some text.',
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
              groupId: group,
              maxHeight: 100,
            ),
          ),
        ),
      ));
    }

    await pump(1);
    expect(find.text('Some text. Some text. Some text. Some text.', findRichText: true), findsOneWidget);
    final h1 = tester.getSize(find.byType(DSLimitedText)).height;
    expect(h1, 96);

    await pump(2);
    expect(find.text('Some text. Some text. Some text. Some text.', findRichText: true), findsOneWidget);
    final h2 = tester.getSize(find.byType(DSLimitedText)).height;
    expect(h2, 96);
  });

  // Returns "A RenderFlex overflowed by 77 pixels on the bottom." which is not reproducible in real renderer
  // Need to find a mistake

  // testWidgets('limited text group height 1', (tester) async {
  //   final items = [
  //     'Some text. Some text. Some text. Some text.',
  //     'Some text. Some text. Some text. Some text. Some text.',
  //     'Some text. Some text. Some text. Some text. Some text.',
  //     'Some text. Some text. Some text. Some text. Some text. Some text. Some text.',
  //   ];
  //   await tester.pumpWidget(Directionality(
  //     textDirection: TextDirection.ltr,
  //     child: Material(
  //       child: Center(
  //         child: SizedBox(
  //           width: 300,
  //           height: 300,
  //           child: Column(
  //             children: items.map((e) => Container(
  //               margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
  //               decoration: ShapeDecoration(
  //                 shape: RoundedRectangleBorder(
  //                   side: const BorderSide(
  //                     width: 1,
  //                     color: Colors.black,
  //                   ),
  //                   borderRadius: BorderRadius.circular(20),
  //                 ),
  //               ),
  //               child: Padding(
  //                 padding: const EdgeInsets.all(16),
  //                 child: Row(
  //                   children: [
  //                     SizedBox(height: 10,
  //                       child: Radio<bool>(
  //                         value: true,
  //                         groupValue: false,
  //                         onChanged: (value) {},
  //                       ),
  //                     ),
  //                     Expanded(
  //                       child: DSLimitedText(
  //                         e,
  //                         textAlign: TextAlign.start,
  //                         groupId: 1,
  //                         style: const TextStyle(
  //                           fontSize: 13,
  //                           fontWeight: FontWeight.w400,
  //                           color: Colors.grey,
  //                         ),
  //                         marginHeight: 2 * (16 + 4),
  //                         maxHeight: 300,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             )).toList(),
  //           ),
  //         ),
  //         ),
  //     ),
  //   ));
  // });

}

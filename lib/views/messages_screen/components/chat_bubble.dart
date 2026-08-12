import '../../../const/const.dart';

Widget chatBubble(Map<String, dynamic> data, {required bool isMine}) {
  return Directionality(
    textDirection: isMine ? TextDirection.rtl : TextDirection.ltr,
    child: Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isMine ? purpleColor : darkGrey,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ), // BorderRadius.only
      ), // BoxDecoration
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: ["${data['msg'] ?? ''}".text.white.size(16).make()],
      ), // Column
    ), // Container
  ); // Directionality
}

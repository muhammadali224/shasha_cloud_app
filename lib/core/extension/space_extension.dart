import 'package:gap/gap.dart';

extension EmptySpace on num {
  Gap get gap => Gap(toDouble());
}

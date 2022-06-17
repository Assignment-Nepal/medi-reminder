
import 'package:url_launcher/url_launcher.dart';

class CallsAndMessagesService {
  void call(String number) => launchUrl((Uri.parse("tel:$number")));
  void sendSms(String number) => launchUrl((Uri.parse("sms:+'60'+$number")));
}

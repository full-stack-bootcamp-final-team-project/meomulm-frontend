import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  static const String _title = '이용약관';

  static const String _effectiveDate = '2026년 2월 10일';

  static const String _providerName = 'meomulm-development';
  static const String _appName = '머묾';
  static const String _email = 'test@naver.com';
  static const String _generatorUrl = 'https://app-privacy-policy-generator.nisrulz.com/';

  static const List<String> _paragraphs = [
    '본 이용약관은 $_providerName(이하 "서비스 제공자")이 무료 서비스로 개발한 모바일 기기용 $_appName 앱(이하 "애플리케이션")에 적용됩니다.',
    '본 애플리케이션을 다운로드하거나 이용하는 즉시, 귀하는 다음 약관에 자동으로 동의하게 됩니다. 애플리케이션을 사용하기 전에 이 약관을 꼼꼼히 읽고 이해하시기를 강력히 권장합니다.',
    '본 애플리케이션, 애플리케이션의 일부 또는 당사의 상표를 무단으로 복제, 수정하는 것은 엄격히 금지됩니다. 애플리케이션의 소스 코드를 추출하거나, 애플리케이션을 다른 언어로 번역하거나, 파생 버전을 제작하려는 모든 시도는 허용되지 않습니다. 애플리케이션과 관련된 모든 상표, 저작권, 데이터베이스 권리 및 기타 지적 재산권은 서비스 제공업체의 소유입니다.',
    '서비스 제공자는 애플리케이션이 최대한 유익하고 효율적이도록 최선을 다하고 있습니다. 따라서 서비스 제공자는 언제든지 어떤 이유로든 애플리케이션을 수정하거나 서비스에 대한 요금을 부과할 권리를 보유합니다. 서비스 제공자는 애플리케이션 또는 서비스 이용에 대한 모든 요금을 명확하게 고지할 것을 보장합니다.',
    '본 애플리케이션은 서비스 제공을 위해 사용자가 서비스 제공자에게 제공한 개인 데이터를 저장하고 처리합니다. 사용자는 휴대전화의 보안과 애플리케이션 접근 권한을 유지할 책임이 있습니다. 서비스 제공자는 휴대전화의 공식 운영 체제에서 부과하는 소프트웨어 제한 및 제약을 제거하는 \'탈옥\' 또는 \'루팅\'을 강력히 권장하지 않습니다. 이러한 행위는 휴대전화를 멀웨어, 바이러스, 악성 프로그램에 노출시키고, 휴대전화의 보안 기능을 손상시키며, 애플리케이션이 제대로 작동하지 않거나 전혀 작동하지 않게 할 수 있습니다.',
    '서비스 제공업체는 특정 사항에 대해 책임을 지지 않음을 알려드립니다. 애플리케이션의 일부 기능은 Wi-Fi 또는 모바일 네트워크 제공업체를 통한 인터넷 연결이 필요합니다. Wi-Fi 접속 불가 또는 데이터 사용량 초과로 인해 애플리케이션이 정상적으로 작동하지 않는 경우, 서비스 제공업체는 책임을 지지 않습니다.',
    'Wi-Fi 네트워크가 연결되지 않은 지역에서 애플리케이션을 사용하는 경우, 이동통신사 이용 약관이 적용됩니다. 따라서 애플리케이션 접속 중 데이터 사용에 대한 이동통신사 요금 또는 기타 제3자 요금이 발생할 수 있습니다. 애플리케이션을 사용함으로써, 데이터 로밍을 해제하지 않고 거주 지역(즉, 국가 또는 지역) 외에서 애플리케이션을 사용하는 경우 발생하는 로밍 데이터 요금을 포함하여 이러한 모든 요금에 대한 책임을 수락하는 것입니다. 애플리케이션을 사용하는 기기의 요금 납부자가 본인이 아닌 경우, 요금 납부자의 허가를 받은 것으로 간주합니다.',
    '마찬가지로, 서비스 제공업체는 사용자의 애플리케이션 사용에 대해 항상 책임을 질 수는 없습니다. 예를 들어, 기기의 배터리 충전 상태를 유지하는 것은 사용자의 책임입니다. 기기의 배터리가 방전되어 서비스에 접속할 수 없는 경우, 서비스 제공업체는 책임을 지지 않습니다.',
    '서비스 제공업체의 책임과 관련하여, 서비스 제공업체는 애플리케이션의 최신성과 정확성을 항상 유지하기 위해 노력하지만, 제3자로부터 정보를 제공받아 사용자에게 제공하는 방식에는 한계가 있음을 알려드립니다. 따라서 서비스 제공업체는 사용자가 애플리케이션의 해당 기능을 전적으로 신뢰하여 발생하는 직간접적인 손실에 대해 어떠한 책임도 지지 않습니다.',
    '서비스 제공자는 언제든지 애플리케이션을 업데이트할 수 있습니다. 현재 애플리케이션은 운영 체제(및 향후 서비스 제공자가 애플리케이션 사용 가능 범위를 확장하기로 결정하는 추가 시스템)의 요구 사항에 따라 제공되지만, 이러한 요구 사항은 변경될 수 있으며, 애플리케이션을 계속 사용하려면 업데이트를 다운로드해야 합니다. 서비스 제공자는 애플리케이션이 항상 사용자에게 적합하고 사용자의 기기에 설치된 특정 운영 체제 버전과 호환되도록 업데이트할 것을 보장하지 않습니다. 그러나 사용자는 제공되는 경우 애플리케이션 업데이트를 항상 수락해야 합니다. 서비스 제공자는 또한 애플리케이션 제공을 중단하거나 사용자에게 통지 없이 언제든지 사용을 종료할 수 있습니다. 서비스 제공자가 달리 통지하지 않는 한, 사용 종료 시 (a) 본 약관에 따라 사용자에게 부여된 권리 및 라이선스는 종료되고, (b) 사용자는 애플리케이션 사용을 중단하고 (필요한 경우) 기기에서 애플리케이션을 삭제해야 합니다.',
  ];

  static const String _changesTitle = '이용약관의 변경 사항';
  static const List<String> _changesParagraphs = [
    '서비스 제공업체는 이용 약관을 주기적으로 업데이트할 수 있습니다. 따라서 변경 사항이 있는지 정기적으로 이 페이지를 확인하시기 바랍니다. 서비스 제공업체는 새로운 이용 약관을 이 페이지에 게시하여 변경 사항을 알려드립니다.',
    '본 이용약관은 $_effectiveDate부터 효력을 발생합니다.',
  ];

  static const String _contactTitle = '문의하기';
  static const List<String> _contactParagraphs = [
    '이용약관에 대한 문의사항이나 건의사항이 있으시면 언제든지 서비스 제공업체($_email)로 연락주시기 바랍니다.',
  ];

  static const String _footerText = '이 이용약관 페이지는 앱 개인정보 보호정책 생성기를 통해 생성되었습니다.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const _SectionTitle(_title),
            const SizedBox(height: 8),
            ..._paragraphs.map((p) => _Paragraph(p)).toList(),

            const SizedBox(height: 16),
            const _SectionTitle(_changesTitle),
            const SizedBox(height: 8),
            ..._changesParagraphs.map((p) => _Paragraph(p)).toList(),

            const SizedBox(height: 16),
            const _SectionTitle(_contactTitle),
            const SizedBox(height: 8),
            ..._contactParagraphs.map((p) => _Paragraph(p)).toList(),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            
            ElevatedButton(onPressed: () => context.pop(), child: Text("확인")),
            SizedBox(height: 20),

            Text(
              _footerText,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 6),
            _LinkButton(
              label: _generatorUrl,
              url: _generatorUrl,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  final String text;
  const _Paragraph(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  final String label;
  final String url;
  const _LinkButton({required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: () => _launch(url),
        icon: const Icon(Icons.open_in_new),
        label: Text(label),
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // 필요하면 스낵바 등으로 처리
    }
  }
}

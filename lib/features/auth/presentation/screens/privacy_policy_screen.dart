import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const String _providerName = 'meomulm-development';
  static const String _appName = '머묾';
  static const String _contactEmail = 'test@naver.com';
  static const String _effectiveDate = '2026년 2월 10일';
  static const String _generatorUrl = 'https://app-privacy-policy-generator.nisrulz.com/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('개인정보 보호정책')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const _SectionTitle('개인정보 보호정책'),
            _Paragraph(
              '이 개인정보 보호정책은 $_providerName(이하 "서비스 제공자")가 무료 서비스로 개발한 모바일 기기용 $_appName 앱(이하 "애플리케이션")에 적용됩니다. 이 서비스는 "있는 그대로" 제공됩니다.',
            ),

            const SizedBox(height: 16),
            const _SectionTitle('정보 수집 및 이용'),
            const _Paragraph('이 애플리케이션은 사용자가 다운로드하고 사용할 때 정보를 수집합니다. 이 정보에는 다음과 같은 내용이 포함될 수 있습니다.'),
            const _BulletList(items: [
              '기기의 인터넷 프로토콜 주소(예: IP 주소)',
              '사용자가 애플리케이션에서 방문한 페이지, 방문 시간 및 날짜, 해당 페이지에서 보낸 시간',
              '지원서 작성에 소요된 시간',
              '모바일 기기에서 사용하는 운영 체제',
            ]),
            _Paragraph(
              '이 애플리케이션은 사용자의 기기 위치 정보를 수집하며, 이를 통해 서비스 제공업체는 사용자의 대략적인 지리적 위치를 파악하고 다음과 같은 방식으로 활용할 수 있습니다.',
            ),
            const _BulletList(items: [
              '위치 정보 서비스: 서비스 제공업체는 위치 데이터를 활용하여 개인 맞춤형 콘텐츠, 관련 추천 및 위치 기반 서비스와 같은 기능을 제공합니다.',
              '분석 및 개선: 집계되고 익명화된 위치 데이터는 서비스 제공업체가 사용자 행동을 분석하고, 추세를 파악하며, 애플리케이션의 전반적인 성능과 기능을 개선하는 데 도움이 됩니다.',
              '제3자 서비스: 서비스 제공자는 주기적으로 익명화된 위치 데이터를 외부 서비스에 전송할 수 있습니다. 이러한 서비스는 애플리케이션 개선 및 서비스 최적화를 지원합니다.',
            ]),
            const _Paragraph('서비스 제공업체는 귀하가 제공한 정보를 이용하여 중요 정보, 필수 고지 사항 및 마케팅 프로모션을 제공하기 위해 때때로 귀하에게 연락할 수 있습니다.'),
            _Paragraph(
              '더 나은 사용자 경험을 위해, 서비스 제공자는 애플리케이션 사용 중 귀하에게 특정 개인 식별 정보(예: $_appName 등)를 제공하도록 요청할 수 있습니다. 서비스 제공자가 요청하는 정보는 서비스 제공자가 보관하며 본 개인정보 처리방침에 명시된 바에 따라 사용됩니다.',
            ),

            const SizedBox(height: 16),
            const _SectionTitle('제3자 접근'),
            const _Paragraph(
              '집계되고 익명화된 데이터만 주기적으로 외부 서비스로 전송되어 서비스 제공업체가 애플리케이션 및 서비스를 개선하는 데 도움을 줍니다. 서비스 제공업체는 본 개인정보 처리방침에 설명된 방식으로 귀하의 정보를 제3자와 공유할 수 있습니다.',
            ),
            const _Paragraph('서비스 제공자는 사용자가 제공한 정보와 자동으로 수집된 정보를 공개할 수 있습니다.'),
            const _BulletList(items: [
              '법률에 따라 요구되는 경우, 예를 들어 소환장이나 유사한 법적 절차를 준수하기 위해;',
              '정보 공개가 본인의 권리를 보호하거나, 귀하 또는 타인의 안전을 보호하거나, 사기 행위를 조사하거나, 정부의 요청에 응하기 위해 필요하다고 선의로 판단하는 경우.',
              '당사가 공개하는 정보를 당사를 대신하여 업무를 수행하는 신뢰할 수 있는 서비스 제공업체는 해당 정보를 독립적으로 사용하지 않으며, 본 개인정보 보호정책에 명시된 규칙을 준수하기로 동의했습니다.',
            ]),

            const SizedBox(height: 16),
            const _SectionTitle('거부권'),
            const _Paragraph('앱을 삭제하면 앱의 모든 정보 수집을 간편하게 중단할 수 있습니다. 모바일 기기 또는 앱 스토어/네트워크에서 제공하는 표준 삭제 절차를 이용하시면 됩니다.'),

            const SizedBox(height: 16),
            const _SectionTitle('데이터 보존 정책'),
            _Paragraph(
              '서비스 제공자는 사용자가 애플리케이션을 사용하는 동안 그리고 그 후 합리적인 기간 동안 사용자가 제공한 데이터를 보관합니다. 애플리케이션을 통해 제공한 사용자 제공 데이터의 삭제를 원하시는 경우, $_contactEmail로 문의해 주시면 합리적인 시간 내에 답변드리겠습니다.',
            ),

            const SizedBox(height: 16),
            const _SectionTitle('어린이들'),
            const _Paragraph('서비스 제공자는 13세 미만 아동으로부터 데이터를 고의로 수집하거나 아동을 대상으로 마케팅을 하기 위해 애플리케이션을 사용하지 않습니다.'),
            _Paragraph(
              '서비스 제공자는 아동으로부터 고의로 개인 식별 정보를 수집하지 않습니다. 서비스 제공자는 모든 아동에게 애플리케이션 및/또는 서비스를 통해 개인 식별 정보를 절대 제출하지 않도록 권장합니다. 서비스 제공자는 부모 및 법정 보호자에게 자녀의 인터넷 사용을 모니터링하고, 자녀가 부모 또는 법정 보호자의 허락 없이 애플리케이션 및/또는 서비스를 통해 개인 식별 정보를 제공하지 않도록 지도함으로써 본 정책을 준수하도록 도와주시기를 권장합니다. 만약 아동이 애플리케이션 및/또는 서비스를 통해 서비스 제공자에게 개인 식별 정보를 제공했다고 생각되는 경우, 서비스 제공자($_contactEmail)에게 연락하여 필요한 조치를 취할 수 있도록 도와주시기 바랍니다. 또한, 거주 국가에서 개인 식별 정보 처리에 동의하려면 만 16세 이상이어야 합니다(일부 국가에서는 부모 또는 법정 보호자가 대신 동의할 수 있습니다).',
            ),

            const SizedBox(height: 16),
            const _SectionTitle('보안'),
            const _Paragraph('서비스 제공업체는 고객 정보의 기밀 유지를 중요하게 생각합니다. 서비스 제공업체는 처리 및 보관하는 정보를 보호하기 위해 물리적, 전자적, 절차적 안전장치를 제공합니다.'),

            const SizedBox(height: 16),
            const _SectionTitle('변경 사항'),
            const _Paragraph(
              '본 개인정보 처리방침은 어떠한 이유로든 수시로 업데이트될 수 있습니다. 서비스 제공자는 본 페이지에 새로운 개인정보 처리방침을 게시하여 변경 사항을 알려드립니다. 변경 사항이 있는지 정기적으로 본 개인정보 처리방침을 확인하시기 바랍니다. 서비스를 계속 이용하는 것은 모든 변경 사항에 대한 동의로 간주됩니다.',
            ),
            _Paragraph('본 개인정보 보호정책은 $_effectiveDate부터 효력을 발생합니다.'),

            const SizedBox(height: 16),
            const _SectionTitle('귀하의 동의'),
            const _Paragraph('본 애플리케이션을 사용함으로써 귀하는 현재 및 향후 당사가 수정할 수 있는 본 개인정보 처리방침에 명시된 바에 따라 귀하의 정보 처리에 동의하는 것입니다.'),

            const SizedBox(height: 16),
            const _SectionTitle('문의하기'),
            _Paragraph(
              '애플리케이션 사용 중 개인정보 보호와 관련하여 궁금한 점이 있거나 개인정보 처리방침에 대해 질문이 있는 경우, 서비스 제공업체($_contactEmail)로 이메일을 보내주시기 바랍니다.',
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 20),

            ElevatedButton(onPressed: () => context.pop(), child: Text("확인")),
            SizedBox(height: 20),

            const Text(
              '이 개인정보 보호정책 페이지는 앱 개인정보 보호정책 생성기를 통해 생성되었습니다.',
            ),
            const SizedBox(height: 20),
            _LinkButton(label: _generatorUrl, url: _generatorUrl),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
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

class _BulletList extends StatelessWidget {
  final List<String> items;
  const _BulletList({required this.items});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (t) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('•  '),
                Expanded(child: Text(t, style: style)),
              ],
            ),
          ),
        )
            .toList(),
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
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

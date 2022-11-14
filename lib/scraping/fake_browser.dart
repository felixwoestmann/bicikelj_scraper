import 'package:puppeteer/puppeteer.dart';

class FakeBrowser {
  static Future<String> obtainRefreshToken(String refreshTokenKey) async {
    // Download the Chromium binaries, launch it and connect to the "DevTools"
    var browser = await puppeteer.launch(
      headless: true,
      args: ['--no-sandbox'],
    );
    var page = await browser.newPage();
    // Go to a page and wait to be fully loaded, then get LocalStorage
    await page.goto('https://www.bicikelj.si/en/mapping', wait: Until.networkIdle);
    Map<String, dynamic> localStorage = await page.evaluate('() =>  Object.assign({}, window.localStorage)');
    await browser.close();
    if (localStorage.containsKey(refreshTokenKey)) {
      return localStorage[refreshTokenKey]!;
    } else {
      throw Exception('No refresh token found in LocalStorage');
    }
  }
}

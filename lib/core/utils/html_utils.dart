class HtmlUtils {
  static String stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static String preview(String html, {int max = 150}) {
    final text = stripHtml(html);
    return text.length <= max ? text : '${text.substring(0, max)}…';
  }
}

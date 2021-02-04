from weasyprint import HTML, CSS
from weasyprint.fonts import FontConfiguration
import pypandoc

font_config = FontConfiguration()
html = HTML(string='<h1>The title</h1>')
css = CSS(string='''
    @font-face {
        font-family: Gentium;
        src: url(http://example.com/fonts/Gentium.otf);
    }
    h1 { font-family: Gentium }''', font_config=font_config)
html.write_pdf(
    'example.pdf', stylesheets=[css],
    font_config=font_config)

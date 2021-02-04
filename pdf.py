from weasyprint import HTML, CSS
from weasyprint.fonts import FontConfiguration
import argparse
import pypandoc
import frontmatter

parser = argparse.ArgumentParser()
parser.add_argument("-f", "--file", help="file to send")
# parser.add_argument('-s', '--send', action='store_true', help="send immediately")
args = parser.parse_args()

with open(args.file) as f:
    md = f.read()
    header, body = frontmatter.parse(md)
    pandoc_md_style = ('markdown'
                '+autolink_bare_uris'
                '-blank_before_blockquote')
    html = pypandoc.convert_text(md, 'html', format=pandoc_md_style)

font_config = FontConfiguration()
html = HTML(string=html)
css = CSS(string='''
    html { font-family: Cousine }''', font_config=font_config)
html.write_pdf(
    'example.pdf', stylesheets=[css],
    font_config=font_config)

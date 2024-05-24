from pathlib import Path
import glob
from lxml import etree
from datetime import datetime

import logging

logger = logging.getLogger(__name__)

import argparse

cmdline_parser = argparse.ArgumentParser(prog="generate_extension_view",
                                         usage='%(prog)s [options]',
                                         description="Generates the required FpML view from the starting XSDs.")

cmdline_parser.add_argument('--xsd-root-folder',
                            type=Path,
                            required=True,
                            help="The root folder for the view generation, containing the starting XSDs.")
cmdline_parser.add_argument('--target-version',
                            type=str,
                            required=True,
                            help='The target version for the view generation.')
cmdline_parser.add_argument('--target-view',
                            type=str,
                            required=False,
                            default='confirmation',
                            help="The target view for the view generation, defaults to 'confirmation'.")
cmdline_parser.add_argument('--date',
                            type=str,
                            required=False,
                            default=datetime.now().date().isoformat(),
                            help="The date when the view was generated, defaults to today's. Use format yyyy-mm-dd.")
def main():

    args = cmdline_parser.parse_args()

    XSD_root_folder = args.xsd_root_folder
    XSL_target_version = args.target_version
    XSL_target_view = args.target_view
    XSL_date = args.date
    XSL_year = str(datetime.fromisoformat(XSL_date).year)
    XSL_yearo = XSL_year

    XSL_extension_view_file = XSD_root_folder / "scripts" / "generate-extension-view.xsl"

    xsl = etree.parse(XSL_extension_view_file)
    transformer = etree.XSLT(xsl)

    master_folder = XSD_root_folder / "src" / "schema"
    target_folder = master_folder / XSL_target_view
    target_folder.mkdir(exist_ok=True)

    for fn in glob.iglob('*.xsd', root_dir=master_folder):
        f = master_folder / fn
        logger.info(f'Processing file {fn}')
        if f.name.startswith('fpml'):
            fname = target_folder / (f.stem + "-" + XSL_target_version + ".xsd")
        else:
            fname = target_folder / f.name
        pre = etree.parse(f)
        try:
            post = transformer(pre, 
                               version=etree.XSLT.strparam(XSL_target_version),
                               view=etree.XSLT.strparam(XSL_target_view),
                               date=etree.XSLT.strparam(XSL_date),
                               year=etree.XSLT.strparam(XSL_year),
                               yearo=etree.XSLT.strparam(XSL_yearo),)
            post.write(fname)
        except etree.XSLTApplyError:
            # the view may not be applicable for certain xsd hence
            # it will raise an error, so just pass
            pass


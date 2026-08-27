import os
import urllib.request

project = "onap"
release = "master"
version = "master"

# Map to 'latest' if this file is used in 'latest' (master) 'doc' branch.
# Change to {releasename} after you have created the new 'doc' branch.
branch = 'latest'

author = "Open Network Automation Platform"
# yamllint disable-line rule:line-length
copyright = "ONAP. Licensed under Creative Commons Attribution 4.0 International License"

pygments_style = "sphinx"
html_theme = "sphinx_rtd_theme"
html_theme_options = {
  "style_nav_header_background": "white",
  "sticky_navigation": "False" }
html_logo = "_static/logo_onap_2024.png"
html_favicon = "_static/favicon.ico"
html_static_path = ["_static"]
html_show_sphinx = False
templates_path = ["_templates"]

# The sidebar logo has to lead back to the ONAP documentation root, staying on the
# release the reader is already on. The parent 'onap' project is not branched for
# every release the subprojects publish -- there is no /en/rabat/ or /en/quebec/
# there -- so probe the versioned URL and fall back to the bare host, which Read
# the Docs resolves to the parent's default version.
onap_docs_home = "https://docs.onap.org/"
_rtd_version = os.environ.get("READTHEDOCS_VERSION", "")
if _rtd_version and os.environ.get("READTHEDOCS_VERSION_TYPE") != "external":
    _versioned_home = "{}{}/{}/".format(
        onap_docs_home, os.environ.get("READTHEDOCS_LANGUAGE", "en"), _rtd_version)
    try:
        _probe = urllib.request.Request(_versioned_home, method="HEAD")
        # docs.onap.org answers 403 to the default Python-urllib user agent.
        _probe.add_header("User-Agent", "onap-docs-build (+https://docs.onap.org)")
        with urllib.request.urlopen(_probe, timeout=5) as _response:
            if _response.status == 200:
                onap_docs_home = _versioned_home
    except OSError:
        pass

html_context = {"onap_docs_home": onap_docs_home}

extensions = [
    'sphinx.ext.intersphinx',
    'sphinx.ext.graphviz',
    'sphinxcontrib.mermaid',
    'sphinxcontrib.openapi',
    'sphinxcontrib.plantuml',
    'sphinx_toolbox.collapse',
    'sphinxcontrib.redoc'
]

redoc_uri = 'https://cdn.redoc.ly/redoc/latest/bundles/redoc.standalone.js'

redoc = [
    {
        'name': 'Policy API',
        'page': 'api/local-swagger',
        'spec': 'https://raw.githubusercontent.com/onap/policy-api/' + release + '/main/src/main/resources/openapi/openapi.yaml',
        'opts': {
            'suppress-warnings': True,
            'hide-hostname': True,
        }
    },
    {
        'name': 'Policy PAP',
        'page': 'pap/local-swagger',
        'spec': 'https://raw.githubusercontent.com/onap/policy-pap/' + release + '/main/src/main/resources/openapi/openapi.yaml',
        'opts': {
            'suppress-warnings': True,
            'hide-hostname': True,
        }
    },
    {
        'name': 'Policy XACML',
        'page': 'xacml/local-swagger',
        'spec': 'https://raw.githubusercontent.com/onap/policy-xacml-pdp/' + release + '/main/src/main/resources/openapi/openapi.yaml',
        'opts': {
            'suppress-warnings': True,
            'hide-hostname': True,
        }
    },
    {
        'name': 'Policy OPA',
        'page': 'opa/local-swagger',
        'spec': 'https://raw.githubusercontent.com/onap/policy-opa-pdp/' + release + '/api/openapi.yaml',
        'opts': {
            'suppress-warnings': True,
            'hide-hostname': True,
        }
    },
    {
        'name': 'Policy DROOLS',
        'page': 'drools/local-swagger',
        'spec': 'https://raw.githubusercontent.com/onap/policy-drools-pdp/' + release + '/feature-healthcheck/src/main/resources/openapi/openapi.yaml',
        'opts': {
            'suppress-warnings': True,
            'hide-hostname': True,
        }
    },
    {
        'name': 'Policy ACM-R',
        'page': 'clamp/acm/api-protocol/local-swagger',
        'spec': 'https://raw.githubusercontent.com/onap/policy-clamp/' + release + '/runtime-acm/src/main/resources/openapi/openapi.yaml',
        'opts': {
            'suppress-warnings': True,
            'hide-hostname': True,
        }
    },
]

intersphinx_mapping = {}
doc_url = 'https://docs.onap.org/projects'
master_doc = 'index'

exclude_patterns = ['.tox']

spelling_word_list_filename='spelling_wordlist.txt'
spelling_lang = "en_GB"

#
# Example:
# intersphinx_mapping['onap-aai-aai-common'] = ('{}/onap-aai-aai-common/en/%s'.format(doc_url) % branch, None)
#

html_last_updated_fmt = '%d-%b-%y %H:%M'

def setup(app):
    app.add_css_file("css/ribbon.css")

linkcheck_ignore = [
  r'http://localhost:\d+/',
  r'.(.*?)/local-swagger.html(.*?)'
]

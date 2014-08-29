unit uHTMLUtils;

interface

uses
  SysUtils, uSpecialStringUtils, RegExpr;

function HTML2Text(const AHTML: string; AWithURLLink: Boolean = True; AUseHTMLDecode: Boolean = False): string;

implementation

function HTML2Text(const AHTML: string; AWithURLLink: Boolean = True; AUseHTMLDecode: Boolean = False): string;
var
  _HTML: string;
begin
  with TRegExpr.Create do
    try
      _HTML := ReplaceRegExpr('<style(.*?)/style>', AHTML, '', False);
      if AWithURLLink then
        _HTML := ReplaceRegExpr('<a href="(.*?)".*?>(.*?)<\/a>', _HTML, '$2 ($1)', True)
      else
        _HTML := ReplaceRegExpr('<a href="(.*?)".*?>(.*?)<\/a>', _HTML, '$2', True);
      _HTML := ReplaceRegExpr('<(.*?)>', _HTML, '', False);
    finally
      Free;
    end;
  if not AUseHTMLDecode then
    _HTML := StringReplaceMultiple(_HTML, ['&quot;', '&amp;', '&lt;', '&gt;'], ['"', '&', '<', '>'], True);

  _HTML := StringReplaceMultiple(_HTML, { }
    ['&nbsp;', '&lsquo;', '&rsquo;', '&sbquo;', '&ldquo;', '&rdquo;', '&bdquo;', '&iexcl;', '&cent;', '&pound;', '&curren;', '&yen;', '&brvbar;', '&sect;',
    '&uml;', '&copy;', '&ordf;', '&laquo;', '&not;', '&shy;', '&reg;', '&macr;', '&deg;', '&plusmn;', '&sup2;', '&sup3;', '&acute;', '&micro;', '&para;',
    '&middot;', '&cedil;', '&sup1;', '&ordm;', '&raquo;', '&frac14;', '&frac12;', '&frac34;', '&iquest;', '&Agrave;', '&Aacute;', '&Acirc;', '&Atilde;',
    '&Auml;', '&Aring;', '&Aelig;', '&Ccedil;', '&Egrave;', '&Eacute;', '&Ecirc;', '&Euml;', '&Igrave;', '&Iacute;', '&Icirc;', '&Iuml;', '&Eth;', '&Ntilde;',
    '&Ograve;', '&Oacute;', '&Ocirc;', '&Otilde;', '&Ouml;', '&times;', '&Oslash;', '&Ugrave;', '&Uacute;', '&Ucirc;', '&Uuml;', '&Yacute;', '&thorn;',
    '&szlig;', '&agrave;', '&aacute;', '&acirc;', '&atilde;', '&auml;', '&aring;', '&aelig;', '&ccedil;', '&egrave;', '&eacute;', '&ecirc;', '&euml;',
    '&igrave;', '&iacute;', '&icirc;', '&iuml;', '&eth;', '&ntilde;', '&ograve;', '&oacute;', '&ocirc;', '&otilde;', '&ouml;', '&divide;', '&oslash;',
    '&ugrave;', '&uacute;', '&ucirc;', '&uuml;', '&yacute;', '&thorn;', '&yuml;', '&hellip;', '&ndash;', '&mdash;', '&trade;', '&euro;'], { }
    [' ', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '#0', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�',
    '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�',
    '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�',
    '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�'], True);

  Result := _HTML;
end;

end.

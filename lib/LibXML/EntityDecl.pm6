use LibXML::Node;

unit class LibXML::EntityDecl
    is LibXML::Node;

use LibXML::Native;

submethod TWEAK(LibXML::Node :doc($)!, xmlEntityDecl:D :struct($)!) { }
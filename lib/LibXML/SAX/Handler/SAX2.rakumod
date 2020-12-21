# a base class that provides a full set of SAX2 callbacks
use LibXML::SAX::Handler;

class LibXML::SAX::Handler::SAX2
    is LibXML::SAX::Handler {
    use LibXML::Raw;
    use NativeCall;
    use LibXML::SAX::Handler::SAX2::Locator;
    has LibXML::SAX::Handler::SAX2::Locator $.locator handles<line-number column-number> .= new;

    use LibXML::Document;
    use LibXML::DocumentFragment;
    use LibXML::Types :QName, :NCName;

    multi method publish(LibXML::Document $doc!) {
        $doc;
    }
    multi method publish(LibXML::DocumentFragment $doc!) {
        $doc;
    }

    constant Ctx = xmlParserCtxt;

    method isStandalone(Ctx :$ctx!) returns Bool {
        ? $ctx.xmlSAX2IsStandalone;
    }

    method startDocument(Ctx :$ctx!) {
        $ctx.xmlSAX2StartDocument;
    }

    method endDocument(Ctx :$ctx!) {
        $ctx.xmlSAX2EndDocument;
    }

    method startElement(QName:D $name, CArray :$atts-raw!, Ctx :$ctx!) {
        $ctx.xmlSAX2StartElement($name, $atts-raw);
    }

    method endElement(QName:D $name, Ctx :$ctx!) {
        $ctx.xmlSAX2EndElement($name);
    }

    method startElementNs($local-name, Str :$prefix!, Str :$uri!, UInt :$num-namespaces!, CArray :$namespaces!, UInt :$num-atts!, UInt :$num-defaulted!, CArray :$atts-raw!, Ctx :$ctx!) {
        $ctx.xmlSAX2StartElementNs($local-name, $prefix, $uri, $num-namespaces, $namespaces, $num-atts, $num-defaulted, $atts-raw);
    }

    method endElementNs($local-name, Str :$prefix, Str :$uri, Ctx :$ctx!) {
        $ctx.xmlSAX2EndElementNs($local-name, $prefix, $uri);
    }

    method characters(Str $chars, Ctx :$ctx!) {
        my Blob $buf = $chars.encode;
        $ctx.xmlSAX2Characters($buf, +$buf);
    }

    method getEntity(Str $name, Ctx :$ctx!) {
        $ctx.xmlSAX2GetEntity($name);
    }
}

=begin pod

=head2 Description

SAX2 is at the very heart of LibXML DOM construction. The standard SAX2 callbacks are what are used to constructed a DOM.

L<LibXML::SAX::Handler::SAX2> is a base class that provides access to LibXML's standard SAX2 callbacks. You may want to inherit from it if you wish to modify or intercept LibXML's standard callbacks, but do not want to completely replace them.

If the handler is acting as a filter, it should at some point redispatch via 'callsame()', 'nextsame()', etc, if the parsed item is to be retained.

=head3 Available SAX Callbacks

=head4 method startDocument

  method startDocument(
      xmlParserCtxt :$ctx,      # the raw user data (XML parser context)
  )

Called when the document starts being processed.

=head4 method endDocument

    method endDocument(
        xmlParserCtxt :$ctx,      # the raw user data (XML parser context)
    )

Called when the document end has been detected.

=head4 method isStandalone

    method isStandalone(
        xmlParserCtxt :$ctx,      # the raw user data (XML parser context)) returns Bool

Determine whether the document is considered standalone. I.e. any associated DTD is used for validation only.

=head4 method attributeDecl

    method attributeDecl(
        Str $elem,                # the name of the element
        Str $fullname,	      # the attribute name
        xmlParserCtxt :$ctx,      # the raw user data (XML parser context)
        UInt :$type,              # the attribute type
        UInt :$def, 	      # the type of default value
        Str  :$default-value,     # the attribute default value
        Uint :$tree,              # the tree of enumerated value set
    )

An attribute definition has been parsed.

=head4 method startElement

    method startElement(
        Str $name,                # the element name
        :%attributes,             # cooked attributes
        CArray[Str] :$atts-raw,   # raw attributes as name-value pairs (null terminated)
        xmlParserCtxt :$ctx,      # the raw user data (XML parser context)
    )

Called when an opening tag has been processed.

=head4 method endElement

    method endElement(
        Str $name,                # the element name
        xmlParserCtxt :$ctx,      # the raw user data (XML parser context)
    )

Called when the end of an element has been detected.

=head4 method startElementNs

    method startElementNs(
        Str $local-name,          # the local name of the element
        Str :$prefix,             # the element namespace prefix, if available
        Str :$uri,                # the element namespace name, if available
        UInt :$num-namespaces,    # number of namespace definitions on that node
        CArray[Str] :$namespaces, # raw namespaces as name-value pairs
        CArray[Str] :$atts-raw,   # raw attributes as name-value pairs
        UInt :$num-attributes,    # the number of attributes on that node
        UInt :$num-defaulted,     # the number of defaulted attributes. These are at the end of the array
        xmlParserCtxt :$ctx,      # the raw user data (XML parser context)
    )

SAX2 callback when an element start has been detected by the parser. It provides the namespace informations for the element, as well as the new namespace declarations on the element.

=head4 method endElementNs

    method endElementNs(
        Str $local-name,          # the element name
        Str :$prefix,             # the element namespace prefix, if available
        Str :$uri,                # the element namespace name, if available
        xmlParserCtxt :$ctx,      # the raw user data (XML parser context)
    )

Called when the end of an element has been detected. It provides the namespace information.

=head4 method characters

    method characters(
        Str $chars,               # the element name
        Str :$uri,                # the element namespace name, if available
        xmlParserCtxt :$ctx,      # the raw user data (XML parser context)
    )

Receive some characters from the parser.

=head4 method cdataBlock

    method cdataBlock(
        Str $chars,               # the element name
        xmlParserCtxt :$ctx,      # the raw user data (XML parser context)
    )

Receive a CDATA block from the parser.

=head4 method ignorableWhitespace

    method ignorableWhitespace(
        Str $chars,               # the element name
        xmlParserCtxt :$ctx,      # the raw user data (XML parser context)
    )

Receive ignorable whitespace from the parser.

=head4 method getEntity

    method getEntity(
        Str $name,                # the element name
        xmlParserCtxt :$ctx,      # the raw user data (XML parser context)
    )

Get an entities data

=head4 method processingInstruction

  method processingInstruction(
      Str $target,              # the target name
      Str $data,                # the PI data
      xmlParserCtxt :$ctx,      # the raw user data (XML parser context)
  )

Get a processing instruction

=head4 method serror

    method getEntity(
        X::LibXML $error,         # the element name
    )

Handle a structured error form the parser.

=head4 method publish

    method publish(
        LibXML::Document $doc
    ) returns Any:D

I<Not part of the standard SAX interface>.

As well as the standard SAX2 callbacks (as described in L<LibXML::SAX::Builder>). There is a `publish()` method that returns the completed LibXML document.

The `publish()` can also be overridden to perform final document construction and possibly return non-LibXML document. See <LibXML::SAX::Handler::XML> for an example which uses SAX parsing but produces a pure Raku L<XML> document.

=end pod

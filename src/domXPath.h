#ifndef __LIBXML_DOM_XPATH_H__
#define __LIBXML_DOM_XPATH_H__

#include <libxml/tree.h>
#include <libxml/xpath.h>
#include "xml6.h"

void
perlDocumentFunction( xmlXPathParserContextPtr ctxt, int nargs );

xmlNodeSetPtr
domXPathSelectNodeSet(xmlXPathObjectPtr);

xmlNodeSetPtr
domXPathSelectStr( xmlNodePtr refNode, xmlChar* xpathstring );

void
domReferenceXPathObject(xmlXPathObjectPtr);

void
domReleaseXPathObject(xmlXPathObjectPtr);

xmlNodeSetPtr
domXPathSelect( xmlNodePtr refNode, xmlXPathCompExprPtr comp );

xmlXPathContextPtr
domXPathNewCtxt(xmlNodePtr refNode);

void
domXPathFreeCtxt(xmlXPathContextPtr ctxt);

xmlXPathObjectPtr
domXPathFind( xmlNodePtr refNode, xmlXPathCompExprPtr comp, int to_bool );

xmlXPathObjectPtr
domXPathFindCtxt( xmlXPathContextPtr ctxt, xmlXPathCompExprPtr comp, int to_bool );

void
domReferenceNodeSet(xmlNodeSetPtr self);

void
domReleaseNodeSet(xmlNodeSetPtr self);

xmlNodeSetPtr
domXPathSelectCtxt( xmlXPathContextPtr ctxt, xmlXPathCompExprPtr comp);

#endif

#ifndef __XML6_SAX_H
#define __XML6_SAX_H

#include <libxml/parser.h>
DLLEXPORT void xml6_sax_set_startElement(xmlSAXHandlerPtr sax, startElementSAXFunc func);

#endif /* __XML6_SAX_H */
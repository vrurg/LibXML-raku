#include "xml6.h"
#include "xml6_sax.h"

DLLEXPORT void xml6_sax_set_startElement(xmlSAXHandlerPtr sax, startElementSAXFunc func) {
  sax->startElement = func;
}
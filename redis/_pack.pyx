cdef bytes SYM_STAR = b'*'
cdef bytes SYM_DOLLAR = b'$'
cdef bytes SYM_CRLF = b'\r\n'
cdef bytes SYM_LF = b'\n'

cdef extern from "Python.h":
    object PyObject_Str(object v)

cdef _encode(self, value):
    "Return a bytestring representation of the value"
    if isinstance(value, bytes):
        return value
    if isinstance(value, float):
        return repr(value)
    if isinstance(value, unicode):
        return (<unicode>value).encode(self.encoding, self.encoding_errors)
    if not isinstance(value, basestring):
        return PyObject_Str(value)

def _pack_command(self, *args):
    "Pack a series of arguments into a value Redis command"
    cdef bytes enc_value
    output = [SYM_STAR, PyObject_Str(len(args)), SYM_CRLF]
    for value in args:
        enc_value = _encode(self, value)
        output.append(SYM_DOLLAR)
        output.append(PyObject_Str(len(enc_value)))
        output.append(SYM_CRLF)
        output.append(enc_value)
        output.append(SYM_CRLF)
    return ''.join(output)

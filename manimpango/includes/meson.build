cython_headers = ['cairo.pxd', 'glib.pxd', 'pango.pxd']
foreach cython_header : cython_headers
  configure_file(
    input: cython_header,
    output: cython_header,
    copy: true,
  )
endforeach

python.install_sources(
  cython_headers,
  pure : false,
  subdir: 'manimpango/include'
)

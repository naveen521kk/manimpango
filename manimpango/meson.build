cython_include_dir = [ meson.current_source_dir() / 'includes' ]

python_sources = [
  '__init__.py',
  '_version.py',
  '_distributor_init.py',
  'py.typed'
]
foreach python_source : python_sources
  configure_file(
    input: python_source,
    output: python_source,
    copy: true,
  )
endforeach

python.install_sources(python_sources,
  pure : false,
  subdir : 'manimpango'
)

python_dep = python.dependency()

pangocairo_dep = dependency(
    'pangocairo',
    version: pango_require_version,
    required: true
)
pangoft2_dep = dependency(
    'pangoft2',
    version: pango_require_version,
    required: true
)

subdir('includes')
subdir('font_manager')
subdir('layout')
subdir('renderer')
subdir('utils')
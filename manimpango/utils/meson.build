subdir_val = 'manimpango/utils'

python_sources = [
    '__init__.py',
    '_list_fonts.pyi',    
    'utils.py',
    'colours.pyi',
    'colours.pyx',
    'enums.pyi',
]

foreach python_source : python_sources
  configure_file(
    input: python_source,
    output: python_source,
    copy: true,
  )
endforeach
python.install_sources(
    python_sources,
    pure : false,
    subdir: subdir_val
)

cython_include_dir += [meson.current_source_dir()]
cython_sources = [
  '_cutils.pyx',
  '_list_fonts.pyx',
  'colours.pyx',
  'enums.pyx'
]
cython_args = [
    cython,
    '@INPUT@',
    '-o',
    '@OUTPUT@',
    '-3'
]

foreach include_dir: cython_include_dir
    cython_args += '-I' + include_dir
endforeach

if get_option('buildtype') == 'debug' or get_option('buildtype') == 'debugoptimized'
    cython_args += [
        '--gdb'
    ]
endif

if get_option('coverage')
    cython_args += [
        '--line-directives'
    ]
endif

foreach source : cython_sources
    module_name = source.split('.')[0]
    output_filename = module_name + '.c'
    source_c = custom_target(
        module_name,
        output : output_filename,
        input : source,
        command : cython_args
    )
    python.extension_module(
        module_name,
        source_c,
        subdir : subdir_val,
        dependencies : [
            python_dep,
            pangocairo_dep,
            pangoft2_dep
        ],
        c_args: main_c_args,
        install: true
    )
endforeach

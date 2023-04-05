cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}
  MultipleInputFeatureRequirement: {}


inputs:
  namelist_ungrib_atm:
    label: Configuration File
    type: File
  vtable_atm:
    label: grib variable table
    type: File
  grib_files_atm:
    label: Grib Files
    type:
      type: array
      items: File
  outname_atm: string

  namelist_ungrib_sfc:
    label: Configuration File
    type: File
  vtable_sfc:
    label: grib variable table
    type: File
  grib_files_sfc:
    label: Grib Files
    type:
      type: array
      items: File
  outname_sfc: string

  namelist_metgrid_uk9km:
    label: metgrid configuration
    type: File
  geo_file_uk9km:
    label: geogrid data file
    type: File

  generate_metdir: boolean
    
outputs:
  logfiles:
    label: log files
    type:
      type: array
      items: File
    outputSource: step3_metgrid/logfile
  metfiles:
    label: output files
    type:
      type: array
      items: File
    outputSource: step3_metgrid/metfiles


steps:
  step0_metdir:
    run: create_metgrid_dir.cwl
    in:
      generate_metdir: generate_metdir
    out: [metdir]


  step1a_linkgrib_atm:
    run: link_grib_tool.cwl
    in:
      grib_files: grib_files_atm
    out: [grib_dir]

  step1b_linkgrib_sfc:
    run: link_grib_tool.cwl
    in:
      grib_files: grib_files_sfc
    out: [grib_dir]


  step2a_ungrib_atm:
    run: ungrib.cwl
    in:
      namelist: namelist_ungrib_atm
      vtable: vtable_atm
      grib_dir: step1a_linkgrib_atm/grib_dir
      outname: outname_atm
    out: [procfiles]

  step2b_ungrib_sfc:
    run: ungrib.cwl
    in:
      namelist: namelist_ungrib_sfc
      vtable: vtable_sfc
      grib_dir: step1b_linkgrib_sfc/grib_dir
      outname: outname_sfc
    out: [procfiles]


  step3_metgrid:
    run: metgrid.cwl
    in:
      namelist: namelist_metgrid_uk9km
      geofile: geo_file_uk9km
      ungribbed_files_a: step2a_ungrib_atm/procfiles
      ungribbed_files_b: step2b_ungrib_sfc/procfiles
      metdir: step0_metdir/metdir
    out: [logfile, metfiles]

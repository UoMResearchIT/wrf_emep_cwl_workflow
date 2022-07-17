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


    
    
outputs:
  procfiles_sfc:
    label: output files
    type:
      type: array
      items: File
    outputSource: step2b_ungrib_sfc/procfiles
  procfiles_atm:
    label: output files
    type:
      type: array
      items: File
    outputSource: step2a_ungrib_atm/procfiles


steps:
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


cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}
  MultipleInputFeatureRequirement: {}


inputs:
  namelist:
    label: Configuration File
    type: File
  vtable:
    label: grib variable table
    type: File
  grib_files:
    label: Grib Files
    type:
      type: array
      items: File
  outname: string
    
    
outputs:
  procfiles:
    label: output files
    type:
      type: array
      items: File
    outputSource: step2_ungrib/procfiles


steps:
  step1_linkgrib:
    run: link_grib_tool.cwl
    in:
      grib_files: grib_files
    out: [grib_dir]

  step2_ungrib:
    run: ungrib.cwl
    in:
      namelist: namelist
      vtable: vtable
      grib_dir: step1_linkgrib/grib_dir
      outname: outname 
    out: [procfiles]
    

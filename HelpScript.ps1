$compartmentId = "ocid1.instance.oc1.ap-mumbai-1.anrg6ljrstqrchaccfapirs75rrog3374jqbmgx6oupx75q6vjbvhxstl2la"

oci compute image list --compartment-id $compartmentId --all |
  ConvertFrom-Json |
  Select-Object -ExpandProperty data |
  Where-Object {
    $_."operating-system" -eq "Oracle Linux" -and
    $_."operating-system-version" -match "^8|^9"
  } |
  Select-Object id, "display-name", "operating-system", "operating-system-version"


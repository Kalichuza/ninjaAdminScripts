param (
  [String]$Domain
)


nltest /sc_verify:$Domain.local 

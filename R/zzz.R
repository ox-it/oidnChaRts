.onAttach <- function(libname = find.package("oidnChaRts"),
                      pkgname = "oidnChaRts") {
  
  packageStartupMessage(
    "oidnChaRts provides a number of templates for comparing htmlwidgets."
  )
  packageStartupMessage(
    "You must separately load each htmlwidget library before using it."
  )
  
}
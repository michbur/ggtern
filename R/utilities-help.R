#' \code{firstUpper} converts a string to the same string however, having first letter in uppercase.
#' @param s character string to convert
#' @rdname undocumented
firstUpper <- function(s) {
  paste(toupper(substring(s, 1,1)), substring(s, 2), sep="")
}

.aesthetics <- function(x) {
  req_aes <- x$required_aes
  def_aes = NULL
  tryCatch({
    def_aes <- names(x$default_aes())
  },error=function(e){
    #nothing
  })
  def_aes <- setdiff(def_aes, req_aes)
  if (length(req_aes) == 0){
    # Suppress warnings which occur when sorting NULL
    return(suppressWarnings(sort(names(x$default_aes()))))
  }
  if (length(def_aes) == 0){
    return(paste("\\strong{", sort(x$required_aes), "}",sep = ""))
  }
  return(c(paste("\\strong{", sort(x$required_aes), "}", sep = ""), sort(def_aes)))
}

.geom_aesthetics <- function(x) {
  fullname = paste0("Geom",firstUpper(x))
  .aesthetics(get(fullname))
}

.stat_aesthetics <- function(x) {
  fullname = paste0("Stat",firstUpper(x))
  .aesthetics(get(fullname))
}

.coord_aesthetics <- function(x){
  fullname = paste0("coord_",x)
  obj <- do.call("coord_tern",args=list())
  .aesthetics(obj)
}

#' \code{rd_aesthetics} is a helper function for documenting aesthetics in R help files.
#' @param type geom, stat or coord
#' @rdname undocumented
rd_aesthetics <- function(type, name) {
  if(toupper(type)=="GEOM"){
    aes = .geom_aesthetics(tolower(name))
  }else if(toupper(type)=="STAT"){
    aes = .stat_aesthetics(tolower(name))
  }else if(toupper(type)=="COORD"){
    aes = .coord_aesthetics(tolower(name))
  }else{
    obj <- get(firstUpper(type))
    aes <- .aesthetics(obj$find(tolower(name)))
  }
  
  paste("\\code{", type, "_", name, "} ",
        "understands the following aesthetics (required aesthetics are in bold):\n\n",
        "\\itemize{\n",
        paste("  \\item \\code{", aes, "}", collapse = "\n", sep = ""),
        "\n}\n", sep = "")
}
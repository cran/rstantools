# various helper functions for creating rstan-enabled packages

# comment to put on top of rstantools system files.
# deduce comment character based on file extension
.rstantools_noedit <- function(file_name) {
  # comment character
  file_name <- basename(file_name)
  ext <- gsub(".*[.]", "", file_name)
  if (ext == file_name) ext <- ""
  com <- ifelse(tolower(ext) %in% c("r", "", "win"), "#", "//")
  paste0(com, " ", "Generated by rstantools.  Do not edit by hand.")
}

# warning message not overwriting file
.warning_nowrite <- function(file_name) {
  warning("'", file_name,
          "' already exists.  Not overwritten by rstantools.",
          .call = FALSE)
  invisible(NULL)
}

# location of rstantools system files,
# i.e., templates to be copied to user's package
.system_file <- function(...) {
  system.file("include", "sys", ..., package = "rstantools")
}

# taken from Rcpp::compileAttributes
# validates package directory
.check_pkgdir <- function(pkgdir) {
  pkgdir <- normalizePath(pkgdir, winslash = "/")
  descFile <- file.path(pkgdir, "DESCRIPTION")
  if (!file.exists(descFile)) {
    stop("pkgdir must refer to the directory containing an R package.",
         call. = FALSE)
  }
  pkgdir
}

# create a stan directory
# msg: display message if attempt to create is made
# warn: warning if directory already exists
# return value: whether or not directory was created
.add_standir <- function(pkgdir, ..., msg = TRUE, warn = FALSE) {
  dir_name <- file.path(pkgdir, ...)
  acc <- FALSE
  if (file.exists(dir_name)) {
    if (!file.info(dir_name)$isdir) {
      stop(file.path(...), " exists but is not a directory.", call. = FALSE)
    }
  } else {
    if (msg) message("Creating ", file.path(...), " directory ...")
    acc <- dir.create(dir_name, recursive = TRUE,
                      showWarnings = TRUE)
    # this should not happen...
    if (!acc) stop(file.path(...), " directory not created.", call. = FALSE)
  }
  if (warn && !acc) .warning_nowrite(file.path(basename(pkgdir), ...))
  invisible(acc)
}

# add stan file consisting of character vector of file_lines
# * don't overwrite unless first line of destination file is .rstantools_noedit
# * only overwrite if file is not identical
# noedit: add "rstantools file: don't edit" to first line of file
# msg: display message if attempt to create is made
# warn: waning if non-stan file of same name already exists
# return value: whether or not file was successfully added
.add_stanfile <- function(file_lines, pkgdir, ...,
                          noedit = TRUE, msg = FALSE, warn = TRUE) {
  dest_file <- file.path(pkgdir, ...)
  noedit_msg <- .rstantools_noedit(dest_file)
  has_file <- file.exists(dest_file) # check if file exists
  # check if existing file is a stan file
  is_stanfile <- has_file && (readLines(dest_file, n = 1) == noedit_msg)
  if (has_file && !is_stanfile) {
    # non-stan file found: don't overwrite
    if (warn) .warning_nowrite(file.path(basename(pkgdir), ...))
    acc <- FALSE
  }
  if (!has_file || is_stanfile) {
    if (noedit && (file_lines[1] != noedit_msg)) {
      # add "noedit" to top of file
      file_lines <- c(noedit_msg, "", file_lines)
    }
    if (is_stanfile) {
      # stan file found: check if it needs to be overwritten
      old_lines <- readLines(dest_file)
      acc <- !identical(paste0(old_lines, collapse = "\n"),
                        paste0(file_lines, collapse = "\n"))
    } else acc <- TRUE
    if (acc) {
      # create/overwrite file
      if (msg) message("Adding ", basename(dest_file), " file ...")
      cat(file_lines, sep = "\n", file = dest_file) # can't this fail?
    }
  }
  ## acc <- has_file && !is_stanfile # create stan file if acc = TRUE
  ## if (acc) {
  ##   # non-stan file found: don't overwrite
  ##   if (warn) .warning_nowrite(file.path(basename(pkgdir), ...))
  ## } else {
  ##   # stan file found: only overwrite if changed
  ##   if (noedit && (file_lines[1] != noedit_msg)) {
  ##     # add "noedit" to top of file
  ##     file_lines <- c(noedit_msg, "", file_lines)
  ##   }
  ##   old_lines <- readLines(dest_file)
  ##   acc <- !identical(old_lines, file_lines)
  ##   if (acc) {
  ##     cat(file_lines, sep = "\n", file = dest_file) # can't this fail?
  ##   }
  ## }
  invisible(acc)
}

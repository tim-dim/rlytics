

#' Create openxlsx workbook object out of data frames
#'
#'
#' @rdname df_to_xlsx
#' @references
#' Create openxlsx workbook object out of data frames
#'


#' @export
#' @rdname df_to_xlsx
#' @param sheet_name name of worksheet
#' @param df first data frame in the input list
#' @param ... more data frames

df_to_xlsx <- function(sheet_name = "Sheet1", df,...) {

  # count of additional dataframes
  n_df = length(list(...))

  # output of first dataframe
  tab0 = xltabr::initialise(ws_name = sheet_name)
  tab0 = xltabr::auto_crosstab_to_wb(df,ws_name = sheet_name, titles = deparse(substitute(df)),footers = c("") , auto_merge = FALSE, body_header_col_widths = "auto",return_tab = TRUE)

  # output of further dataframes
  for(i in 1:length(list(...))){
    #print(names(list(...))[i])

    assign(paste0("tab",i) , xltabr::auto_crosstab_to_wb(list(...)[[i]],ws_name = sheet_name, titles = names(named_list(...)[i]),footers = c(""), auto_merge = FALSE, body_header_col_widths = "auto",return_tab = TRUE, insert_below_tab = eval(as.name(paste0("tab",i-1)))))
  }

  # output of last dataframe, overwrite
  tabx = xltabr::auto_crosstab_to_wb(list(...)[[n_df]], ws_name = sheet_name, titles = names(named_list(...)[n_df]),footers = c(""), auto_merge = FALSE, body_header_col_widths = "auto", insert_below_tab = eval(as.name(paste0("tab",n_df-1))))


  #openxlsx::openXL(tabx)
  return(tabx)

}

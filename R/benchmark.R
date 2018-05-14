
#' Benchmark processing time for typical analytics tasks
#'
#'
#' @rdname benchmark
#'
#' @param size How you want to specify the size of your
#' testing dataset. Either "rows" or "bytes". "rows" by default.
#' @param rows Number of rows of the testing dataset if `size = "rows"`.
#' @param csv If `TRUE`, the csv-functions `read.csv2` and `write.csv`
#' are included in the benchmarking.
#' @param bytes Size of the dataset if `size = "bytes"`.
#' E.g. (3*1024)^2 for 3 MB or 1024^4 for one GB.
#' @param rep_times Number of time each benchmarked function is repeated
#' for the benchmarking.
#'
#' @examples
#' benchmark(csv = T) # include benchmarking of read.csv and write.csv2
#'
#' # specify the size of the dataset you want to test your system with:
#' benchmark(size = "bytes", bytes = (5*1024)^2) # in bytes
#' benchmark(rows = 100000) # in rows
#'
#' benchmark(rep_times = 20) # specify how many times you want to repeat
#' # benchmarking one function

benchmark <- function(rows = 100000, csv = FALSE,
                      size = "rows", bytes = (3*1024)^2,
                      rep_times = 10) {

  ###############################################################################
  # Load Libraries
  ###############################################################################
  if (!require("dplyr")) install.packages("dplyr")
  if (!require("data.table")) install.packages("data.table")
  if (!require("feather")) install.packages("feather")


  ###############################################################################
  # Create and prepare dataset
  ###############################################################################
  mtcars <- mtcars %>% mutate(model = rownames(mtcars))

  if(!exists("size")) {size <- "rows"}
  if(!size %in% c("rows", "bytes")) {
    stop("Please define size either as 'rows' or as 'bytes', e.g. benchmark(rows = 100000, size = 'rows')")
  }

  s <- 1

  if(size == "rows") {

    if(!exists("rows")) {rows <- 1000000}
    if(!is.numeric(rows)) {
      stop("Please define size either as 'rows' or as 'bytes', e.g. benchmark(rows = 100000, size = 'rows')")
    }

    while(s < rows) { # smaller than row numbers
      mtcars <- rbind(mtcars, mtcars)
      s <- nrow(mtcars)
    }

    # Trimming the dataset to the right dimensions:
    mtcars <- mtcars[1:rows, ]
  }


  if(size == "bytes") {

    if(!exists("bytes")) {bytes <- (3*1024)^2}
    # (3*1024)^2: 3 MB
    # 1024^4: one GB

    while(s < bytes) { # smaller than bytes
      mtcars <- rbind(mtcars, mtcars)
      s <- object.size(mtcars)
    }
  }


  ##########
  # Set unique identifiers for each row:
  mtcars <- mtcars %>%
    mutate(id = 1:n())


  ##########
  # Shuffle around the existing data to change the values:
  set.seed(15)
  mtcars <- mtcars %>%
    # shuffle values around for integer values
    mutate_at(vars(cyl, vs, am, gear, carb),
              funs(sample(unique(.), size = nrow(mtcars), replace = T))) %>%
    # add noise for continuous variables
    mutate_at(vars(mpg, drat, disp, wt, qsec),
              funs(round(jitter(.), 1))) %>%
    mutate(hp = round(jitter(hp), 0))

  # mtcars

  cat("\nCreated dataset ...")
  ###############################################################################
  # Specify spelling convention for variables
  # that store benchmarking results
  ##############################################################################
  # Spelling convention:
  # time_ + R command
  # e.g. time_read.csv2 for benchmarking read.csv2

  ###############################################################################
  # Create function for repeating operations
  ###############################################################################
  if(!exists("rep_times")) {rep_times <- 50}
  repfun <- function(x){
    i <- 1
    while(i <= rep_times) {
      x
      i <- i + 1
    }
  }

  ###############################################################################
  # Writing to disk
  ###############################################################################
  # Create sub-directory if it does not exist:
  if(!dir.exists("data")) {dir.create("data")}


  #############
  if(!exists("csv")) {csv <- F}
  if(csv) {
    start.time <- Sys.time()
    repfun(write.csv(mtcars, file = "data/mtcars.csv"))
    end.time <- Sys.time()

    time_write.csv <- end.time - start.time
  }


  #############
  start.time <- Sys.time()
  repfun(fwrite(mtcars, file = "data/mtcars.csv"))
  end.time <- Sys.time()

  time_fwrite <- end.time - start.time


  #############
  start.time <- Sys.time()
  repfun(write_feather(mtcars, path = "data/mtcars.feather"))
  end.time <- Sys.time()

  time_write_feather <- end.time - start.time


  #############
  start.time <- Sys.time()
  repfun(saveRDS(mtcars, file = "data/mtcars.rds"))
  end.time <- Sys.time()

  time_saveRDS <- end.time - start.time


  cat("\nWrote file to disk ... ")
  ###############################################################################
  # Import Data
  ###############################################################################
  # Import csv:

  if(csv) {
    start.time <- Sys.time()
    repfun(tmp <- read.csv2("data/mtcars.csv"))
    end.time <- Sys.time()

    time_read.csv2 <- end.time - start.time
  }


  ##############
  # Import using fread:
  start.time <- Sys.time()
  repfun(tmp <- fread("data/mtcars.csv", sep=",", dec = ".", verbose = F))
  end.time <- Sys.time()

  time_fread <- end.time - start.time

  ##############
  # Import using feather:
  start.time <- Sys.time()
  repfun(tmp <- read_feather("data/mtcars.feather"))
  end.time <- Sys.time()

  time_read_feather <- end.time - start.time



  ##############
  # Import RDS:
  start.time <- Sys.time()
  repfun(tmp <- readRDS("data/mtcars.rds"))
  end.time <- Sys.time()

  time_readRDS <- end.time - start.time


  # Delete the data folder from disk:
  unlink("data", recursive = TRUE)


  cat("\nImported from disk ... ")
  ###############################################################################
  # Filtering
  ###############################################################################
  start.time <- Sys.time()
  repfun(tmp <- mtcars %>%
           filter(gear %in% c(3, 4) & qsec >18 ))
  end.time <- Sys.time()

  time_filter <- end.time - start.time

  ###############################################################################
  # Selecting
  ###############################################################################
  start.time <- Sys.time()
  repfun(tmp <- mtcars %>%
           select(model, cyl))
  end.time <- Sys.time()

  time_select <- end.time - start.time



  ###############################################################################
  # Joining
  ###############################################################################
  # 2 types of joining:

  #############
  # 1. Joining a small dataset to a really large one.
  # Create one small dataset:
  set.seed(13)
  models <- data.frame(
    model = as.character(unique(mtcars$model)),
    price = abs(rnorm(length(unique(mtcars$model)), mean = 15000, sd = 8000))
  )

  start.time <- Sys.time()
  repfun(tmp <- mtcars %>%
           left_join(models, by = "model"))
  end.time <- Sys.time()

  time_left_join_smalltolarge <- end.time - start.time


  #############
  # 2. Joining 2 really big datasets.
  set.seed(17)
  tmp <- sample_frac(mtcars, 0.8)

  tmp1 <- tmp %>% select(id, mpg, cyl)
  tmp2 <- tmp %>% select(id, hp, drat, wt)

  start.time <- Sys.time()
  repfun(tmp <- tmp1 %>%
           left_join(tmp2, by = "id"))
  end.time <- Sys.time()

  time_left_join_largetolarge <- end.time - start.time


  ###############################################################################
  # Aggregation
  ###############################################################################
  # Aggregate by gear and transmission type:
  # how many cars exist with each type of gear and transmission type?
  start.time <- Sys.time()
  repfun(tmp <- mtcars %>%
           select(gear, am) %>%
           group_by(gear, am) %>%
           summarize(n = n()))
  end.time <- Sys.time()

  time_select_group_by_summarize <- end.time - start.time


  cat("\nFiltered, selected, joined etc ... \n\n")
  ###############################################################################
  # Calculate sums per process
  ###############################################################################
  if(csv) {
    time_importing <- sum(
      time_read.csv2, time_read_feather, time_fread,
      time_readRDS
    )
  } else{
    time_importing <- sum(
      time_read_feather, time_fread,
      time_readRDS
    )
  }


  time_filtering_etc <- sum(
    time_filter, time_select,
    time_left_join_smalltolarge, time_left_join_largetolarge,
    time_select_group_by_summarize
  )

  if(csv){
    time_writing <- sum(
      time_write.csv, time_write_feather,
      time_saveRDS, time_fwrite
    )
  } else{
    time_writing <- sum(
      time_write_feather,
      time_saveRDS, time_fwrite
    )
  }


  if(!exists("time_read.csv2")) {time_read.csv2 <- NA}
  if(!exists("time_write.csv")) {time_write.csv <- NA}

  time_total <- sum(time_importing, time_filtering_etc, time_writing)
  machine_info <- paste(Sys.info()[c("sysname", "release")], collapse = " ")
  machine_user <- Sys.info()["user"]
  rows_mtcars <- nrow(mtcars)
  size_mtcars <- object.size(mtcars)
  print_read.csv2 <- if(csv){
    sprintf("read.csv2:                          %f\n    ", time_read.csv2)
  } else{""}
  print_write.csv <- if(csv){
    sprintf("write.csv:                          %f\n    ", time_write.csv)
  } else{""}
  ###############################################################################
  # Output: write down how long each process took
  ###############################################################################
  cat(sprintf(
    "
    BENCHMARKING RESULT
    (in secs, for %s, user %s)

    Times each process was executed: %d
    nrows of the dataset: %d
    Size of the dataset: %d bytes


    1. IMPORTING
    --------------------------------------------
    %sread_feather:                       %f
    fread:                              %f
    readRDS:                            %f
    --------------------------------------------
    SUM IMPORTING                       %f


    2. FILTERTING, JOINING, AGGREGATION etc. (dplyr)
    --------------------------------------------
    Filtering with filter:              %f
    Selecting with select:              %f
    Joining 2 datasets with left_join
    (large with small dataset):         %f
    Joining 2 datasets with left_join
    (large with large dataset):         %f
    Aggregating with select, group_by,
    summarize:                          %f
    --------------------------------------------
    SUM FILTERING etc.                  %f


    3. WRITING TO DISK
    --------------------------------------------
    %sfwrite:                             %f
    write_feather:                      %f
    saveRDS:                            %f
    --------------------------------------------
    SUM WRITING TO DISK                 %f


    TOTAL                               %f

    ",

    machine_info, machine_user,
    rep_times,
    rows_mtcars,
    size_mtcars,

    print_read.csv2, time_read_feather, time_fread, time_readRDS,

    time_importing,

    time_filter, time_select,
    time_left_join_smalltolarge, time_left_join_largetolarge,
    time_select_group_by_summarize,

    time_filtering_etc,

    print_write.csv, time_fwrite, time_write_feather, time_saveRDS,

    time_writing,

    time_total
  )

  )

}

SpaDES.core.version <- "0.1.0"
if (utils::packageVersion("SpaDES.core") < SpaDES.core.version) {
  stop("This 'randomLandscapes' module was built with 'SpaDES.core' version",
       SpaDES.core.version, ".\n",
       "Please update 'SpaDES.core' to use this module.")
}
rm(SpaDES.core.version)

## this version of the 'randomLandscapes' module loads data from file instead of
## generating it using 'SpaDES.tools::gaussMap'

defineModule(sim, list(
  name = "randomLandscapes",
  description = paste("Generate RasterStack of random maps representative of a forest landscape",
                      "(DEM, forestAge, forestCover, habitatQuality, percentPine).",
                      "Requires a global simulation parameter `stackName` be set."),
  keywords = c("random map", "random landscape"),
  childModules = character(),
  authors = c(
    person(c("Alex", "M"), "Chubaty", email = "alexander.chubaty@canada.ca",
           role = c("aut", "cre")),
    person(c("Eliot", "J", "B"), "McIntire", email = "eliot.mcintire@canada.ca",
           role = c("aut", "cre"))
  ),
  version = list(SpaDES.core = "0.1.0", SpaDES.tools = "0.1.0", randomLandscapes = "1.6.0"),
  spatialExtent = raster::extent(rep(NA_real_, 4)),
  timeframe = as.POSIXlt(c(NA, NA)),
  timeunit = "year",
  citation = list(),
  documentation = list(),
  reqdPkgs = list("raster", "RColorBrewer", "SpaDES.tools"),
  parameters = rbind(
    defineParameter("inRAM", "logical", FALSE, TRUE, FALSE, "should the raster be stored in memory?"),
    defineParameter("nx", "numeric", 100L, 10L, 500L, "size of map (number of pixels) in the x dimension"),
    defineParameter("ny", "numeric", 100L, 10L, 500L, "size of map (number of pixels) in the y dimension"),
    defineParameter("stackName", "character", "landscape", NA, NA, "name of the RasterStack"),
    defineParameter(".plotInitialTime", "numeric", start(sim), start(sim), NA, "time to schedule first plot event"),
    defineParameter(".plotInterval", "numeric", NA_real_, NA, NA, "time interval between plot events"),
    defineParameter(".saveInitialTime", "numeric", NA_real_, NA, NA, "time to schedule first save event"),
    defineParameter(".saveInterval", "numeric", NA_real_, NA, NA, "time interval between save events"),
    defineParameter(".useCache", "logical", FALSE, c("init", "plot"), NA, "should the module result be cached for future use")
  ),
  inputObjects = bind_rows(
    expectsInput(objectName = NA_character_, objectClass = NA_character_,
                 sourceURL = NA_character_, desc = NA_character_,
                 other = NA_character_)
  ),
  outputObjects = bind_rows(
    createsOutput(objectName = SpaDES.core::P(sim, "randomLandscapes")$stackName, objectClass = "RasterStack",
                  desc = NA_character_, other = NA_character_)
  )
))

## event types4347526b7f30225e6198f8802475b22285d885e8
doEvent.randomLandscapes <- function(sim, eventTime, eventType, debug = FALSE) {
  switch(
    eventType,
    init = {
      # do stuff for this event
      sim <- Init(sim)

      # schedule the next events
      sim <- scheduleEvent(sim, SpaDES.core::P(sim)$.plotInitialTime, "randomLandscapes", "plot", .last())
      sim <- scheduleEvent(sim, SpaDES.core::P(sim)$.saveInitialTime, "randomLandscapes", "save", .last() + 1)
    },
    plot = {
      # do stuff for this event
      stackName <- SpaDES.core::P(sim)$stackName # Plot doesn't like long variables
      Plot(sim[[stackName]])
    },
    save = {
      # do stuff for this event
      sim <- saveFiles(sim)

      # schedule the next event
      sim <- scheduleEvent(sim, time(sim) + SpaDES.core::P(sim)$.saveInterval, "randomLandscapes", "save", .last() + 1)
    },
    warning(paste(
      "Undefined event type: \'", events(sim)[1, "eventType", with = FALSE],
      "\' in module \'", events(sim)[1, "moduleName", with = FALSE], "\'", sep = ""
    ))
  )
  return(invisible(sim))
}

## event functions
Init <- function(sim) {
  if (is.null(SpaDES.core::P(sim)$inRAM)) {
    inMemory <- FALSE
  } else {
    inMemory <- SpaDES.core::P(sim)$inRAM
  }
  # Give dimensions of dummy raster
  nx <- SpaDES.core::P(sim)$nx
  ny <- SpaDES.core::P(sim)$ny
  template <- raster(nrows = ny, ncols = nx, xmn = -nx / 2, xmx = nx / 2,
                     ymn = -ny / 2, ymx = ny / 2)
  speedup <- max(1, nx / 5e2)

    # Make dummy maps for testing of models
    DEM <- gaussMap(template, scale = 300, var = 0.03, speedup = speedup, inMemory = inMemory)
    DEM[] <- round(getValues(DEM), 1) * 1000
    forestAge <- gaussMap(template, scale = 10, var = 0.1, speedup = speedup, inMemory = inMemory)
    forestAge[] <- round(getValues(forestAge), 1) * 20
    percentPine <- gaussMap(template, scale = 50, var = 1, speedup = speedup, inMemory = inMemory)
    percentPine[] <- round(getValues(percentPine), 1)

  # Scale them as needed
  forestAge <- forestAge / maxValue(forestAge) * 100
  percentPine <- percentPine / maxValue(percentPine) * 100

  # Make layers that are derived from other layers
  habitatQuality <- (DEM + 10 + (forestAge + 2.5) * 10) / 100
  habitatQuality <- habitatQuality / maxValue(habitatQuality)

  # Stack them into a single stack and assign to global env
  mapStack <- stack(DEM, forestAge, habitatQuality, percentPine)
  names(mapStack) <- c("DEM", "forestAge", "habitatQuality", "percentPine")

  setColors(mapStack) <- list(DEM = brewer.pal(9, "YlOrBr"),
                              forestAge = brewer.pal(9, "BuGn"),
                              habitatQuality = brewer.pal(8, "Spectral"),
                              percentPine = brewer.pal(9, "Greens"))
  sim[[SpaDES.core::P(sim)$stackName]] <- mapStack
  return(invisible(sim))
}

#' @title Read geochronology data
#'
#' @description
#' Cast a \code{.csv} file or a matrix into one of \code{IsoplotR}'s
#' data classes
#'
#' @details IsoplotR provides the following example input files:
#'
#' \itemize{
#' \item{U-Pb: \code{UPb1.csv}, \code{UPb2.csv}, \code{UPb3.csv},
#' \code{UPb4.csv}, \code{UPb5.csv}, \code{UPb6.csv},
#' \code{UPb7.csv}, \code{UPb8.csv}}
#' \item{Pb-Pb: \code{PbPb1.csv}, \code{PbPb2.csv}, \code{PbPb3.csv}}
#' \item{Th-Pb: \code{ThPb1.csv}, \code{ThPb2.csv}, \code{ThPb3.csv}}
#' \item{Ar-Ar: \code{ArAr1.csv}, \code{ArAr2.csv}, \code{ArAr3.csv}}
#' \item{K-Ca: \code{KCa1.csv}, \code{KCa2.csv}, \code{KCa3.csv}}
#' \item{Re-Os: \code{ReOs1.csv}, \code{ReOs2.csv}, \code{ReOs3.csv}}
#' \item{Sm-Nd: \code{SmNd1.csv}, \code{SmNd2.csv}, \code{SmNd3.csv}}
#' \item{Rb-Sr: \code{RbSr1.csv}, \code{RbSr2.csv}, \code{RbSr3.csv}}
#' \item{Lu-Hf: \code{LuHf1.csv}, \code{LuHf2.csv}, \code{LuHf3.csv}}
#' \item{Th-U: \code{ThU1.csv}, \code{ThU2.csv}, \code{ThU3.csv}
#' \code{ThU4.csv}}
#' \item{fissiontracks: \code{FT1.csv}, \code{FT2.csv},
#' \code{FT3.csv}}
#' \item{U-Th-He: \code{UThHe.csv}, \code{UThSmHe.csv}}
#' \item{detritals: \code{DZ.csv}}
#' \item{other: \code{LudwigMixture.csv}, \code{LudwigMean.csv},
#' \code{LudwigKDE.csv}, \code{LudwigSpectrum.csv}}
#' }
#'
#' The contents of these files can be viewed using the
#' \code{system.file(...)} function. For example, to read the
#' \code{ArAr1.csv} file:
#'
#' \code{fname <- system.file('ArAr1.csv',package='IsoplotR')}
#'
#' \code{ArAr <- read.data(fname,method='Ar-Ar',format=1)}
#'
#' @param x either a file name (\code{.csv} format) OR a matrix
#' 
#' @param method one of \code{'U-Pb'}, \code{'Pb-Pb'}, \code{'Th-Pb'},
#'     \code{'Ar-Ar'}, \code{'K-Ca'}, \code{'detritals'},
#'     \code{'Rb-Sr'}, \code{'Sm-Nd'}, \code{'Re-Os'}, \code{'Th-U'},
#'     \code{'U-Th-He'}, \code{'fissiontracks'} or \code{'other'}
#' 
#' @param format formatting option, depends on the value of
#'     \code{method}.
#'
#' if \code{method='U-Pb'}, then \code{format} is one of either:
#'
#' \enumerate{
#' \item{\code{07/35, err[07/35],} \code{06/38, err[06/38], rho}} 
#' \item{\code{38/06, err[38/06],}\code{07/06, err[07/06] (, rho)}}
#' \item{\code{X=07/35, err[X],} \code{Y=06/38, err[Y],}
#'       \code{Z=07/06, err[Z]} \code{(, rho[X,Y]) (, rho[Y,Z])}} 
#' \item{\code{X=07/35, err[X], Y=06/38, err[Y], Z=04/38, }
#'       \code{rho[X,Y], rho[X,Z], rho[Y,Z]}} 
#' \item{\code{X=38/06, err[X]}, \code{Y=07/06, err[Y]},
#'       \code{Z=04/06, err[Z] (}, \code{rho[X,Y], rho[X,Z], rho[Y,Z])}}
#' \item{\code{07/35, err[07/35]}, \code{06/38, err[06/38]},
#'       \code{04/38, err[04/38]}, \code{07/06, err[07/06]},
#'       \code{04/07, err[04/07]}, \code{04/06, err[04/06]}}
#' \item{\code{W=07/35, err[W]}, \code{X=06/38, err[X]},
#'       \code{Y=08/32, err[Y]}, and \code{Z=32/38, err[Z]},
#'       \code{rho[W,X], rho[W,Y]}, \code{rho[W,Z], rho[X,Y]},
#'       \code{rho[X,Z], rho[Y,Z]}}
#' \item{\code{W=38/06, err[W]}, \code{X=07/06, err[X]},
#'       \code{Y=08/06, err[Y]}, and \code{Z=32/38, (err[Z]},
#'       \code{rho[W,X], rho[W,Y]}, \code{rho[W,Z], rho[X,Y]},
#'       \code{rho[X,Z], rho[Y,Z])}}
#' }
#'
#' where optional columns are marked in round brackets
#'
#' if \code{method='Pb-Pb'}, then \code{format} is one of either:
#'
#' \enumerate{
#' \item{\code{6/4, err[6/4], 7/4, err[7/4], rho}}
#' \item{\code{4/6, err[4/6], 7/6, err[7/6], rho}}
#' \item{\code{6/4, err[6/4], 7/4, err[7/4], 6/7, err[6/7]}}
#' }
#'
#' if \code{method='Th-Pb'}, then \code{format} is one of either:
#'
#' \enumerate{
#' \item{\code{32/04, err[32/04], 08/04, err[08/04], rho}}
#' \item{\code{32/08, err[32/08], 04/08, err[08/04], rho}}
#' \item{\code{32/04, err[32/04], 08/04, }
#'       \code{err[08/04], 32/08, err[32/08]}}
#' }
#' 
#' if \code{method='Ar-Ar'}, then \code{format} is one of either:
#'
#' \enumerate{
#' \item{\code{9/6, err[9/6], 0/6, err[0/6], rho (, 39)}}
#' \item{\code{6/0, err[6/0], 9/0, err[9/0] (, rho) (, 39)}}
#' \item{\code{9/0, err[9/0], 6/0, err[6/0], 9/6, err[9/6] (, 39)}}
#' }
#'
#' if \code{method='K-Ca'}, then \code{format} is one of either:
#'
#' \enumerate{
#' \item{\code{K40/Ca44, err[K40/Ca44], Ca40/Ca44, err[Ca40/Ca44], rho}}
#' \item{\code{K40/Ca40, err[K40/Ca40], Ca44/Ca40, err[Ca44/Ca40], rho}}
#' \item{\code{K40/Ca44, err[K40/Ca44], Ca40/Ca44, }
#'       \code{err[Ca40/Ca44], K40/Ca40, err[K40/Ca40]}}
#' }
#'
#' if \code{method='Rb-Sr'}, then \code{format} is one of either:
#'
#' \enumerate{
#' \item{\code{Rb87/Sr86, err[Rb87/Sr86], Sr87/Sr86, err[Sr87/Sr86] (, rho)}}
#' \item{\code{Rb87/Sr87, err[Rb87/Sr87], Sr86/Sr87, err[Sr86/Sr87] (, rho)}}
#' \item{\code{Rb, err[Rb], Sr, err[Sr], Sr87/Sr86, err[Sr87/Sr86]}}
#' }
#'
#' where \code{Rb} and \code{Sr} are in ppm
#'
#' if \code{method='Sm-Nd'}, then \code{format} is one of either:
#'
#' \enumerate{
#' \item{\code{Sm147/Nd144, err[Sm147/Nd144], Nd143/Nd144, err[Nd143/Nd144] (, rho)}}
#' \item{\code{Sm147/Nd143, err[Sm147/Nd143], Nd144/Nd143, err[Nd144/Nd143] (, rho)}}
#' \item{\code{Sm, err[Sm], Nd, err[Nd], Nd143/Nd144, err[Nd143/Nd144]}}
#' }
#'
#' where \code{Sm} and \code{Nd} are in ppm
#'
#' if \code{method='Re-Os'}, then \code{format} is one of either:
#'
#' \enumerate{
#' \item{\code{Re187/Os188, err[Re187/Os188], Os187/Os188, err[Os187/Os188] (, rho)}}
#' \item{\code{Re187/Os187, err[Re187/Os187], Os188/Os187, err[Os188/Os187] (, rho)}}
#' \item{\code{Re, err[Re], Os, err[Os], Os187/Os188, err[Os187/Os188]}}
#' }
#'
#' where \code{Re} and \code{Os} are in ppm
#'
#' if \code{method='Lu-Hf'}, then \code{format} is one of either:
#'
#' \enumerate{
#' \item{\code{Lu176/Hf177, err[Lu176/Hf177], Hf176/Hf177, err[Hf176/Hf177] (, rho)}}
#' \item{\code{Lu176/Hf176, err[Lu176/Hf176], Hf177/Hf176, err[Hf177/Hf176] (, rho)}}
#' \item{\code{Lu, err[Lu], Hf, err[Hf], Hf176/Hf177, err[Hf176/Hf177]}}
#' }
#'
#' where \code{Lu} and \code{Hf} are in ppm
#'
#' if \code{method='Th-U'}, then \code{format} is one of either:
#'
#' \enumerate{
#' \item{\code{X=8/2, err[X], Y=4/2, err[Y], Z=0/2, err[Z],}\cr
#' \code{rho[X,Y], rho[X,Z], rho[Y,Z]}}
#' \item{\code{X=2/8, err[X], Y=4/8, err[Y], Z=0/8, err[Z],}\cr
#' \code{ rho[X,Y], rho[X,Z], rho[Y,Z]}}
#' \item{\code{X=8/2, err[X], Y=0/2, err[Y], rho[X,Y]}}
#' \item{\code{X=2/8, err[X], Y=0/8, err[Y], rho[X,Y]}}
#' }
#'
#' where all values are activity ratios
#'
#' if \code{method='fissiontracks'}, then \code{format} is one of
#' either:
#'
#' \enumerate{
#' \item{the External Detector Method (EDM), which requires a
#' \eqn{\zeta}-calibration constant and its uncertainty, the induced
#' track density in a dosimeter glass, and a table with the
#' spontaneous and induced track densities.}
#'
#' \item{LA-ICP-MS-based fission track data using the
#' \eqn{\zeta}-calibration method, which requires a 'session
#' \eqn{\zeta}' and its uncertainty and a table with the number of
#' spontaneous tracks, the area over which these were counted and one
#' or more U/Ca- or U-concentration measurements and their analytical
#' uncertainties.}
#'
#' \item{LA-ICP-MS-based fission track data using the 'absolute
#' dating' method, which only requires a table with the the number of
#' spontaneous tracks, the area over which these were counted and one
#' or more U/Ca-ratios or U-concentration measurements (in ppm) and
#' their analytical uncertainties.}  }
#'
#' if \code{method='other'}, \code{x} is read as a table, unless
#' \code{format} is one of either:
#'
#' \describe{
#' \item{\code{radial} or \code{average}:}{\code{X, err[X]}}
#' \item{\code{regression}:}{\code{X, err[X], Y, err[Y], rho} \cr
#'       OR \code{X/Z, err[X/Z], Y/Z, err[Y/Z], X/Y, err[X/Y]}}
#' \item{\code{spectrum}:}{\code{f, X, err[X]}} 
#' }
#' 
#' @param ierr indicates whether the analytical uncertainties are
#'     reported as: 
#' 
#' \code{1}: 1\eqn{\sigma} absolute uncertainties.
#' 
#' \code{2}: 2\eqn{\sigma} absolute uncertainties.
#' 
#' \code{3}: 1\eqn{\sigma} relative uncertainties (\%).
#' 
#' \code{4}: 2\eqn{\sigma} relative uncertainties (\%).
#'
#' @param d an object of class \code{\link{diseq}}.
#' 
#' @param Th02 2-element vector with the assumed initial
#'     \eqn{^{230}}Th/\eqn{^{232}}Th-ratio of the detritus and its
#'     standard error. Only used if \code{isochron=FALSE} and
#'     \code{detritus=2}
#' 
#' @param Th02U48 9-element vector with the measured composition of
#'     the detritus, containing \code{X=0/8}, \code{sX}, \code{Y=2/8},
#'     \code{sY}, \code{Z=4/8}, \code{sZ}, \code{rXY}, \code{rXZ},
#'     \code{rYZ}.
#' 
#' @param ... optional arguments to the \code{read.csv} function
#' 
#' @seealso \code{\link{examples}}, \code{\link{settings}}
#' 
#' @return
#' \itemize{
#' 
#' \item If \code{method="U-Pb"}: an object of class \code{UPb}, i.e. a list
#' inheriting the input arguments \code{x}, \code{format} and \code{d}.
#'
#' \item If \code{method="ArAr"}: and object of class \code{ArAr}, i.e. a
#' three item list containing the following items:
#'
#' \code{x}: a matrix containing the isotopic measurements
#'
#' \code{J}: a two-element vector with the J-factor and its
#' uncertainty, extracted from the input file.
#' 
#' \code{format}: same as the input argument
#' 
#' \item If \code{method="Pb-Pb"}, \code{method="Th-Pb"},
#' \code{"K-Ca"}, \code{"Rb-Sr"}, \code{"Sm-Nd"}, \code{"Lu-Hf"}, or
#' \code{"Re-Os"}: objects of classes \code{PbPb}, \code{KCa},
#' \code{RbSr}, \code{SmNd}, \code{LuHf}, or \code{ReOs},
#' respectively; i.e. a list inheriting the input arguments \code{x}
#' and \code{format}.
#'
#' \item If \code{method="UThHe"}: an object of class \code{UThHe},
#' i.e. a matrix with the contents of \code{x}.
#'
#' \item If \code{method="fissiontracks"}: an object of class
#' \code{fissiontracks}, i.e. a list containing the following items:
#'
#' \code{format}: same as the input argument
#'
#' \code{x}: a matrix of spontaneous and induced fission track counts
#' (only returned if \code{format=1})
#'
#' \code{rhoD}: the track density of the dosimeter glass, extracted
#' from the input data (only returned if \code{format=1})
#'
#' \code{zeta}: the zeta calibration constant extracted from the input
#' data (only returned if \code{format<3})
#'
#' \code{Ns} a list containing the spontaneous fission track counts
#' (only returned if \code{format>1})
#'
#' \code{U}: a list of lists containing the U-concentration or
#' U/Ca-ratio measurements for each of the analysed grains (only
#' returned if \code{format>1})
#'
#' \code{sU}: a list of lists containing the standard errors of the
#' U-concentration or U/Ca-ratio measurements for each of the analysed
#' grains (only returned if \code{format>1})
#'
#' \code{spotSize}: the laser ablation spot size (only returned if
#' \code{format>1})
#'
#' \item If \code{method="detritals"}: an object of class
#' \code{detritals}, i.e. a list of named vectors, one for each
#' detrital sample.
#'
#' }
#' 
#' @examples
#'
#' f1 <- system.file("UPb1.csv",package="IsoplotR")
#' file.show(f1) # inspect the contents of 'UPb1.csv'
#' d1 <- read.data(f1,method="U-Pb",format=1)
#' concordia(d1)
#'
#' f2 <- system.file("ArAr1.csv",package="IsoplotR")
#' d2 <- read.data(f2,method="Ar-Ar",format=1)
#' agespectrum(d2)
#'
#' f3 <- system.file("ReOs1.csv",package="IsoplotR")
#' d3 <- read.data(f3,method="Re-Os",format=1)
#' isochron(d2)
#'
#' f4 <- system.file("FT1.csv",package="IsoplotR")
#' d4 <- read.data(f4,method="fissiontracks",format=1)
#' radialplot(d4)
#'
#' f5 <- system.file("UThSmHe.csv",package="IsoplotR")
#' d5 <- read.data(f5,method="U-Th-He")
#' helioplot(d5)
#'
#' f6 <- system.file("ThU2.csv",package="IsoplotR")
#' d6 <- read.data(f6,method="Th-U",format=2)
#' evolution(d6)
#'
#' #  one detrital zircon U-Pb file (detritals.csv)
#' f7 <- system.file("DZ.csv",package="IsoplotR")
#' d7 <- read.data(f7,method="detritals")
#' kde(d7)
#'
#' #  four 'other' files (LudwigMixture.csv, LudwigSpectrum.csv,
#' #  LudwigMean.csv, LudwigKDE.csv)
#' f8 <- system.file("LudwigMixture.csv",package="IsoplotR")
#' d8 <- read.data(f8,method="other")
#' radialplot(d8)
#'
#' @rdname read.data
#' @export
read.data <- function(x,...){ UseMethod("read.data",x) }
#' @rdname read.data
#' @export
read.data.default <- function(x,method='U-Pb',format=1,ierr=1,d=diseq(),
                              Th02=c(0,0),Th02U48=c(0,0,1e6,0,0,0,0,0,0),...){
    X <- as.matrix(utils::read.table(x,sep=',',...))
    read.data.matrix(X,method=method,format=format,ierr=ierr,d=d,
                     Th02=Th02,Th02U48=Th02U48)
}
#' @rdname read.data
#' @export
read.data.data.frame <- function(x,method='U-Pb',format=1,ierr=1,d=diseq(),
                                 Th02=c(0,0),Th02U48=c(0,0,1e6,0,0,0,0,0,0),...){
    read.data.matrix(as.matrix(x),method=method,format=format,
                     ierr=ierr,d=d,Th02=Th02,Th02U48=Th02U48,...)
}
#' @rdname read.data
#' @export
read.data.matrix <- function(x,method='U-Pb',format=1,ierr=1,d=diseq(),
                             Th02=c(0,0),Th02U48=c(0,0,1e6,0,0,0,0,0,0),...){
    if (identical(method,'U-Pb')){
        out <- as.UPb(x,format=format,ierr=ierr,d=d)
    } else if (identical(method,'Pb-Pb')){
        out <- as.PbPb(x,format=format,ierr=ierr)
    } else if (identical(method,'Ar-Ar')){
        out <- as.ArAr(x,format=format,ierr=ierr)
    } else if (identical(method,'Th-Pb')){
        out <- as.ThPb(x,format=format,ierr=ierr)
    } else if (identical(method,'K-Ca')){
        out <- as.KCa(x,format=format,ierr=ierr)
    } else if (identical(method,'Re-Os')){
        out <- as.ReOs(x,format=format,ierr=ierr)
    } else if (identical(method,'Rb-Sr')){
        out <- as.RbSr(x,format=format,ierr=ierr)
    } else if (identical(method,'Sm-Nd')){
        out <- as.SmNd(x,format=format,ierr=ierr)
    } else if (identical(method,'Lu-Hf')){
        out <- as.LuHf(x,format=format,ierr=ierr)
    } else if (identical(method,'Th-U')){
        out <- as.ThU(x,format=format,ierr=ierr,Th02=Th02,Th02U48=Th02U48)
    } else if (identical(method,'U-Th-He')){
        out <- as.UThHe(x,ierr=ierr)
    } else if (identical(method,'fissiontracks')){
        out <- as.fissiontracks(x,format=format,ierr=ierr)
    } else if (identical(method,'detritals')){
        out <- as.detritals(x)
    } else if (identical(method,'other')){
        out <- as.other(x,format=format,ierr=ierr)
    }
    out
}

as.UPb <- function(x,format=3,ierr=1,d=diseq()){
    out <- list()
    class(out) <- "UPb"
    out$format <- format
    nc <- ncol(x)
    nr <- nrow(x)
    if (is.numeric(x)) X <- x
    else X <- shiny2matrix(x,2,nr,nc)
    opt <- NULL
    if (format==1){
        cnames <- c('Pb207U235','errPb207U235',
                    'Pb206U238','errPb206U238','rhoXY')
    } else if (format==2){
        cnames <- c('U238Pb206','errU238Pb206',
                    'Pb207Pb206','errPb207Pb206','rhoXY')
        opt <- 5
    } else if (format==3){
        cnames <- c('Pb207U235','errPb207U235',
                    'Pb206U238','errPb206U238',
                    'Pb207Pb206','errPb207Pb206',
                    'rhoXY','rhoYZ')
    } else if (format==4){
        cnames <- c('Pb207U235','errPb207U235',
                    'Pb206U238','errPb206U238',
                    'Pb204U238','errPb204U238',
                    'rhoXY','rhoXZ','rhoYZ')
    } else if (format==5){
        cnames <- c('U238Pb206','errU238Pb206',
                    'Pb207Pb206','errPb207Pb206',
                    'Pb204Pb206','errPb204Pb206',
                    'rhoXY','rhoXZ','rhoYZ')
        opt <- 7:9
    } else if (format==6){
        cnames <- c('Pb207U235','errPb207U235',
                    'Pb206U238','errPb206U238',
                    'Pb204U238','errPb204U238',
                    'Pb207Pb206','errPb207Pb206',
                    'Pb204Pb207','errPb204Pb207',
                    'Pb204Pb206','errPb204Pb206')
    } else if (format==7){
        cnames <- c('Pb207U235','errPb207U235',
                    'Pb206U238','errPb206U238',
                    'Pb208Th232','errPb208Th232',
                    'Th232U238','errTh232U238',
                    'rhoXY','rhoXZ','rhoXW',
                    'rhoYZ','rhoYW','rhoZW')
        opt <- 8:14
    } else if (format==8){
        cnames <- c('U238Pb206','errU238Pb206',
                    'Pb207Pb206','errPb207Pb206',
                    'Pb208Pb206','errPb208Pb206',
                    'Th232U238','errTh232U238',
                    'rhoXY','rhoXZ','rhoXW',
                    'rhoYZ','rhoYW','rhoZW')
        opt <- 8:14
    } else {
        stop('Invalid input format')
    }
    X <- insert.data(x=X,cnames=cnames,opt=opt)
    out$x <- errconvert(X,gc='U-Pb',format=format,ierr=ierr)
    if (format==3) out$x <- optionalredundancy2cor(X=out$x,nc=nc)
    out$d <- copy_diseq(x=out,d=d)
    out
}
# for U-Pb format 3, the correlation coefficients are optional
# and can be inferred from the redundancy of the ratios
optionalredundancy2cor <- function(X,nc){
    out <- X
    if (nc > 7){
        rhoXY <- X[,7]
        rhoYZ <- X[,8]
        i <- which(is.na(rhoXY))
        j <- which(is.na(rhoYZ))
    } else if (nc == 7){
        rhoXY <- X[,7]
        i <- which(is.na(rhoXY))
        j <- 1:nrow(X)
        out <- cbind(X,0)
    } else {
        i <- 1:nrow(X)
        j <- 1:nrow(X)
        out <- cbind(X,0,0)
    }
    out[i,7] <- get.cor.75.68(X[i,1],X[i,2],X[i,3],X[i,4],X[i,5],X[i,6])
    out[j,8] <- get.cor.68.76(X[j,1],X[j,2],X[j,3],X[j,4],X[j,5],X[j,6])
    out
}

get.cor.75.68 <- function(Pb207U235,errPb207U235,
                          Pb206U238,errPb206U238,
                          Pb207Pb206,errPb207Pb206){
    get.cor.div(Pb207U235,errPb207U235,
                Pb206U238,errPb206U238,
                Pb207Pb206,errPb207Pb206)
}
get.cor.68.76 <- function(Pb207U235,errPb207U235,
                          Pb206U238,errPb206U238,
                          Pb207Pb206,errPb207Pb206){
    get.cor.mult(Pb206U238,errPb206U238,
                 Pb207Pb206,errPb207Pb206,
                 Pb207U235,errPb207U235)
}
get.cov.75.68 <- function(Pb207U235,errPb207U235,
                          Pb206U238,errPb206U238,
                          Pb207Pb206,errPb207Pb206){
    get.cov.div(Pb207U235,errPb207U235,
                Pb206U238,errPb206U238,
                Pb207Pb206,errPb207Pb206)
}
get.cov.75.48 <- function(Pb207U235,errPb207U235,
                          Pb204U238,errPb204U238,
                          Pb204Pb207,errPb204Pb207){
    get.cov.div(Pb207U235,errPb207U235,
                Pb204U238,errPb204U238,
                Pb204Pb207,errPb204Pb207)
}
get.cov.68.48 <- function(Pb206U238,errPb206U238,
                          Pb204U238,errPb204U238,
                          Pb204Pb206,errPb204Pb206){
    get.cov.div(Pb206U238,errPb206U238,
                Pb204U238,errPb204U238,
                Pb204Pb206,errPb204Pb206)
}
get.cov.76.86 <- function(Pb207Pb206,errPb207Pb206,
                          U238Pb206,errU238Pb206,
                          Pb207U235,errPb207U235){
    get.cov.div(Pb207Pb206,errPb207Pb206,
                U238Pb206,errU238Pb206,
                Pb207U235,errPb207U235)
}
get.cov.46.86 <- function(Pb204Pb206,errPb204Pb206,
                          U238Pb206,errU238Pb206,
                          Pb204U238,errPb204U238){
    get.cov.div(Pb204Pb206,errPb204Pb206,
                U238Pb206,errU238Pb206,
                Pb204U238,errPb204U238)
}
get.cov.46.68 <- function(Pb204Pb206,errPb204Pb206,
                          Pb206U238,errPb206U238,
                          Pb204U238,errPb204U238){
    get.cov.mult(Pb204Pb206,errPb204Pb206,
                 Pb206U238,errPb206U238,
                 Pb204U238,errPb204U238)
}
get.cov.46.76 <- function(Pb204Pb206,errPb204Pb206,
                          Pb207Pb206,errPb207Pb206,
                          Pb204Pb207,errPb204Pb207){
    get.cov.div(Pb204Pb206,errPb204Pb206,
                Pb207Pb206,errPb207Pb206,
                Pb204Pb207,errPb204Pb207)
}
get.cov.47.75 <- function(Pb204Pb207,errPb204Pb207,
                          Pb207U235,errPb207U235,
                          Pb204U238,errPb204U238){
    get.cov.mult(Pb204Pb207,errPb204Pb207,
                 Pb207U235,errPb207U235,
                 Pb204U238,errPb204U238)
}
as.PbPb <- function(x,format=1,ierr=1){
    out <- list()
    class(out) <- "PbPb"
    out$format <- format
    nc <- ncol(x)
    nr <- nrow(x)
    if (is.numeric(x)) X <- x
    else X <- shiny2matrix(x,2,nr,nc)
    X <- errconvert(X,gc='Pb-Pb',format=format,ierr=ierr)
    opt <- NULL
    if (format==1 & nc>4){
        cnames <- c('Pb206Pb204','errPb206Pb204',
                    'Pb207Pb204','errPb207Pb204',
                    'rho')
    } else if (format==2 & nc>4) {
        cnames <- c('Pb204Pb206','errPb204Pb206',
                    'Pb207Pb206','errPb207Pb206',
                    'rho')
        opt <- 5
    } else if (format==3 & nc>5){
        cnames <- c('Pb206Pb204','errPb206Pb204',
                    'Pb207Pb204','errPb207Pb204',
                    'Pb206Pb207','errPb206Pb207')
    } else {
        stop('Invalid PbPb input format')
    }
    out$x <- insert.data(x=X,cnames=cnames,opt=opt)
    out
}
as.ArAr <- function(x,format=3,ierr=1){
    out <- list()
    class(out) <- "ArAr"
    out$format <- format
    out$J <- errAdjust(x=as.numeric(x[2,1:2]),ierr=ierr)
    nc <- ncol(x)
    nr <- nrow(x)
    bi <- 4 # begin index
    X <- shiny2matrix(x,bi,nr,nc)
    X <- errconvert(X,gc='Ar-Ar',format=format,ierr=ierr)
    if (format==1) {
        cnames <- c('Ar39Ar36','errAr39Ar36',
                    'Ar40Ar36','errAr40Ar36',
                    'rho','Ar39')
    } else if (format==2) {
        cnames <- c('Ar39Ar40','errAr39Ar40',
                    'Ar36Ar40','errAr36Ar40',
                    'rho','Ar39')
    } else if (format==3){
        cnames <- c('Ar39Ar40','errAr39Ar40',
                    'Ar36Ar40','errAr36Ar40',
                    'Ar39Ar36','errAr39Ar36','Ar39')
    } else {
        stop('Invalid input format.')
    }
    out$x <- insert.data(x=X,cnames=cnames)
    if (ncol(X)<ncol(out$x)){
        ns <- nr-bi+1
        out$x[,'Ar39'] <- 1/ns
    }
    out
}
as.ThPb <- function(x,format=1,ierr=1){
    out <- list()
    class(out) <- "ThPb"
    out$format <- format
    nc <- ncol(x)
    nr <- nrow(x)
    bi <- 2 # begin index
    X <- shiny2matrix(x,bi,nr,nc)
    X <- errconvert(X,gc='Th-Pb',format=format,ierr=ierr)
    if (format==1 & nc>3){
        cnames <- c('Th232Pb204','errTh232Pb204',
                    'Pb208Pb204','errPb208Pb204','rho')
    } else if (format==2 & nc>3){
        cnames <- c('Th232Pb208','errTh232Pb208',
                    'Pb204Pb208','errPb204Pb208','rho')
    } else if (format==3 & nc>5){
        cnames <- c('Th232Pb208','errTh232Pb208',
                    'Pb204Pb208','errPb204Pb208',
                    'Th232Pb204','errTh232Pb204')
    } else {
        stop("Incorrect format or insufficient columns")
    }
    out$x <- insert.data(x=X,cnames=cnames)
    out
}
as.KCa <- function(x,format=1,ierr=1){
    out <- list()
    class(out) <- "KCa"
    out$format <- format
    nc <- ncol(x)
    nr <- nrow(x)
    bi <- 2 # begin index
    X <- shiny2matrix(x,bi,nr,nc)
    X <- errconvert(X,gc='K-Ca',format=format,ierr=ierr)
    if (format==1 & nc>3){
        cnames <- c('K40Ca44','errK40Ca44',
                    'Ca40Ca44','errCa40Ca44','rho')
    } else if (format==2 & nc>3){
        cnames <- c('K40Ca40','errK40Ca40',
                    'Ca44Ca40','errCa44Ca40','rho')
    } else if (format==3 & nc>5){
        cnames <- c('K40Ca44','errK40Ca44',
                    'Ca40Ca44','errCa40Ca44',
                    'K40Ca40','errK40Ca40')
    } else {
        stop("Incorrect format or insufficient columns")
    }
    out$x <- insert.data(x=X,cnames=cnames)
    out
}
as.RbSr <- function(x,format=1,ierr=1){
    if (format==1){
        cnames <- c('Rb87Sr86','errRb87Sr86',
                    'Sr87Sr86','errSr87Sr86','rho')
    } else if (format==2){
        cnames <- c('Rb87Sr87','errRb87Sr87',
                    'Sr86Sr87','errSr86Sr87','rho')
    } else if (format==3){
        cnames <- c('Rbppm','errRbppm','Srppm','errSrppm',
                    'Sr87Sr86','errSr87Sr86')
    }
    as.PD(x,"RbSr",cnames,format,ierr)
}
as.ReOs <- function(x,format=1,ierr=1){
    if (format==1){
        cnames <- c('Re187Os188','errRe187Os188',
                    'Os187Os188','errOs187Os188','rho')
    } else if (format==2){
        cnames <- c('Re187Os187','errRe187Os187',
                    'Os188Os187','errOs188Os187','rho')
    } else if (format==3){
        cnames <- c('Reppm','errReppm','Osppm','errOsppm',
                    'Os187Os188','errOs187Os188')
    }
    as.PD(x,"ReOs",cnames,format,ierr)
}
as.SmNd <- function(x,format=1,ierr=1){
    if (format==1){
        cnames <- c('Sm143Nd144','errSm143Nd144',
                    'Nd143Nd144','errNd143Nd144','rho')
    } else if (format==2){
        cnames <- c('Sm143Nd143','errSm143Nd143',
                    'Nd144Nd143','errNd144Nd143','rho')
    } else if (format==3){
        cnames <- c('Smppm','errSmppm','Ndppm','errNdppm',
                    'Nd143Nd144','errNd143Nd144')
    }
    as.PD(x,"SmNd",cnames,format,ierr)
}
as.LuHf <- function(x,format=1,ierr=1){
    if (format==1){
        cnames <- c('Lu176Hf177','errLu176Hf177',
                    'Hf176Hf177','errHf176Hf177','rho')
    } else if (format==2){
        cnames <- c('Lu176Hf176','errLu176Hf176',
                    'Hf177Hf176','errHf177Hf176','rho')
    } else if (format==3){
        cnames <- c('Luppm','errLuppm','Hfppm','errHfppm',
                    'Hf176Hf177','errHf176Hf177')
    }
    as.PD(x,"LuHf",cnames,format,ierr)
}
as.PD <- function(x,classname,cnames,format,ierr){
    out <- list()
    class(out) <- c(classname,'PD')
    out$x <- NA
    out$format <- format
    nc <- ncol(x)
    nr <- nrow(x)
    if (is.numeric(x)) X <- x
    else X <- shiny2matrix(x,2,nr,nc)
    X <- errconvert(X,gc='PD',format=format,ierr=ierr)
    if (format<3) opt <- 5
    else opt <- NULL
    out$x <- insert.data(x=X,cnames=cnames,opt=opt)
    out
}
as.ThU <- function(x,format=1,ierr=1,Th02=c(0,0),Th02U48=c(0,0,1e6,0,0,0,0,0,0)){
    out <- list()
    class(out) <- "ThU"
    out$x <- NA
    out$format <- format
    out$Th02 <- Th02
    out$Th02U48 <- Th02U48
    nc <- ncol(x)
    nr <- nrow(x)
    if (is.numeric(x)) X <- x
    else X <- shiny2matrix(x,2,nr,nc)
    X <- errconvert(X,gc='Th-U',format=format,ierr=ierr)
    cnames <- NULL
    if (format==1 & nc>8){
        cnames <- c('U238Th232','errU238Th232',
                    'U234Th232','errU234Th232',
                    'Th230Th232','errTh230Th232',
                    'rhoXY','rhoXZ','rhoYZ')
    } else if (format==2 & nc>8) {
        cnames <- c('Th232U238','errTh232U238',
                    'U234U238','errU234U238',
                    'Th230U238','errTh230U238',
                    'rhoXY','rhoXZ','rhoYZ')
    } else if (format==3 & nc>3) {
        if (nc==4) X <- cbind(subset(X,select=1:4),0)
        cnames <- c('U238Th232','errU238Th232',
                    'Th230Th232','errTh230Th232',
                    'rho')
    } else if (format==4 & nc>3) {
        if (nc==4) X <- cbind(subset(X,select=1:4),0)
        cnames <- c('Th232U238','errTh232U238',
                    'Th230U238','errTh230U238',
                    'rho')
    }
    out$x <- insert.data(x=X,cnames=cnames)
    out
}
as.UThHe <- function(x,ierr=1){
    nc <- ncol(x)
    nr <- nrow(x)
    if (is.numeric(x)) X <- x
    else X <- shiny2matrix(x,2,nr,nc)
    X[X<=0] <- NA
    X <- errconvert(X,gc='U-Th-He',ierr=ierr)
    if (nc>5) cnames <- c('He','errHe','U','errU','Th','errTh')
    if (nc>7) cnames <- c(cnames,'Sm','errSm')
    out <- insert.data(x=X,cnames=cnames)
    class(out) <- append("UThHe",class(out))
    out
}
as.fissiontracks <- function(x,format=1,ierr=1){
    nr <- nrow(x)
    nc <- ncol(x)
    out <- list()
    class(out) <- "fissiontracks"
    out$format <- format
    if (format==1){
        out$zeta <- errAdjust(as.numeric(x[2,1:2]),ierr=ierr)
        out$rhoD <- errAdjust(as.numeric(x[4,1:2]),ierr=ierr)
        X <- shiny2matrix(x,6,nr,nc)
        out$x <- insert.data(x=X,cnames=c('Ns','Ni'))
    } else {
        if (format==2){
            out$zeta <- errAdjust(as.numeric(x[2,1:2]),ierr=ierr)
            out$spotSize <- as.numeric(x[4,1])
            si <- 6 # start index
        } else {
            out$spotSize <- as.numeric(x[2,1])
            si <- 4
        }
        ns <- nr-si+1
        Ns <- as.numeric(x[si:nr,1])
        A <- as.numeric(x[si:nr,2])
        out$Ns <- Ns
        out$A <- A
        out$U <- list()
        out$sU <- list()
        errcols <- seq(from=4,to=nc,by=2)-2
        for (i in 1:ns){
            UsU <- as.numeric(x[i+si-1,3:nc])
            UsU <- errAdjust(UsU,i=errcols,ierr=ierr)
            iU <- seq(from=1,to=length(UsU)-1,by=2)
            isU <- seq(from=2,to=length(UsU),by=2)
            out$U[[i]] <- UsU[iU]
            out$sU[[i]] <- UsU[isU]
        }
    }
    out
}
as.detritals <- function(x){
    out <- list()
    class(out) <- "detritals"
    nr <- nrow(x)
    nc <- ncol(x)
    snames <- x[1,]
    if (is.numeric(x)) X <- x
    else X <- shiny2matrix(x,2,nr,nc)
    colnames(X) <- snames
    for (sname in snames){
        out[[sname]] = X[!is.na(X[,sname]),sname]
    }
    out
}
as.other <- function(x,format='generic',ierr=1){
    nc <- ncol(x)
    has.header <- is.na(suppressWarnings(as.numeric(x[1,1])))
    if (has.header) x <- x[-1,]
    X <- matrix(as.numeric(x),ncol=nc)
    errconvert(X,gc='other',format=format,ierr=ierr)
}

# x = a numerical vector, br = length of the preamble with parameters
# nr = number of rows, nc = number of columns
shiny2matrix <- function(x,br,nr,nc){
    suppressWarnings(
        return(matrix(as.numeric(x[(br:nr),]),nr-br+1,nc))
    )
}

insert.data <- function(x,cnames,opt=NULL){
    nr <- nrow(x)
    nc <- length(cnames)
    out <- matrix(0,nr,nc)
    ncx <- min(nc,ncol(x))
    out[1:nr,1:ncx] <- as.matrix(x)[1:nr,1:ncx]
    if (!is.null(opt)){ # replace NA values in optional columns with zeros
        ij <- which(is.na(out[,opt]),arr.ind=TRUE)
        out[,opt][ij] <- 0
    }
    colnames(out) <- cnames
    out
}

errconvert <- function(x,gc='U-Pb',format=1,ierr=1){
    if (ierr==1){ return(x) }
    else { out <- x }
    i <- getErrCols(gc,format,ierr)
    errAdjust(x,i,ierr)
}

errAdjust <- function(x,i=2,ierr=1){
    out <- x
    if (is.vector(x)){
        if (ierr==2){
            out[i] <- x[i]/2
        } else if (ierr==3){
            out[i] <- x[i]*x[i-1]/100
        } else if (ierr==4){
            out[i] <- x[i]*x[i-1]/200
        }
    } else {
        if (ierr==2){
            out[,i] <- x[,i]/2
        } else if (ierr==3){
            out[,i] <- x[,i]*x[,i-1]/100
        } else if (ierr==4){
            out[,i] <- x[,i]*x[,i-1]/200
        }
    }
    out
}

getErrCols <- function(gc,format=NA,ierr=1){
    UPb12 <- (gc=='U-Pb' && format%in%(1:2))
    UPb345 <- (gc=='U-Pb' && format%in%(3:5))
    UPb6 <- (gc=='U-Pb' && format==6)
    UPb78 <- (gc=='U-Pb' && format%in%(7:8))
    PbPb12 <- (gc=='Pb-Pb' && format%in%(1:2))
    PbPb3 <- (gc=='Pb-Pb' && format==3)
    ArAr12 <- (gc=='Ar-Ar' && format%in%(1:2))
    ArAr3 <- (gc=='Ar-Ar' && format==3)
    KCa12 <- (gc=='K-Ca' && format%in%(1:2))
    KCa3 <- (gc=='K-Ca' && format==3)
    PD12 <- (gc=='PD' && format%in%(1:2))
    PD3 <- (gc=='PD' && format==3)
    UThHe <- (gc=='U-Th-He')
    ThU12 <- (gc=='Th-U' && format<3)
    ThU34 <- (gc=='Th-U' && format>2)
    radial <- (gc=='other' && identical(format,'radial'))
    regression <- (gc=='other' && identical(format,'regression'))
    spectrum <- (gc=='other' && identical(format,'spectrum'))
    average <- (gc=='other' && identical(format,'average'))
    if (UPb12 | PbPb12 | ArAr12 | KCa12 | PD12 | ThU34 | regression){
        cols <- c(2,4)
    } else if (UPb345 | PbPb3 | ArAr3 | KCa3 | PD3 | UThHe | ThU12){
        cols <- c(2,4,6)
    } else if (UPb78){
        cols <- seq(from=2,to=8,by=2)
    } else if (UPb6){
        cols <- seq(from=2,to=12,by=2)
    } else if (radial || average){
        cols <- 2
    } else if (spectrum){
        cols <- 3
    } else {
        cols <- NULL
    }
    cols
}

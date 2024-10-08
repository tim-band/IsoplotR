#' @title
#' Calculate the weighted mean age
#' 
#' @description
#' Models the data as a Normal distribution with two sources of
#' variance.  Estimates the mean and `overdispersion' using the method
#' of Maximum Likelihood. Computes the MSWD of a Normal fit without
#' overdispersion. Implements a modified Chauvenet Criterion to detect
#' and reject outliers. Only propagates the analytical uncertainty
#' associated with decay constants and \eqn{\zeta} and J-factors after
#' computing the weighted mean isotopic composition.
#' 
#' @details
#' Let \eqn{\{t_1, ..., t_n\}} be a set of n age estimates
#' determined on different aliquots of the same sample, and let
#' \eqn{\{s[t_1], ..., s[t_n]\}} be their analytical
#' uncertainties. \code{IsoplotR} then calculates the weighted mean of
#' these data using one of two methods:
#'
#' \enumerate{
#'
#' \item The ordinary error-weighted mean:
#'
#' \eqn{\mu = \sum(t_i/s[t_i]^2)/\sum(1/s[t_i]^2)}
#'
#' \item A random effects model with two sources of variance:
#'
#' \eqn{\log[t_i] \sim N(\log[\mu], \sigma^2 = (s[t_i]/t_i)^2 + \omega^2 )}
#'
#' where \eqn{\mu} is the mean, \eqn{\sigma^2} is the total variance
#' and \eqn{\omega} is the 'overdispersion'. This equation can be
#' solved for \eqn{\mu} and \eqn{\omega} by the method of maximum
#' likelihood.
#' 
#' }
#'
#' IsoplotR uses a modified version of Chauvenet's criterion for
#' outlier detection:
#'
#' \enumerate{
#'
#' \item Compute the error-weighted mean (\eqn{\mu}) of the \eqn{n}
#' age determinations \eqn{t_i} using their analytical uncertainties
#' \eqn{s[t_i]}
#'
#' \item For each \eqn{t_i}, compute the probability \eqn{p_i} that
#' that \eqn{|t-\mu|>|t_i-\mu|} for \eqn{t \sim N(\mu, s[t_i]^2 MSWD)}
#' (ordinary weighted mean) or \eqn{\log[t] \sim
#' N(\log[\mu],s[t_i]^2+\omega^2)} (random effects model)
#'
#' \item Let \eqn{p_j \equiv \min(p_1, ..., p_n)}. If
#' \eqn{p_j<0.05/n}, then reject the j\eqn{^{th}} date, reduce \eqn{n}
#' by one (i.e., \eqn{n \rightarrow n-1}) and repeat steps 1 through 3
#' until the surviving dates pass the third step.  }
#'
#' If the analtyical uncertainties are small compared to the scatter
#' between the dates (i.e. if \eqn{\omega \gg s[t]} for all \eqn{i}),
#' then this generalised algorithm reduces to the conventional
#' Chauvenet criterion. If the analytical uncertainties are large and
#' the data do not exhibit any overdispersion, then the heuristic
#' outlier detection method is equivalent to Ludwig (2003)'s `2-sigma'
#' method.
#' 
#' @param x a two column matrix of values (first column) and their
#'     standard errors (second column) OR an object of class
#'     \code{UPb}, \code{PbPb}, \code{ThPb}, \code{ArAr}, \code{KCa},
#'     \code{ReOs}, \code{SmNd}, \code{RbSr}, \code{LuHf}, \code{ThU},
#'     \code{fissiontracks} or \code{UThHe}
#' @param random.effects if \code{TRUE}, computes the weighted mean
#'     using a random effects model with two parameters: the mean and
#'     the dispersion. This is akin to a `model-3' isochron
#'     regression.
#' 
#'     if \code{FALSE}, attributes any excess dispersion to an
#'     underestimation of the analytical uncertainties. This akin to a
#'     `model-1' isochron regression.
#' @param ... optional arguments
#' @seealso \code{\link{central}}
#' 
#' @return Returns a list with the following items:
#'
#' \describe{
#'
#' \item{mean}{a three element vector with:
#'
#' \code{t}: the weighted mean
#'
#' \code{s[t]}: the standard error of the weighted mean
#'
#' \code{ci[t]}: the \eqn{100(1-\alpha)\%} confidence interval for
#' \code{t}
#'
#' }
#'
#' \item{disp}{a three-element vector with the (over)dispersion and
#' the lower and upper half-widths of its \eqn{100(1-\alpha)\%}
#' confidence interval.}
#'
#' \item{mswd}{the Mean Square of the Weighted Deviates
#' (a.k.a. `reduced Chi-square' statistic)}
#'
#' \item{df}{the number of degrees of freedom of the Chi-square test
#' for homogeneity (\eqn{df=n-1}, where \eqn{n} is the number of
#' samples).}
#'
#' \item{p.value}{the p-value of a Chi-square test with \eqn{df}
#' degrees of freedom, testing the null hypothesis that the underlying
#' population is not overdispersed.}
#'
#' \item{valid}{vector of logical flags indicating which steps are
#' included into the weighted mean calculation}
#'
#' \item{plotpar}{list of plot parameters for the weighted mean
#' diagram, including \code{mean} (the mean value), \code{ci} (a grey
#' rectangle with the 100[1-\eqn{\alpha}]\% confidence interval
#' ignoring systematic errors), \code{ci.exterr} (a grey rectangle
#' with the 100[1-\eqn{\alpha}]\% confidence interval including
#' systematic errors), \code{dash1} and \code{dash2} (lines marking
#' the overdispersion if \code{random.effects=TRUE}).} }
#' @rdname weightedmean
#' @export
weightedmean <- function(x,...){
    UseMethod("weightedmean",x)
}
#' @param detect.outliers logical flag indicating whether outliers
#'     should be detected and rejected using Chauvenet's Criterion.
#' @param plot logical flag indicating whether the function should
#'     produce graphical output or return numerical values to the
#'     user.
#' @param from minimum y-axis limit. Setting \code{from=NA} scales the
#'     plot automatically.
#' @param to maximum y-axis limit. Setting \code{to=NA} scales the
#'     plot automatically.
#' @param levels a vector with additional values to be displayed as
#'     different background colours of the plot symbols.
#' @param clabel label of the colour legend
#' @param rect.col Fill colour for the measurements or age estimates. This can
#'     either be a single colour or multiple colours to form a colour
#'     ramp (to be used if \code{levels!=NA}):
#'
#' a single colour: \code{rgb(0,1,0,0.5)}, \code{'#FF000080'},
#' \code{'white'}, etc.;
#'
#' multiple colours: \code{c(rbg(1,0,0,0.5)},
#' \code{rgb(0,1,0,0.5))}, \code{c('#FF000080','#00FF0080')},
#' \code{c('blue','red')}, \code{c('blue','yellow','red')}, etc.;
#'
#' a colour palette: \code{rainbow(n=100)},
#' \code{topo.colors(n=100,alpha=0.5)}, etc.; or
#'
#' a reversed palette: \code{rev(topo.colors(n=100,alpha=0.5))},
#' etc.
#'
#' For empty boxes, set \code{rect.col=NA}
#' 
#' @param outlier.col if \code{detect.outliers=TRUE}, the outliers are
#'     given a different colour.
#' @param sigdig the number of significant digits of the numerical
#'     values reported in the title of the graphical output.
#' @param alpha the confidence limits of the error bars/rectangles.
#' @param ranked plot the aliquots in order of increasing age?
#' @param hide vector with indices of aliquots that should be removed
#'     from the weighted mean plot.
#' @param omit vector with indices of aliquots that should be plotted
#'     but omitted from the weighted mean calculation.
#' @param omit.col colour that should be used for the omitted
#'     aliquots.
#' @importFrom grDevices rgb
#' @rdname weightedmean
#' @export
weightedmean.default <- function(x,from=NA,to=NA,random.effects=TRUE,
                                 detect.outliers=TRUE,plot=TRUE,
                                 levels=NA,clabel="",
                                 rect.col=c("#00FF0080","#FF000080"),
                                 outlier.col="#00FFFF80",sigdig=2,
                                 alpha=0.05,ranked=FALSE,hide=NULL,
                                 omit=NULL,omit.col=NA,...){
    ns <- nrow(x)
    calcit <- (1:ns)%ni%c(hide,omit)
    X <- x[,1]
    sX <- x[,2]
    valid <- !is.na(X) & !is.na(sX) & calcit
    nvalid <- count(valid)
    if (detect.outliers){
        while (TRUE & nvalid>2){
            valid <- chauvenet(X,sX,valid=valid,
                               random.effects=random.effects)
            if (count(valid) < nvalid) { nvalid <- count(valid) }
            else { break }
        }
    }
    out <- get.weightedmean(X,sX,random.effects=random.effects,
                            valid=valid,alpha=alpha)
    if (plot){
        plot_weightedmean(X,sX,fit=out,from=from,to=to,levels=levels,
                          clabel=clabel,rect.col=rect.col,
                          outlier.col=outlier.col,sigdig=sigdig,
                          alpha=alpha,ranked=ranked,hide=hide,
                          omit=omit,omit.col=omit.col,...)
    }
    invisible(out)
}
#' @param type scalar indicating whether to plot the
#'     \eqn{^{207}}Pb/\eqn{^{235}}U age (\code{type}=1), the
#'     \eqn{^{206}}Pb/\eqn{^{238}}U age (\code{type}=2), the
#'     \eqn{^{207}}Pb/\eqn{^{206}}Pb age (\code{type}=3), the
#'     \eqn{^{207}}Pb/\eqn{^{206}}Pb-\eqn{^{206}}Pb/\eqn{^{238}}U age
#'     (\code{type}=4), the concordia age (\code{type}=5), or the
#'     \eqn{^{208}}Pb/\eqn{^{232}}Th age (\code{type}=6).
#' @param cutoff.76 the age (in Ma) below which the
#'     \eqn{^{206}}Pb/\eqn{^{238}}U age and above which the
#'     \eqn{^{207}}Pb/\eqn{^{206}}Pb age is used. This parameter is
#'     only used if \code{type=4}.
#' @param cutoff.disc discordance cutoff filter. This is an object of
#'     class \code{discfilter}
#' @param exterr propagate decay constant uncertainties?
#' @param common.Pb common lead correction:
#'
#' \code{0}: none
#'
#' \code{1}: use the Pb-composition stored in
#' 
#' \code{settings('iratio','Pb206Pb204')} (if \code{x} has class
#' \code{UPb} and \code{x$format<4});
#' 
#' \code{settings('iratio','Pb206Pb204')} and
#' \code{settings('iratio','Pb207Pb204')} (if \code{x} has class
#' \code{PbPb} or \code{x} has class \code{UPb} and
#' \code{3<x$format<7}); or
#'
#' \code{settings('iratio','Pb208Pb206')} and
#' \code{settings('iratio','Pb208Pb207')} (if \code{x} has class
#' \code{UPb} and \code{x$format=7} or \code{8}).
#'
#' \code{2}: use the isochron intercept as the initial Pb-composition
#'
#' \code{3}: use the Stacey-Kramers two-stage model to infer the
#' initial Pb-composition (only applicable if \code{x} has class
#' \code{UPb})
#' @examples
#' ages <- c(251.9,251.59,251.47,251.35,251.1,251.04,250.79,250.73,251.22,228.43)
#' errs <- c(0.28,0.28,0.63,0.34,0.28,0.63,0.28,0.4,0.28,0.33)
#' weightedmean(cbind(ages,errs))
#'
#' data(examples)
#' weightedmean(examples$LudwigMean)
#' @rdname weightedmean
#' @export
weightedmean.UPb <- function(x,random.effects=TRUE,
                             detect.outliers=TRUE,plot=TRUE,from=NA,
                             to=NA,levels=NA,clabel="",
                             rect.col=c("#00FF0080","#FF000080"),
                             outlier.col="#00FFFF80",sigdig=2,type=4,
                             cutoff.76=1100,alpha=0.05,
                             cutoff.disc=discfilter(),exterr=TRUE,
                             ranked=FALSE,common.Pb=0,hide=NULL,
                             omit=NULL,omit.col=NA,...){
    weightedmean_helper(x,random.effects=random.effects,
                        detect.outliers=detect.outliers,plot=plot,
                        from=from,to=to,levels=levels,clabel=clabel,
                        rect.col=rect.col,outlier.col=outlier.col,
                        type=type,cutoff.76=cutoff.76,
                        cutoff.disc=cutoff.disc,sigdig=sigdig,
                        alpha=alpha,exterr=exterr,units='Ma',
                        ranked=ranked,hide=hide,omit=omit,
                        omit.col=omit.col,common.Pb=common.Pb,...)
}
#' @rdname weightedmean
#' @export
weightedmean.PbPb <- function(x,random.effects=TRUE,
                              detect.outliers=TRUE,plot=TRUE, from=NA,
                              to=NA,levels=NA,clabel="",
                              rect.col=c("#00FF0080","#FF000080"),
                              outlier.col="#00FFFF80",sigdig=2,
                              alpha=0.05,exterr=TRUE,common.Pb=2,
                              ranked=FALSE,hide=NULL,omit=NULL,
                              omit.col=NA,...){
    weightedmean_helper(x,random.effects=random.effects,
                        detect.outliers=detect.outliers,plot=plot,
                        from=from,to=to,levels=levels,clabel=clabel,
                        rect.col=rect.col,outlier.col=outlier.col,
                        sigdig=sigdig, alpha=alpha,exterr=exterr,
                        units='Ma',ranked=ranked,hide=hide,omit=omit,
                        omit.col=omit.col,common.Pb=common.Pb,...)
}
#' @param i2i `isochron to intercept': calculates the initial (aka
#'     `inherited', `excess', or `common')
#'     \eqn{^{40}}Ar/\eqn{^{36}}Ar, \eqn{^{40}}Ca/\eqn{^{44}}Ca,
#'     \eqn{^{207}}Pb/\eqn{^{204}}Pb, \eqn{^{87}}Sr/\eqn{^{86}}Sr,
#'     \eqn{^{143}}Nd/\eqn{^{144}}Nd, \eqn{^{187}}Os/\eqn{^{188}}Os,
#'     \eqn{^{230}}Th/\eqn{^{232}}Th, \eqn{^{176}}Hf/\eqn{^{177}}Hf or
#'     \eqn{^{204}}Pb/\eqn{^{208}}Pb ratio from an isochron
#'     fit. Setting \code{i2i} to \code{FALSE} uses the default values
#'     stored in \code{settings('iratio',...)}.
#' @param detritus detrital \eqn{^{230}}Th correction (only applicable
#'     when \code{x$format=1} or \code{2}).
#'
#' \code{0}: no correction
#'
#' \code{1}: project the data along an isochron fit
#'
#' \code{2}: correct the data using an assumed initial
#' \eqn{^{230}}Th/\eqn{^{232}}Th-ratio for the detritus.
#'
#' \code{3}: correct the data using the measured present day
#' \eqn{^{230}}Th/\eqn{^{238}}U, \eqn{^{232}}Th/\eqn{^{238}}U and
#' \eqn{^{234}}U/\eqn{^{238}}U-ratios in the detritus.
#' @rdname weightedmean
#' @export
weightedmean.ThU <- function(x,random.effects=TRUE,
                             detect.outliers=TRUE,plot=TRUE, from=NA,
                             to=NA,levels=NA,clabel="",
                             rect.col=c("#00FF0080","#FF000080"),
                             outlier.col="#00FFFF80",sigdig=2,
                             alpha=0.05,ranked=FALSE,i2i=TRUE,
                             detritus=0,hide=NULL,omit=NULL,omit.col=NA,...){
    weightedmean_helper(x,random.effects=random.effects,
                        detect.outliers=detect.outliers,plot=plot,
                        from=from,to=to,levels=levels,clabel=clabel,
                        rect.col=rect.col,outlier.col=outlier.col,
                        sigdig=sigdig,alpha=alpha,ranked=ranked,
                        i2i=i2i,units='ka',detritus=detritus,hide=hide,
                        omit=omit,omit.col=omit.col,...)
}
#' @rdname weightedmean
#' @export
weightedmean.ArAr <- function(x,random.effects=TRUE,
                              detect.outliers=TRUE,plot=TRUE, from=NA,
                              to=NA,levels=NA,clabel="",
                              rect.col=c("#00FF0080","#FF000080"),
                              outlier.col="#00FFFF80",sigdig=2,
                              alpha=0.05,exterr=TRUE,ranked=FALSE,
                              i2i=FALSE,hide=NULL,omit=NULL,
                              omit.col=NA,...){
    weightedmean_helper(x,random.effects=random.effects,
                        detect.outliers=detect.outliers,plot=plot,
                        from=from,to=to,levels=levels,clabel=clabel,
                        rect.col=rect.col,outlier.col=outlier.col,
                        sigdig=sigdig,alpha=alpha,exterr=exterr,
                        i2i=i2i,units='Ma',ranked=ranked,hide=hide,
                        omit=omit,omit.col=omit.col,...)
}
#' @rdname weightedmean
#' @export
weightedmean.KCa <- function(x,random.effects=TRUE,
                             detect.outliers=TRUE,plot=TRUE, from=NA,
                             to=NA,levels=NA,clabel="",
                             rect.col=c("#00FF0080","#FF000080"),
                             outlier.col="#00FFFF80",sigdig=2,
                             alpha=0.05,exterr=TRUE,ranked=FALSE,
                             i2i=FALSE,hide=NULL,omit=NULL,
                             omit.col=NA,...){
    weightedmean_helper(x,random.effects=random.effects,
                        detect.outliers=detect.outliers,plot=plot,
                        from=from,to=to,levels=levels,clabel=clabel,
                        rect.col=rect.col,outlier.col=outlier.col,
                        sigdig=sigdig,alpha=alpha,exterr=exterr,
                        i2i=i2i,units='Ma',ranked=ranked,hide=NULL,
                        omit=omit,omit.col=omit.col,...)
}
#' @rdname weightedmean
#' @export
weightedmean.ThPb <- function(x,random.effects=TRUE,
                              detect.outliers=TRUE,plot=TRUE, from=NA,
                              to=NA,levels=NA,clabel="",
                              rect.col=c("#00FF0080","#FF000080"),
                              outlier.col="#00FFFF80",sigdig=2,
                              alpha=0.05,exterr=TRUE,ranked=FALSE,
                              i2i=TRUE,hide=NULL,omit=NULL,
                              omit.col=NA,...){
    weightedmean_helper(x,random.effects=random.effects,
                        detect.outliers=detect.outliers,plot=plot,
                        from=from,to=to,levels=levels,clabel=clabel,
                        rect.col=rect.col,outlier.col=outlier.col,
                        sigdig=sigdig, alpha=alpha,exterr=exterr,
                        i2i=i2i,units='Ma',ranked=ranked,hide=hide,
                        omit=omit,omit.col=omit.col,...)
}
#' @rdname weightedmean
#' @export
weightedmean.ReOs <- function(x,random.effects=TRUE,
                              detect.outliers=TRUE,plot=TRUE, from=NA,
                              to=NA,levels=NA,clabel="",
                              rect.col=c("#00FF0080","#FF000080"),
                              outlier.col="#00FFFF80",sigdig=2,
                              alpha=0.05,exterr=TRUE,ranked=FALSE,
                              i2i=TRUE,hide=NULL,omit=NULL,
                              omit.col=NA,...){
    weightedmean_helper(x,random.effects=random.effects,
                        detect.outliers=detect.outliers,plot=plot,
                        from=from,to=to,levels=levels,clabel=clabel,
                        rect.col=rect.col,outlier.col=outlier.col,
                        sigdig=sigdig, alpha=alpha,exterr=exterr,
                        i2i=i2i,units='Ma',ranked=ranked,hide=hide,
                        omit=omit,omit.col=omit.col,...)
}
#' @rdname weightedmean
#' @export
weightedmean.SmNd <- function(x,random.effects=TRUE,
                              detect.outliers=TRUE,plot=TRUE,from=NA,
                              to=NA,levels=NA,clabel="",
                              rect.col=c("#00FF0080","#FF000080"),
                              outlier.col="#00FFFF80",sigdig=2,
                              alpha=0.05,exterr=TRUE,ranked=FALSE,
                              i2i=TRUE,hide=NULL,omit=NULL,
                              omit.col=NA,...){
    weightedmean_helper(x,random.effects=random.effects,
                        detect.outliers=detect.outliers,plot=plot,
                        from=from,to=to,levels=levels,clabel=clabel,
                        rect.col=rect.col,outlier.col=outlier.col,
                        sigdig=sigdig,alpha=alpha,exterr=exterr,
                        i2i=i2i,units='Ma',ranked=ranked,hide=hide,
                        omit=omit,omit.col=omit.col,...)
}
#' @rdname weightedmean
#' @export
weightedmean.RbSr <- function(x,random.effects=TRUE,
                              detect.outliers=TRUE,plot=TRUE,from=NA,
                              to=NA,levels=NA,clabel="",
                              rect.col=c("#00FF0080","#FF000080"),
                              outlier.col="#00FFFF80",sigdig=2,
                              alpha=0.05,exterr=TRUE,i2i=TRUE,
                              ranked=FALSE,hide=NULL,omit=NULL,
                              omit.col=NA,...){
    weightedmean_helper(x,random.effects=random.effects,
                        detect.outliers=detect.outliers,plot=plot,
                        from=from,to=to,levels=levels,clabel=clabel,
                        rect.col=rect.col,outlier.col=outlier.col,
                        sigdig=sigdig,alpha=alpha,exterr=exterr,
                        i2i=i2i,units='Ma',ranked=ranked,hide=hide,
                        omit=omit,omit.col=omit.col,...)
}
#' @rdname weightedmean
#' @export
weightedmean.LuHf <- function(x,random.effects=TRUE,
                              detect.outliers=TRUE,plot=TRUE,
                              from=NA,to=NA,levels=NA,clabel="",
                              rect.col=c("#00FF0080","#FF000080"),
                              outlier.col="#00FFFF80",sigdig=2,
                              alpha=0.05,exterr=TRUE,i2i=TRUE,
                              ranked=FALSE,hide=NULL,omit=NULL,
                              omit.col=NA,...){
    weightedmean_helper(x,random.effects=random.effects,
                        detect.outliers=detect.outliers,plot=plot,
                        from=from,to=to,levels=levels,clabel=clabel,
                        rect.col=rect.col,outlier.col=outlier.col,
                        sigdig=sigdig,alpha=alpha,exterr=exterr,
                        i2i=i2i,units='Ma',ranked=ranked,hide=hide,
                        omit=omit,omit.col=omit.col,...)
}
#' @rdname weightedmean
#' @export
weightedmean.UThHe <- function(x,random.effects=TRUE,
                               detect.outliers=TRUE,plot=TRUE,
                               from=NA,to=NA,levels=NA,clabel="",
                               rect.col=c("#00FF0080","#FF000080"),
                               outlier.col="#00FFFF80",sigdig=2,
                               alpha=0.05,ranked=FALSE,hide=NULL,
                               omit=NULL,omit.col=NA,...){
    weightedmean_helper(x,random.effects=random.effects,
                        detect.outliers=detect.outliers,plot=plot,
                        from=from,to=to,levels=levels,clabel=clabel,
                        rect.col=rect.col,outlier.col=outlier.col,
                        sigdig=sigdig,alpha=alpha,exterr=FALSE,
                        units='Ma',ranked=ranked,hide=hide,
                        omit=omit,omit.col=omit.col,...)
}
#' @rdname weightedmean
#' @export
weightedmean.fissiontracks <- function(x,random.effects=TRUE,
                                       detect.outliers=TRUE,plot=TRUE,
                                       from=NA,to=NA,levels=NA,clabel="",
                                       rect.col=c("#00FF0080","#FF000080"),
                                       outlier.col="#00FFFF80",
                                       sigdig=2,alpha=0.05,
                                       exterr=TRUE,ranked=FALSE,
                                       hide=NULL, omit=NULL,
                                       omit.col=NA,...){
    weightedmean_helper(x,random.effects=random.effects,
                        detect.outliers=detect.outliers,plot=plot,
                        from=from,to=to,levels=levels,clabel=clabel,
                        rect.col=rect.col,outlier.col=outlier.col,
                        sigdig=sigdig,alpha=alpha,exterr=exterr,
                        units='Ma',ranked=ranked,hide=hide,
                        omit=omit,omit.col=omit.col,...)
}
weightedmean_helper <- function(x,random.effects=TRUE,
                                detect.outliers=TRUE,plot=TRUE,
                                from=NA,to=NA,levels=NA,clabel="",
                                rect.col=c("#00FF0080","#FF000080"),
                                outlier.col="#00FFFF80",type=4,
                                cutoff.76=1100,cutoff.disc=discfilter(),
                                sigdig=2,alpha=0.05,exterr=TRUE,
                                ranked=FALSE,i2i=FALSE,common.Pb=1,
                                units='',detritus=0,hide=NULL,
                                omit=NULL,omit.col=NA,...){
    tt <- get.ages(x,type=type,cutoff.76=cutoff.76,cutoff.disc=cutoff.disc,
                   i2i=i2i,omit4c=unique(c(hide,omit)),
                   common.Pb=common.Pb,detritus=detritus)
    fit <- weightedmean.default(tt,random.effects=random.effects,
                                detect.outliers=detect.outliers,
                                alpha=alpha,plot=FALSE,hide=hide,
                                omit=omit)
    if (exterr)
        out <- add.exterr.to.wtdmean(x,fit,cutoff.76=cutoff.76,type=type)
    else out <- fit
    if (plot){
        plot_weightedmean(tt[,1],tt[,2],from=from,to=to,fit=out,
                          levels=levels,clabel=clabel,
                          rect.col=rect.col,outlier.col=outlier.col,
                          sigdig=sigdig,alpha=alpha,units=units,
                          ranked=ranked,hide=hide,omit=omit,
                          omit.col=omit.col,...)
    }
    invisible(out)
}

get.weightedmean <- function(X,sX,random.effects=TRUE,
                             valid=TRUE,alpha=0.05){
    ns <- length(X)
    x <- X[valid]
    sx <- sX[valid]
    out <- list()
    if (length(x)<=1){
        out$mean <- c(x,sx,nfact(alpha)*sx)
        out$mswd <- 0
        out$p.value <- 1
        return(out)
    }
    out$random.effects <- random.effects
    out$alpha <- alpha
    out$df <- length(x)-1 # degrees of freedom for the homogeneity test
    if (random.effects){ # random effects model:
        if (all(x>0)){
            fit <- central(cbind(x,sx),alpha=alpha)
            out$mean <- fit$age
            out$disp <- fit$disp*out$mean['t']
            out$mswd <- fit$mswd
            out$p.value <- fit$p.value
        } else {
            out$mean <- rep(NA,3)
            out$disp <- rep(NA,3)
            names(out$mean) <- c('t','s[t]','ci[t]')
            names(out$disp) <- c('s','ll','ul')
            fit <- continuous_mixture(x,sx)
            out$mean['t'] <- fit$mu[1]
            out$mean['s[t]'] <- fit$mu[2]
            out$mean['ci[t]'] <- nfact(alpha)*out$mean['s[t]']
            out$disp['s'] <- fit$sigma
            out$disp[c('ll','ul')] <-
                profile_LL_weightedmean_disp(fit,x,sx,alpha)
            SS <- sum(((x-out$mean['t'])/sx)^2)
            out$mswd <- SS/out$df
            out$p.value <- 1-stats::pchisq(SS,out$df)
        }
    } else { # Ludwig's Isoplot approach:
        out$mean <- rep(NA,4)
        names(out$mean) <- c('t','s[t]','ci[t]','disp[t]')
        w <- 1/sx^2
        out$mean['t'] <- sum(w*x)/sum(w)
        out$mean['s[t]'] <- 1/sqrt(sum(w))
        SS <- sum(((x-out$mean['t'])/sx)^2)
        out$mswd <- SS/out$df
        out$p.value <- 1-stats::pchisq(SS,out$df)
        out$mean['ci[t]'] <- tfact(alpha,out$df)*out$mean['s[t]']
        out$mean['disp[t]'] <- sqrt(out$mswd)*out$mean['ci[t]']
        out$valid <- valid
    }
    plotpar <- list()
    plotpar$mean <- list(x=c(0,ns+1),y=rep(out$mean['t'],2))
    plotpar$ci <- list(x=c(0,ns+1,ns+1,0),
                       y=c(rep(out$mean['t']+out$mean['ci[t]'],2),
                           rep(out$mean['t']-out$mean['ci[t]'],2)))
    plotpar$ci.exterr <- NA # to be defined later
    if (random.effects){
        plotpar$dash1 <- list(x=c(0,ns+1),y=rep(out$mean['t']+nfact(alpha)*out$disp['s'],2))
        plotpar$dash2 <- list(x=c(0,ns+1),y=rep(out$mean['t']-nfact(alpha)*out$disp['s'],2))
    }
    out$plotpar <- plotpar
    out$valid <- valid
    out
}

wtdmean.title <- function(fit,sigdig=2,units='',...){
    rounded.mean <- roundit(fit$mean['t'],
                            fit$mean[c('s[t]','ci[t]')],
                            sigdig=sigdig)
    line1 <- substitute('mean ='~a%+-%b~'|'~c~u~'(n='*n/N*')',
                        list(a=rounded.mean['t'],
                             b=rounded.mean['s[t]'],
                             c=rounded.mean['ci[t]'],
                             u=units,
                             n=sum(fit$valid),
                             N=length(fit$valid)))
    if (fit$random.effects){
        rounded.disp <- roundit(fit$disp['s'],
                                fit$disp[c('ll','ul')],
                                sigdig=sigdig)
        line3 <- substitute('dispersion ='~a+b/-c~u,
                            list(a=rounded.disp['s'],
                                 b=rounded.disp['ul'],
                                 c=rounded.disp['ll'],
                                 u=units))
        mymtext(line3,line=0,...)
        line1line <- 2
        line2line <- 1
    } else {
        if (inflate(c(fit,model=1))){
            rounded.mean <- roundit(fit$mean['t'],
                                    fit$mean[c('s[t]','ci[t]','disp[t]')],
                                    sigdig=sigdig)
            line1 <- substitute('mean ='~a%+-%b~'|'~c~'|'~d~u~'(n='*n/N*')',
                                list(a=rounded.mean['t'],
                                     b=rounded.mean['s[t]'],
                                     c=rounded.mean['ci[t]'],
                                     d=rounded.mean['disp[t]'],
                                     u=units,
                                     n=sum(fit$valid),
                                     N=length(fit$valid)))
        }
        line1line <- 1
        line2line <- 0
    }
    line2 <- substitute('MSWD ='~a*', p('*chi^2*') ='~b,
                        list(a=roundit(fit$mswd,fit$mswd,sigdig=sigdig),
                             b=roundit(fit$p.value,fit$p.value,
                                       sigdig=sigdig)))
    mymtext(line1,line=line1line,...)
    mymtext(line2,line=line2line,...)
}

plot_weightedmean <- function(X,sX,fit,from=NA,to=NA,levels=NA,clabel="",
                              rect.col=c("#00FF0080","#FF000080"),
                              outlier.col="#00FFFF80",sigdig=2,
                              alpha=0.05,units='',ranked=FALSE,
                              hide=NULL,omit=NULL,omit.col=NA,...){
    NS <- length(X)
    plotit <- (1:NS)%ni%hide
    calcit <- (1:NS)%ni%c(hide,omit)
    colour <- set.ellipse.colours(ns=NS,levels=levels,col=rect.col,
                                  hide=hide,omit=which(!fit$valid),
                                  omit.col=omit.col)
    x <- X[plotit]
    sx <- sX[plotit]
    valid <- fit$valid[plotit]
    calcit <- calcit[plotit]
    colour <- colour[plotit]
    ns <- length(x)
    if (ranked){
        i <- order(x)
        x <- x[i]
        sx <- sx[i]
        valid <- valid[i]
        calcit <- calcit[i]
        colour <- colour[i]
    }
    fact <- nfact(alpha)
    if (is.na(from))
        minx <- min(c(x-fact*sx,x-fact*fit$disp['s']),na.rm=TRUE)
    else
        minx <- from
    if (is.na(to))
        maxx <- max(c(x+fact*sx,x+fact*fit$disp['s']),na.rm=TRUE)
    else
        maxx <- to
    graphics::plot(c(0,ns+1),c(minx,maxx),type='n',
                   axes=FALSE,xlab='N',ylab='',...)
    if (!any(is.na(fit$plotpar$ci.exterr)))
        graphics::polygon(fit$plotpar$ci.exterr,col='gray90',border=NA)
    graphics::polygon(fit$plotpar$ci,col='gray75',border=NA)
    graphics::lines(fit$plotpar$mean)
    if (fit$random.effects){
        graphics::lines(fit$plotpar$dash1,lty=3)
        graphics::lines(fit$plotpar$dash2,lty=3)
    }
    graphics::axis(side=1,at=1:ns)
    graphics::axis(side=2)
    for (i in 1:ns){
        if (!calcit[i]){
            col <- omit.col
        } else if (valid[i]){
            col <- colour[i]
        } else {
            col <- outlier.col
        }
        graphics::rect(xleft=i-0.4,ybottom=x[i]-fact*sx[i],
                       xright=i+0.4,ytop=x[i]+fact*sx[i],col=col)
    }
    colourbar(z=levels[valid],col=rect.col,clabel=clabel)
    graphics::title(wtdmean.title(fit,sigdig=sigdig,units=units))
}

# prune the data if necessary
# X and sX are some measurements and their standard errors
# valid is a vector of logical flags indicating whether the corresponding
# measurements have already been rejected or not
chauvenet <- function(X,sX,valid,random.effects=TRUE){
    if (sum(valid)<2) return(valid)
    fit <- get.weightedmean(X,sX,random.effects=random.effects,valid=valid)
    if (random.effects){
        if (all(X>0,na.rm=TRUE)){
            x <- log(X)
            mu <- log(fit$mean[1])
            sigma <- sqrt((fit$disp[1]/fit$mean[1])^2 + (sX/X)^2)
        } else {
            x <- X
            mu <- fit$mean[1]
            sigma <- sqrt(fit$disp[1]^2 + sX^2)
        }
    } else {
        x <- X
        mu <- fit$mean[1]
        sigma <- sqrt(fit$mean[2]^2 + max(1,fit$mswd)*sX^2)
        # max(1,mswd) is an ad hoc solution to avoid
        # dealing with underdispersed datasets
    }
    misfit <- abs(x-mu)/sigma
    prob <- 2*(1-stats::pnorm(misfit))
    iworst <- which.max(misfit[valid])
    minp <- prob[iworst]
    ns <- length(which(valid))
    if (ns*minp < 0.5) {
        valid[iworst] <- FALSE # remove outlier
    } 
    valid
}

add.exterr.to.wtdmean <- function(x,fit,cutoff.76=1100,type=4){
    out <- fit
    out$mean[c('t','s[t]')] <-
        add.exterr(x,tt=fit$mean['t'],st=fit$mean['s[t]'],
                   cutoff.76=cutoff.76,type=type)
    if (fit$random.effects){
        out$mean['ci[t]'] <- nfact(fit$alpha)*out$mean['s[t]']
    } else {
        out$mean['ci[t]'] <- tfact(fit$alpha,fit$df)*out$mean['s[t]']
        if (inflate(c(fit,model=1))){
            out$mean['disp[t]'] <- tfact(fit$alpha,fit$df)*
                add.exterr(x,tt=fit$mean['t'],
                           st=sqrt(fit$mswd)*fit$mean['s[t]'],
                           cutoff.76=cutoff.76,type=type)[2]
        }
    }
    ns <- length(x)
    ci.exterr <- list(x=c(0,ns+1,ns+1,0),
                      y=c(rep(out$mean['t']+out$mean['ci[t]'],2),
                          rep(out$mean['t']-out$mean['ci[t]'],2)))
    out$plotpar$ci.exterr <- ci.exterr
    out
}

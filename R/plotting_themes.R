# Plotting Themes and Utilities
# Author: Automated improvement script
# Purpose: Provide consistent, reusable plot themes and styling

#' Get Default ggplot2 Theme for Workshop
#'
#' Returns a consistent theme for all plots in the workshop manual
#'
#' @param base_size Base font size (default: 12)
#' @param base_family Base font family (default: "")
#' @return A ggplot2 theme object
#' @examples
#' library(ggplot2)
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   get_default_theme()
#' @export
get_default_theme <- function(base_size = 12, base_family = "") {
  ggplot2::theme_bw(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      # Title formatting
      plot.title = ggplot2::element_text(
        size = base_size * 1.2,
        face = "bold",
        hjust = 0,
        margin = ggplot2::margin(b = 10)
      ),
      plot.subtitle = ggplot2::element_text(
        size = base_size * 0.9,
        hjust = 0,
        margin = ggplot2::margin(b = 10)
      ),

      # Axis formatting
      axis.title = ggplot2::element_text(
        size = base_size,
        face = "bold"
      ),
      axis.text = ggplot2::element_text(size = base_size * 0.9),

      # Legend formatting
      legend.title = ggplot2::element_text(
        size = base_size,
        face = "bold"
      ),
      legend.text = ggplot2::element_text(size = base_size * 0.9),
      legend.position = "right",
      legend.background = ggplot2::element_rect(
        fill = "white",
        color = "gray80"
      ),

      # Panel formatting
      panel.grid.major = ggplot2::element_line(color = "gray90"),
      panel.grid.minor = ggplot2::element_line(color = "gray95"),
      panel.border = ggplot2::element_rect(color = "gray70", fill = NA),

      # Strip formatting (for facets)
      strip.background = ggplot2::element_rect(
        fill = "gray90",
        color = "gray70"
      ),
      strip.text = ggplot2::element_text(
        size = base_size,
        face = "bold"
      )
    )
}

#' Get Publication-Ready Theme
#'
#' Theme optimized for publication in academic journals
#'
#' @param base_size Base font size (default: 11)
#' @return A ggplot2 theme object
#' @export
get_publication_theme <- function(base_size = 11) {
  ggplot2::theme_classic(base_size = base_size) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(
        size = base_size * 1.2,
        face = "bold"
      ),
      axis.title = ggplot2::element_text(
        size = base_size,
        face = "bold"
      ),
      axis.text = ggplot2::element_text(size = base_size * 0.9),
      legend.title = ggplot2::element_text(
        size = base_size,
        face = "bold"
      ),
      legend.text = ggplot2::element_text(size = base_size * 0.9),
      strip.background = ggplot2::element_blank(),
      strip.text = ggplot2::element_text(
        size = base_size,
        face = "bold"
      )
    )
}

#' Get Colorblind-Friendly Palette
#'
#' Returns a palette that is accessible to colorblind individuals
#'
#' @param n Number of colors needed
#' @param type Type of palette: "qualitative", "sequential", "diverging"
#' @return A character vector of hex color codes
#' @export
get_colorblind_palette <- function(n, type = "qualitative") {
  if (type == "qualitative") {
    # Okabe-Ito palette (colorblind safe)
    palette <- c(
      "#E69F00", # Orange
      "#56B4E9", # Sky blue
      "#009E73", # Bluish green
      "#F0E442", # Yellow
      "#0072B2", # Blue
      "#D55E00", # Vermillion
      "#CC79A7", # Reddish purple
      "#999999" # Gray
    )

    if (n > length(palette)) {
      warning(sprintf(
        "Requested %d colors but palette only has %d. Recycling colors.",
        n, length(palette)
      ))
      return(rep_len(palette, n))
    }

    return(palette[1:n])
  } else if (type == "sequential") {
    # Use viridis palette (colorblind safe)
    if (requireNamespace("viridis", quietly = TRUE)) {
      return(viridis::viridis(n))
    } else {
      warning("viridis package not available, using default sequential palette")
      return(grDevices::colorRampPalette(c("#440154", "#FDE724"))(n))
    }
  } else if (type == "diverging") {
    # Colorblind-safe diverging palette
    return(grDevices::colorRampPalette(
      c("#0072B2", "#FFFFFF", "#D55E00")
    )(n))
  }
}

#' Apply consistent formatting to plots
#'
#' Helper function to apply common formatting rules
#'
#' @param plot A ggplot object
#' @param title Plot title (optional)
#' @param subtitle Plot subtitle (optional)
#' @param x_lab X-axis label (optional)
#' @param y_lab Y-axis label (optional)
#' @return A ggplot object with formatting applied
#' @export
apply_plot_formatting <- function(plot, title = NULL, subtitle = NULL,
                                  x_lab = NULL, y_lab = NULL) {
  if (!is.null(title)) {
    plot <- plot + ggplot2::labs(title = title)
  }

  if (!is.null(subtitle)) {
    plot <- plot + ggplot2::labs(subtitle = subtitle)
  }

  if (!is.null(x_lab)) {
    plot <- plot + ggplot2::labs(x = x_lab)
  }

  if (!is.null(y_lab)) {
    plot <- plot + ggplot2::labs(y = y_lab)
  }

  plot <- plot + get_default_theme()

  return(plot)
}

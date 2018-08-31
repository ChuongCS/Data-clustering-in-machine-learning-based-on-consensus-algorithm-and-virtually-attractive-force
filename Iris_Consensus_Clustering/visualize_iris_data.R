rm(list = ls())

ir_df <- iris
names(ir_df) <- c( "sep len","sep wid","pet len", "pet len", "species")

pairs(ir_df[1:4], main = "Pair Scatter Plot of Iris Data", pch = 21, bg = c("blue","orange", "green")[unclass(ir_df$species)])
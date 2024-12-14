library(ggplot2)
library(reshape2)
library(dplyr)

x <- read.table("all.txt", header = F, sep = ',')
colnames(x) <- c("ligand", "protein", "domain", "residue", "val")
data <- na.omit(x)


data <- data %>%
  filter(
    (ligand == "APO+Effector" & protein %in% c("WT", "A97V", "S171L", "M188I", "R102Q", "T180I", "R71C", "E152A")) |
    (ligand == "Effector-bound" & protein %in% c("WT", "A97V", "S171L", "M188I", "R102Q", "T180I", "R71C", "E152A")) |
    (ligand == "Effector-free" & protein %in% c("WT", "A97V", "S171L", "M188I", "R102Q", "T180I", "R71C", "E152A")) |
    (ligand == "APO" & protein %in% c("WT", "A97V", "S171L", "M188I", "R102Q", "T180I", "R71C", "E152A"))
  )

attach(data)


ppi <- 300
png("all_filtered2.png", width = 32 * ppi, height = 22 * ppi, res = ppi)

data_diff <- data %>%
  group_by(protein, domain, residue) %>%
  arrange(protein, domain, residue) %>%
  mutate(diff_val = val - lag(val)) %>%
  filter(!is.na(diff_val))

data_diff_gt_0_40 <- data_diff %>%
  filter(abs(diff_val) > 1.1)


dfa <- c(75, 81)
dfxa <- data.frame(dfa)

dfb <- c(97, 171, 180, 188)
dfxb <- data.frame(dfb)

hp <- ggplot(data, aes(x = residue, y = val)) +
  geom_line(aes(colour = protein), linewidth = 2.5) +
  geom_vline(data = dfxa, aes(xintercept = dfa), linewidth = 0.6, linetype = "dashed") +
  geom_vline(data = dfxb, aes(xintercept = dfb), linewidth = 0.5, colour = "blue", linetype = "dotted") +
  ylab(expression(RMSF(ring(A)))) +
  xlab("Residue") +
  theme_bw() +
  theme(
    axis.text.x = element_text(size = 32),
    axis.text.y = element_text(size = 32),   
    panel.background = element_blank(),
    panel.border = element_rect(colour = "black", linewidth = 1.0, linetype = 1),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_blank(),
    axis.title = element_text(size = 35)
  ) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_colour_manual(
    values =  c("#0072B2", "#D55E00", "#009E73", "#F0E442", "#CC79A7", "#E69F00", "#56B4E9", "#000000")
,
    name = "protein",
    limits = c("A97V", "R102Q","S171L", "T180I", "M188I", "R71C", "E152A", "WT")
  ) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 7)) + 
  annotate("rect", xmin = 1, xmax = 75, ymin = 0, ymax = 0.2, fill = "magenta", linewidth = 1.2) +
  annotate("rect", xmin = 81, xmax = 229, ymin = 0, ymax = 0.2, fill = "orange", linewidth = 1.2)

data2 <- transform(
  data,
  domain = factor(
    domain,
    levels = c("ChainA", "ChainB"),
    labels = c("Chain A", "Chain B")
  ),
  protein = factor(protein, levels = c("A97V", "R102Q","S171L", "T180I", "M188I", "R71C", "E152A", "WT"))
)

hp2 <- (hp %+% data2) +
  facet_grid(ligand~domain, scales = 'free_y') +
  theme(
    strip.background = element_rect(fill = "lightblue", colour = "black"),
    strip.text.y = element_text(face = "bold", size = 42, margin = margin(b = 20)),
    strip.text.x = element_text(face = "bold", size = 42)
  )


print(hp2)


warnings()

dev.off()

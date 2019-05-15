library(fs)
library(stringr)
moviemaker <- function(img_dir){
  # img_dir <- "/nfs/khondula-data/planetmethane/jr-viz-stills/"
  
  # rename images as image-xx.png and move to folder
  nums_lp2 <- str_pad(1:length(dir_ls(img_dir)), 3, pad = "0")
  imgs_to_rename <- dir_ls(img_dir)
  stills_dir <- file.path(img_dir, "stills")
  if(!fs::dir_exists(stills_dir)){
    fs::dir_create(stills_dir)}
  new_paths <- file.path(stills_dir, paste0("image-", nums_lp2, ".png"))
  fs::file_move(imgs_to_rename, new_paths)
  
  # repeat the same frame for 10 frames
  # for each file, make 9 copies
  imgs_for_mov <- dir_ls(stills_dir) %>% basename() %>% tools::file_path_sans_ext()
  new_paths_list <- lapply(imgs_for_mov,
                           function(x) file.path(stills_dir, paste0(x, letters[2:10], ".png"))) %>% unlist()
  copy_input_list <- lapply(dir_ls(stills_dir), function(x) rep(x, 9)) %>% unlist()
  file_copy(copy_input_list, new_paths_list)
  
  # rename all as numbers
  nums_lp3 <- str_pad(1:length(dir_ls(stills_dir)), 4, pad = "0")
  
  imgs_to_rename <- dir_ls(stills_dir)
  new_paths <- file.path(stills_dir, paste0("image-", nums_lp3, ".png"))
  fs::file_move(imgs_to_rename, new_paths)
  
  # imager::make.video(dname = img_dir, pattern = "image-%03d.png",
  #                    fname = paste0("movies/", img_dir, ".mpeg"),
  #                    fps = 20, verbose = TRUE)
  
  
  ffmpegcommand <- paste0('ffmpeg -r 20 -s 1920x1080 -i ', img_dir, '/stills/image-%04d.png -vcodec libx264 -crf 25  -pix_fmt yuv420p ', img_dir, '/', basename(img_dir), '.mp4')
  system(ffmpegcommand)
  
}

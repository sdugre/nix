{ 
  pkgs,
  lib,
  ffmpeg,
  writeShellApplication,
  ...
}:

(writeShellApplication {
  name = "rotate-video";
  runtimeInputs = [ ffmpeg ];
  text = 
    /*
    bash
    */
    ''

      # Check if an input file is provided
      if [ $# -eq 0 ]; then
          echo "Usage: $0 <input_file>"
          exit 1
      fi
  
      input_file="$1"
  
      # Check if the input file exists
      if [[ ! -f "$input_file" ]]; then
          echo "Error: File '$input_file' not found!"
          exit 1
      fi
  
      # Generate the output file name
      filename=$(basename -- "$input_file")
      extension="''${filename##*.}"
      filename="''${filename%.*}"
      output_file="''${filename}r.''${extension}"
  
      # Prompt the user for rotation direction
      echo "Choose the rotation direction:"
      echo "1: Rotate 90° clockwise"
      echo "2: Rotate 90° counterclockwise"
      echo "3: Rotate 180°"
      read -r -p "Enter your choice (1/2/3): " rotation_choice
  
      # Set the transpose value based on user input
      case $rotation_choice in
          1)
              transpose_value=1
              ;;
          2)
              transpose_value=2
              ;;
          3)
              transpose_value=3
              ;;
          *)
              echo "Invalid choice. Please run the script again and choose 1, 2, or 3."
              exit 1
              ;;
      esac
  
      # Run FFmpeg command to rotate the video and preserve metadata
      ffmpeg -i "$input_file" -movflags use_metadata_tags -map_metadata 0 -vf "transpose=$transpose_value" "$output_file"

      echo "Video successfully rotated and saved as '$output_file'."
    '';
})
// {
  meta = with lib; {
    licenses = licenses.mit;
    platforms = platforms.all;
  };
}

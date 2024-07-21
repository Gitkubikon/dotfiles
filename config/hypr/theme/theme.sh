#!/usr/bin/env bash

## Theme ------------------------------------
DIR="$HOME/.config/hypr"

## Directories ------------------------------
PATH_ALAC="$DIR/alacritty"
PATH_FOOT="$DIR/foot"
PATH_MAKO="$DIR/mako"
PATH_ROFI="$DIR/rofi"
PATH_WAYB="$DIR/waybar"
PATH_WLOG="$DIR/wlogout"
PATH_WOFI="$DIR/wofi"

## Source Theme File ------------------------
CURRENT_THEME="$DIR/theme/current.bash"
DEFAULT_THEME="$DIR/theme/default.bash"
PYWAL_THEME="$HOME/.cache/wal/colors.sh"

## Check if current file exist
if [[ ! -e "$CURRENT_THEME" ]]; then
	touch "$CURRENT_THEME"
fi

## Default Theme
source_default() {
	cat ${DEFAULT_THEME} > ${CURRENT_THEME}
	source ${CURRENT_THEME}
	altbackground="`pastel color $background | pastel lighten 0.10 | pastel format hex`"
	altforeground="`pastel color $foreground | pastel darken 0.30 | pastel format hex`"
	modbackground=(`pastel gradient -n 3 $background $altbackground | pastel format hex`)
	accent="$color4"
	notify-send -h string:x-canonical-private-synchronous:sys-notify-dtheme -u normal -i ${PATH_MAKO}/icons/palette.png "Applying Default Theme..."
}

generate_all_wallpaper_schemes() {
    # Set your wallpaper directory here.
    WALLDIR="`xdg-user-dir PICTURES`/wallpapers"

    # Check for wallpapers
    check_wallpaper() {
        if [[ -d "$WALLDIR" ]]; then
            WFILES="`ls --format=single-column $WALLDIR | wc -l`"
            if [[ "$WFILES" == 0 ]]; then
                notify-send -h string:x-canonical-private-synchronous:sys-notify-noimg -u low -i ${PATH_MAKO}/icons/picture.png "There are no wallpapers in : $WALLDIR"
                exit
            fi
        else
            mkdir -p "$WALLDIR"
            notify-send -h string:x-canonical-private-synchronous:sys-notify-noimg -u low -i ${PATH_MAKO}/icons/picture.png "Put some wallpapers in : $WALLDIR"
            exit
        fi
    }

    # Run `pywal` to generate colors for all wallpapers
    generate_colors_all() {
        check_wallpaper
        if [[ `which wal` ]]; then
            for wallpaper in "$WALLDIR"/*; do
                notify-send -t 50000 -h string:x-canonical-private-synchronous:sys-notify-runpywal -i ${PATH_MAKO}/icons/timer.png "Generating Colorscheme for $wallpaper. Please wait..."
                wal -q -n -s -t -e -i "$wallpaper"
                if [[ "$?" != 0 ]]; then
                    notify-send -h string:x-canonical-private-synchronous:sys-notify-runpywal -u normal -i ${PATH_MAKO}/icons/palette.png "Failed to generate colorscheme for $wallpaper."
                    exit
                fi
                mv ~/.cache/wal/colors.sh ~/.cache/wal/schemes/$(basename "$wallpaper")_colors.sh
            done
        else
            notify-send -h string:x-canonical-private-synchronous:sys-notify-runpywal -u normal -i ${PATH_MAKO}/icons/palette.png "'pywal' is not installed."
            exit
        fi
    }

    generate_colors_all
}

## Random Theme
source_pywal() {
	# Set you wallpaper directory here.
	WALLDIR="`xdg-user-dir PICTURES`/wallpapers"

	# Check for wallpapers
	check_wallpaper() {
		if [[ -d "$WALLDIR" ]]; then
			WFILES="`ls --format=single-column $WALLDIR | wc -l`"
			if [[ "$WFILES" == 0 ]]; then
				notify-send -h string:x-canonical-private-synchronous:sys-notify-noimg -u low -i ${PATH_MAKO}/icons/picture.png "There are no wallpapers in : $WALLDIR"
				exit
			fi
		else
			mkdir -p "$WALLDIR"
			notify-send -h string:x-canonical-private-synchronous:sys-notify-noimg -u low -i ${PATH_MAKO}/icons/picture.png "Put some wallpapers in : $WALLDIR"
			exit
		fi
	}

	# Run `pywal` to generate colors
	generate_colors() {	
		check_wallpaper
		if [[ `which wal` ]]; then
			notify-send -t 50000 -h string:x-canonical-private-synchronous:sys-notify-runpywal -i ${PATH_MAKO}/icons/timer.png "Generating Colorscheme. Please wait..."
			wal -q -n -s -t -e -i "$WALLDIR"
			if [[ "$?" != 0 ]]; then
				notify-send -h string:x-canonical-private-synchronous:sys-notify-runpywal -u normal -i ${PATH_MAKO}/icons/palette.png "Failed to generate colorscheme."
				exit
			fi
		else
			notify-send -h string:x-canonical-private-synchronous:sys-notify-runpywal -u normal -i ${PATH_MAKO}/icons/palette.png "'pywal' is not installed."
			exit
		fi
	}

	generate_colors
	cat ${PYWAL_THEME} > ${CURRENT_THEME}
	source ${CURRENT_THEME}

  cp ${CURRENT_THEME} ~/.local/custom-web-startup/
	
  altbackground="`pastel color $background | pastel lighten 0.10 | pastel format hex`"
	altforeground="`pastel color $foreground | pastel darken 0.30 | pastel format hex`"
	modbackground=(`pastel gradient -n 3 $background $altbackground | pastel format hex`)
	accent="$color4"
}

## Wallpaper ---------------------------------
apply_wallpaper() {
	sed -i -e "s#WALLPAPER=.*#WALLPAPER='$wallpaper'#g" ${DIR}/scripts/wallpaper
	bash ${DIR}/scripts/wallpaper &
}

## GTK ---------------------------------------

apply_gtk_theme() {
    # Define the local theme directory
    LOCAL_THEME_DIR="$HOME/.local/share/themes/Adapta/gtk-3.0"
    mkdir -p "$LOCAL_THEME_DIR"

    # Define the path to the local gtk.css file
    GTK_FILE="$LOCAL_THEME_DIR/gtk.css"

    # Copy the original gtk.css from the system theme to the local theme directory
    echo "Copying original gtk.css..."
    cp /usr/share/themes/Adapta/gtk-3.0/gtk.css "$GTK_FILE"

    # Debugging: Check if the copy was successful
    if [ -f "$GTK_FILE" ]; then
        echo "gtk.css successfully copied to $GTK_FILE"
    else
        echo "Failed to copy gtk.css to $GTK_FILE"
        return 1 # Exit the function with an error
    fi

    # Link the original Adapta gresource file to the local theme directory
    echo "Linking gresource file..."
    ln -sf /usr/share/themes/Adapta/gtk-3.0/gtk.gresource "$LOCAL_THEME_DIR"

    # Debugging: Verify the symlink
    if [ -L "$LOCAL_THEME_DIR/gtk.gresource" ]; then
        echo "gresource file successfully linked"
    else
        echo "Failed to link gresource file"
        return 1 # Exit the function with an error
    fi

    # Add custom CSS to the gtk.css, placing custom styles before the import statement
    echo "Adding custom CSS..."
    echo "EMailSidebar.view { font-size: 5px; }" > "$GTK_FILE.tmp"
    echo '@import url("resource:///org/adapta-project/gtk-3.20/gtk-contained.css");' >> "$GTK_FILE.tmp"
    cat "$GTK_FILE.tmp" > "$GTK_FILE"
    rm "$GTK_FILE.tmp"

    # Debugging: Check if custom CSS was added
    grep "EMailSidebar.view" "$GTK_FILE" > /dev/null
    if [ $? -eq 0 ]; then
        echo "Custom CSS successfully added to gtk.css"
    else
        echo "Failed to add custom CSS to gtk.css"
        return 1 # Exit the function with an error
    fi

    # Set the local theme as the current theme
    echo "Setting the local theme..."
    gsettings set org.gnome.desktop.interface gtk-theme "Adapta"
    echo "Theme set to Adapta"
}

# Function to apply icon theme using gsettings
apply_icon_theme() {
    local current_icon_theme=$(gsettings get org.gnome.desktop.interface icon-theme)
    echo "Current Icon Theme: $current_icon_theme"
    
    # Check if the desired icon theme is already set
    if [ "$current_icon_theme" != "'Colorful-Dark-Icons'" ]; then
        echo "Applying new icon theme: Colorful-Dark-Icons"
        gsettings set org.gnome.desktop.interface icon-theme 'Colorful-Dark-Icons'
    else
        echo "Icon theme 'Colorful-Dark-Icons' is already set."
    fi
}

## Zathura -----------------------------------
apply_zathura() {
    local zathura_config="$HOME/.config/zathura/catppuccin-mocha"

    # Ensure the Zathura config directory exists
    mkdir -p "$(dirname "$zathura_config")"

    # Write new settings to the Zathura configuration file
    cat > "$zathura_config" <<- _EOF_
set default-fg                "${foreground}"
set default-bg                "${background}"

set completion-bg             "${color2}"
set completion-fg             "${foreground}"
set completion-highlight-bg   "${color1}"
set completion-highlight-fg   "${foreground}"
set completion-group-bg       "${color0}"
set completion-group-fg       "${color4}"

set statusbar-fg              "${foreground}"
set statusbar-bg              "${color2}"

set notification-bg           "${color0}"
set notification-fg           "${foreground}"
set notification-error-bg     "${color1}"
set notification-error-fg     "${color9}"
set notification-warning-bg   "${color3}"
set notification-warning-fg   "${color11}"

set inputbar-fg               "${foreground}"
set inputbar-bg               "${color2}"

set recolor-lightcolor        "${background}"
set recolor-darkcolor         "${foreground}"

set index-fg                  "${foreground}"
set index-bg                  "${background}"
set index-active-fg           "${foreground}"
set index-active-bg           "${color2}"

set render-loading-bg         "${background}"
set render-loading-fg         "${foreground}"

set highlight-color           "${color4}"
set highlight-fg              "${color5}"
set highlight-active-color    "${color6}"

set recolor true
_EOF_
}

## Alacritty ---------------------------------
apply_alacritty() {
	# alacritty : colors in TOML format
	cat > ${PATH_ALAC}/colors.toml <<- _EOF_
		# Colors configuration

		[colors]

		# Default colors
		[colors.primary]
		background = '${background}'
		foreground = '${foreground}'

		# Normal colors
		[colors.normal]
		black = '${color0}'
		red = '${color1}'
		green = '${color2}'
		yellow = '${color3}'
		blue = '${color4}'
		magenta = '${color5}'
		cyan = '${color6}'
		white = '${color7}'

		# Bright colors
		[colors.bright]
		black = '${color8}'
		red = '${color9}'
		green = '${color10}'
		yellow = '${color11}'
		blue = '${color12}'
		magenta = '${color13}'
		cyan = '${color14}'
		white = '${color15}'
	_EOF_
}


## Foot --------------------------------------
apply_foot() {
	# foot : colors
	cat > ${PATH_FOOT}/colors.ini <<- _EOF_
		## Colors configuration
		[colors]
		alpha=1.0
		foreground=${foreground:1}
		background=${background:1}

		## Normal/regular colors (color palette 0-7)
		regular0=${color0:1}  # black
		regular1=${color1:1}  # red
		regular2=${color2:1}  # green
		regular3=${color3:1}  # yellow
		regular4=${color4:1}  # blue
		regular5=${color5:1}  # magenta
		regular6=${color6:1}  # cyan
		regular7=${color7:1}  # white

		## Bright colors (color palette 8-15)
		bright0=${color8:1}   # bright black
		bright1=${color9:1}   # bright red
		bright2=${color10:1}   # bright green
		bright3=${color11:1}   # bright yellow
		bright4=${color12:1}   # bright blue
		bright5=${color13:1}   # bright magenta
		bright6=${color14:1}   # bright cyan
		bright7=${color15:1}   # bright white
	_EOF_
}

## Mako --------------------------------------
apply_mako() {
	# mako : config
	sed -i '/# Mako_Colors/Q' ${PATH_MAKO}/config
	cat >> ${PATH_MAKO}/config <<- _EOF_
		# Mako_Colors
		background-color=${background}
		text-color=${foreground}
		border-color=${modbackground[1]}
		progress-color=over ${accent}

		[urgency=low]
		border-color=${modbackground[1]}
		default-timeout=2000

		[urgency=normal]
		border-color=${modbackground[1]}
		default-timeout=5000

		[urgency=high]
		border-color=${color1}
		text-color=${color1}
		default-timeout=0
	_EOF_

	pkill mako && bash ${DIR}/scripts/notifications &
}

## Rofi --------------------------------------
apply_rofi() {
	# rofi : colors
	cat > ${PATH_ROFI}/shared/colors.rasi <<- EOF
		* {
		    background:     ${background};
		    background-alt: ${modbackground[1]};
		    foreground:     ${foreground};
		    selected:       ${accent};
		    active:         ${color2};
		    urgent:         ${color1};
		}
	EOF
}

## Waybar ------------------------------------
apply_waybar() {
	# waybar : colors
	cat > ${PATH_WAYB}/colors.css <<- EOF
		/** ********** Colors ********** **/
		@define-color background      ${background};
		@define-color background-alt1 ${modbackground[1]};
		@define-color background-alt2 ${modbackground[2]};
		@define-color foreground      ${foreground};
		@define-color selected        ${accent};
		@define-color black           ${color0};
		@define-color red             ${color1};
		@define-color green           ${color2};
		@define-color yellow          ${color3};
		@define-color blue            ${color4};
		@define-color magenta         ${color5};
		@define-color cyan            ${color6};
		@define-color white           ${color7};
	EOF

	pkill waybar && bash ${DIR}/scripts/statusbar &
}

## Wlogout -----------------------------------
apply_wlogout() {
	# wlogout : colors
	cat > ${PATH_WLOG}/colors.css <<- EOF
		/** ********** Colors ********** **/
		@define-color background      ${background};
		@define-color background-alt1 ${modbackground[1]};
		@define-color background-alt2 ${modbackground[2]};
		@define-color foreground      ${foreground};
		@define-color selected        ${accent};
		@define-color black           ${color0};
		@define-color red             ${color1};
		@define-color green           ${color2};
		@define-color yellow          ${color3};
		@define-color blue            ${color4};
		@define-color magenta         ${color5};
		@define-color cyan            ${color6};
		@define-color white           ${color7};
	EOF
}

## Wofi --------------------------------------
apply_wofi() {
	# wofi : colors	
	sed -i ${PATH_WOFI}/style.css \
		-e "s/@define-color background .*/@define-color background      ${background};/g" \
		-e "s/@define-color background-alt1 .*/@define-color background-alt1 ${modbackground[1]};/g" \
		-e "s/@define-color background-alt2 .*/@define-color background-alt2 ${modbackground[2]};/g" \
		-e "s/@define-color foreground .*/@define-color foreground      ${foreground};/g" \
		-e "s/@define-color selected .*/@define-color selected        ${accent};/g" \
		-e "s/@define-color black .*/@define-color black           ${color0};/g" \
		-e "s/@define-color red .*/@define-color red             ${color1};/g" \
		-e "s/@define-color green .*/@define-color green           ${color2};/g" \
		-e "s/@define-color yellow .*/@define-color yellow          ${color3};/g" \
		-e "s/@define-color blue .*/@define-color blue            ${color4};/g" \
		-e "s/@define-color magenta .*/@define-color magenta         ${color5};/g" \
		-e "s/@define-color cyan .*/@define-color cyan            ${color6};/g" \
		-e "s/@define-color white .*/@define-color white           ${color7};/g"
}

## Hyprland --------------------------------------
apply_hypr() {
	# hyprland : theme
	sed -i ${DIR}/hyprtheme.conf \
		-e "s/\$active_border_col_1 =.*/\$active_border_col_1 = 0xFF${accent:1}/g" \
		-e "s/\$active_border_col_2 =.*/\$active_border_col_2 = 0xFF${color1:1}/g" \
		-e "s/\$inactive_border_col_1 =.*/\$inactive_border_col_1 = 0xFF${modbackground[1]:1}/g" \
		-e "s/\$inactive_border_col_2 =.*/\$inactive_border_col_2 = 0xFF${modbackground[2]:1}/g" \
		-e "s/\$group_border_col =.*/\$group_border_col = 0xFF${color1:1}/g" \
		-e "s/\$group_border_active_col =.*/\$group_border_active_col = 0xFF${color2:1}/g"
}

apply_css_theme() {
    # Define the path to the style.css file
    CSS_FILE="$HOME/.local/custom-web-startup/src/css/style.css"

    # Define the colors you want to use in the CSS file
    BACKGROUND_COLOR="$background"
    ACCENT_COLOR="$color4"

    # Use sed to replace the values in the CSS file
    sed -i -e "s/--accent: .*/--accent: $ACCENT_COLOR;/g" "$CSS_FILE"
    sed -i -e "s/--bg: .*/--bg: $BACKGROUND_COLOR;/g" "$CSS_FILE"
}

apply_js_theme() {
    # Define the path to the JavaScript file
    JS_FILE="$HOME/.local/custom-web-startup/src/components/tabs/tabs.component.js"

    # Define the color you want to use in the JavaScript file
    BACKGROUND_COLOR=${modbackground[1]}

    # Use sed to replace the value in the JavaScript file
    sed -i -e "s/background_color = .*/background_color = \"$BACKGROUND_COLOR\"/g" "$JS_FILE"
}

apply_js_theme_todo() {
    # Define the path to the JavaScript file
    JS_FILE_TODO="$HOME/.local/custom-web-startup/src/components/todo/todo.component.js"

    # Define the colors you want to use in the JavaScript file

    DONE_COLOR="${color5}"                            # color13 corresponds to magenta in the pywal colorscheme
    TODO_COLOR="${color4}"                             # color9 corresponds to red in the pywal colorscheme
    BG_COLOR="${modbackground[1]}"                     # Background color
    TASK_OPTIONS_TODO_BG_COLOR="${color4}"   # First gradient color for task options todo background
    TASK_OPTIONS_DONE_BG_COLOR="${color5}"   # Second gradient color for task options done background
    HEADER_TITLE_COLOR="${color7}"                     # color7 corresponds to white in the pywal colorscheme
    TASK_ACTIONS_COLOR="${foreground}"                 # Foreground color
    COUNTER_COLOR="${color7}"                          # color7 corresponds to white in the pywal colorscheme
    CLEAN_TASKS_COLOR="${color5}"                      # color5 corresponds to blue in the pywal colorscheme
    ADD_TASK_COLOR="${color4}"                         # color4 corresponds to yellow in the pywal colorscheme

    # Use sed to replace the values in the JavaScript file
    sed -i -e "/:host {/,/:host }/ s/--done: .*/--done: $DONE_COLOR;/" "$JS_FILE_TODO"
    sed -i -e "/:host {/,/:host }/ s/--todo: .*/--todo: $TODO_COLOR;/" "$JS_FILE_TODO"
    sed -i -e "/:host {/,/:host }/ s/--bg: .*/--bg: $BG_COLOR;/" "$JS_FILE_TODO"
    # sed -i -e "/\.clean-tasks {/,/.clean-tasks }/ s/background: .*/background: $CLEAN_TASKS_COLOR;/" "$JS_FILE_TODO"
    # sed -i -e "/\.add-task {/,/.add-task }/ s/background: .*/background: $ADD_TASK_COLOR;/" "$JS_FILE_TODO"
    sed -i -e "/--task-options-done-background: .*/ s/--task-options-done-background: .*/--task-options-done-background: $TASK_OPTIONS_DONE_BG_COLOR;/" "$JS_FILE_TODO"
    sed -i -e "/--task-options-todo-background: .*/ s/--task-options-todo-background: .*/--task-options-todo-background: $TASK_OPTIONS_TODO_BG_COLOR;/" "$JS_FILE_TODO"

   sed -i -e "/.add-task /,/}/ s/--bg: .*/--bg: $BG_COLOR;/g" "$JS_FILE_TODO"
    sed -i -e "/.clean-tasks /,/}/ s/--bg: .*/--bg: $BG_COLOR;/g" "$JS_FILE_TODO"
    sed -i -e "/.add-task /,/}/ s/background: .*/background: $ADD_TASK_COLOR;/g" "$JS_FILE_TODO"
    sed -i -e "/.clean-tasks /,/}/ s/background: .*/background: $CLEAN_TASKS_COLOR;/g" "$JS_FILE_TODO"
    sed -i -e "/.add-task /,/}/ s/box-shadow: .*/box-shadow: 0 0 0 1px #27272a, 0 5px 5px rgb(0 0 0 \/ 20%);/g" "$JS_FILE_TODO"
    sed -i -e "/.clean-tasks /,/}/ s/box-shadow: .*/box-shadow: 0 0 0 1px #c975a0, 0 5px 5px rgb(0 0 0 \/ 20%);/g" "$JS_FILE_TODO"
    sed -i -e "/.add-task /,/}/ s/--task-options-done-background: .*/--task-options-done-background: $TASK_OPTIONS_DONE_BG_COLOR;/g" "$JS_FILE_TODO"
    sed -i -e "/.clean-tasks /,/}/ s/--task-options-todo-background: .*/--task-options-todo-background: $TASK_OPTIONS_TODO_BG_COLOR;/g" "$JS_FILE_TODO"

    # sed -i -e "s/--done: .*/--done: $DONE_COLOR;/g" \
    #        -e "s/--todo: .*/--todo: $TODO_COLOR;/g" \
    #        -e "s/--bg: .*/--bg: $BG_COLOR;/g" \
    #        # -e "s/--task-options-done-background: .*/--task-options-done-background: $TASK_OPTIONS_DONE_BG_COLOR;/g" \
    #        # -e "s/--task-options-todo-background: .*/--task-options-todo-background: $TASK_OPTIONS_TODO_BG_COLOR;/g" \
    #        # -e "s/color: .*/color: $HEADER_TITLE_COLOR;/g" \
    #        # -e "s/color: .*/color: $TASK_ACTIONS_COLOR;/g" \
    #        # -e "s/color: .*/color: $COUNTER_COLOR;/g" \
    #        # -e "s/background: .*/background: $CLEAN_TASKS_COLOR;/g" \
    #        # -e "s/background: .*/background: $ADD_TASK_COLOR;/g" \
    #        "$JS_FILE_TODO"
}

# Source Theme Accordingly
if [[ "$1" == '--default' ]]; then
    source_default
elif [[ "$1" == '--pywal' ]]; then
    source_pywal
elif [[ "$1" == '--gall' ]]; then
    generate_all_wallpaper_schemes
else
    echo "Available Options: --default --pywal --gall"
    exit 1
fi

## Execute Script ---------------------------
apply_wallpaper
apply_alacritty
apply_foot
apply_mako
apply_rofi
apply_waybar
apply_wlogout
apply_wofi
apply_hypr
apply_css_theme
apply_js_theme
apply_js_theme_todo
apply_zathura
# apply_gtk_theme
# apply_icon_theme

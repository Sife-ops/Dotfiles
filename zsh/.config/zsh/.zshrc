#              _              
#      _______| |__  _ __ ___ 
#     |_  / __| '_ \| '__/ __|
#    _ / /\__ \ | | | | | (__ 
#   (_)___|___/_| |_|_|  \___|
                          
# source plugins
for file in $(find ${ZDOTDIR}/conf.d/*)
do
    source $file
done


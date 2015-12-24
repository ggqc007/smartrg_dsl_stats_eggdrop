#####################################################
# This TCL script is compatible with eggdrop 1.x    #
#                                                   #
# It extract the usefull information about a DSL    #
# link from the smartrg modem web page and post it  #
# to a IRC channel.                                 #
#                                                   #
# GG - 20151222                                     #
#####################################################

# SmartRG IP
set smartrghost "http://172.20.0.25/"

# Define IRC trigger
set trigger "% !dsl"

# HTML Stats Frame - SHOULD NOT BE CHANGED
set htmlstatsframe "landingpage.fwd"


#
# END OF CONFIG
#


bind pubm - $trigger pubm:pull_stats

proc pubm:pull_stats {nick host handle chan text} {
    global smartrghost htmlstatsframe
    catch {exec lynx -dump -nolist ${smartrghost}${htmlstatsframe} | sed -n -e {/DSL Statistics/, $p} | sed {/Type/d} | sed {/Link/d} | sed {/^$/d}} result
    
    foreach line [split $result "\n"] {
        putserv "PRIVMSG $chan $line"
    }
}


# Show script loaded to bot logs
putlog "SmartRG DSL Stats v0.1 Loaded!"


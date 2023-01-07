<#
.DESCRIPTION
  Naming system, enter tags, you get name, compy paste, leave.
.NOTES
  Need TagMap.csv in same directory.
  Entertainment purposes only.
.VERSION
  1.0  - AC - 12/18/2022 - Compress file completed.
  1.1  - AC - 12/28/2022 - Update process to match NameGen.ps1 processes and formats.
  
#>

Write-Output 'Yeh, use me to find material, just remember to have the mapping csv file in same directory.'

for($true) {
    $del = read-host 'if you want to delete existing output zip file, enter name here (default is output.zip):'
    if($del -like '*.zip') {
        $delPath = '.\' + $del
    } else {
        $delPath = '.\output.zip'
    }
    
    if(test-path $delPath) {
        remove-item $delPath
        write-output 'zip file detected and deleted'
        break
    } else {
        write-output 'zip file not detected, continuing...'
        break
    }
}

#Start load csv map
$pathToMap = '.\TagMap.csv'

if(test-path $pathToMap) {
    write-output 'Tag map detected, continuing variable initiation...'
    $MapCSV = import-csv $pathToMap
    
    write-output 'CSV loaded... Loading maps...'

    #Maps
    $originMap = @{}
    $positionMap = @{}
    $hairMap = @{}
    $tagMap = @{}
    $reverseTagMap = @{}

    #Populate maps
    foreach($row in $MapCSV) {
        if($row.ID -ne 0) {
            if($row.Section -eq 'Origin') {
                $originMap.add($row.Name,$row.Format)
            }
            if($row.Section -eq 'Position') {
                $positionMap.add($row.Name,$row.Format)
            }
            if($row.Section -eq 'Hair') {
                $hairMap.add($row.Name,$row.Format)
            }
            if($row.Section -eq 'Tags') {
                $tagMap.add($row.Name.ToLower(),$row.Format)
                $reverseTagMap.add($row.Format,$row.Name)
            }
        }
    }
        
    write-output 'Maps loaded...'
} else {
    read-host 'Tag map not detected, press any key to exit procedure...'
    EXIT
}

#End load csv map

#----------------------------------#

#Start entry file path define and validation

$filepath = $PSScriptRoot
for($true) {
    $P_filepath = $filepath
    $temp = $P_filepath
    $P_filepath = read-host 'enter filepath, default is' $PSScriptRoot

    if($P_filepath.length -gt 0) {
        $temp = $P_filepath
    }

    if (test-path -path $temp) {
        $filepath = $P_filepath
        write-output 'file path validated...'
        
        #output retrieval
        
        $outputPath = read-host 'enter designated zip directory, default is .\output'
        if($outputPath.length -eq 0) {
            $outputPath = '.\output'
        }

        break
    } 
    else {
        write-output 'invalid path, put in a valid path'
        continue
    }
}

#End entry file path define and validation

#----------------------------------#

#Start function definition

function mapNameToCode([Hashtable]$table, [String]$Name, [String]$Section) {
    if($table.ContainsKey($Name.ToLower())) {
        write-host "$Section detected in map..."
        return $table[$Name.ToLower()]
    } else {
        write-host "$Section not detected in map, please try again"
        return ''
    }
}

#End function definition

#----------------------------------#

write-output 'default enter to search all (e.g. if u just want someone with cleavage and white hair, enter for origin, enter for character, enter for position, white for hair, cleavage for tag done)'
while($true) {   
    #Filtering origin
    while($true) {
        $origin = read-host 'Enter origin:'
        
        if($origin -eq '') {
            $origin = '*'
        } else {
            $origin = mapNameToCode $originMap $origin 'Origin'
            if($origin -eq '') {
                $lever = read-host 'Check origins? y to check, enter any other key to skip'
                if($lever -eq 'y') {
                    write-output $originMap
                    read-host 'Enter to continue'
                }
                continue
            }

            $origin += '*'
        }
        $itemsOrigin = Get-ChildItem $filepath -filter $origin -Recurse | where-object length -gt 0
        write-output ("There are "+$itemsOrigin.count+" search result(s)")

        #Set local items
        $items = $itemsOrigin
        break
    }

    #Filtering character
    while($true) {
        $character = read-host 'Enter character:'

        if($character -eq '') {
            #if wild card, then just pass the items variable onto next section
            break
        }

        $character = '*1*'+$character+'*2*'
        $tempItems = $items | where-object Name -like $character

        $lever = read-host ("There are "+$tempItems.count+" search result(s). Press back to backtrack process. Any key to continue.")
        if($lever -eq 'back') {
            continue
        }
        $items = $tempItems
        break
    }

    #Filtering position
    while($true) {
        $position = read-host 'Enter position:'
        
        #verify position entry with map csv
        if($position -eq '') {
            #if wild card, then just pass the items variable onto next section
            break
        } else {
            $position = mapNameToCode $positionMap $position 'Position'
            if($position -eq '') {
                $lever = read-host 'Invalid position. Enter y to check positions, enter any other key to skip'
                if($lever -eq 'y') {
                    write-output $positionMap
                    read-host 'Enter to continue'
                }
                continue
            }
        }

        $position = '*2'+$position+'*'
        $tempItems = $items | where-object Name -like $position

        $lever = read-host ("There are "+$tempItems.count+" search result(s). Press back to backtrack process. Any key to continue.")
        if($lever -eq 'back') {
            continue
        }
        $items = $tempItems
        break
    }

    #Filtering hair color
    while($true) {
        $hair = read-host 'Enter hair color:'
        
        #verify hair color entry with map csv
        if($hair -eq '') {
            #if wild card, then just pass the items variable onto next section
            break
        } else {
            $hair = mapNameToCode $hairMap $hair 'Hair Color'
            if($hair -eq '') {
                $lever = read-host 'Invalid color. Enter y to check colors, enter any other key to skip'
                if($lever -eq 'y') {
                    write-output $hairMap
                    read-host 'Enter to continue'
                }
                continue
            }
        }

        $hair = '*3'+$hair+'*'
        $tempItems = $items | where-object Name -like $hair

        $lever = read-host ("There are "+$tempItems.count+" search result(s). Press back to backtrack process. Any key to continue.")
        if($lever -eq 'back') {
            continue
        }
        $items = $tempItems
        break
    }

    #filtering tags (oh boy is this fun)
    [System.Collections.ArrayList]$addedTags = @()
    $tagItems = $items
    while($true) {

        #Tag addition
        while($true) {
            $tag = read-host 'Enter tag or exit to terminate process:'
            
            if($tag -eq 'exit') {
                break
            }
            #verify tag entry with map csv
            if($tag -eq '') {
                if($includedTags.count -eq 0) {
                    #wild card not allowed for tags
                    write-output 'Enter at least one tag'
                    continue
                }            
            } else {
                $tag = mapNameToCode $tagMap $tag 'Tag'
                if($tag -eq '') {
                    $lever = read-host 'Invalid tag. Enter y to check tags, enter any other key to skip'
                    if($lever -eq 'y') {
                        write-output $tagMap
                        read-host 'Enter to continue'
                    }
                    continue
                } else {
                    $tagOG = $tag
                }
            }

            $tag = '*4*'+$tag+'*'
            $tempItems = $tagItems | where-object Name -like $tag

            $lever = read-host ("There are "+$tempItems.count+" search result(s). Press back to backtrack process. Any key to continue.")
            if($tempItems.count -eq 0) {
                write-output 'no items detected, backtracking...'
                continue
            }
            if($lever -eq 'back') {
                continue
            } else {
                $tagItems = $tempItems
                if(-not $addedTags.Contains($reverseTagMap[$tagOG])) {
                    $addedTags += $reverseTagMap[$tagOG]
                }
                write-output 'Current tags: ' ($addedTags -join ',')
            }
        }
            
        for($true) {
            $lever = read-host "Press r to save current files and refresh tags (Note, refresh does not support safety of files), exit to generate zip folder."
            if($lever -ne 'r' -and $lever -ne 'exit') {
                continue
            }
            break
        }

        if($lever -eq 'r') {
            Compress-Archive -path $tagItems.FullName -DestinationPath $outputPath -update
            $addedTags = @()
            $tagItems = $items
            continue
        }
        if($lever -eq 'exit') {
            $items = $tagItems
            break
        }
    }

    $nsfw = read-host 'nsfw? enter y to turn on, anything else to ignore'
    if($nsfw -eq 'y') { 
        $Tempitems = $items | where-object Name -like '*-S'
        if($tempitems.count -eq 0) {
            write-output 'No safe items detected, automatically continuing zipping process...'
        } else {
            $lever = read-host ("There are "+$tempItems.count+" search result(s). Press back to backtrack process. Any key to continue.")
            if($lever -ne 'back') {
                $items = $tempItems
            }
        }
    }

    Compress-Archive -path $items.FullName -DestinationPath $outputPath -update

    #End filtering

    $lever = read-host 'Enter exit to leave, anything else to continue searching...'
    if($lever -eq 'exit') {
        exit
    }
    continue
}

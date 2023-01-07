<#
.DESCRIPTION
  Naming system, enter tags, you get name, compy paste, leave.
.NOTES
  Need TagMap.csv in same directory.
  Entertainment purposes only.
.VERSION
  1.0  - AC - 12/22/2022 - Basic structure completed, help operations not stabalized.
  1.1  - AC - 12/22/2022 - Added quality of life exits onto tag additions and removal.
  1.2  - AC - 12/24/2022 - Added remove tag feature, refresh csv feature, refined tag display
  1.21 - AC - 12/26/2022 - Adjusted exit and remove tag function.
#>

#Startup section

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
    
    #ID map
    $idMap = @()

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
                $reverseTagMap.add($row.Format.ToLower(),$row.Name)
                $idMap += $row.Format
            }
        }
    }
        
    write-output 'Maps loaded...'
} else {
    read-host 'Tag map not detected, press any key to exit procedure...'
    EXIT
}


$begin = read-host 'Enter something for help, otherwise enter nothing to start generating name.'
if($begin.length -gt 0) {
    write-output "This script is made specifically to generate names via inputing tags so you don't need to painfully search through the tags and their order."
    write-output "Anyways, enter 1 to show full list of tags with description, 2 to show section descriptions, 3... no 3 right now"
    write-output "Enter o to show origins, p to show positions, h to show hair colors, t to show tags."
    write-output "Enter nothing to continue generate name."
    while($true) {
        $begin = read-host 'Your response?'
        if($begin -eq '1') {
            write-output $MapCsv | where-object ID -gt 0 | sort-object ID | select-object Name, Description, Format
        }
        if($begin -eq '2') {
            write-output $MapCsv | where-object ID -eq 0 | select-object Section, Description
        }
        if($begin -eq 'p') {
            write-output $MapCsv | where-object Section -eq 'Position' | select-object Name, Description, Format
        }
        if($begin -eq 'o') {
            write-output $MapCsv | where-object Section -eq 'Origin' | select-object Name, Description, Format
        }
        if($begin -eq 'o') {
            write-output $MapCsv | where-object Section -eq 'Hair' | select-object Name, Description, Format
        }
        if($begin -eq 'o') {
            write-output $MapCsv | where-object Section -eq 'Tags' | select-object Name, Description, Format
        }
        if($begin.Length -eq 0) {
            break
        }
    }
}

#End of startup

#----------------------------------#

#Function definition
function search-term {
    param(
        [Parameter(Mandatory = $true)]
        [String]$term,
        [Parameter(Mandatory = $false)]
        [int]$range = 0.7
    )
}
function edit-distance-similarity([String]$term,[String]$compared) {
    
    if($term.Length -eq 0) {
        #if string is empty return 0
        return 0
    }

    if($term -eq $compared) {
        return 1
    }

    if($term.Length -lt $comapred.Length) {
        return edit-distance-similarity($compared,$term)
    }


    return 0
}
#change the color to whatever you want
function color {
    process { write-host $_ -ForegroundColor Green}
}
#End of function definition

#----------------------------------#

#Start of generation
while($true) {

    #loop for origin
    while($true) {
        $origin = read-host "Origin:"
        if($origin.Length -eq 2) {
            if($originMap.ContainsValue($origin.toupper())) {
                write-output 'origin recgonized on map'
                break
            } else {
                write-output 'origin code not recgonized on map, please retry.'
                $lever = read-host 'Check origins? y to check, enter any other key to skip'
                if($lever -eq 'y') {
                    write-output $originMap
                    read-host
                }
            }
        }
        if($origin.Length -gt 2) {
            if($originMap.ContainsKey(($origin))) {
                write-output 'origin recgonized on map'
                $origin = $originMap[$origin]
                break
            } else {
                write-output 'origin not recgonized on map, please retry.'
                $lever = read-host 'Check origins? y to check, enter any other key to skip'
                if($lever -eq 'y') {
                    write-output $originMap
                    read-host
                }
            }
        }
    }
    
    #-----------------------------#

    $character = read-host "Character:"

    #-----------------------------#

    #loop for position
    while($true) {

        $position = read-host "Position:"
        if($position.Length -lt 3) {
            if($positionMap.ContainsValue($position.ToUpper())) {
                write-output 'position recgonized on map'
                break
            } else {
                write-output 'position code not recgonized on map, please retry.'
                $lever = read-host 'Check positions? y to check, enter any other key to skip'
                if($lever -eq 'y') {
                    write-output $positionMap
                    read-host
                }
                continue
            }
        }
        if($position.Length -gt 2) {
            if($positionMap.ContainsKey(($position))) {
                write-output 'position recgonized on map'
                $position = $positionMap[$position]
                break
            } else {
                write-output 'position not recgonized on map, please retry.'
                $lever = read-host 'Check positions? y to check, enter any other key to skip'
                if($lever -eq 'y') {
                    write-output $positionMap
                    read-host
                }
            }
        }
    }

    #-----------------------------#

    #loop for hair
    while($true) {
        $hair = read-host "Hair Color:"
        if($hair.Length -eq 2) {
            if($hairMap.ContainsValue($hair.ToUpper())) {
                write-output 'Color recgonized on map'
                break
            } else {
                write-output 'Color code not recgonized on map, please retry.'
                $lever = read-host 'Check colors? y to check, enter any other key to skip'
                if($lever -eq 'y') {
                    write-output $hairMap
                    read-host
                }
            }
        }
        if($hair.Length -gt 2) {
            if($hairMap.ContainsKey(($hair))) {
                write-output 'Color recgonized on map'
                $hair = $hairMap[$hair]
                break
            } else {
                write-output 'Color not recgonized on map, please retry.'
                $lever = read-host 'Check color? y to check, enter any other key to skip'
                if($lever -eq 'y') {
                    write-output $hairMap
                    read-host
                }
            }
        }
    }
    
    #-----------------------------#

    #loop for tag
    [System.Collections.ArrayList]$tags
    [System.Collections.ArrayList]$includedTags = @()
    $includedTags.Add(":")

    #Start for add tag
    while($true) {

        #if user wants to enter 1+ tags and not get asked whehter user wants to exit after every tag, turn to true to disable.
        #loop for one tag
        while($true) {
            $tempTag = read-host "Tag(s), or press exit to leave:"
            #if tag is in code form
            if($tempTag.Length -eq 2) {
                if($tagMap.ContainsValue($tempTag.ToUpper())) {
                    
                    #if tag already incldued reset
                    if($includedTags.contains($reverseTagMap[$tempTag])) {
                        write-output 'tag already included!'
                        break
                    }
                    $includedTags += $reverseTagMap[$tempTag]
                    write-output 'tag recgonized on map'
                    $tags += $tempTag
                    break
                } else {
                    write-output 'tag code not recgonized on map, please retry.'
                    write-output 'If you just added the tag, enter refresh to load csv again.'
                    $lever = read-host 'Check tags? y to check, enter any other key to skip'
                    if($lever -eq 'y') {
                        write-output $tagmap
                        read-host
                    }
                    if($lever -eq 'refresh') {
                        write-output 'Tag map detected, continuing variable initiation...'
                        $MapCSV = import-csv $pathToMap
                        
                        write-output 'CSV loaded... Loading maps...'

                        $tagMap = @{}
                        $reverseTagMap = @{}
                        $idMap = @()
                        foreach($row in $MapCSV) {
                            if($row.Section -eq 'Tags') {
                                $tagMap.add($row.Name,$row.Format)
                                $reverseTagMap.add($row.Format,$row.Name)
                                $idMap += $row.Format
                            }
                        }
                        write-output 'Tag map refreshed'
                    }
                }
            }
            #if tag is longer than 2 characters
            if($tempTag.Length -gt 2) {
                #if option is exit
                if($tempTag -eq 'exit') {
                    $tempFinal = @()
                    foreach($row in $idMap) {
                        if($tags.contains($row)) {
                            $tempFinal += $row
                        }
                    }
                    $tags = $tempFinal
                    break
                }
                #if tag is in list
                if($tagMap.ContainsKey(($tempTag))) {
                    #if tag already incldued reset
                    if($includedTags.contains($tempTag)) {
                        write-output 'tag already included!'
                        break
                    }
                    $includedTags += $tempTag
                    write-output 'tag recgonized on map'
                    $tempTag = $tagMap[$tempTag]
                    $tags += $tempTag
                    break
                } else {
                    #if tag is not in list start
                    write-output 'tag not recgonized on map, please retry.'
                    write-output 'If you just added the tag, enter refresh to load csv again.'
                    $lever = read-host 'Check tags? y to check, enter any other key to skip'
                    if($lever -eq 'y') {
                        write-output $tagMap
                        read-host
                    }
                    if($lever -eq 'refresh') {
                        write-output 'Tag map detected, continuing variable initiation...'
                        $MapCSV = import-csv $pathToMap
                        
                        write-output 'CSV loaded... Loading maps...'

                        $tagMap = @{}
                        $reverseTagMap = @{}
                        $idMap = @()
                        foreach($row in $MapCSV) {
                            if($row.Section -eq 'Tags') {
                                $tagMap.add($row.Name,$row.Format)
                                $reverseTagMap.add($row.Format,$row.Name)
                                $idMap += $row.Format
                            }
                        }
                        write-output 'Tag map refreshed'
                    }
                    #end of if tag not in list
                }
            }
        }
        write-output 'current tags: ' ($includedTags -join '- ')
        if($tempTag -eq 'exit') {break}
    }
    #End adding tags

    #-----------------------------#

    #Start removing tags
    $lever = read-host 'Enter r to remove tags, or enter any other key to finish'
    if($lever -eq 'r') {
        while($true) {
            $removingTag = read-host "enter tag to remove"
            #tag is in coded form
            if($tags.Contains($removingTag)) {
                [System.Collections.ArrayList]$tempTagList = @()
                [System.Collections.ArrayList]$tempIncludedTagList = @()
                $tempTag = $reverseTagMap[$removingTag]
                foreach($tag in $tags) {
                    if($tag -ne $removingTag) {
                        $tempTagList.add($tag)
                    }
                }
                foreach($tag in $includedTags) {
                    if($tag -ne $temptag) {
                        $tempIncludedTagList.add($tag)
                    }
                }
                $tags = $tempTagList
                $includedTags = $tempIncludedTagList
                Remove-Variable tempTagList
                Remove-Variable tempIncludedTagList
                Remove-Variable tempTag
                Write-Output 'tag removed'
            }
            #tag is in name form
            if($includedTags.contains($removingTag)) {
                [System.Collections.ArrayList]$tempTagList = @()
                [System.Collections.ArrayList]$tempIncludedTagList = @()
                
                foreach($tag in $includedTags) {
                    if($tag -ne $removingTag) {
                        $tempIncludedTagList.add($tag)
                    }
                    $tempTagList += $tagMap[$tag]
                }
                $tags = $tempTagList
                $includedTags = $tempIncludedTagList
                Remove-Variable tempTagList
                Remove-Variable tempIncludedTagList
                Remove-Variable tempTag
                Write-output 'tag removed'
            } else {
                write-output 'tag not found'
            }
            #write-output $tagMap
            $lever = read-host 'press enter to continue removing tags... anything else to leave'
            if($lever.length -gt 0) {break} else {continue}
        }
    }
    #End removing tags.
    
    #End of tag string
    #-----------------------------#

    $safe = read-host "Enter y if safe, anything else if not:"
    if($safe -eq 'y') {$safe = '-S'} else {$safe = ''}
    
    $finalName = $origin + '1' + $character + '2' + $position + '3' + $hair + '4'
    foreach($temp in $includedTags) {
        if($temp -ne ':') {
            $pop = $tagMap[$temp.toLower()]
            $finalName += $pop.toLower()
        }
    }
    $finalName += $safe
    write-output $finalName | color
    $lever = read-host "enter exit to exit, anything else to continue making fileNames"
    if($lever -eq 'exit') {exit} else {
        Remove-Variable tags
        Remove-Variable tempFinal
        Remove-Variable includedTags
        continue
    }
}
#End of generation
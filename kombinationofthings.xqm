module namespace kk = 'http://www.w3.org/2005/07/kk';
import module namespace scx='http://www.w3.org/2005/07/scxml/extension/';
import module namespace functx = 'http://www.functx.com';
import module namespace mba='http://www.dke.jku.at/MBA'; 
import module namespace sc = 'http://www.w3.org/2005/07/scxml';
import module namespace sync = 'http://www.dke.jku.at/MBA/Synchronization';


declare updating function kk:startProcess($dbName,$collectionName,$mbaName)
{
  
 let $mba   := mba:getMBA($dbName, $collectionName, $mbaName)
  let $scxml := mba:getSCXML($mba)
 
 return mba:init($mba)
};



declare function kk:getNewMultilevelBusinessArtifacts($dbName, $collectionName)
{
  

let $document := db:open($dbName, 'collections.xml')
let $collectionEntry := $document/mba:collections/mba:collection[@name = $collectionName]

for $entry in $collectionEntry/mba:new/mba:mba
  return mba:getMBA($dbName, $collectionName, $entry/@ref)
};


declare updating function kk:initMBA($dbName,$collectionName,$mbaName as xs:string)
{
  
  let $mba := mba:getMBA($dbName, $collectionName, $mbaName)
 let $scxml :=  mba:getSCXML($mba)
  return  mba:init($mba),kk:initSCXML($dbName,$collectionName,$mbaName), kk:removeFromUpdateLog($dbName,$collectionName,$mbaName)

};


declare updating function kk:initSCXML($dbName,$collectionName,$mbaName as xs:string)
{
  
  

let $mba   := mba:getMBA($dbName, $collectionName, $mbaName)
let $scxml := mba:getSCXML($mba)
let $configuration := mba:getConfiguration($mba)
return
  if (not ($configuration)) then 
    mba:addCurrentStates($mba, sc:getInitialStates($scxml))
  else ()
};

declare function kk:getupdatedMBAS($dbName, $collectionName)
{
  let $document := db:open($dbName, 'collections.xml')
let $collectionEntry := $document/mba:collections/mba:collection[@name = $collectionName]

for $entry in $collectionEntry/mba:updated/mba:mba
  return mba:getMBA($dbName, $collectionName, $entry/@ref)

};


declare updating function kk:removeFromInsertLog($dbName, $collectionName, $mbaName)
{
let $mba := mba:getMBA($dbName, $collectionName, $mbaName)
return mba:removeFromInsertLog($mba)
};

declare updating function kk:getNextExternalEvent($dbName,$collectionName,$mbaName)
{
let $mba := mba:getMBA($dbName, $collectionName, $mbaName)
return mba:loadNextExternalEvent($mba)
};

declare function kk:getExecutableContents($dbName, $collectionName, $mbaName)
{

let $mba   := mba:getMBA($dbName, $collectionName, $mbaName)
let $scxml := mba:getSCXML($mba)

let $currentEvent := mba:getCurrentEvent($mba)
let $eventName    := $currentEvent/name

let $configuration := mba:getConfiguration($mba)
let $dataModels := sc:selectDataModels($configuration)

let $transitions := 
  if($eventName) then
    sc:selectTransitions($configuration, $dataModels, $eventName)
  else ()
  
let $contents :=
  for $t in $transitions
    return $t/*

return $contents
};

declare updating function kk:runExecutableContent($dbName, $collectionName, $mbaName , $content)
{


let $mba   := mba:getMBA($dbName, $collectionName, $mbaName)
let $scxml := mba:getSCXML($mba)

let $configuration := mba:getConfiguration($mba)
let $dataModels := sc:selectDataModels($configuration)

return 
  typeswitch($content)
    case element(sc:assign) return 
      sc:assign($dataModels, $content/@location, $content/@expr, $content/@type, $content/@attr, $content/*)
    case element(sync:assignAncestor) return
      sync:assignAncestor($mba, $content/@location, $content/@expr, $content/@type, $content/@attr, $content/*, $content/@level)
    case element(sync:sendAncestor) return 
      sync:sendAncestor($mba, $content/@event, $content/@level, $content/sc:param, $content/sc:content)
    case element(sync:assignDescendants) return
      sync:assignDescendants($mba, $content/@location, $content/@expr, $content/@type, $content/@attr, $content/*, $content/@level, $content/@inState, $content/@satisfying)
    case element(sync:sendDescendants) return 
      sync:sendDescendants($mba, $content/@event, $content/@level, $content/@inState, $content/@satisfying, $content/sc:param, $content/sc:content)
    case element(sync:newDescendant) return 
      sync:newDescendant($mba, $content/@name, $content/@level, $content/@parents, $content/*)
    default return ()
};

declare updating function kk:changeCurrentStatus($dbName, $collectionName, $mbaName)
{


let $mba   := mba:getMBA($dbName, $collectionName, $mbaName)
let $scxml := mba:getSCXML($mba)

let $currentEvent := mba:getCurrentEvent($mba)
let $eventName    := $currentEvent/name

let $configuration := mba:getConfiguration($mba)

let $dataModels := sc:selectDataModels($configuration)

let $transitions := 
  if($eventName) then
    sc:selectTransitions($configuration, $dataModels, $eventName)
  else ()

let $exitSet  := sc:computeExitSet($configuration, $transitions)
let $entrySet := sc:computeEntrySet($transitions)

return (
  mba:removeCurrentStates($mba, $exitSet),
  mba:addCurrentStates($mba, $entrySet)
)

};

declare updating function kk:removeCurrentExternalEvent($dbName, $collectionName, $mbaName)
{
 

let $mba := mba:getMBA($dbName, $collectionName, $mbaName)

return mba:removeCurrentEvent($mba)

};

(: getExecutableContentsEventless runExecutableContent changeCurrentStatusEventless :)
declare updating function kk:processEventlessTransitions($dbName, $collectionName, $mbaName)
{
  let $executableContents := kk:getExecutableContentsEventless($dbName, $collectionName, $mbaName)
  for $content in $executableContents
  return kk:runExecutableContent($dbName, $collectionName, $mbaName, $content),kk:changeCurrentStatusEventless($dbName, $collectionName, $mbaName)
};

declare function kk:getExecutableContentsEventless($dbName, $collectionName, $mbaName)
{
let $mba   := mba:getMBA($dbName, $collectionName, $mbaName)
let $scxml := mba:getSCXML($mba)

let $configuration := mba:getConfiguration($mba)
let $dataModels := sc:selectDataModels($configuration)

let $transitions := 
  sc:selectEventlessTransitions($configuration, $dataModels)

let $contents :=
  for $t in $transitions
    return $t/*

return $contents
};

declare updating function kk:changeCurrentStatusEventless($dbName, $collectionName, $mbaName)
{
  let $mba   := mba:getMBA($dbName, $collectionName, $mbaName)
let $scxml := mba:getSCXML($mba)

let $configuration := mba:getConfiguration($mba)

let $dataModels := sc:selectDataModels($configuration)

let $transitions := 
  sc:selectEventlessTransitions($configuration, $dataModels)

let $exitSet  := sc:computeExitSet($configuration, $transitions)
let $entrySet := sc:computeEntrySet($transitions)

return (
  mba:removeCurrentStates($mba, $exitSet),
  mba:addCurrentStates($mba, $entrySet)
)
};

declare updating function kk:getandExecuteExecutablecontent($dbName, $collectionName, $mbaName)
{
  for $content in kk:getExecutableContents($dbName, $collectionName, $mbaName)
  return kk:runExecutableContent($dbName, $collectionName, $mbaName, $content)
};

declare updating function kk:macrostep($dbName, $collectionName, $mbaName)
{
  
  kk:removeFromInsertLog($dbName, $collectionName, $mbaName), kk:getNextExternalEvent($dbName, $collectionName, $mbaName), kk:getandExecuteExecutablecontent($dbName, $collectionName, $mbaName), kk:changeCurrentStatus($dbName, $collectionName, $mbaName), kk:removeCurrentExternalEvent($dbName, $collectionName, $mbaName), kk:processEventlessTransitions($dbName, $collectionName, $mbaName)
};


declare updating function kk:removeFromUpdateLog($dbName, $collectionName, $mbaName)
{
  
  let $mba := mba:getMBA($dbName, $collectionName, $mbaName)
return mba:removeFromUpdateLog($mba)
};

declare updating function kk:tostep($database, $collections)
{
  let $updatedmbas := kk:getupdatedMBAS($database,$collections)
  for $name in $updatedmbas/@name
  return kk:macrostep($database, $collections, $name)
};

(:

let $database := "myMBAse",
$collections := "JohannesKeplerUniversity",
$mbas := kk:getNewMultilevelBusinessArtifacts($database,$collections)
for $name in $mbas/@name
return kk:initMBA($database,$collections,$name)

let $updatedmbas := kk:getupdatedMBAS($database,$collections)
return $updatedmbas 
return kk:tostep($database, $collections):)

module namespace page = 'http://basex.org/kk/web-page';

import module namespace kk = 'http://www.w3.org/2005/07/kk';
import module namespace scx='http://www.w3.org/2005/07/scxml/extension/';
import module namespace functx = 'http://www.functx.com';
import module namespace mba='http://www.dke.jku.at/MBA'; 
import module namespace sc = 'http://www.w3.org/2005/07/scxml';
import module namespace sync = 'http://www.dke.jku.at/MBA/Synchronization';




declare
  %rest:path("/foradding")
  %output:method("xhtml")
  %output:omit-xml-declaration("no")
  %output:doctype-public("-//W3C//DTD XHTML 1.0 Transitional//EN")
  %output:doctype-system("http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd")
  function page:start()
  as element(Q{http://www.w3.org/1999/xhtml}html)
{
  <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
      <title>Event Adding Service</title>
      <link rel="stylesheet" type="text/css" href="static/style.css"/>
    </head>
    <body>
      <div class="right"><img src="static/basex.svg" width="96"/></div>
      <h2>Event Adding Service</h2>
			<div>Welcome to the Event Adding Service, which allow you to add Events to the Event Queue</div>


declare variable $dbName := 'myMBAse';
declare variable $collectionName := 'JohannesKeplerUniversity';
declare variable $mbaName := 'InformationSystems';


      <h3>Adding Event 2</h3>
      <p>This allows one to add Prepared and own events to Event Queue</p>
      <form method="post" action="addEvent">
        <p>Your dbName:<br />
        <input name="dbName" size="50"></input> <br />
                Your collectionName:<br />
        <input name="collectionName" size="50"></input> <br />
               Your mbaName:<br />
        <input name="mbaName" size="50"></input> <br />
        
        <h4> EventType </h4>
          <fieldset>
    <input type="radio" name="event" value="setDegree"/> setDegree<br/>
    <input type="radio" name="event" value="addSchool"/>addSchool  <br/>
    <input type="radio" name="event" value="addDegree"/>addDegree<br/>
    <input type="radio" name="event" value="removeDegree"/>removeDegree <br/>
    <input type="radio" name="event" value="addCourse"/>addCourse  <br/>
    
    <input type="radio" name="event" value="removeDegree"/>removeDegree<br/>
<input type="radio" name="event" value=""/>Other​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​

<h4> Input </h4>
<input type="text" name="addText" />
  </fieldset>

  
        <input type="submit" /></p>
        
        
      </form>
    </body>
  </html>
};



declare
  %rest:path("/modify")
  %output:method("xhtml")
  %output:omit-xml-declaration("no")
  %output:doctype-public("-//W3C//DTD XHTML 1.0 Transitional//EN")
  %output:doctype-system("http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd")
  function page:modify()
  as element(Q{http://www.w3.org/1999/xhtml}html)
{
  <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
      <title>Event Adding Service</title>
      <link rel="stylesheet" type="text/css" href="static/style.css"/>
    </head>
    <body>
      <div class="right"><img src="static/basex.svg" width="96"/></div>
      <h2>Event Adding Service</h2>
			<div>Welcome to the Modify Service, which allows you to add Certain Events for Transitions</div>


      <h3>Adding Event 2</h3>
      <p>This allows one to add Prepared and own events to Event Queue</p>
      <form method="post" action="index">
        <p>Your dbName:<br />
        <input name="dbName" size="50"></input> <br />
                Your collectionName:<br />
        <input name="collectionName" size="50"></input> <br />
               Your mbaName:<br />
        <input name="mbaName" size="50"></input> <br />
       
  
        <input type="submit" /></p>
        
        
      </form>
    </body>
  </html>
};


declare
  %rest:path("/index")
    %rest:POST
  %rest:form-param("dbName","{$dbName}", "(no dbName)")
%rest:form-param("collectionName","{$collectionName}", "(no collectionName)")
%rest:form-param("mbaName","{$mbaName}", "(no mbaName)")
 function page:hello-index(
    $dbName, $collectionName, $mbaName)
    as node()*
{
  
  
let $mba   := mba:getMBA($dbName, $collectionName, $mbaName)
let $scxml := mba:getSCXML($mba)
let $configuration := mba:getConfiguration($mba)
let $dataModels := sc:selectDataModels($configuration)
let $events :=

<auswahl>
{
  
 for $event in $configuration/sc:transition/@event
return 
<event>{$event/data()}</event>
}
</auswahl>


let $target := 'xml-stylesheet',
$content := 'href="../static/start.xsl" type="text/xsl" '

return document {
   processing-instruction {$target} {$content},

  <output>
  {($events,
 <hidden>
<dbName>{$dbName}</dbName>
<collectionName>{$collectionName}</collectionName>
<mbaName>{$mbaName}</mbaName>
</hidden>)}
</output> 
}

};


declare %rest:path("addEventWithName")
%rest:form-param("dbName","{$dbName}", "(no dbName)")
%rest:form-param("collectionName","{$collectionName}", "no collectionName")
%rest:form-param("mbaName","{$mbaName}", "no mbaName")
%rest:form-param("event","{$event}", "no event")
  %rest:POST
  function page:change(
    $event as xs:string, $dbName as xs:untypedAtomic*, $collectionName as xs:untypedAtomic*, $mbaName as xs:untypedAtomic*)
    as item()*
{

let $target := 'xml-stylesheet',
$content := 'href="../static/event.xsl" type="text/xsl" '



let $mba   := mba:getMBA($dbName, $collectionName, $mbaName)
let $scxml := mba:getSCXML($mba)

let $configuration := mba:getConfiguration($mba)
let $dataModels := sc:selectAllDataModels($mba)


return 

for $eventName in $event

let $transitions := 
  sc:selectTransitionsoC($configuration, $dataModels, $eventName)
let $exitSet := sc:computeExitSet2($configuration,$transitions)
let $entrymap :=sc:computeEntryOc($transitions)
let $historycontent :=  if (not (fn:empty($entrymap))) then 
 map:get($entrymap[1],'historyContent')
 else
 ()
let $entrySet := if (not (fn:empty($entrymap))) then 
 map:get($entrymap[1],'statesToEnter')
 else
 ()
 
 let $contentEntry := 
  for $state in $entrySet
  return  kk:getExecutableContentsEnter($dbName, $collectionName, $mbaName,$state,$historycontent)
 let $contentExit :=
  for $state in $exitSet
return kk:getExecutableContentsExit($dbName, $collectionName, $mbaName,$state)
 
let $value :=
(
$transitions/@cond, $transitions/*/@expr, $contentEntry/@expr, $contentExit/@expr)

let $dataToCheck :=  ($value[contains(.,'$_event')])
let $values := 
for $d in $dataToCheck
let $after :=(substring-after($d,'$_event/data/'))
let $before := <text>{functx:substring-before-match($after,('/|\s'))} </text>
return $before


let $data := 
for $d in fn:distinct-values($values)
return 
<data> {$d}</data>
return document {
   processing-instruction {$target} {$content},
 element
 {$event }
 {
   <input>
   {$data}
 <hidden>
<dbName>{$dbName}</dbName>
<collectionName>{$collectionName}</collectionName>
<mbaName>{$mbaName}</mbaName>
</hidden>
  </input>
 }
 
}


};




declare %rest:path("update")
  %rest:POST("{$data}")
updating function page:change($data)
   
{
 
  let $input :=
  <input>  
 { let $row :=  fn:tokenize($data,'&amp;')
 for $r in $row
 let $data := fn:tokenize( $r, '=')
 return element{$data[1]}{$data[2]}
}
 </input>
 
 
 let $dbName := $input/dbName/text()
 let $collectionName := $input/collectionName/text()
 let $mbaName := $input/mbaName/text()
  let $mba := mba:getMBA($dbName, $collectionName, $mbaName)
 let $max := fn:count($input/*)+1
let $ownEvent :=  if  ($input/*[1]/text()='eigenesEvent') then
fn:true()
else
fn:false()


 let $eventName := 
 
 if ( $ownEvent) then
 $input/*[5]
 else
 $input/*[1]
 
 
 let $eventData :=
 
  if ( $ownEvent) then
  $input/*[position()>5 and position()<=last()-2]
 else
  $input/*[position()>4 and position()<=last()-2]
  
  let $extraData := 
  let $name :=  $input/*[position()=(last()-1)]
  let $data := $input/*[position()=(last())]
  return
  if (not(fn:empty($name) and fn:empty($data))) then
  element{$name/data()}{$data/data()}
  else
  ()



return 

(mba:enqueueExternalEvent($mba, <event name='{$eventName}' >{ $eventData , $extraData,  <id>{mba:getCounter( $mba )}</id> }</event>),
kk:updateCounter($dbName,$collectionName,$mbaName),db:output(<response> 
  <result> added Eevent</result>
    <addText> {$eventName}</addText>
    <addText> {$extraData}</addText>
    <name> {$input/*[position()=last()-1]}</name>
    <input> {$input}</input>
  <counter> {mba:getCounter( mba:getMBA($dbName, $collectionName, $mbaName) )}</counter>
</response>))

};









declare
  %rest:path("/addEvent")
  %rest:POST
  %rest:form-param("message","{$message}", "(no message)")
    %rest:form-param("event","{$event}", "(no event)")
%rest:form-param("addText","{$addText}", "(no addText)")
%rest:form-param("dbName","{$dbName}", "(no dbName)")
%rest:form-param("collectionName","{$collectionName}", "(no collectionName)")
%rest:form-param("mbaName","{$mbaName}", "(no mbaName)")
  %rest:header-param("User-Agent", "{$agent}")
updating  function page:addEvent(
    $message as xs:string,
    $agent   as xs:string*, 
  $event, $addText, $dbName, $collectionName, $mbaName)
{
  
(:  let $addText := functx:trim($addText):)
  let $mba := mba:getMBA($dbName, $collectionName, $mbaName)


let $externalEvent := 
   
   switch($event)
  
   case "setDegree" 
         return 
         <event name="{$event}" xmlns="">
            <degree xmlns="">{$addText}</degree>
            <id>{mba:getCounter( $mba )}</id>
      </event>

    case "addSchool" 

      return
       <event name="{$event}" xmlns="">
          <name xmlns="">{$addText}</name>
          <id>{mba:getCounter( $mba )}</id>
        </event>
        
       case "addDegree"
             return
              <event name="{$event}" xmlns="">
          <text xmlns="">{$addText}</text>
          <id>{mba:getCounter( $mba )}</id>
        </event>
        case "removeDegree"
              return
       <event name="{$event}" xmlns="">
          <text xmlns="">{$addText}</text>
          <id>{mba:getCounter( $mba )}</id>
        </event>
         case "addCourse"
               return
       <event name="{$event}" xmlns="">
         <name xmlns="">{$addText}</name>
          <id>{mba:getCounter( $mba )}</id>
        </event>
       
   default
   


return 
   copy $c := fn:parse-xml-fragment(fn:replace($addText, '"', "'"))/*
   modify
   insert node <id>{mba:getCounter( $mba )}</id>  into $c
   return $c
   
      
  return mba:enqueueExternalEvent($mba, $externalEvent),kk:updateCounter($dbName,$collectionName,$mbaName),
db:output(<response> 
  <result> added Eevent</result>
    <addText> {$addText}</addText>
  <parse> {fn:replace($addText, '"', "'") }</parse>
  <counter> {mba:getCounter( mba:getMBA($dbName, $collectionName, $mbaName) )}</counter>
</response>)
   
   (: return  :)
  
};









declare
  %rest:path("/add/{$dbName}/{$collectionName}/{$mbaName}/{$value}")
  %rest:GET
  updating function page:addEventtoQueue(
    $dbName as xs:string, $collectionName as xs:string , $mbaName as xs:string, $value as xs:string)
{


let $externalEvent := <event name="setDegree" type="external" xmlns="">
<degree xmlns="">{$value}</degree>
<id>{mba:getCounter(mba:getMBA($dbName, $collectionName, $mbaName))}</id>
</event>
 
let $mba := mba:getMBA($dbName, $collectionName, $mbaName)

(: get Counter, update Counter and add Event to Eventqueue:)

return mba:enqueueExternalEvent($mba, $externalEvent),kk:updateCounter($dbName,$collectionName,$mbaName),
db:output(<response> 
  <result> added Eevent</result>
  <value> {$value}</value> 
  <counter> {mba:getCounter(mba:getMBA($dbName, $collectionName, $mbaName))}</counter>
</response>)


};



declare
  %rest:path("/addEvent/{$dbName}/{$collectionName}/{$mbaName}/{$event}")
  %rest:GET
  updating function page:addEvent(
    $dbName as xs:string, $collectionName as xs:string , $mbaName as xs:string, $event as xs:string)
{

 let $mba := mba:getMBA($dbName, $collectionName, $mbaName)
 let $externalEvent :=
   copy $c := fn:parse-xml-fragment(fn:replace($event, '"', "'"))/*
   modify
   insert node <id>{mba:getCounter( $mba )}</id>  into $c
   return $c
   
      
  return mba:enqueueExternalEvent($mba, $externalEvent),kk:updateCounter($dbName,$collectionName,$mbaName),
db:output(<response> 
  <result> added Eevent</result>
    <addText> {$event}</addText>
  <counter> {mba:getCounter( mba:getMBA($dbName, $collectionName, $mbaName) )}</counter>
</response>)


};



(:
this function returns a Result for an mba with an certain Id
:)
declare
  %rest:path("/getResult/{$dbName}/{$collectionName}/{$mbaName}/{$id}")
  %rest:GET
  function page:getResult(
    $dbName as xs:string, $collectionName as xs:string , $mbaName as xs:string, $id as xs:string)
{



kk:getResult($dbName, $collectionName, $mbaName, $id)


};



declare
  %rest:path("/initMBA/{$dbName}/{$collectionName}/{$mbaName}")
  %rest:GET
  updating function page:initMba(
    $dbName as xs:string, $collectionName as xs:string , $mbaName as xs:string)
{


(
 kk:initMBARest($dbName,$collectionName,$mbaName), kk:removeFromInsertLog($dbName, $collectionName, $mbaName),
 kk:markAsUpdated($dbName, $collectionName, $mbaName)
 
)


};


declare
  %rest:path("/initSCXML/{$dbName}/{$collectionName}/{$mbaName}/{$counter}")
  %rest:GET
  updating function page:initSCXML(
    $dbName as xs:string, $collectionName as xs:string , $mbaName as xs:string, $counter as xs:integer)
{

 let $mba   := mba:getMBA($dbName, $collectionName, $mbaName)
 return
if($counter = 0) then 

 
 (
  mba:createDatamodel($mba), kk:removeFromUpdateLog($dbName, $collectionName, $mbaName)

,
 db:output(<rest:forward>{fn:concat('/initSCXML/', string-join(($dbName,$collectionName,$mbaName,1), '/' ))}</rest:forward>))
 else

(


(: if not initialState enter First State  :)


  (kk:initSCXMLRest($dbName,$collectionName,$mbaName)
,

let $configuration := mba:getConfiguration($mba)
return
  if (not ($configuration)) then 
  
 db:output(<rest:forward>{fn:concat('/enterContents/', string-join(($dbName,$collectionName,$mbaName, 0, 1, 'init'), '/' ))}</rest:forward>)
else
( db:output(<rest:forward>{fn:concat('/controller/', string-join(($dbName,$collectionName,$mbaName,'external'), '/' ))}</rest:forward>))))



 
 
};

declare
  %rest:path("/startProcess/{$dbName}/{$collectionName}/{$mbaName}")
  %rest:GET
  updating function page:startProcess(
    $dbName as xs:string, $collectionName as xs:string , $mbaName as xs:string)
{

(: maybee some inital Things:)
(: move forward to Eventless Transitions :)

 kk:removeFromInsertLog($dbName, $collectionName, $mbaName),
  db:output(<rest:forward>{fn:concat('/internalTransitions/', string-join(($dbName,$collectionName,$mbaName), '/' ))}</rest:forward>)

};




declare
  %rest:path("/internalTransitions/{$dbName}/{$collectionName}/{$mbaName}")
  %rest:GET
  updating function page:internalTransitions(
    $dbName as xs:string, $collectionName as xs:string , $mbaName as xs:string)
{

let $mba   := mba:getMBA($dbName, $collectionName, $mbaName)
let $scxml := mba:getSCXML($mba)

let $configuration := mba:getConfiguration($mba)
let $dataModels := sc:selectAllDataModels($mba)

let $enabledTransitions := sc:selectEventlessTransitions($configuration,$dataModels)




return if (fn:empty($enabledTransitions)) then 

let $internalEvent := mba:getInternalEventQueue($mba)/*
return
if(fn:empty($internalEvent)) then

(
   kk:getNextExternalEvent($dbName, $collectionName, $mbaName),db:output(<rest:forward>{fn:concat('/doFinalizeandAutoforward/', string-join(($dbName,$collectionName,$mbaName,0,0), '/' ))}</rest:forward>)) 

 
else
(kk:getNextInternalEvent($dbName, $collectionName, $mbaName), db:output(<rest:forward>{fn:concat('/transitions/', string-join(($dbName,$collectionName,$mbaName,'0','internal'), '/' ))}</rest:forward>))
else
( (), db:output(<rest:forward>{fn:concat('/transitions/', string-join(($dbName,$collectionName,$mbaName,'0', 'eventless'), '/' ))}</rest:forward>))


};


declare
  %rest:path("/doFinalizeandAutoforward/{$dbName}/{$collectionName}/{$mbaName}/{$finalizeCounter}/{$stepCounter}")
  %rest:GET
  updating function page:doFinalizeandAutoforward(
    $dbName as xs:string, $collectionName as xs:string , $mbaName as xs:string, $finalizeCounter as xs:integer, $stepCounter as xs:integer)
{
  

let $mba   := mba:getMBA($dbName, $collectionName, $mbaName)
  let $configuration := mba:getConfiguration($mba)
  let $currentEvent := mba:getCurrentEvent($mba)
  let $dataModel :=  sc:selectAllDataModels($mba)

 
 return 
 (
   (if (
    $currentEvent/type = 'cancel')then 
     mba:updateRunning($mba , fn:false()) 
    else
    () )
   
   ,
    for $s in $configuration
    for $inv in $s/sc:invoke
   return
  (
     let $match := $s/@id || '.*'
     return
   ( 
         if (fn:matches($currentEvent/invokeid,$match)) then
 
 ( 
 let $content := $inv/sc:finalize/*
  for $c in $content
  return kk:runExecutableContent($dbName, $collectionName,$mbaName, $c))

  else
  ()),
  (
  if($inv/@autoforward = 'true') then
  
  ( 
  
  let $event := 
  
  if (fn:empty(sc:evalWithError('$_event/name/text()', $dataModel)) or fn:matches(fn:string(sc:evalWithError('$_event/name/text()', $dataModel)),'^err:')) then
  
  ()
  else
  (  
   let $name := sc:evalWithError('$_event/name/text()', $dataModel)
   let $type := sc:evalWithError('$_event/type/text()', $dataModel)
   let $sendid :=sc:evalWithError("$_event/type/text()'", $dataModel)
   let $origin := sc:evalWithError('$_event/origin/text()', $dataModel)
   let $origintype := sc:evalWithError('$_event/origintype/text()', $dataModel)
   let $invokeid := sc:evalWithError('$_event/invokeid/text()', $dataModel)
   let $data :=sc:evalWithError('$_event/data', $dataModel)
   return 

  
   <event name="{$name}" type="{$type}" sendid="{$sendid}" origin="{$origin}" origintype = "{$origintype}" invokeid ="{$invokeid}">{$data}</event>
   
)
return
if (fn:empty($event)) then 
()
else
(
   let $mbaData := mba:getChildInvokeQueue($mba)/*[@ref = $s/@id]/text()
   
    
  let $mbaData :=  
             if (fn:substring-before($mbaData, ':') = 'mba') then 
             
    
            fn:substring-after($mbaData,':')        
            else()  
            
     let $mbadata :=fn:tokenize($mbaData, ',')
  return if(fn:empty($mbadata)) then 
  
  ()
  else
   
  let $insertMba := 
  try 
  {
   mba:getMBA($mbadata[1],$mbadata[2],$mbadata[3])
  }
  catch *
  { 'err:special'}
  
  
  
   return 
   
   if((fn:matches($insertMba,'^err:'))) then
  ()
  else
  (mba:enqueueExternalEvent($insertMba, $event))))
   else())),
 

  
db:output(<rest:forward>{fn:concat('/transitions/', string-join(($dbName,$collectionName,$mbaName,0,'external'), '/' ))}</rest:forward>) )

 (:   
db:output(fn:concat('/transitions/', string-join(($dbName,$collectionName,$mbaName,0,'external'), '/' )))) 
  :)
};



declare
  %rest:path("/transitions/{$dbName}/{$collectionName}/{$mbaName}/{$counter}/{$transType}")
  %rest:GET
  updating function page:internalTransitions(
    $dbName as xs:string, $collectionName as xs:string , $mbaName as xs:string, $counter, $transType as xs:string)
{

let $mba   := mba:getMBA($dbName, $collectionName, $mbaName)
let $scxml := mba:getSCXML($mba)

let $configuration := mba:getConfiguration($mba)
let $dataModels := sc:selectAllDataModels($mba)

let $currentEvent := mba:getCurrentEvent($mba)

let $eventName    :=
$currentEvent/name

let $transitions := 
(
switch($transType)
case('external')
 return 
  sc:selectTransitions($configuration, $dataModels, $eventName)
case('internal')
return 
  sc:selectTransitions($configuration, $dataModels, $eventName)
case('eventless')
  return 
  sc:selectEventlessTransitions($configuration, $dataModels)
default
  return ()
)


let $insert :=

for $t in $transitions
let $s :=  sc:getSourceState($t)
return <transitions ref="{$s/@id}">
{$t}</transitions>



 
let $exitSet :=  sc:computeExitSet2($configuration,$transitions)





return 
(mba:updateCurrentExitSet($mba,$exitSet),mba:updatecurrentTransitions($mba,$insert)
 , db:output(<rest:forward>{fn:concat('/exitContents/', string-join(($dbName,$collectionName,$mbaName, 0, 1, $transType), '/' ))}</rest:forward>))


};



declare
  %rest:path("/exitContents/{$dbName}/{$collectionName}/{$mbaName}/{$counterContent}/{$counterExit}/{$transType}")
  %rest:GET
  updating function page:exitContents(
    $dbName as xs:string, $collectionName as xs:string , $mbaName as xs:string, $counterContent as xs:integer, $counterExit as xs:integer,  $transType as xs:string)
{
  
 
let $mba   := mba:getMBA($dbName, $collectionName, $mbaName)
let $scxml := mba:getSCXML($mba)

  
   let $transitions := 
 mba:getCurrentTransitionsQueue($mba)/transitions/*
 
 
 let $exitSet :=  reverse(mba:getCurrentExitSet($mba))
 
 let $state := $exitSet[$counterExit]
  
 let $content :=  kk:getExecutableContentsExit($dbName, $collectionName, $mbaName,$state)
 
 

 let $max := fn:count($content)

 return
 if (fn:empty($state)) then 
  
 db:output(<rest:forward>{fn:concat('/microstep/', string-join(($dbName,$collectionName,$mbaName,0, $transType), '/' ))}</rest:forward>) 

else

  
   if ($counterContent = 0 ) then 
   
(   mba:removeCurrentStates($mba, $state),mba:removestatesToInvoke($mba,$state), kk:exitStatesSingle($dbName,$collectionName,$mbaName,$state,$transType),
   db:output(<rest:forward>{fn:concat('/exitContents/', string-join(($dbName,$collectionName,$mbaName, $counterContent+1, $counterExit, $transType), '/' ))}</rest:forward>))
  
else if ($counterContent <= $max) then
  
  ( kk:executeExecutablecontent($dbName, $collectionName, $mbaName, $content, $counterContent),  db:output(<rest:forward>{fn:concat('/exitContents/', string-join(($dbName,$collectionName,$mbaName, $counterContent+1, $counterExit, $transType), '/' ))}</rest:forward>))
 
 
 else
 
 let $maxStates := fn:count($exitSet)
 return 
 if ($counterExit <= $maxStates) then 
  db:output(<rest:forward>{fn:concat('/exitContents/', string-join(($dbName,$collectionName,$mbaName,0, $counterExit +1 , $transType), '/' ))}</rest:forward>)
 else 
 db:output(<rest:forward>{fn:concat('/microstep/', string-join(($dbName,$collectionName,$mbaName,0, $transType), '/' ))}</rest:forward>) 

 


};




declare
  %rest:path("/microstep/{$dbName}/{$collectionName}/{$mbaName}/{$counter}/{$transType}")
  %rest:GET
  updating function page:microstep(
    $dbName as xs:string, $collectionName as xs:string , $mbaName as xs:string, $counter as xs:integer, $transType as xs:string)
{
  
 if (not($transType = 'exit')) then 
 (
let $mba   := mba:getMBA($dbName, $collectionName, $mbaName)
let $scxml := mba:getSCXML($mba)



let $content := 
   kk:getExecutableContentsTransitions($dbName, $collectionName, $mbaName)

  
  
let $max := fn:count($content)
let $counterneu := $counter + 1

(:EnterStates with Content or transitions.. to Check:)


return if ($counter = 0) then 
(
  (:kk:exitStates($dbName,$collectionName,$mbaName,$transType), :)
   db:output(<rest:forward>{fn:concat('/microstep/', string-join(($dbName,$collectionName,$mbaName,$counterneu,$transType), '/' ))}</rest:forward>)
)
else if ($counter <= $max) then
 (kk:executeExecutablecontent($dbName, $collectionName, $mbaName, $content, $counter),
   db:output(<rest:forward>{fn:concat('/microstep/', string-join(($dbName,$collectionName,$mbaName,$counterneu, $transType), '/' ))}</rest:forward>))
 else
 (: (kk:enterStates($dbName, $collectionName, $mbaName,$transType), :)
 
      let $transitions := 
 mba:getCurrentTransitionsQueue($mba)/transitions/*
 
let $entrySet := if (not (fn:empty(sc:computeEntry($transitions)))) then 
 map:get(sc:computeEntry($transitions)[1],'statesToEnter')
 else
 ()
 
 return
 
 ( mba:updatecurrentEntrySet($mba,$entrySet),  db:output(<rest:forward>{fn:concat('/enterContents/', string-join(($dbName,$collectionName,$mbaName, 0, 1, $transType), '/' ))}</rest:forward>))
 )
 else
 (
   db:output(<rest:forward>{fn:concat('/exitInterpreter/', string-join(($dbName,$collectionName,$mbaName,1), '/' ))}</rest:forward>))
   
};



declare
  %rest:path("/enterContents/{$dbName}/{$collectionName}/{$mbaName}/{$counterContent}/{$counterEntry}/{$transType}")
  %rest:GET
  updating function page:enterContents(
    $dbName as xs:string, $collectionName as xs:string , $mbaName as xs:string, $counterContent as xs:integer, $counterEntry as xs:integer,  $transType as xs:string)
{


let $mba   := mba:getMBA($dbName, $collectionName, $mbaName)
let $scxml := mba:getSCXML($mba)

 
   let $transitions := 
 mba:getCurrentTransitionsQueue($mba)/transitions/*
 
  
let $entrySet := mba:getCurrentEntrySet($mba)
let $historyContent :=  
if ($transType = 'init') then 
(
  try
  {
  map:get(sc:computeEntryInit($scxml)[$counterEntry],'historyContent')
  }
  
  catch *
  {
    ()
  }
  
)
else
(
  if (not (fn:empty(sc:computeEntry($transitions)))) then 
 map:get(sc:computeEntry($transitions)[1],'historyContent')
 else
 ()
)
  let $state := $entrySet[$counterEntry]
  
 let $content :=  kk:getExecutableContentsEnter($dbName, $collectionName, $mbaName,$state,$historyContent)
 let $max := fn:count($content)

 return
 if (fn:empty($state)) then 
  
  let $maxStates := fn:count($entrySet)
 return 
 if ($counterEntry < $maxStates) then 
 
  db:output(<rest:forward>{fn:concat('/enterContents/', string-join(($dbName,$collectionName,$mbaName,0, $counterEntry +1 , $transType), '/' ))}</rest:forward>)
 else 
 db:output(<rest:forward>{fn:concat('/controller/', string-join(($dbName,$collectionName,$mbaName, $transType), '/' ))}</rest:forward>) 

else

  
   if ($counterContent = 0 ) then 
   
(  kk:enterStatesSingle($dbName,$collectionName,$mbaName,$state),
   db:output(<rest:forward>{fn:concat('/enterContents/', string-join(($dbName,$collectionName,$mbaName, $counterContent+1, $counterEntry, $transType), '/' ))}</rest:forward>))
  
else if ($counterContent <= $max) then
  
  ( kk:executeExecutablecontent($dbName, $collectionName, $mbaName, $content, $counterContent),  db:output(<rest:forward>{fn:concat('/enterContents/', string-join(($dbName,$collectionName,$mbaName, $counterContent+1, $counterEntry, $transType), '/' ))}</rest:forward>))
 
 
 else
 
 let $maxStates := fn:count($entrySet)
 return 
 if ($counterEntry <= $maxStates) then 
  db:output(<rest:forward>{fn:concat('/enterContents/', string-join(($dbName,$collectionName,$mbaName,0, $counterEntry +1 , $transType), '/' ))}</rest:forward>)
 else 
 db:output(<rest:forward>{fn:concat('/controller/', string-join(($dbName,$collectionName,$mbaName, $transType), '/' ))}</rest:forward>) 




};






declare
  %rest:path("/controller/{$dbName}/{$collectionName}/{$mbaName}/{$transType}")
  %rest:GET
updating function page:controller(
    $dbName as xs:string, $collectionName as xs:string , $mbaName as xs:string, $transType as xs:string)
{
 
 (: Wenn transtyp external 
 dann Check if running -> wann ja exit Interpreter
  wenn nein  -> invoke states
  
  Sonst -> wieder von vorne  :)
(:maybe not necessary
-> :)


 let $mba   := mba:getMBA($dbName, $collectionName, $mbaName)
 
 let $transitions := 
 mba:getCurrentTransitionsQueue($mba)/transitions/*
 
 
let $configuration := mba:getConfiguration($mba)
 
let $exitSet :=  sc:computeExitSetTrans2($configuration,$transitions)



let $entrySet := if (not (fn:empty(sc:computeEntry($transitions)))) then 
 map:get(sc:computeEntry($transitions)[1],'statesToEnter')
 else
 ()


let $ids := functx:value-intersect($exitSet/@id, $entrySet/@id)

let $exitSet := $exitSet[not (@id=$ids)]

let $exitSet := ()

let $scxml := mba:getSCXML($mba)

let $configuration := mba:getConfiguration($mba)
let $dataModels := sc:selectAllDataModels($mba)

return
(:im init vmlt to autoforwad:)

if($transType != 'external' and $transType !='init') then

   ( db:output(<rest:forward>{fn:concat('/internalTransitions/', string-join(($dbName,$collectionName,$mbaName), '/' ))}</rest:forward>) )

   else
  
  if (mba:getRunning($mba)) then 
  ( 
   if( not(fn:empty(mba:getStatesToInvokeQueue($mba)/*))) then
   ( db:output(<rest:forward>{fn:concat('/invokeStates/', string-join(($dbName,$collectionName,$mbaName,$transType), '/' ))}</rest:forward>) )
   
   else
  if(fn:empty(sc:selectEventlessTransitions($configuration,$dataModels)) and fn:empty(mba:getInternalEventQueue($mba)/*) and fn:empty(mba:getExternalEventQueue($mba)/*)) then 
   
   (kk:changeCurrentStatus($mba,(),$exitSet), db:output(
     <response><trans> { $transType}</trans></response>
   ) )
   
   else
    ( db:output(<rest:forward>{fn:concat('/internalTransitions/', string-join(($dbName,$collectionName,$mbaName), '/' ))}</rest:forward>) )
)

else 
db:output(<rest:forward>{fn:concat('/exitInterpreter/', string-join(($dbName,$collectionName,$mbaName,0), '/' ))}</rest:forward>)
(:

if($transType != 'external' and $transType !='init') then

   fn:concat('/internalTransitions/', string-join(($dbName,$collectionName,$mbaName), '/' ))

   else
  
  if (mba:getRunning($mba)) then 
  ( 
   if( not(fn:empty(mba:getStatesToInvokeQueue($mba)/*))) then
   ( fn:concat('/invokeStates/', string-join(($dbName,$collectionName,$mbaName,$transType), '/' )))
   
   else
   
  if(fn:empty(sc:selectEventlessTransitions($configuration,$dataModels)) and fn:empty(mba:getInternalEventQueue($mba)/*) and fn:empty(mba:getExternalEventQueue($mba)/*)) then 
   
   
     <response><trans> { $transType}</trans></response>

   
   else
    fn:concat('/internalTransitions/', string-join(($dbName,$collectionName,$mbaName), '/' ))
)

else 
fn:concat('/exitInterpreter/', string-join(($dbName,$collectionName,$mbaName,0), '/' ))


:)
};






declare
  %rest:path("/invokeStates/{$dbName}/{$collectionName}/{$mbaName}/{$transType}")
  %rest:GET
  updating function page:invoke(
    $dbName as xs:string, $collectionName as xs:string , $mbaName as xs:string, $transType as xs:string)
{
  
  let $mba   := mba:getMBA($dbName, $collectionName, $mbaName)
 
  
  return 
  
  (kk:invokeStateswithNewDb($mba)
 ,mba:deleteStatesToInvokeQueue($mba), 
  db:output(<rest:forward>{fn:concat('/internalTransitions/', string-join(($dbName,$collectionName,$mbaName), '/' ))}</rest:forward>) )  
  


};









declare
  %rest:path("/exitInterpreter/{$dbName}/{$collectionName}/{$mbaName}/{$counter}")
  %rest:GET
  updating function page:exitInterpreter(
    $dbName as xs:string, $collectionName as xs:string , $mbaName as xs:string, $counter as xs:integer)
{
  
  let $mba   := mba:getMBA($dbName, $collectionName, $mbaName)
 
  let $states := mba:getStatesToInvokeQueue($mba)
  

  
  let $configuration := mba:getConfiguration($mba)
  return
  if ($counter = 0) then 
  (
    if(not($dbName = 'myMBAse')) then
    (
     for $s in $configuration
    
    return  if (sc:isFinalState($s)and not (fn:empty($s/parent::*[self::sc:scxml])) )  then    
    (
    let $exitSet := $configuration
    return 
    (mba:updateCurrentExitSet($mba,$exitSet),

db:output(<rest:forward>{fn:concat('/exitContents/', string-join(($dbName,$collectionName,$mbaName, 0, 1, 'exit'), '/' ))}</rest:forward>)))
else()
)
else
()
 
)
else
(
 
     for $s in mba:getCurrentExitSet($mba)
    
  return (: runExitcontent , cancelInvoke, :)
  if (sc:isFinalState($s)and not (fn:empty($s/parent::*[self::sc:scxml])))  then
  let $invokeid := mba:getParentInvoke($mba)/id
  let $name := 'done.invoke' || '.' ||$invokeid
  let $event := <event invokeid="{$invokeid}"  name="{$name}"></event>
  
  let $src := mba:getParentInvoke($mba)/parent
  
  let $mbaData :=  
             if (fn:substring-before($src, ':') = 'mba') then 
             
    
            fn:substring-after($src,':')        
            else()  
        
  let $mbadata :=fn:tokenize($mbaData, ',')
  return if(fn:empty($mbadata)) then 
  
  ()
  else
  
  
  let $insertMba :=  mba:getMBA($mbadata[1],$mbadata[2],$mbadata[3])
  
  

  return (mba:enqueueExternalEvent($insertMba, $event)
 , db:drop($dbName))


  else
  ())
};
 
 
 
 





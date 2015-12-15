import module namespace kk = 'http://www.w3.org/2005/07/kk';
import module namespace scx='http://www.w3.org/2005/07/scxml/extension/';
import module namespace functx = 'http://www.functx.com';
import module namespace mba='http://www.dke.jku.at/MBA'; 
import module namespace sc = 'http://www.w3.org/2005/07/scxml';
import module namespace sync = 'http://www.dke.jku.at/MBA/Synchronization';



declare variable $dbName := 'myMBAse';
declare variable $collectionName := 'JohannesKeplerUniversity';
declare variable $mbaName := 'InformationSystems';

let $string := string-join(($dbName,$collectionName,$mbaName), '/' )

let $url := 'http://localhost:8984/'
(:  let $f1  := doc(fn:concat($url, 'removeFromInsertLog/', $string )) :)
let $addEvent :=  doc(fn:concat($url, 'addEvent/', $string ))

return mba:getMBA($dbName, $collectionName, $mbaName)



(: 
    let $string := string-join(($dbName,$collectionName,$mbaName), '/' )
  let $url := 'http://localhost:8984/'
  
  let $f1  := doc(fn:concat($url, 'removeFromInsertLog/', $string ))
  let $f2  := doc(fn:concat($url, 'getNextExternalEvent/', $string ))

  let $f3  := doc(fn:concat($url, 'tryptoupdate/', $string ))
  let $f4  := doc(fn:concat($url, 'changeCurrentStatus/', $string ))
  let $f5  := doc(fn:concat($url, 'removeCurrentExternalEvent/', $string ))

  let $f7  := doc(fn:concat($url, 'processEventlessTransitions/', $string ))
  :)
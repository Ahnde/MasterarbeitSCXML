<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
   <xsl:template match="/">
   
                        <xsl:variable name="dbName">
                        <xsl:value-of select="./response/input/input/dbName" />
                     </xsl:variable>
                     <xsl:variable name="collectionName">
                        <xsl:value-of select="./response/input/input/collectionName" />
                     </xsl:variable>
                     <xsl:variable name="mbaName">
                        <xsl:value-of select="./response/input/input/mbaName" />
                     </xsl:variable>
                     <xsl:variable name="counter">
                        <xsl:value-of select="./response/counter" />
                     </xsl:variable>
					 
      <html>
         <head>
            <title>Event Adding Service</title>
            <link rel="stylesheet" href="static/bootstrap/css/bootstrap.min.css" />
            <script src="static/bootstrap/js/bootstrap.min.js" />
         </head>
         <body>
            <div class="navbar navbar-inverse">
               <div class="navbar-header">
                  <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-inverse-collapse">
                     <span class="icon-bar" />
                     <span class="icon-bar" />
                     <span class="icon-bar" />
                  </button>
                  <a class="navbar-brand" href="#">SCXML-Interpreter</a>
               </div>
            </div>
            <div class="container">
               <div class="page-header" id="banner">
                  <div class="row">
                     <div class="col-lg-6">
                        <h1>SCXML - Interpreter</h1>
                        <p class="lead">Hinzufügen von Events</p>
                     </div>
                  </div>
               </div>
               <h3>Added Event</h3>
   
   
    <div class="table-responsive">
                  <table class="table">
                     <thead>
                        <tr>
                           <th>Element</th>
                           <th>Id</th>
                           <th>Value</th>
                        </tr>
                     </thead>
					 

                     <xsl:for-each select="./response/counter">
					 
					 
					 
					            
					 
			
					 
					  <tr>
		<td> <xsl:value-of select="local-name(.)"/> </td>
		<td>  <xsl:value-of select="./@id"/> </td>
        <td> <b> <xsl:value-of select="."/> </b> </td>

      </tr>
	  
                      <!--  <h3>
                           <xsl:value-of select="local-name(.)" />
                           :
                           <xsl:value-of select="." />
                        </h3> 
                        <br />
                        
                        <br />




						

						-->
                     </xsl:for-each>
                     <xsl:for-each select="./response/input/input/*">
                        <xsl:if test=". != ''">
                           
						     <tr>
		<td> <xsl:value-of select="local-name(.)"/> </td>
		<td>  <xsl:value-of select="./@id"/> </td>
        <td> <xsl:value-of select="."/> </td>

      </tr>
	  
	  
						  <!--  <xsl:value-of select="local-name(.)" />
                           :
                           <xsl:value-of select="." />
                           <br />  -->
                        </xsl:if>
                     </xsl:for-each>
´
                  </table>
               </div>
			   
			   
			   
		 <!-- <form action="getResult" method="POST" role="form" class="form-horizontal">
                           <div class="form-group">
                              <input type="hidden" class="form-control" id="dbName" name="dbName">
                                 <xsl:attribute name="value">
                                    <xsl:copy-of select="$dbName" />
                                 </xsl:attribute>
                              </input>
                           </div>
                           <div class="form-group">
                              <input type="hidden" class="form-control" id="collectionName" name="collectionName">
                                 <xsl:attribute name="value">
                                    <xsl:copy-of select="$collectionName" />
                                 </xsl:attribute>
                              </input>
                           </div>
                           <div class="form-group">
                              <input type="hidden" class="form-control" id="mbaName" name="mbaName">
                                 <xsl:attribute name="value">
                                    <xsl:copy-of select="$mbaName" />
                                 </xsl:attribute>
                              </input>
                           </div>
                           <div class="form-group">
                              <input type="hidden" class="form-control" id="counter" name="counter">
                                 <xsl:attribute name="value">
                                    <xsl:copy-of select="$counter" />
                                 </xsl:attribute>
                              </input>
                           </div>
                           <div class="form-group">
                              <div class="col-sm-offset-2 col-sm-10">
                                 <button type="submit" class="btn btn-default">getResult</button>
                              </div>
                           </div>
						   
                        </form> -->
						
						
						<form action="getResult" method="POST" role="form" class="form-horizontal">
       <div class="form-group">
                              <input type="hidden" class="form-control" id="dbName" name="dbName">
                                 <xsl:attribute name="value">
                                    <xsl:copy-of select="$dbName" />
                                 </xsl:attribute>
                              </input>
                           </div>
                           <div class="form-group">
                              <input type="hidden" class="form-control" id="collectionName" name="collectionName">
                                 <xsl:attribute name="value">
                                    <xsl:copy-of select="$collectionName" />
                                 </xsl:attribute>
                              </input>
                           </div>
                           <div class="form-group">
                              <input type="hidden" class="form-control" id="mbaName" name="mbaName">
                                 <xsl:attribute name="value">
                                    <xsl:copy-of select="$mbaName" />
                                 </xsl:attribute>
                              </input>
                           </div>
                   <div class="form-group">
                              <input type="hidden" class="form-control" id="counter" name="counter">
                                 <xsl:attribute name="value">
                                    <xsl:copy-of select="$counter" />
                                 </xsl:attribute>
                              </input>
                           </div>
                           <div class="form-group">
                              <div class="col-sm-offset-2 col-sm-10">
                                 <button type="submit" class="btn btn-default">getLogs</button>
                              </div>
                           </div>
						   
</form>
			   
			   
					
			   
            </div>
         </body>
      </html>
   </xsl:template>
</xsl:stylesheet>

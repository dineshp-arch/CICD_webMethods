<?xml version="1.0" encoding="UTF-8"?>
<!--
      Copyright © 2013 - 2018 Software AG, Darmstadt, Germany and/or its licensors

 SPDX-License-Identifier: Apache-2.0

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.                                                            
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  <xsl:param name="deployerHost"/>
  <xsl:param name="deployerPort"/>
  <xsl:param name="deployerUsername"/>
  <xsl:param name="deployerPassword"/>
  <xsl:param name="targetHost1"/>
  <xsl:param name="targetHost2"/>
  <xsl:param name="targetPort1"/>
  <xsl:param name="targetPort2"/>
  <xsl:param name="targetUsername1"/>
  <xsl:param name="targetUsername2"/>
  <xsl:param name="targetPassword1"/>
  <xsl:param name="targetPassword2"/>
  <xsl:param name="targetAlias1"/>
  <xsl:param name="targetAlias2"/>
  <xsl:param name="targetVersion1"/>
  <xsl:param name="targetVersion2"/>
  <xsl:param name="targetSsl1" />
  <xsl:param name="targetSsl2" />
  <xsl:param name="sourceAlias"/>
  <xsl:param name="sourcePath"/>
  <xsl:param name="targetClusterGroupAlias"/>
  <xsl:param name="projectName"/>
  <xsl:param name="compositeName"/>
  <xsl:param name="setName"/>
  <xsl:param name="mapName"/>
  <xsl:param name="candidateName"/>
  <xsl:param name="buildVersion"/>
  
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="DeployerSpec/DeployerServer">
    <DeployerServer>
      <host><xsl:value-of select="$deployerHost"/>:<xsl:value-of select="$deployerPort"/></host>
      <user>
        <xsl:value-of select="$deployerUsername"/>
      </user>
      <pwd>
        <xsl:value-of select="$deployerPassword"/>
      </pwd>
    </DeployerServer>
  </xsl:template>
  
  <xsl:template match="DeployerSpec/Environment">
    <Environment>
      <IS>
        <isalias>
        <xsl:attribute name="name">
          <xsl:value-of select="$targetAlias1"/>
        </xsl:attribute>      
          <host>
            <xsl:value-of select="$targetHost1"/>
          </host>
          <port>
            <xsl:value-of select="$targetPort1"/>
          </port>
          <user>
            <xsl:value-of select="$targetUsername1"/>
          </user>
          <pwd>
            <xsl:value-of select="$targetPassword1"/>
          </pwd>
          <useSSL>
          	<xsl:value-of select="$targetSsl1"/>
		  </useSSL>
		  <version>
	          <xsl:value-of select="$targetVersion1"/>			
		  </version>
          <installDeployerResource>true</installDeployerResource>
          <Test>false</Test>
        </isalias>
        <isalias>
        <xsl:attribute name="name">
          <xsl:value-of select="$targetAlias2"/>
        </xsl:attribute>      
          <host>
            <xsl:value-of select="$targetHost2"/>
          </host>
          <port>
            <xsl:value-of select="$targetPort2"/>
          </port>
          <user>
            <xsl:value-of select="$targetUsername2"/>
          </user>
          <pwd>
            <xsl:value-of select="$targetPassword2"/>
          </pwd>
          <useSSL>
          	<xsl:value-of select="$targetSsl2"/>
		  </useSSL>
		  <version>
	          <xsl:value-of select="$targetVersion2"/>			
		  </version>
          <installDeployerResource>true</installDeployerResource>
          <Test>false</Test>
        </isalias>
      </IS> 	  
	  <Repository>
		<repalias>
        <xsl:attribute name="name">
          <xsl:value-of select="$sourceAlias"/>
        </xsl:attribute>
			<type>FlatFile</type>
			<urlOrDirectory>
	            <xsl:value-of select="$sourcePath"/>				
			</urlOrDirectory>
			<createIndex>true</createIndex>
			<Test>true</Test>
		</repalias>
	  </Repository>
      <TargetGroup description="" isLogicalCluster="false" type="IS">
		<xsl:attribute name="name">
          <xsl:value-of select="$targetClusterGroupAlias"/>
        </xsl:attribute>
		<alias type="IS" />
		<cluster name="ISCLUSTER">
			<xsl:value-of select="$targetAlias1"/>,<xsl:value-of select="$targetAlias2"/>
		</cluster>
      </TargetGroup>
	  <xsl:apply-templates select="@* | *"/>
    </Environment>
  </xsl:template>
  
  <xsl:template match="DeployerSpec/Projects">
    <Projects>
      <xsl:apply-templates select="@* | *"/>
      <Project  type="Repository" overwrite="true" ignoreMissingDependencies="true">
        
        <xsl:attribute name="description">
          <xsl:value-of select="concat('CICD Deployment v',$buildVersion)"/>
        </xsl:attribute>
                
        <xsl:attribute name="name">
          <xsl:value-of select="$projectName"/>
        </xsl:attribute>      

        <DeploymentSet autoResolve="ignore">

          <xsl:attribute name="description">
            <xsl:value-of select="concat($projectName,' IS DeploymentSet')"/>
          </xsl:attribute>
          
          <xsl:attribute name="name">
            <xsl:value-of select="$setName"/>
          </xsl:attribute>
          
          <xsl:attribute name="srcAlias">
            <xsl:value-of select="$sourceAlias"/>
          </xsl:attribute>
          
          <Composite type="IS">
          
	          <xsl:attribute name="name">
	            <xsl:value-of select="$compositeName"/>
	          </xsl:attribute>

	          <xsl:attribute name="srcAlias">
	            <xsl:value-of select="$sourceAlias"/>
	          </xsl:attribute>
     
          </Composite>
          
       	</DeploymentSet>

		<DeploymentMap>			
	         <xsl:attribute name="description">
	            <xsl:value-of select="concat($projectName,' IS Deployment Map')"/>
	         </xsl:attribute>
	         
	         <xsl:attribute name="name">
				<xsl:value-of select="$mapName"/>
	         </xsl:attribute>	         
	         
		</DeploymentMap>
		 
		<MapSetMapping>
		
	         <xsl:attribute name="mapName">
				<xsl:value-of select="$mapName"/>
	         </xsl:attribute>		

	         <xsl:attribute name="setName">
				<xsl:value-of select="$setName"/>
	         </xsl:attribute>
				
			<group type="IS">
	            <xsl:value-of select="$targetClusterGroupAlias"/>				
		
			</group>			
		</MapSetMapping>
		
		<DeploymentCandidate>

	         <xsl:attribute name="description">
	            <xsl:value-of select="concat($projectName,' IS Deployment Candidate')"/>
	         </xsl:attribute>

	         <xsl:attribute name="mapName">
				<xsl:value-of select="$mapName"/>
	         </xsl:attribute>

	         <xsl:attribute name="name">
				<xsl:value-of select="$candidateName"/>
	         </xsl:attribute>

		</DeploymentCandidate>
			 		     
      </Project>
    </Projects>
  </xsl:template>


  
</xsl:stylesheet>

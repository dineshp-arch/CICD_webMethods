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
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:output method="xml" encoding="utf-8" indent="yes"/>
	<xsl:param name="deployerHost"/>
	<xsl:param name="deployerPort"/>
	<xsl:param name="deployerUsername"/>
	<xsl:param name="deployerPassword"/>
	<xsl:param name="targetHost"/>
	<xsl:param name="targetPort"/>
	<xsl:param name="targetUsername"/>
	<xsl:param name="targetPassword"/>
	<xsl:param name="targetAlias"/>
	<xsl:param name="targetVersion"/>
	<xsl:param name="targetSsl" />
	<xsl:param name="sourceAlias"/>
	<xsl:param name="sourcePath"/>
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
			<host>
				<xsl:value-of select="$deployerHost"/>:<xsl:value-of select="$deployerPort"/>
			</host>
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
						<xsl:value-of select="$targetAlias"/>
					</xsl:attribute>
					<host>
						<xsl:value-of select="$targetHost"/>
					</host>
					<port>
						<xsl:value-of select="$targetPort"/>
					</port>
					<user>
						<xsl:value-of select="$targetUsername"/>
					</user>
					<pwd>
						<xsl:value-of select="$targetPassword"/>
					</pwd>
					<useSSL>
						<xsl:value-of select="$targetSsl"/>
					</useSSL>
					<version>
						<xsl:value-of select="$targetVersion"/>
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
			<xsl:apply-templates select="@* | *"/>
		</Environment>
	</xsl:template>
	<xsl:template match="DeployerSpec/Projects">
		<xsl:variable name="currentDate" select="java:format(java:java.text.SimpleDateFormat.new('yyyy-MM-dd HH:mm:ss'), java:java.util.Date.new())" />
		<Projects>
			<xsl:apply-templates select="@* | *"/>
			<Project  type="Repository" overwrite="true" ignoreMissingDependencies="true">
				<xsl:attribute name="description">
					<xsl:value-of select="concat('Auto generated project ', $buildVersion ,' (', $currentDate,' )' )"/>
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
					<alias type="IS">
						<xsl:value-of select="$targetAlias"/>
					</alias>
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
